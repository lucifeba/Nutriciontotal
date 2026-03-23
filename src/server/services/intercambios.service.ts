import { GRUPOS_INTERCAMBIO } from '@/lib/constants/alimentos-grupos';
import { DISTRIBUCION_CALORICA, FACTORES_ACTIVIDAD } from '@/lib/constants/nutrientes-referencia';

export type Sexo = 'MASCULINO' | 'FEMENINO';
export type NivelActividad = keyof typeof FACTORES_ACTIVIDAD;

/**
 * Calcula la Tasa Metabólica Basal (TMB) usando Harris-Benedict revisada
 */
export function calculateTMB(sexo: Sexo, peso: number, altura: number, edad: number): number {
  if (sexo === 'MASCULINO') {
    return 88.362 + (13.397 * peso) + (4.799 * altura) - (5.677 * edad);
  } else {
    return 447.593 + (9.247 * peso) + (3.098 * altura) - (4.330 * edad);
  }
}

/**
 * Calcula la TMB usando Mifflin-St Jeor (más precisa)
 */
export function calculateTMBMifflin(sexo: Sexo, peso: number, altura: number, edad: number): number {
  if (sexo === 'MASCULINO') {
    return (10 * peso) + (6.25 * altura) - (5 * edad) + 5;
  } else {
    return (10 * peso) + (6.25 * altura) - (5 * edad) - 161;
  }
}

/**
 * Calcula el Gasto Energético Total (GET)
 */
export function calculateGET(tmb: number, nivelActividad: NivelActividad): number {
  return Math.round(tmb * FACTORES_ACTIVIDAD[nivelActividad]);
}

/**
 * Ajusta calorías según objetivo
 */
export function adjustCaloriesByGoal(get: number, objetivo: string): number {
  switch (objetivo) {
    case 'perder peso':
      return Math.round(get * 0.80); // Déficit del 20%
    case 'ganar masa':
      return Math.round(get * 1.15); // Superávit del 15%
    case 'mejorar composición corporal':
      return Math.round(get * 0.90); // Déficit ligero del 10%
    default:
      return get; // Mantenimiento
  }
}

/**
 * Calcula macros en gramos a partir de calorías
 */
export function calculateMacros(calorias: number, distribucion: { proteinas: number; carbohidratos: number; grasas: number }) {
  return {
    proteinas: Math.round((calorias * distribucion.proteinas) / 4),
    carbohidratos: Math.round((calorias * distribucion.carbohidratos) / 4),
    grasas: Math.round((calorias * distribucion.grasas) / 9),
  };
}

/**
 * Distribuye calorías entre comidas activas
 */
export function distributeCaloriesPerMeal(
  caloriasTotal: number,
  comidasActivas: string[]
): Record<string, number> {
  const distribucion: Record<string, number> = {};

  const midPoints: Record<string, number> = {
    DESAYUNO: 0.225,
    MEDIA_MANANA: 0.075,
    ALMUERZO: 0.325,
    MERIENDA: 0.125,
    CENA: 0.275,
    RECENA: 0.05,
  };

  // Calculate total weight of active meals
  let totalWeight = 0;
  for (const comida of comidasActivas) {
    totalWeight += midPoints[comida] || 0;
  }

  // Normalize and distribute
  for (const comida of comidasActivas) {
    const weight = midPoints[comida] || 0;
    distribucion[comida] = Math.round(caloriasTotal * (weight / totalWeight));
  }

  return distribucion;
}

/**
 * Distribuye intercambios por comida según calorías asignadas
 */
export function distributeIntercambiosPerMeal(
  caloriasPorComida: Record<string, number>
): Record<string, Record<string, number>> {
  const result: Record<string, Record<string, number>> = {};

  for (const [comida, calorias] of Object.entries(caloriasPorComida)) {
    result[comida] = calculateIntercambiosForMeal(comida, calorias);
  }

  return result;
}

function calculateIntercambiosForMeal(tipoComida: string, calorias: number): Record<string, number> {
  const intercambios: Record<string, number> = {};

  switch (tipoComida) {
    case 'DESAYUNO':
      intercambios.LACTEOS = 1;
      intercambios.CEREALES_TUBERCULOS = Math.round((calorias - 130 - 45) / 70);
      intercambios.GRASAS = 1;
      intercambios.FRUTAS = 1;
      break;
    case 'MEDIA_MANANA':
      intercambios.FRUTAS = 1;
      intercambios.CEREALES_TUBERCULOS = 1;
      break;
    case 'ALMUERZO':
      intercambios.VERDURAS_HORTALIZAS = 2;
      intercambios.CEREALES_TUBERCULOS = Math.max(2, Math.round((calorias * 0.3) / 70));
      intercambios.CARNES_PESCADOS_HUEVOS = Math.max(1, Math.round((calorias * 0.25) / 80));
      intercambios.GRASAS = 2;
      intercambios.FRUTAS = 1;
      break;
    case 'MERIENDA':
      intercambios.LACTEOS = 1;
      intercambios.FRUTAS = 1;
      break;
    case 'CENA':
      intercambios.VERDURAS_HORTALIZAS = 2;
      intercambios.CEREALES_TUBERCULOS = Math.max(1, Math.round((calorias * 0.25) / 70));
      intercambios.CARNES_PESCADOS_HUEVOS = Math.max(1, Math.round((calorias * 0.3) / 80));
      intercambios.GRASAS = 1;
      break;
    case 'RECENA':
      intercambios.LACTEOS = 1;
      break;
  }

  return intercambios;
}

/**
 * Calculate age from birth date
 */
export function calculateAge(fechaNacimiento: Date): number {
  const today = new Date();
  let age = today.getFullYear() - fechaNacimiento.getFullYear();
  const monthDiff = today.getMonth() - fechaNacimiento.getMonth();
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < fechaNacimiento.getDate())) {
    age--;
  }
  return age;
}

/**
 * Calculate IMC (BMI)
 */
export function calculateIMC(peso: number, alturaCm: number): number {
  const alturaM = alturaCm / 100;
  return Math.round((peso / (alturaM * alturaM)) * 10) / 10;
}

/**
 * Get IMC category
 */
export function getIMCCategory(imc: number): string {
  if (imc < 18.5) return 'Bajo peso';
  if (imc < 25) return 'Normopeso';
  if (imc < 30) return 'Sobrepeso';
  if (imc < 35) return 'Obesidad grado I';
  if (imc < 40) return 'Obesidad grado II';
  return 'Obesidad grado III';
}
