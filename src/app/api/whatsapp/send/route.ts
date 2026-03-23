import { NextRequest, NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';
import { prisma } from '@/lib/prisma';

export async function POST(req: NextRequest) {
  const session = await getServerSession(authOptions);
  if (!session) {
    return NextResponse.json({ error: 'No autenticado' }, { status: 401 });
  }

  const body = await req.json();
  const { telefono, tipo, nombre, url, mensaje } = body;

  if (!telefono) {
    return NextResponse.json({ error: 'Teléfono requerido' }, { status: 400 });
  }

  let messageContent = '';

  switch (tipo) {
    case 'encuesta':
      messageContent = `¡Hola ${nombre}! Tu nutricionista te ha dado de alta en NutriPlan Pro. Por favor, completa esta encuesta inicial para que podamos conocerte mejor: ${url}`;
      break;
    case 'recordatorio':
      messageContent = `Hola ${nombre}, ${mensaje}`;
      break;
    case 'notificacion':
      messageContent = mensaje || 'Tienes una nueva notificación en NutriPlan Pro.';
      break;
    default:
      messageContent = mensaje || '';
  }

  // Log the attempt
  const log = await prisma.whatsAppLog.create({
    data: {
      telefono,
      tipo,
      contenido: messageContent,
      estado: 'enviado',
    },
  });

  // If WhatsApp API credentials are configured, send the actual message
  const accessToken = process.env.WHATSAPP_ACCESS_TOKEN;
  const phoneNumberId = process.env.WHATSAPP_PHONE_NUMBER_ID;

  if (accessToken && phoneNumberId) {
    try {
      const formattedPhone = telefono.replace(/[^0-9]/g, '');

      const response = await fetch(
        `https://graph.facebook.com/v18.0/${phoneNumberId}/messages`,
        {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            messaging_product: 'whatsapp',
            to: formattedPhone,
            type: 'text',
            text: { body: messageContent },
          }),
        }
      );

      if (response.ok) {
        const data = await response.json();
        await prisma.whatsAppLog.update({
          where: { id: log.id },
          data: {
            estado: 'entregado',
            messageId: data.messages?.[0]?.id,
          },
        });
      } else {
        await prisma.whatsAppLog.update({
          where: { id: log.id },
          data: { estado: 'error' },
        });
      }
    } catch (error) {
      await prisma.whatsAppLog.update({
        where: { id: log.id },
        data: { estado: 'error' },
      });
    }
  }

  return NextResponse.json({
    success: true,
    message: accessToken
      ? 'Mensaje enviado por WhatsApp'
      : 'Mensaje registrado (WhatsApp API no configurada)',
    logId: log.id,
  });
}
