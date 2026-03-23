import { initTRPC, TRPCError } from '@trpc/server';
import superjson from 'superjson';
import { Context } from './context';

const t = initTRPC.context<Context>().create({
  transformer: superjson,
});

export const router = t.router;
export const publicProcedure = t.procedure;

const isAuthed = t.middleware(({ ctx, next }) => {
  if (!ctx.session || !ctx.session.user) {
    throw new TRPCError({ code: 'UNAUTHORIZED', message: 'No autenticado' });
  }
  return next({
    ctx: {
      session: ctx.session,
      user: ctx.session.user,
    },
  });
});

const isNutricionista = t.middleware(({ ctx, next }) => {
  if (!ctx.session?.user || (ctx.session.user as any).rol !== 'NUTRICIONISTA') {
    throw new TRPCError({ code: 'FORBIDDEN', message: 'Acceso solo para nutricionistas' });
  }
  return next({
    ctx: {
      session: ctx.session,
      user: ctx.session.user,
    },
  });
});

export const protectedProcedure = t.procedure.use(isAuthed);
export const nutricionistaProcedure = t.procedure.use(isNutricionista);
