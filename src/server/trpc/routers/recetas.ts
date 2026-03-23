import { z } from 'zod';
import { router, nutricionistaProcedure } from '../trpc';

export const recetasRouter = router({
  list: nutricionistaProcedure.input(z.object({
    tipoComida: z.string().optional(),
    search: z.string().optional(),
    page: z.number().default(1),
    limit: z.number().default(20),
  }).optional()).query(async ({ ctx, input }) => {
    const where: any = {};
    if (input?.tipoComida) where.tipoComida = { has: input.tipoComida };
    if (input?.search) where.nombre = { contains: input.search, mode: 'insensitive' };

    const [recetas, total] = await Promise.all([
      ctx.prisma.receta.findMany({
        where,
        include: { alimentos: { include: { alimento: true } } },
        skip: ((input?.page || 1) - 1) * (input?.limit || 20),
        take: input?.limit || 20,
        orderBy: { nombre: 'asc' },
      }),
      ctx.prisma.receta.count({ where }),
    ]);

    return { recetas, total, pages: Math.ceil(total / (input?.limit || 20)) };
  }),

  getById: nutricionistaProcedure.input(z.object({ id: z.string() })).query(async ({ ctx, input }) => {
    return ctx.prisma.receta.findUnique({
      where: { id: input.id },
      include: { alimentos: { include: { alimento: true } } },
    });
  }),
});
