"use client";

import { useState, useRef, useEffect } from "react";
import { trpc } from "@/lib/trpc/client";
import { useSession } from "next-auth/react";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Send, MessageSquare } from "lucide-react";

export default function PacienteMensajesPage() {
  const { data: session } = useSession();
  const [message, setMessage] = useState("");
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const { data: conversaciones, isLoading } = trpc.mensajes.getConversaciones.useQuery();
  const conversacion = (conversaciones || [])[0] as any;

  const { data: messagesData, refetch: refetchMessages } = trpc.mensajes.getMessages.useQuery(
    { conversacionId: conversacion?.id },
    { enabled: !!conversacion?.id, refetchInterval: 5000 }
  );

  const utils = trpc.useUtils();
  const sendMutation = trpc.mensajes.send.useMutation({
    onSuccess: () => {
      setMessage("");
      refetchMessages();
      utils.mensajes.getConversaciones.invalidate();
    },
  });
  const markReadMutation = trpc.mensajes.markAsRead.useMutation();

  const nutriNombre = conversacion?.paciente?.nutricionista?.user?.nombre;
  const nutriApellidos = conversacion?.paciente?.nutricionista?.user?.apellidos;
  const nutriUserId = conversacion?.paciente?.nutricionista?.userId;

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messagesData]);

  useEffect(() => {
    if (conversacion?.id) {
      markReadMutation.mutate({ conversacionId: conversacion.id });
    }
  }, [conversacion?.id]);

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <LoadingSpinner text="Cargando mensajes..." />
      </div>
    );
  }

  if (!conversacion) {
    return (
      <div className="space-y-4">
        <div>
          <h2 className="text-xl font-bold text-[#2D5A3D]">Mensajes</h2>
          <p className="text-sm text-muted-foreground">Comunicación con tu nutricionista</p>
        </div>
        <Card className="p-12 text-center">
          <MessageSquare className="h-12 w-12 mx-auto text-muted-foreground/30 mb-3" />
          <p className="text-muted-foreground">No hay conversaciones todavía</p>
        </Card>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div>
        <h2 className="text-xl font-bold text-[#2D5A3D]">Mensajes</h2>
        <p className="text-sm text-muted-foreground">
          Conversación con {nutriNombre} {nutriApellidos}
        </p>
      </div>

      <Card className="flex flex-col h-[calc(100vh-220px)]">
        {/* Messages */}
        <ScrollArea className="flex-1 p-4">
          <div className="space-y-3">
            {(messagesData?.messages || []).map((msg: any) => {
              const isMe = msg.remitenteId === (session?.user as any)?.id;
              return (
                <div key={msg.id} className={`flex ${isMe ? "justify-end" : "justify-start"}`}>
                  <div className={`max-w-[70%] rounded-lg p-3 text-sm ${isMe ? "bg-[#2D5A3D] text-white" : "bg-gray-100"}`}>
                    <p>{msg.contenido}</p>
                    <p className={`text-[10px] mt-1 ${isMe ? "text-white/60" : "text-muted-foreground"}`}>
                      {new Date(msg.createdAt).toLocaleTimeString("es-ES", { hour: "2-digit", minute: "2-digit" })}
                    </p>
                  </div>
                </div>
              );
            })}
            <div ref={messagesEndRef} />
          </div>
        </ScrollArea>

        {/* Input */}
        <div className="p-3 border-t flex gap-2">
          <Input
            placeholder="Escribe un mensaje..."
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter" && !e.shiftKey && message.trim() && nutriUserId) {
                sendMutation.mutate({
                  conversacionId: conversacion.id,
                  destinatarioId: nutriUserId,
                  contenido: message.trim(),
                });
              }
            }}
          />
          <Button
            onClick={() => {
              if (message.trim() && nutriUserId) {
                sendMutation.mutate({
                  conversacionId: conversacion.id,
                  destinatarioId: nutriUserId,
                  contenido: message.trim(),
                });
              }
            }}
            disabled={!message.trim() || sendMutation.isPending}
            className="bg-[#2D5A3D] hover:bg-[#234A31]"
          >
            <Send className="h-4 w-4" />
          </Button>
        </div>
      </Card>
    </div>
  );
}
