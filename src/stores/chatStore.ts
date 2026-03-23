"use client";

import { create } from 'zustand';

interface ChatState {
  activeConversationId: string | null;
  activeRecipientId: string | null;
  activeRecipientName: string | null;
  setActiveConversation: (id: string | null, recipientId?: string | null, recipientName?: string | null) => void;
  reset: () => void;
}

export const useChatStore = create<ChatState>((set) => ({
  activeConversationId: null,
  activeRecipientId: null,
  activeRecipientName: null,
  setActiveConversation: (id, recipientId = null, recipientName = null) =>
    set({ activeConversationId: id, activeRecipientId: recipientId, activeRecipientName: recipientName }),
  reset: () =>
    set({ activeConversationId: null, activeRecipientId: null, activeRecipientName: null }),
}));
