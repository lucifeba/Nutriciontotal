"use client";

import { useSession } from "next-auth/react";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { Badge } from "@/components/ui/badge";
import { Settings, User, Building, Phone } from "lucide-react";

export default function ConfiguracionPage() {
  const { data: session } = useSession();
  const user = session?.user as any;

  return (
    <div className="space-y-6 max-w-2xl">
      <div>
        <h2 className="text-xl font-bold text-[#2D5A3D]">Configuración</h2>
        <p className="text-sm text-muted-foreground">Gestiona tu perfil profesional</p>
      </div>

      {/* Profile info */}
      <Card className="p-6 space-y-6">
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded-full bg-[#2D5A3D] flex items-center justify-center text-white font-bold text-lg">
            {user?.name?.charAt(0) || "N"}
          </div>
          <div>
            <p className="font-semibold">{user?.name || "Nutricionista"}</p>
            <p className="text-sm text-muted-foreground">{user?.email}</p>
            <Badge className="bg-[#2D5A3D]/10 text-[#2D5A3D] mt-1">Nutricionista</Badge>
          </div>
        </div>

        <Separator />

        <div className="space-y-4">
          <h3 className="font-semibold flex items-center gap-2">
            <User className="h-4 w-4" />
            Datos personales
          </h3>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label>Nombre</Label>
              <Input value={user?.name || ""} disabled />
            </div>
            <div>
              <Label>Email</Label>
              <Input value={user?.email || ""} disabled />
            </div>
          </div>
        </div>

        <Separator />

        <div className="space-y-4">
          <h3 className="font-semibold flex items-center gap-2">
            <Building className="h-4 w-4" />
            Información profesional
          </h3>
          <p className="text-sm text-muted-foreground">
            La edición del perfil profesional estará disponible próximamente.
          </p>
        </div>

        <Separator />

        <div className="space-y-4">
          <h3 className="font-semibold flex items-center gap-2">
            <Phone className="h-4 w-4" />
            WhatsApp Business
          </h3>
          <p className="text-sm text-muted-foreground">
            Configura la integración con WhatsApp Business para enviar recordatorios y planes a tus pacientes.
            Esta funcionalidad requiere configurar las variables de entorno de WhatsApp.
          </p>
        </div>
      </Card>
    </div>
  );
}
