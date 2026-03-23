"use client";

import { useEffect, useCallback } from 'react';
import { trpc } from '@/lib/trpc';
import { useChatStore } from '@/stores/chatStore';

export function useChat(conversacionId: string | null) {
  const { data: messages, refetch } = trpc.mensajes.getMessages.useQuery(
    { conversacionId: conversacionId || '' },
    { enabled: !!conversacionId, refetchInterval: 5000 }
  );

  const sendMutation = trpc.mensajes.send.useMutation({
    onSuccess: () => {
      refetch();
    },
  });

  const markAsReadMutation = trpc.mensajes.markAsRead.useMutation();

  const sendMessage = useCallback(
    (destinatarioId: string, contenido: string) => {
      if (!conversacionId) return;
      sendMutation.mutate({
        conversacionId,
        destinatarioId,
        contenido,
      });
    },
    [conversacionId, sendMutation]
  );

  const markAsRead = useCallback(() => {
    if (!conversacionId) return;
    markAsReadMutation.mutate({ conversacionId });
  }, [conversacionId, markAsReadMutation]);

  useEffect(() => {
    if (conversacionId) {
      markAsRead();
    }
  }, [conversacionId, markAsRead]);

  return {
    messages: messages?.messages || [],
    sendMessage,
    markAsRead,
    isSending: sendMutation.isLoading,
    refetch,
  };
}
