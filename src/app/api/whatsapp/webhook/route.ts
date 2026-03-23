import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

// Webhook verification (GET)
export async function GET(req: NextRequest) {
  const searchParams = req.nextUrl.searchParams;
  const mode = searchParams.get('hub.mode');
  const token = searchParams.get('hub.verify_token');
  const challenge = searchParams.get('hub.challenge');

  if (mode === 'subscribe' && token === process.env.WHATSAPP_VERIFY_TOKEN) {
    return new NextResponse(challenge, { status: 200 });
  }

  return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
}

// Webhook messages (POST)
export async function POST(req: NextRequest) {
  const body = await req.json();

  // Process status updates
  const entry = body.entry?.[0];
  const changes = entry?.changes?.[0];
  const statuses = changes?.value?.statuses;

  if (statuses) {
    for (const status of statuses) {
      const messageId = status.id;
      const statusValue = status.status; // sent, delivered, read

      const estadoMap: Record<string, string> = {
        sent: 'enviado',
        delivered: 'entregado',
        read: 'leido',
        failed: 'error',
      };

      if (messageId && estadoMap[statusValue]) {
        await prisma.whatsAppLog.updateMany({
          where: { messageId },
          data: { estado: estadoMap[statusValue] },
        });
      }
    }
  }

  return NextResponse.json({ status: 'ok' });
}
