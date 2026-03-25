import { router } from './trpc';
import { pacientesRouter } from './routers/pacientes';
import { alimentosRouter } from './routers/alimentos';
import { recetasRouter } from './routers/recetas';
import { planesRouter } from './routers/planes';
import { encuestasRouter } from './routers/encuestas';
import { mensajesRouter } from './routers/mensajes';
import { perfilRouter } from './routers/perfil';

export const appRouter = router({
  pacientes: pacientesRouter,
  alimentos: alimentosRouter,
  recetas: recetasRouter,
  planes: planesRouter,
  encuestas: encuestasRouter,
  mensajes: mensajesRouter,
  perfil: perfilRouter,
});

export type AppRouter = typeof appRouter;
