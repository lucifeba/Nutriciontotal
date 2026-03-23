/**
 * PDF generation service for nutritional plans
 * Uses @react-pdf/renderer for server-side PDF generation
 */

import { ESTRUCTURA_COMIDAS, DIAS_SEMANA } from '@/lib/constants/comidas-espana';

export interface PlanPDFData {
  planName: string;
  pacienteName: string;
  nutricionistaName: string;
  fechaInicio?: string;
  caloriasObjetivo: number;
  proteinasObjetivo: number;
  carbohidratosObjetivo: number;
  grasasObjetivo: number;
  planificaciones: {
    nombre: string;
    dias: {
      nombre: string;
      comidas: {
        tipo: string;
        hora?: string;
        alimentos: {
          nombre: string;
          cantidad: number;
          unidad?: string;
          notas?: string;
        }[];
        recetas: {
          nombre: string;
          raciones: number;
        }[];
        caloriasTotal?: number;
        proteinasTotal?: number;
        carbohidratosTotal?: number;
        grasasTotal?: number;
      }[];
      caloriasTotal?: number;
    }[];
  }[];
  observaciones?: string;
}

export function formatPlanForPDF(plan: any): PlanPDFData {
  return {
    planName: plan.nombre,
    pacienteName: `${plan.paciente.user.nombre} ${plan.paciente.user.apellidos}`,
    nutricionistaName: 'Nutricionista',
    caloriasObjetivo: plan.caloriasObjetivo,
    proteinasObjetivo: plan.proteinasObjetivo,
    carbohidratosObjetivo: plan.carbohidratosObjetivo,
    grasasObjetivo: plan.grasasObjetivo,
    observaciones: plan.observaciones,
    planificaciones: plan.planificaciones.map((p: any) => ({
      nombre: p.nombre || `Planificación ${p.numeroPlan}`,
      dias: p.dias.map((d: any) => ({
        nombre: d.nombre || DIAS_SEMANA.find(ds => ds.numero === d.diaSemana)?.nombre || `Día ${d.diaSemana}`,
        caloriasTotal: d.caloriasTotal,
        comidas: d.comidas.map((c: any) => {
          const estructura = ESTRUCTURA_COMIDAS[c.tipoComida as keyof typeof ESTRUCTURA_COMIDAS];
          return {
            tipo: estructura?.nombre || c.tipoComida,
            hora: c.hora || estructura?.horaDefault,
            caloriasTotal: c.caloriasTotal,
            proteinasTotal: c.proteinasTotal,
            carbohidratosTotal: c.carbohidratosTotal,
            grasasTotal: c.grasasTotal,
            alimentos: c.alimentos.map((a: any) => ({
              nombre: a.alimento.nombre,
              cantidad: a.cantidad,
              unidad: 'g',
              notas: a.notas,
            })),
            recetas: c.recetas.map((r: any) => ({
              nombre: r.receta.nombre,
              raciones: r.raciones,
            })),
          };
        }),
      })),
    })),
  };
}

export function generatePlanText(data: PlanPDFData): string {
  let text = '';
  text += `PLAN NUTRICIONAL: ${data.planName}\n`;
  text += `Paciente: ${data.pacienteName}\n`;
  text += `═══════════════════════════════════════\n\n`;
  text += `Objetivos: ${data.caloriasObjetivo} kcal | P: ${data.proteinasObjetivo}g | CH: ${data.carbohidratosObjetivo}g | G: ${data.grasasObjetivo}g\n\n`;

  for (const planificacion of data.planificaciones) {
    text += `──── ${planificacion.nombre} ────\n\n`;

    for (const dia of planificacion.dias) {
      text += `📅 ${dia.nombre}\n`;

      for (const comida of dia.comidas) {
        text += `  🍽️ ${comida.tipo}${comida.hora ? ` (${comida.hora})` : ''}\n`;

        for (const alimento of comida.alimentos) {
          text += `    • ${alimento.nombre} - ${alimento.cantidad}${alimento.unidad || 'g'}`;
          if (alimento.notas) text += ` (${alimento.notas})`;
          text += '\n';
        }

        for (const receta of comida.recetas) {
          text += `    🍳 ${receta.nombre} (${receta.raciones} ración/es)\n`;
        }

        if (comida.caloriasTotal) {
          text += `    [${comida.caloriasTotal} kcal | P:${comida.proteinasTotal}g | CH:${comida.carbohidratosTotal}g | G:${comida.grasasTotal}g]\n`;
        }
        text += '\n';
      }

      if (dia.caloriasTotal) {
        text += `  Total día: ${dia.caloriasTotal} kcal\n`;
      }
      text += '\n';
    }
  }

  if (data.observaciones) {
    text += `\n📝 Observaciones:\n${data.observaciones}\n`;
  }

  text += '\n── Generado por NutriPlan Pro ──\n';
  return text;
}
