import { z } from 'zod';

export const crearPacienteSchema = z.object({
  nombre: z.string().min(2, "El nombre debe tener al menos 2 caracteres"),
  apellidos: z.string().min(2, "Los apellidos deben tener al menos 2 caracteres"),
  email: z.string().email("Email no válido"),
  telefono: z.string().min(9, "Teléfono no válido").optional(),
  fechaNacimiento: z.string().optional(),
  sexo: z.enum(["MASCULINO", "FEMENINO", "OTRO"]).optional(),
  altura: z.number().min(50).max(250).optional(),
  pesoActual: z.number().min(20).max(300).optional(),
  pesoObjetivo: z.number().min(20).max(300).optional(),
});

export type CrearPacienteInput = z.infer<typeof crearPacienteSchema>;
