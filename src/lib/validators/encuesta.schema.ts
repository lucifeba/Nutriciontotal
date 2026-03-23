import { z } from 'zod';

export const encuestaStep1Schema = z.object({
  ocupacion: z.string().optional(),
  horarioLaboral: z.string().optional(),
  estadoCivil: z.string().optional(),
  numHijos: z.number().min(0).optional(),
  quienCocinaEnCasa: z.string().optional(),
  comeEnCasaOFuera: z.string().optional(),
});

export const encuestaStep2Schema = z.object({
  patologias: z.array(z.string()).optional(),
  patologiasDetalle: z.string().optional(),
  alergias: z.array(z.string()).optional(),
  intolerancias: z.array(z.string()).optional(),
  medicacionActual: z.string().optional(),
  suplementos: z.string().optional(),
  cirugiasPrevias: z.string().optional(),
  antecedentesFamiliares: z.array(z.string()).optional(),
  problemaDigestivo: z.array(z.string()).optional(),
  transitoIntestinal: z.string().optional(),
});

export const encuestaStep8Schema = z.object({
  aceptaPoliticaPrivacidad: z.literal(true, { error: "Debes aceptar la política de privacidad" }),
  aceptaTratamientoDatos: z.literal(true, { error: "Debes aceptar el tratamiento de datos" }),
  firmaDigital: z.string().min(1, "La firma es obligatoria"),
});
