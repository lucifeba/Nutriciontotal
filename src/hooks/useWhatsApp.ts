"use client";

import { useState } from 'react';

export function useWhatsApp() {
  const [isSending, setIsSending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const sendEncuestaLink = async (telefono: string, nombre: string, token: string) => {
    setIsSending(true);
    setError(null);

    try {
      const encuestaUrl = `${process.env.NEXT_PUBLIC_APP_URL}/encuesta/${token}`;
      const response = await fetch('/api/whatsapp/send', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          telefono,
          tipo: 'encuesta',
          nombre,
          url: encuestaUrl,
        }),
      });

      if (!response.ok) throw new Error('Error al enviar WhatsApp');
      return true;
    } catch (e) {
      setError((e as Error).message);
      return false;
    } finally {
      setIsSending(false);
    }
  };

  const sendRecordatorio = async (telefono: string, nombre: string, message: string) => {
    setIsSending(true);
    setError(null);

    try {
      const response = await fetch('/api/whatsapp/send', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          telefono,
          tipo: 'recordatorio',
          nombre,
          mensaje: message,
        }),
      });

      if (!response.ok) throw new Error('Error al enviar recordatorio');
      return true;
    } catch (e) {
      setError((e as Error).message);
      return false;
    } finally {
      setIsSending(false);
    }
  };

  return { sendEncuestaLink, sendRecordatorio, isSending, error };
}
