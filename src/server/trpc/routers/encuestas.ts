import { z } from 'zod';
import { router, publicProcedure, nutricionistaProcedure } from '../trpc';

export const encuestasRouter = router({
  getByToken: publicProcedure.input(z.object({ token: z.string() })).query(async ({ ctx, input }) => {
    const paciente = await ctx.prisma.paciente.findUnique({
      where: { encuestaToken: input.token },
      include: { user: { select: { nombre: true, apellidos: true } } },
    });
    if (!paciente) return null;
    return {
      pacienteId: paciente.id,
      nombre: paciente.user.nombre,
      apellidos: paciente.user.apellidos,
      completada: paciente.encuestaCompletada,
    };
  }),

  submit: publicProcedure.input(z.object({
    token: z.string(),
    data: z.any(),
  })).mutation(async ({ ctx, input }) => {
    const paciente = await ctx.prisma.paciente.findUnique({
      where: { encuestaToken: input.token },
    });
    if (!paciente) throw new Error('Token no válido');
    if (paciente.encuestaCompletada) throw new Error('Encuesta ya completada');

    const anamnesisData = input.data;

    await ctx.prisma.$transaction([
      ctx.prisma.anamnesis.create({
        data: {
          pacienteId: paciente.id,
          ...anamnesisData,
        },
      }),
      ctx.prisma.paciente.update({
        where: { id: paciente.id },
        data: { encuestaCompletada: true },
      }),
    ]);

    return { success: true };
  }),

  getAnamnesis: nutricionistaProcedure.input(z.object({
    pacienteId: z.string(),
  })).query(async ({ ctx, input }) => {
    return ctx.prisma.anamnesis.findUnique({
      where: { pacienteId: input.pacienteId },
    });
  }),
});
