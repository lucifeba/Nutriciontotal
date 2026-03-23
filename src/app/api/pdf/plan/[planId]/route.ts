import { NextRequest, NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';
import { prisma } from '@/lib/prisma';
import { formatPlanForPDF, generatePlanText } from '@/server/services/pdf.service';

export async function GET(
  req: NextRequest,
  { params }: { params: { planId: string } }
) {
  const session = await getServerSession(authOptions);
  if (!session) {
    return NextResponse.json({ error: 'No autenticado' }, { status: 401 });
  }

  const plan = await prisma.planNutricional.findUnique({
    where: { id: params.planId },
    include: {
      paciente: { include: { user: { select: { nombre: true, apellidos: true } } } },
      planificaciones: {
        include: {
          dias: {
            include: {
              comidas: {
                include: {
                  alimentos: { include: { alimento: true } },
                  recetas: { include: { receta: true } },
                },
                orderBy: { orden: 'asc' },
              },
            },
            orderBy: { diaSemana: 'asc' },
          },
        },
        orderBy: { numeroPlan: 'asc' },
      },
    },
  });

  if (!plan) {
    return NextResponse.json({ error: 'Plan no encontrado' }, { status: 404 });
  }

  const pdfData = formatPlanForPDF(plan);
  const textContent = generatePlanText(pdfData);

  // Return as downloadable text file (PDF generation would use @react-pdf/renderer on the client)
  return new NextResponse(textContent, {
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Content-Disposition': `attachment; filename="plan-${plan.nombre.replace(/\s+/g, '-')}.txt"`,
    },
  });
}
