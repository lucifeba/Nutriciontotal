"use client";

import { useMemo } from 'react';
import { GRUPOS_INTERCAMBIO } from '@/lib/constants/alimentos-grupos';

interface FoodItem {
  alimento: {
    nombre: string;
    calorias: number;
    proteinas: number;
    carbohidratos: number;
    grasas: number;
  };
  cantidad: number;
}

interface RecipeItem {
  receta: {
    nombre: string;
    caloriasPorRacion: number | null;
    proteinasPorRacion: number | null;
    carbohidratosPorRacion: number | null;
    grasasPorRacion: number | null;
  };
  raciones: number;
}

export function useMealNutrients(alimentos: FoodItem[], recetas: RecipeItem[]) {
  return useMemo(() => {
    let calorias = 0;
    let proteinas = 0;
    let carbohidratos = 0;
    let grasas = 0;

    for (const item of alimentos) {
      const factor = item.cantidad / 100;
      calorias += item.alimento.calorias * factor;
      proteinas += item.alimento.proteinas * factor;
      carbohidratos += item.alimento.carbohidratos * factor;
      grasas += item.alimento.grasas * factor;
    }

    for (const item of recetas) {
      calorias += (item.receta.caloriasPorRacion || 0) * item.raciones;
      proteinas += (item.receta.proteinasPorRacion || 0) * item.raciones;
      carbohidratos += (item.receta.carbohidratosPorRacion || 0) * item.raciones;
      grasas += (item.receta.grasasPorRacion || 0) * item.raciones;
    }

    return {
      calorias: Math.round(calorias),
      proteinas: Math.round(proteinas),
      carbohidratos: Math.round(carbohidratos),
      grasas: Math.round(grasas),
    };
  }, [alimentos, recetas]);
}

export function useDayNutrients(comidas: any[]) {
  return useMemo(() => {
    let calorias = 0;
    let proteinas = 0;
    let carbohidratos = 0;
    let grasas = 0;

    for (const comida of comidas) {
      calorias += comida.caloriasTotal || 0;
      proteinas += comida.proteinasTotal || 0;
      carbohidratos += comida.carbohidratosTotal || 0;
      grasas += comida.grasasTotal || 0;
    }

    return {
      calorias: Math.round(calorias),
      proteinas: Math.round(proteinas),
      carbohidratos: Math.round(carbohidratos),
      grasas: Math.round(grasas),
    };
  }, [comidas]);
}

export function useExchangeCalculator() {
  return {
    calculateExchanges: (alimentoGrupo: string, cantidadGramos: number, racionIntercambio: number) => {
      return Math.round((cantidadGramos / racionIntercambio) * 10) / 10;
    },
    calculateGramsFromExchanges: (intercambios: number, racionIntercambio: number) => {
      return Math.round(intercambios * racionIntercambio);
    },
    getExchangeNutrients: (grupo: string, intercambios: number) => {
      const grupoData = GRUPOS_INTERCAMBIO[grupo as keyof typeof GRUPOS_INTERCAMBIO];
      if (!grupoData) return { calorias: 0, proteinas: 0, carbohidratos: 0, grasas: 0 };
      return {
        calorias: Math.round(grupoData.porRacion.calorias * intercambios),
        proteinas: Math.round(grupoData.porRacion.proteinas * intercambios * 10) / 10,
        carbohidratos: Math.round(grupoData.porRacion.carbohidratos * intercambios * 10) / 10,
        grasas: Math.round(grupoData.porRacion.grasas * intercambios * 10) / 10,
      };
    },
  };
}
