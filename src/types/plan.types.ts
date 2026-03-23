import { TipoComida, GrupoIntercambio, EstadoPlan, TipoPlan } from '@prisma/client';

export interface IntercambiosConfig {
  [key: string]: {
    [comida in TipoComida]?: number;
  };
}

export interface NutrienteSummary {
  calorias: number;
  proteinas: number;
  carbohidratos: number;
  grasas: number;
  fibra?: number;
}

export interface PlanConfig {
  pacienteId: string;
  nombre: string;
  tipoPlan: TipoPlan;
  numPlanificaciones: number;
  comidasActivas: TipoComida[];
  caloriasObjetivo: number;
  proteinasObjetivo: number;
  carbohidratosObjetivo: number;
  grasasObjetivo: number;
  fibraObjetivo?: number;
  intercambiosConfig?: IntercambiosConfig;
}
