"use client";

import { useSession } from "next-auth/react";
import { trpc } from "@/lib/trpc/client";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { User, Scale, Ruler, Target, Activity } from "lucide-react";

export default function PerfilPacientePage() {
  const { data: session } = useSession();
  const user = session?.user as any;
  const pacienteId = user?.pacienteId;

  const { data: paciente, isLoading } = trpc.pacientes.getById.useQuery(
    { id: pacienteId! },
    { enabled: !!pacienteId }
  );

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <LoadingSpinner text="Cargando perfil..." />
      </div>
    );
  }

  return (
    <div className="space-y-6 max-w-2xl">
      <div>
        <h2 className="text-xl font-bold text-[#2D5A3D]">Mi Perfil</h2>
        <p className="text-sm text-muted-foreground">Tu información personal y de salud</p>
      </div>

      {/* Personal info */}
      <Card className="p-6 space-y-6">
        <div className="flex items-center gap-3">
          <div className="w-14 h-14 rounded-full bg-[#2D5A3D] flex items-center justify-center text-white font-bold text-xl">
            {user?.name?.charAt(0) || "P"}
          </div>
          <div>
            <p className="font-semibold text-lg">{paciente?.user?.nombre} {paciente?.user?.apellidos}</p>
            <p className="text-sm text-muted-foreground">{paciente?.user?.email}</p>
            {paciente?.user?.telefono && (
              <p className="text-sm text-muted-foreground">{paciente.user.telefono}</p>
            )}
          </div>
        </div>

        <Separator />

        {/* Body metrics */}
        <div>
          <h3 className="font-semibold flex items-center gap-2 mb-4">
            <Activity className="h-4 w-4" />
            Datos corporales
          </h3>
          <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
            {paciente?.altura && (
              <div className="bg-gray-50 rounded-lg p-3 text-center">
                <Ruler className="h-5 w-5 mx-auto text-[#2D5A3D] mb-1" />
                <div className="text-lg font-bold">{paciente.altura} cm</div>
                <div className="text-xs text-muted-foreground">Altura</div>
              </div>
            )}
            {paciente?.pesoActual && (
              <div className="bg-gray-50 rounded-lg p-3 text-center">
                <Scale className="h-5 w-5 mx-auto text-[#2D5A3D] mb-1" />
                <div className="text-lg font-bold">{paciente.pesoActual} kg</div>
                <div className="text-xs text-muted-foreground">Peso actual</div>
              </div>
            )}
            {paciente?.pesoObjetivo && (
              <div className="bg-gray-50 rounded-lg p-3 text-center">
                <Target className="h-5 w-5 mx-auto text-[#C67B4D] mb-1" />
                <div className="text-lg font-bold">{paciente.pesoObjetivo} kg</div>
                <div className="text-xs text-muted-foreground">Peso objetivo</div>
              </div>
            )}
            {paciente?.imc && (
              <div className="bg-gray-50 rounded-lg p-3 text-center">
                <div className="text-lg font-bold">{paciente.imc}</div>
                <div className="text-xs text-muted-foreground">IMC</div>
              </div>
            )}
            {paciente?.sexo && (
              <div className="bg-gray-50 rounded-lg p-3 text-center">
                <User className="h-5 w-5 mx-auto text-[#2D5A3D] mb-1" />
                <div className="text-sm font-medium">{paciente.sexo}</div>
                <div className="text-xs text-muted-foreground">Sexo</div>
              </div>
            )}
            {paciente?.fechaNacimiento && (
              <div className="bg-gray-50 rounded-lg p-3 text-center">
                <div className="text-sm font-medium">
                  {new Date(paciente.fechaNacimiento).toLocaleDateString("es-ES")}
                </div>
                <div className="text-xs text-muted-foreground">Fecha nacimiento</div>
              </div>
            )}
          </div>
        </div>

        {/* Recent measurements */}
        {paciente?.mediciones && paciente.mediciones.length > 0 && (
          <>
            <Separator />
            <div>
              <h3 className="font-semibold mb-3">Últimas mediciones</h3>
              <div className="space-y-2">
                {paciente.mediciones.slice(0, 5).map((m: any) => (
                  <div key={m.id} className="flex items-center justify-between text-sm bg-gray-50 rounded p-2">
                    <span className="text-muted-foreground">
                      {new Date(m.fecha).toLocaleDateString("es-ES")}
                    </span>
                    <div className="flex gap-3">
                      {m.peso && <span>{m.peso} kg</span>}
                      {m.porcentajeGrasa && <span>{m.porcentajeGrasa}% grasa</span>}
                      {m.masaMuscular && <span>{m.masaMuscular} kg músculo</span>}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </>
        )}

        {/* Anamnesis status */}
        <Separator />
        <div className="flex justify-between items-center">
          <span className="text-sm font-medium">Encuesta nutricional</span>
          <Badge className={paciente?.encuestaCompletada ? "bg-green-100 text-green-700" : "bg-orange-100 text-orange-700"}>
            {paciente?.encuestaCompletada ? "Completada" : "Pendiente"}
          </Badge>
        </div>
      </Card>
    </div>
  );
}
