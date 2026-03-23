export const DISTRIBUCION_CALORICA = {
  DESAYUNO: { min: 0.20, max: 0.25 },
  MEDIA_MANANA: { min: 0.05, max: 0.10 },
  ALMUERZO: { min: 0.30, max: 0.35 },
  MERIENDA: { min: 0.10, max: 0.15 },
  CENA: { min: 0.25, max: 0.30 },
  RECENA: { min: 0.05, max: 0.05 },
} as const;

export const MACROS_DISTRIBUCION = {
  equilibrada: { proteinas: 0.20, carbohidratos: 0.50, grasas: 0.30 },
  hiperproteica: { proteinas: 0.30, carbohidratos: 0.40, grasas: 0.30 },
  lowCarb: { proteinas: 0.25, carbohidratos: 0.35, grasas: 0.40 },
  deportista: { proteinas: 0.25, carbohidratos: 0.55, grasas: 0.20 },
} as const;

export const FACTORES_ACTIVIDAD = {
  sedentario: 1.2,
  ligero: 1.375,
  moderado: 1.55,
  activo: 1.725,
  muy_activo: 1.9,
} as const;
