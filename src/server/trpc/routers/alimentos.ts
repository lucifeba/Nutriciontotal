import { z } from 'zod';
import { router, nutricionistaProcedure } from '../trpc';

export const alimentosRouter = router({
  list: nutricionistaProcedure.input(z.object({
    grupo: z.string().optional(),
    search: z.string().optional(),
    page: z.number().default(1),
    limit: z.number().default(50),
  }).optional()).query(async ({ ctx, input }) => {
    const where: any = {};
    if (input?.grupo) where.grupoIntercambio = input.grupo;
    if (input?.search) where.nombre = { contains: input.search, mode: 'insensitive' };

    const [alimentos, total] = await Promise.all([
      ctx.prisma.alimento.findMany({
        where,
        skip: ((input?.page || 1) - 1) * (input?.limit || 50),
        take: input?.limit || 50,
        orderBy: { nombre: 'asc' },
      }),
      ctx.prisma.alimento.count({ where }),
    ]);

    return { alimentos, total, pages: Math.ceil(total / (input?.limit || 50)) };
  }),

  getByGrupo: nutricionistaProcedure.input(z.object({
    grupo: z.string(),
  })).query(async ({ ctx, input }) => {
    return ctx.prisma.alimento.findMany({
      where: { grupoIntercambio: input.grupo as any },
      orderBy: { nombre: 'asc' },
    });
  }),

  search: nutricionistaProcedure.input(z.object({
    query: z.string().min(2),
    excludeAllergens: z.array(z.string()).optional(),
  })).query(async ({ ctx, input }) => {
    const where: any = {
      nombre: { contains: input.query, mode: 'insensitive' },
    };

    if (input.excludeAllergens?.includes('lactosa')) where.contieneLactosa = false;
    if (input.excludeAllergens?.includes('gluten')) where.contieneGluten = false;
    if (input.excludeAllergens?.includes('frutos_secos')) where.contieneFrutosSecos = false;

    return ctx.prisma.alimento.findMany({ where, take: 20, orderBy: { nombre: 'asc' } });
  }),

  getAlternativas: nutricionistaProcedure.input(z.object({
    alimentoId: z.string(),
  })).query(async ({ ctx, input }) => {
    const alimento = await ctx.prisma.alimento.findUnique({ where: { id: input.alimentoId } });
    if (!alimento) return [];

    return ctx.prisma.alimento.findMany({
      where: {
        grupoIntercambio: alimento.grupoIntercambio,
        id: { not: alimento.id },
      },
      take: 10,
      orderBy: { nombre: 'asc' },
    });
  }),
});
