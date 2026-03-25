"use client";

import { useState, useRef, useEffect } from "react";
import { trpc } from "@/lib/trpc/client";
import { useSession } from "next-auth/react";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Send, MessageSquare } from "lucide-react";

export default function MensajesPage() {
  const { data: session } = useSession();
  const [selectedConv, setSelectedConv] = useState<string | null>(null);
  const [message, setMessage] = useState("");
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const { data: conversaciones, isLoading } = trpc.mensajes.getConversaciones.useQuery();
  const { data: messagesData, refetch: refetchMessages } = trpc.mensajes.getMessages.useQuery(
    { conversacionId: selectedConv! },
    { enabled: !!selectedConv, refetchInterval: 5000 }
  );

  const utils = trpc.useUtils();
  const sendMutation = trpc.mensajes.send.useMutation({
    onSuccess: () => {
      setMessage("");
      refetchMessages();
      utils.mensajes.getConversaciones.invalidate();
    },
  });
  const markReadMutation = trpc.mensajes.markAsRead.useMutation({
    onSuccess: () => utils.mensajes.getConversaciones.invalidate(),
  });

  const selectedConversacion = (conversaciones || []).find((c: any) => c.id === selectedConv);
  const destinatarioId = selectedConversacion
    ? (selectedConversacion as any).paciente?.userId
    : undefined;

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messagesData]);

  useEffect(() => {
    if (selectedConv) {
      markReadMutation.mutate({ conversacionId: selectedConv });
    }
  }, [selectedConv]);

  const handleSend = () => {
    if (!message.trim() || !selectedConv || !destinatarioId) return;
    sendMutation.mutate({
      conversacionId: selectedConv,
      destinatarioId,
      contenido: message.trim(),
    });
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <LoadingSpinner text="Cargando mensajes..." />
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div>
        <h2 className="text-xl font-bold text-[#2D5A3D]">Mensajes</h2>
        <p className="text-sm text-muted-foreground">Comunicación con tus pacientes</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 h-[calc(100vh-220px)]">
        {/* Conversations list */}
        <Card className="p-0 overflow-hidden">
          <div className="p-3 border-b font-medium text-sm">Conversaciones</div>
          <ScrollArea className="h-full">
            {(conversaciones || []).length === 0 ? (
              <div className="p-4 text-sm text-muted-foreground text-center">
                No hay conversaciones
              </div>
            ) : (
              (conversaciones || []).map((conv: any) => (
                <div
                  key={conv.id}
                  className={`p-3 border-b cursor-pointer hover:bg-gray-50 transition-colors ${selectedConv === conv.id ? "bg-[#2D5A3D]/5 border-l-2 border-l-[#2D5A3D]" : ""}`}
                  onClick={() => setSelectedConv(conv.id)}
                >
                  <div className="flex justify-between items-start">
                    <p className="font-medium text-sm">
                      {conv.paciente?.user?.nombre} {conv.paciente?.user?.apellidos}
                    </p>
                    {conv.noLeidos > 0 && (
                      <Badge className="bg-[#C67B4D] text-white text-[10px]">{conv.noLeidos}</Badge>
                    )}
                  </div>
                  <p className="text-xs text-muted-foreground truncate mt-1">
                    {conv.ultimoMensaje || "Sin mensajes"}
                  </p>
                </div>
              ))
            )}
          </ScrollArea>
        </Card>

        {/* Chat area */}
        <Card className="md:col-span-2 p-0 overflow-hidden flex flex-col">
          {!selectedConv ? (
            <div className="flex-1 flex flex-col items-center justify-center text-muted-foreground">
              <MessageSquare className="h-12 w-12 mb-2 opacity-30" />
              <p className="text-sm">Selecciona una conversación</p>
            </div>
          ) : (
            <>
              {/* Header */}
              <div className="p-3 border-b font-medium text-sm">
                {selectedConversacion && (selectedConversacion as any).paciente?.user?.nombre}{" "}
                {selectedConversacion && (selectedConversacion as any).paciente?.user?.apellidos}
              </div>

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
                  onKeyDown={(e) => e.key === "Enter" && !e.shiftKey && handleSend()}
                />
                <Button
                  onClick={handleSend}
                  disabled={!message.trim() || sendMutation.isPending}
                  className="bg-[#2D5A3D] hover:bg-[#234A31]"
                >
                  <Send className="h-4 w-4" />
                </Button>
              </div>
            </>
          )}
        </Card>
      </div>
    </div>
  );
}
