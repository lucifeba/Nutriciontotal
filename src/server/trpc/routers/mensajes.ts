import { z } from 'zod';
import { router, protectedProcedure } from '../trpc';

export const mensajesRouter = router({
  getConversaciones: protectedProcedure.query(async ({ ctx }) => {
    const user = ctx.user as any;

    if (user.rol === 'NUTRICIONISTA') {
      return ctx.prisma.conversacion.findMany({
        where: { paciente: { nutricionistaId: user.nutricionistaId } },
        include: {
          paciente: { include: { user: { select: { nombre: true, apellidos: true, avatar: true } } } },
        },
        orderBy: { ultimaActividad: 'desc' },
      });
    } else {
      return ctx.prisma.conversacion.findMany({
        where: { pacienteId: user.pacienteId },
        include: {
          paciente: { include: { nutricionista: { include: { user: { select: { nombre: true, apellidos: true, avatar: true } } } } } },
        },
      });
    }
  }),

  getMessages: protectedProcedure.input(z.object({
    conversacionId: z.string(),
    cursor: z.string().optional(),
    limit: z.number().default(50),
  })).query(async ({ ctx, input }) => {
    const messages = await ctx.prisma.mensaje.findMany({
      where: { conversacionId: input.conversacionId },
      include: {
        remitente: { select: { nombre: true, apellidos: true, avatar: true } },
      },
      orderBy: { createdAt: 'desc' },
      take: input.limit + 1,
      cursor: input.cursor ? { id: input.cursor } : undefined,
    });

    let nextCursor: string | undefined;
    if (messages.length > input.limit) {
      const next = messages.pop();
      nextCursor = next!.id;
    }

    return { messages: messages.reverse(), nextCursor };
  }),

  send: protectedProcedure.input(z.object({
    conversacionId: z.string(),
    destinatarioId: z.string(),
    contenido: z.string().min(1),
    tipo: z.string().default('texto'),
  })).mutation(async ({ ctx, input }) => {
    const userId = (ctx.user as any).id;

    const [mensaje] = await ctx.prisma.$transaction([
      ctx.prisma.mensaje.create({
        data: {
          conversacionId: input.conversacionId,
          remitenteId: userId,
          destinatarioId: input.destinatarioId,
          contenido: input.contenido,
          tipo: input.tipo,
        },
        include: {
          remitente: { select: { nombre: true, apellidos: true, avatar: true } },
        },
      }),
      ctx.prisma.conversacion.update({
        where: { id: input.conversacionId },
        data: {
          ultimoMensaje: input.contenido,
          ultimaActividad: new Date(),
          noLeidos: { increment: 1 },
        },
      }),
    ]);

    return mensaje;
  }),

  markAsRead: protectedProcedure.input(z.object({
    conversacionId: z.string(),
  })).mutation(async ({ ctx, input }) => {
    const userId = (ctx.user as any).id;

    await ctx.prisma.$transaction([
      ctx.prisma.mensaje.updateMany({
        where: {
          conversacionId: input.conversacionId,
          destinatarioId: userId,
          leido: false,
        },
        data: { leido: true, leidoAt: new Date() },
      }),
      ctx.prisma.conversacion.update({
        where: { id: input.conversacionId },
        data: { noLeidos: 0 },
      }),
    ]);
  }),
});
