import { z } from 'zod';
import { router, nutricionistaProcedure, protectedProcedure } from '../trpc';

export const planesRouter = router({
  list: protectedProcedure.input(z.object({
    pacienteId: z.string().optional(),
  }).optional()).query(async ({ ctx, input }) => {
    const user = ctx.user as any;
    const where: any = {};

    if (user.rol === 'PACIENTE') {
      where.pacienteId = user.pacienteId;
    } else if (input?.pacienteId) {
      where.pacienteId = input.pacienteId;
      where.nutricionistaId = user.nutricionistaId;
    } else {
      where.nutricionistaId = user.nutricionistaId;
    }

    return ctx.prisma.planNutricional.findMany({
      where,
      include: {
        paciente: { include: { user: { select: { nombre: true, apellidos: true } } } },
        planificaciones: { include: { dias: { include: { comidas: true } } } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }),

  getById: protectedProcedure.input(z.object({ id: z.string() })).query(async ({ ctx, input }) => {
    return ctx.prisma.planNutricional.findUnique({
      where: { id: input.id },
      include: {
        paciente: { include: { user: { select: { nombre: true, apellidos: true } } } },
        planificaciones: {
          include: {
            dias: {
              include: {
                comidas: {
                  include: {
                    alimentos: { include: { alimento: true } },
                    recetas: { include: { receta: true } },
                  },
                  orderBy: { orden: 'asc' },
                },
              },
              orderBy: { diaSemana: 'asc' },
            },
          },
          orderBy: { numeroPlan: 'asc' },
        },
      },
    });
  }),

  create: nutricionistaProcedure.input(z.object({
    nombre: z.string(),
    pacienteId: z.string(),
    tipoPlan: z.enum(['SEMANAL', 'QUINCENAL']),
    numPlanificaciones: z.number().min(1).max(4),
    comidasActivas: z.array(z.string()),
    caloriasObjetivo: z.number(),
    proteinasObjetivo: z.number(),
    carbohidratosObjetivo: z.number(),
    grasasObjetivo: z.number(),
    fibraObjetivo: z.number().optional(),
  })).mutation(async ({ ctx, input }) => {
    const nutricionistaId = (ctx.user as any).nutricionistaId;

    const plan = await ctx.prisma.planNutricional.create({
      data: {
        ...input,
        comidasActivas: input.comidasActivas as any[],
        nutricionistaId,
        planificaciones: {
          create: Array.from({ length: input.numPlanificaciones }, (_, i) => ({
            numeroPlan: i + 1,
            nombre: `Semana ${String.fromCharCode(65 + i)}`,
            dias: {
              create: Array.from({ length: input.tipoPlan === 'SEMANAL' ? 7 : 14 }, (_, j) => ({
                diaSemana: (j % 7) + 1,
                nombre: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'][j % 7],
              })),
            },
          })),
        },
      },
      include: { planificaciones: { include: { dias: true } } },
    });

    return plan;
  }),

  updateEstado: nutricionistaProcedure.input(z.object({
    id: z.string(),
    estado: z.enum(['BORRADOR', 'ACTIVO', 'COMPLETADO', 'CANCELADO']),
  })).mutation(async ({ ctx, input }) => {
    return ctx.prisma.planNutricional.update({
      where: { id: input.id },
      data: { estado: input.estado },
    });
  }),

  addAlimentoToComida: nutricionistaProcedure.input(z.object({
    planComidaId: z.string(),
    alimentoId: z.string(),
    cantidad: z.number(),
    intercambios: z.number().optional(),
    notas: z.string().optional(),
  })).mutation(async ({ ctx, input }) => {
    return ctx.prisma.planComidaAlimento.create({ data: input });
  }),

  addRecetaToComida: nutricionistaProcedure.input(z.object({
    planComidaId: z.string(),
    recetaId: z.string(),
    raciones: z.number().default(1),
    notas: z.string().optional(),
  })).mutation(async ({ ctx, input }) => {
    return ctx.prisma.planComidaReceta.create({ data: input });
  }),

  removeAlimentoFromComida: nutricionistaProcedure.input(z.object({
    id: z.string(),
  })).mutation(async ({ ctx, input }) => {
    return ctx.prisma.planComidaAlimento.delete({ where: { id: input.id } });
  }),
});
