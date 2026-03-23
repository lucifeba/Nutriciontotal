import { z } from 'zod';

export const crearPlanSchema = z.object({
  nombre: z.string().min(3, "El nombre debe tener al menos 3 caracteres"),
  pacienteId: z.string().min(1, "Selecciona un paciente"),
  tipoPlan: z.enum(["SEMANAL", "QUINCENAL"]),
  numPlanificaciones: z.number().min(1).max(4),
  comidasActivas: z.array(z.enum(["DESAYUNO", "MEDIA_MANANA", "ALMUERZO", "MERIENDA", "CENA", "RECENA"])).min(1),
  caloriasObjetivo: z.number().min(800).max(6000),
  proteinasObjetivo: z.number().min(20).max(500),
  carbohidratosObjetivo: z.number().min(50).max(800),
  grasasObjetivo: z.number().min(20).max(300),
  fibraObjetivo: z.number().min(10).max(80).optional(),
});

export type CrearPlanInput = z.infer<typeof crearPlanSchema>;
