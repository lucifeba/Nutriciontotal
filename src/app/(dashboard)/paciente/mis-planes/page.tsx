"use client";

import { trpc } from "@/lib/trpc/client";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { CalendarDays, Target, FileText } from "lucide-react";

const estadoColor: Record<string, string> = {
  BORRADOR: "bg-gray-100 text-gray-700",
  ACTIVO: "bg-green-100 text-green-700",
  COMPLETADO: "bg-blue-100 text-blue-700",
  CANCELADO: "bg-red-100 text-red-700",
};

const tipoComidaLabel: Record<string, string> = {
  DESAYUNO: "Desayuno",
  MEDIA_MANANA: "Media mañana",
  ALMUERZO: "Almuerzo",
  MERIENDA: "Merienda",
  CENA: "Cena",
  RECENA: "Recena",
};

export default function MisPlanesPage() {
  const { data: planes, isLoading } = trpc.planes.list.useQuery();

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <LoadingSpinner text="Cargando tus planes..." />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-bold text-[#2D5A3D]">Mis Planes Nutricionales</h2>
        <p className="text-sm text-muted-foreground">
          Consulta tus planes de alimentación asignados
        </p>
      </div>

      {(planes || []).length === 0 ? (
        <Card className="p-12 text-center">
          <FileText className="h-12 w-12 mx-auto text-muted-foreground/30 mb-3" />
          <p className="text-muted-foreground">Aún no tienes planes nutricionales asignados</p>
          <p className="text-sm text-muted-foreground mt-1">Tu nutricionista te creará uno próximamente</p>
        </Card>
      ) : (
        <div className="space-y-4">
          {(planes || []).map((plan: any) => (
            <Card key={plan.id} className="p-5">
              <div className="flex justify-between items-start mb-3">
                <div>
                  <h3 className="font-semibold text-[#2D5A3D]">{plan.nombre}</h3>
                  <p className="text-xs text-muted-foreground">
                    {plan.tipoPlan === "SEMANAL" ? "Plan semanal" : "Plan quincenal"}
                    {plan.fechaInicio && ` · Desde ${new Date(plan.fechaInicio).toLocaleDateString("es-ES")}`}
                  </p>
                </div>
                <Badge className={estadoColor[plan.estado] || ""}>{plan.estado}</Badge>
              </div>

              {/* Macros */}
              <div className="grid grid-cols-4 gap-3 mb-4">
                <div className="text-center bg-gray-50 rounded-lg p-2">
                  <div className="text-lg font-bold text-[#2D5A3D]">{plan.caloriasObjetivo}</div>
                  <div className="text-xs text-muted-foreground">kcal</div>
                </div>
                <div className="text-center bg-gray-50 rounded-lg p-2">
                  <div className="text-lg font-bold">{plan.proteinasObjetivo}g</div>
                  <div className="text-xs text-muted-foreground">Proteínas</div>
                </div>
                <div className="text-center bg-gray-50 rounded-lg p-2">
                  <div className="text-lg font-bold">{plan.carbohidratosObjetivo}g</div>
                  <div className="text-xs text-muted-foreground">Carbos</div>
                </div>
                <div className="text-center bg-gray-50 rounded-lg p-2">
                  <div className="text-lg font-bold">{plan.grasasObjetivo}g</div>
                  <div className="text-xs text-muted-foreground">Grasas</div>
                </div>
              </div>

              {/* Comidas activas */}
              <div className="flex gap-1 flex-wrap">
                {(plan.comidasActivas || []).map((c: string) => (
                  <Badge key={c} variant="outline" className="text-xs">
                    {tipoComidaLabel[c] || c}
                  </Badge>
                ))}
              </div>

              {plan.notas && (
                <p className="text-sm text-muted-foreground mt-3 italic">{plan.notas}</p>
              )}
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
