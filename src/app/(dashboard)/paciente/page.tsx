"use client";

import { useSession } from "next-auth/react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { FileText, MessageSquare, User } from "lucide-react";
import Link from "next/link";

export default function PacienteDashboard() {
  const { data: session } = useSession();

  return (
    <div className="space-y-6">
      {/* Welcome */}
      <div>
        <h2 className="text-2xl font-bold text-[#2D5A3D]">
          Hola, {session?.user?.name?.split(" ")[0]}
        </h2>
        <p className="text-muted-foreground">Tu espacio de seguimiento nutricional</p>
      </div>

      {/* Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* Mi Plan Activo */}
        <Card className="md:col-span-2">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-lg">
              <FileText className="h-5 w-5 text-[#2D5A3D]" />
              Mi Plan Activo
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-center py-8">
              <div className="w-16 h-16 rounded-full bg-[#2D5A3D]/10 flex items-center justify-center mx-auto mb-4">
                <FileText className="h-8 w-8 text-[#2D5A3D]" />
              </div>
              <p className="text-muted-foreground mb-4">
                No tienes planes asignados actualmente
              </p>
              <p className="text-sm text-muted-foreground">
                Tu nutricionista te asignará un plan personalizado pronto
              </p>
            </div>
            <Link href="/paciente/mis-planes">
              <Button variant="outline" className="w-full border-[#2D5A3D] text-[#2D5A3D]">
                Ver Mis Planes
              </Button>
            </Link>
          </CardContent>
        </Card>

        {/* Side Cards */}
        <div className="space-y-6">
          {/* Mensajes */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <MessageSquare className="h-5 w-5 text-[#C67B4D]" />
                Mensajes
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-sm text-muted-foreground mb-4">
                Comunícate con tu nutricionista
              </p>
              <Link href="/paciente/mensajes">
                <Button variant="outline" className="w-full">
                  Ir a Mensajes
                </Button>
              </Link>
            </CardContent>
          </Card>

          {/* Mi Perfil */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <User className="h-5 w-5 text-[#2D5A3D]" />
                Mi Perfil
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-sm text-muted-foreground mb-4">
                Actualiza tus datos personales
              </p>
              <Link href="/paciente/perfil">
                <Button variant="outline" className="w-full">
                  Ver Perfil
                </Button>
              </Link>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
