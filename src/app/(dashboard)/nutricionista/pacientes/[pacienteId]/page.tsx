"use client";

import { use } from "react";
import { trpc } from "@/lib/trpc/client";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { ArrowLeft, Scale, Ruler, Target, User, CalendarDays, FileText, ClipboardList } from "lucide-react";
import Link from "next/link";

const estadoColor: Record<string, string> = {
  BORRADOR: "bg-gray-100 text-gray-700",
  ACTIVO: "bg-green-100 text-green-700",
  COMPLETADO: "bg-blue-100 text-blue-700",
  CANCELADO: "bg-red-100 text-red-700",
};

export default function PacienteDetallePage({ params }: { params: Promise<{ pacienteId: string }> }) {
  const { pacienteId } = use(params);
  const { data: paciente, isLoading } = trpc.pacientes.getById.useQuery({ id: pacienteId });

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <LoadingSpinner text="Cargando ficha del paciente..." />
      </div>
    );
  }

  if (!paciente) {
    return (
      <div className="text-center py-20">
        <p className="text-muted-foreground">Paciente no encontrado</p>
        <Link href="/nutricionista/pacientes">
          <Button variant="link">Volver a pacientes</Button>
        </Link>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Link href="/nutricionista/pacientes">
          <Button variant="ghost" size="sm">
            <ArrowLeft className="h-4 w-4 mr-1" />
            Volver
          </Button>
        </Link>
        <div>
          <h2 className="text-xl font-bold text-[#2D5A3D]">
            {paciente.user?.nombre} {paciente.user?.apellidos}
          </h2>
          <p className="text-sm text-muted-foreground">{paciente.user?.email}</p>
        </div>
        <Badge className={paciente.activo ? "bg-green-100 text-green-700" : "bg-gray-100 text-gray-700"}>
          {paciente.activo ? "Activo" : "Inactivo"}
        </Badge>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left column - Personal data */}
        <Card className="p-5 space-y-4">
          <h3 className="font-semibold flex items-center gap-2">
            <User className="h-4 w-4" />
            Datos corporales
          </h3>
          <div className="space-y-3">
            {paciente.altura && (
              <div className="flex justify-between">
                <span className="text-sm text-muted-foreground">Altura</span>
                <span className="text-sm font-medium">{paciente.altura} cm</span>
              </div>
            )}
            {paciente.pesoActual && (
              <div className="flex justify-between">
                <span className="text-sm text-muted-foreground">Peso actual</span>
                <span className="text-sm font-medium">{paciente.pesoActual} kg</span>
              </div>
            )}
            {paciente.pesoObjetivo && (
              <div className="flex justify-between">
                <span className="text-sm text-muted-foreground">Peso objetivo</span>
                <span className="text-sm font-medium">{paciente.pesoObjetivo} kg</span>
              </div>
            )}
            {paciente.imc && (
              <div className="flex justify-between">
                <span className="text-sm text-muted-foreground">IMC</span>
                <span className="text-sm font-medium">{paciente.imc}</span>
              </div>
            )}
            {paciente.sexo && (
              <div className="flex justify-between">
                <span className="text-sm text-muted-foreground">Sexo</span>
                <span className="text-sm font-medium">{paciente.sexo}</span>
              </div>
            )}
            {paciente.fechaNacimiento && (
              <div className="flex justify-between">
                <span className="text-sm text-muted-foreground">Fecha nacimiento</span>
                <span className="text-sm font-medium">
                  {new Date(paciente.fechaNacimiento).toLocaleDateString("es-ES")}
                </span>
              </div>
            )}
          </div>

          <Separator />

          <div className="flex justify-between items-center">
            <span className="text-sm">Encuesta nutricional</span>
            <Badge className={paciente.encuestaCompletada ? "bg-green-100 text-green-700" : "bg-orange-100 text-orange-700"}>
              {paciente.encuestaCompletada ? "Completada" : "Pendiente"}
            </Badge>
          </div>
          {!paciente.encuestaCompletada && paciente.encuestaToken && (
            <div className="bg-orange-50 rounded p-3">
              <p className="text-xs text-orange-700 mb-1">Link de la encuesta:</p>
              <code className="text-xs break-all">/encuesta/{paciente.encuestaToken}</code>
            </div>
          )}
        </Card>

        {/* Middle column - Plans */}
        <Card className="p-5 space-y-4">
          <div className="flex justify-between items-center">
            <h3 className="font-semibold flex items-center gap-2">
              <CalendarDays className="h-4 w-4" />
              Planes nutricionales
            </h3>
            <Link href="/nutricionista/planificador">
              <Button size="sm" className="bg-[#2D5A3D] hover:bg-[#234A31]">
                Crear plan
              </Button>
            </Link>
          </div>

          {(paciente.planes || []).length === 0 ? (
            <p className="text-sm text-muted-foreground text-center py-4">Sin planes asignados</p>
          ) : (
            <div className="space-y-3">
              {paciente.planes.map((plan: any) => (
                <Link key={plan.id} href={`/nutricionista/planificador/${plan.id}`}>
                  <div className="border rounded-lg p-3 hover:bg-gray-50 transition-colors">
                    <div className="flex justify-between items-start">
                      <p className="text-sm font-medium">{plan.nombre}</p>
                      <Badge className={`text-[10px] ${estadoColor[plan.estado] || ""}`}>{plan.estado}</Badge>
                    </div>
                    <p className="text-xs text-muted-foreground mt-1">
                      {plan.caloriasObjetivo} kcal · {plan.tipoPlan}
                    </p>
                  </div>
                </Link>
              ))}
            </div>
          )}
        </Card>

        {/* Right column - Measurements */}
        <Card className="p-5 space-y-4">
          <h3 className="font-semibold flex items-center gap-2">
            <Scale className="h-4 w-4" />
            Historial de mediciones
          </h3>

          {(paciente.mediciones || []).length === 0 ? (
            <p className="text-sm text-muted-foreground text-center py-4">Sin mediciones registradas</p>
          ) : (
            <div className="space-y-2">
              {paciente.mediciones.map((m: any) => (
                <div key={m.id} className="border rounded p-2 text-sm">
                  <p className="text-xs text-muted-foreground mb-1">
                    {new Date(m.fecha).toLocaleDateString("es-ES")}
                  </p>
                  <div className="grid grid-cols-2 gap-1 text-xs">
                    {m.peso && <span>Peso: {m.peso} kg</span>}
                    {m.porcentajeGrasa && <span>Grasa: {m.porcentajeGrasa}%</span>}
                    {m.masaMuscular && <span>Músculo: {m.masaMuscular} kg</span>}
                    {m.circunferenciaCintura && <span>Cintura: {m.circunferenciaCintura} cm</span>}
                  </div>
                  {m.notas && <p className="text-xs text-muted-foreground mt-1 italic">{m.notas}</p>}
                </div>
              ))}
            </div>
          )}
        </Card>
      </div>
    </div>
  );
}
