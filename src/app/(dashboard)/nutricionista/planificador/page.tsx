"use client";

import { useState } from "react";
import { trpc } from "@/lib/trpc";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { PlanCreator } from "@/components/planificador/PlanCreator";
import Link from "next/link";

const ESTADO_CONFIG: Record<string, { label: string; variant: "default" | "secondary" | "destructive" | "outline" }> = {
  BORRADOR: { label: "Borrador", variant: "secondary" },
  ACTIVO: { label: "Activo", variant: "default" },
  COMPLETADO: { label: "Completado", variant: "outline" },
  CANCELADO: { label: "Cancelado", variant: "destructive" },
};

export default function PlanificadorPage() {
  const [showCreator, setShowCreator] = useState(false);
  const { data: planes, isLoading, refetch } = trpc.planes.list.useQuery();

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Planificador Nutricional</h1>
          <p className="text-muted-foreground">
            Crea y gestiona los planes nutricionales de tus pacientes
          </p>
        </div>
        <Button onClick={() => setShowCreator(true)}>
          Crear Nuevo Plan
        </Button>
      </div>

      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {[1, 2, 3].map((i) => (
            <Card key={i} className="animate-pulse">
              <CardHeader>
                <div className="h-5 bg-gray-200 rounded w-3/4" />
                <div className="h-4 bg-gray-200 rounded w-1/2 mt-2" />
              </CardHeader>
              <CardContent>
                <div className="h-4 bg-gray-200 rounded w-full mb-2" />
                <div className="h-4 bg-gray-200 rounded w-2/3" />
              </CardContent>
            </Card>
          ))}
        </div>
      ) : !planes || planes.length === 0 ? (
        <Card className="text-center py-12">
          <CardContent>
            <div className="text-5xl mb-4">&#128203;</div>
            <h3 className="text-lg font-semibold mb-2">
              No hay planes creados
            </h3>
            <p className="text-muted-foreground mb-4">
              Crea tu primer plan nutricional para empezar a trabajar con tus
              pacientes.
            </p>
            <Button onClick={() => setShowCreator(true)}>
              Crear Primer Plan
            </Button>
          </CardContent>
        </Card>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {planes.map((plan: any) => {
            const estadoConfig = ESTADO_CONFIG[plan.estado] || ESTADO_CONFIG.BORRADOR;
            const pacienteNombre = plan.paciente?.user
              ? `${plan.paciente.user.nombre} ${plan.paciente.user.apellidos}`
              : "Paciente";

            return (
              <Link
                key={plan.id}
                href={`/nutricionista/planificador/${plan.id}`}
              >
                <Card className="hover:shadow-md transition-shadow cursor-pointer h-full">
                  <CardHeader className="pb-3">
                    <div className="flex items-start justify-between">
                      <CardTitle className="text-lg">{plan.nombre}</CardTitle>
                      <Badge variant={estadoConfig.variant}>
                        {estadoConfig.label}
                      </Badge>
                    </div>
                    <CardDescription>{pacienteNombre}</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-2 text-sm">
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">Tipo:</span>
                        <span>
                          {plan.tipoPlan === "SEMANAL"
                            ? "Semanal"
                            : "Quincenal"}
                        </span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">
                          Calorias objetivo:
                        </span>
                        <span className="font-medium">
                          {plan.caloriasObjetivo} kcal
                        </span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">
                          Planificaciones:
                        </span>
                        <span>
                          {plan.planificaciones?.length || 0}
                        </span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">Creado:</span>
                        <span>
                          {new Date(plan.createdAt).toLocaleDateString("es-ES")}
                        </span>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            );
          })}
        </div>
      )}

      <Dialog open={showCreator} onOpenChange={setShowCreator}>
        <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Crear Nuevo Plan Nutricional</DialogTitle>
          </DialogHeader>
          <PlanCreator
            onSuccess={() => {
              setShowCreator(false);
              refetch();
            }}
            onCancel={() => setShowCreator(false)}
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}
