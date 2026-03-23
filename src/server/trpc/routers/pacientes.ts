import { z } from 'zod';
import { router, nutricionistaProcedure, protectedProcedure } from '../trpc';
import bcrypt from 'bcryptjs';

export const pacientesRouter = router({
  list: nutricionistaProcedure.query(async ({ ctx }) => {
    const nutricionistaId = (ctx.user as any).nutricionistaId;
    return ctx.prisma.paciente.findMany({
      where: { nutricionistaId },
      include: {
        user: { select: { nombre: true, apellidos: true, email: true, telefono: true, avatar: true } },
        _count: { select: { planes: true } },
      },
      orderBy: { fechaAlta: 'desc' },
    });
  }),

  getById: protectedProcedure.input(z.object({ id: z.string() })).query(async ({ ctx, input }) => {
    return ctx.prisma.paciente.findUnique({
      where: { id: input.id },
      include: {
        user: true,
        anamnesis: true,
        planes: { orderBy: { createdAt: 'desc' } },
        mediciones: { orderBy: { fecha: 'desc' } },
      },
    });
  }),

  create: nutricionistaProcedure.input(z.object({
    nombre: z.string().min(2),
    apellidos: z.string().min(2),
    email: z.string().email(),
    telefono: z.string().optional(),
    fechaNacimiento: z.string().optional(),
    sexo: z.enum(['MASCULINO', 'FEMENINO', 'OTRO']).optional(),
    altura: z.number().optional(),
    pesoActual: z.number().optional(),
    pesoObjetivo: z.number().optional(),
  })).mutation(async ({ ctx, input }) => {
    const nutricionistaId = (ctx.user as any).nutricionistaId;
    const tempPassword = Math.random().toString(36).slice(-8);
    const hashedPassword = await bcrypt.hash(tempPassword, 10);

    const user = await ctx.prisma.user.create({
      data: {
        email: input.email,
        password: hashedPassword,
        nombre: input.nombre,
        apellidos: input.apellidos,
        rol: 'PACIENTE',
        telefono: input.telefono,
        paciente: {
          create: {
            nutricionistaId,
            fechaNacimiento: input.fechaNacimiento ? new Date(input.fechaNacimiento) : undefined,
            sexo: input.sexo as any,
            altura: input.altura,
            pesoActual: input.pesoActual,
            pesoObjetivo: input.pesoObjetivo,
          },
        },
      },
      include: { paciente: true },
    });

    return { user, tempPassword, encuestaToken: user.paciente!.encuestaToken };
  }),

  update: nutricionistaProcedure.input(z.object({
    id: z.string(),
    pesoActual: z.number().optional(),
    pesoObjetivo: z.number().optional(),
    altura: z.number().optional(),
    porcentajeGrasa: z.number().optional(),
    circunferenciaCintura: z.number().optional(),
    circunferenciaCadera: z.number().optional(),
  })).mutation(async ({ ctx, input }) => {
    const { id, ...data } = input;
    return ctx.prisma.paciente.update({ where: { id }, data });
  }),

  addMedicion: nutricionistaProcedure.input(z.object({
    pacienteId: z.string(),
    peso: z.number().optional(),
    porcentajeGrasa: z.number().optional(),
    masaMuscular: z.number().optional(),
    circunferenciaCintura: z.number().optional(),
    circunferenciaCadera: z.number().optional(),
    notas: z.string().optional(),
  })).mutation(async ({ ctx, input }) => {
    return ctx.prisma.medicion.create({ data: input });
  }),

  stats: nutricionistaProcedure.query(async ({ ctx }) => {
    const nutricionistaId = (ctx.user as any).nutricionistaId;
    const [totalPacientes, pacientesActivos, planesActivos, encuestasPendientes] = await Promise.all([
      ctx.prisma.paciente.count({ where: { nutricionistaId } }),
      ctx.prisma.paciente.count({ where: { nutricionistaId, activo: true } }),
      ctx.prisma.planNutricional.count({ where: { nutricionistaId, estado: 'ACTIVO' } }),
      ctx.prisma.paciente.count({ where: { nutricionistaId, encuestaCompletada: false } }),
    ]);
    return { totalPacientes, pacientesActivos, planesActivos, encuestasPendientes };
  }),
});
