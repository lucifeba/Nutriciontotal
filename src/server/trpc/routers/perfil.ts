import { z } from 'zod';
import { router, protectedProcedure, nutricionistaProcedure } from '../trpc';

export const perfilRouter = router({
  get: protectedProcedure.query(async ({ ctx }) => {
    const userId = (ctx.user as any).id;
    const user = await ctx.prisma.user.findUnique({
      where: { id: userId },
      include: { nutricionista: true, paciente: true },
    });
    return user;
  }),

  updateUser: protectedProcedure.input(z.object({
    nombre: z.string().min(1).optional(),
    apellidos: z.string().min(1).optional(),
    telefono: z.string().optional(),
  })).mutation(async ({ ctx, input }) => {
    const userId = (ctx.user as any).id;
    return ctx.prisma.user.update({
      where: { id: userId },
      data: input,
    });
  }),

  updateNutricionista: nutricionistaProcedure.input(z.object({
    numColegiado: z.string().optional(),
    especialidad: z.string().optional(),
    clinica: z.string().optional(),
    direccion: z.string().optional(),
    bio: z.string().optional(),
  })).mutation(async ({ ctx, input }) => {
    const nutricionistaId = (ctx.user as any).nutricionistaId;
    return ctx.prisma.nutricionista.update({
      where: { id: nutricionistaId },
      data: input,
    });
  }),

  bulkUploadAlimentos: nutricionistaProcedure.input(z.array(z.object({
    nombre: z.string().min(1),
    grupoIntercambio: z.string(),
    subgrupo: z.string().optional(),
    calorias: z.number(),
    proteinas: z.number(),
    carbohidratos: z.number(),
    grasas: z.number(),
    fibra: z.number().optional(),
    racionIntercambio: z.number(),
    descripcionRacion: z.string().optional(),
    esAptoVegetariano: z.boolean().default(false),
    esAptoVegano: z.boolean().default(false),
    contieneLactosa: z.boolean().default(false),
    contieneGluten: z.boolean().default(false),
    contieneFrutosSecos: z.boolean().default(false),
    contieneHuevo: z.boolean().default(false),
    contienePescado: z.boolean().default(false),
    contieneMarisco: z.boolean().default(false),
    contieneSoja: z.boolean().default(false),
  }))).mutation(async ({ ctx, input }) => {
    let created = 0;
    const errors: string[] = [];

    for (const alimento of input) {
      try {
        await ctx.prisma.alimento.create({
          data: {
            ...alimento,
            grupoIntercambio: alimento.grupoIntercambio as any,
            temporada: ['todo el año'],
          },
        });
        created++;
      } catch (e: any) {
        errors.push(`${alimento.nombre}: ${e.message}`);
      }
    }

    return { created, errors, total: input.length };
  }),

  bulkUploadRecetas: nutricionistaProcedure.input(z.array(z.object({
    nombre: z.string().min(1),
    descripcion: z.string().optional(),
    instrucciones: z.string(),
    tiempoPreparacion: z.number(),
    tiempoCoccion: z.number(),
    dificultad: z.string(),
    raciones: z.number().default(4),
    tipoComida: z.array(z.string()),
    categoria: z.string().optional(),
    caloriasPorRacion: z.number().optional(),
    proteinasPorRacion: z.number().optional(),
    carbohidratosPorRacion: z.number().optional(),
    grasasPorRacion: z.number().optional(),
    ingredientes: z.array(z.object({
      alimentoNombre: z.string(),
      cantidad: z.number(),
      unidad: z.string().default('g'),
      notas: z.string().optional(),
    })).optional(),
  }))).mutation(async ({ ctx, input }) => {
    let created = 0;
    const errors: string[] = [];

    for (const receta of input) {
      try {
        const ingredientesData = [];
        if (receta.ingredientes) {
          for (const ing of receta.ingredientes) {
            const alimento = await ctx.prisma.alimento.findFirst({
              where: { nombre: { equals: ing.alimentoNombre, mode: 'insensitive' } },
            });
            if (alimento) {
              ingredientesData.push({
                alimentoId: alimento.id,
                cantidad: ing.cantidad,
                unidad: ing.unidad,
                notas: ing.notas || null,
              });
            }
          }
        }

        await ctx.prisma.receta.create({
          data: {
            nombre: receta.nombre,
            descripcion: receta.descripcion || null,
            instrucciones: receta.instrucciones,
            tiempoPreparacion: receta.tiempoPreparacion,
            tiempoCoccion: receta.tiempoCoccion,
            dificultad: receta.dificultad,
            raciones: receta.raciones,
            tipoComida: receta.tipoComida,
            categoria: receta.categoria || null,
            caloriasPorRacion: receta.caloriasPorRacion || null,
            proteinasPorRacion: receta.proteinasPorRacion || null,
            carbohidratosPorRacion: receta.carbohidratosPorRacion || null,
            grasasPorRacion: receta.grasasPorRacion || null,
            alimentos: {
              create: ingredientesData,
            },
          },
        });
        created++;
      } catch (e: any) {
        errors.push(`${receta.nombre}: ${e.message}`);
      }
    }

    return { created, errors, total: input.length };
  }),
});
