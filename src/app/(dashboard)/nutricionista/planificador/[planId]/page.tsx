"use client";

import { useState } from "react";
import { useParams } from "next/navigation";
import { trpc } from "@/lib/trpc";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { NutrientSummary } from "@/components/planificador/NutrientSummary";
import { FoodSearch } from "@/components/planificador/FoodSearch";
import { InterchangeSystem } from "@/components/planificador/InterchangeSystem";

const ESTADO_LABELS: Record<string, string> = {
  BORRADOR: "Borrador",
  ACTIVO: "Activo",
  COMPLETADO: "Completado",
  CANCELADO: "Cancelado",
};

export default function PlanEditorPage() {
  const params = useParams();
  const planId = params.planId as string;

  const { data: plan, isLoading, refetch } = trpc.planes.getById.useQuery(
    { id: planId },
    { enabled: !!planId }
  );

  const updateEstado = trpc.planes.updateEstado.useMutation({
    onSuccess: () => refetch(),
  });

  const addAlimento = trpc.planes.addAlimentoToComida.useMutation({
    onSuccess: () => refetch(),
  });

  const [selectedPlanificacion, setSelectedPlanificacion] = useState(0);
  const [selectedDay, setSelectedDay] = useState(0);
  const [showFoodSearch, setShowFoodSearch] = useState(false);
  const [showInterchange, setShowInterchange] = useState(false);
  const [targetComidaId, setTargetComidaId] = useState<string | null>(null);
  const [selectedAlimento, setSelectedAlimento] = useState<any>(null);

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-pulse text-center">
          <div className="h-8 w-8 mx-auto mb-4 rounded-full border-4 border-green-500 border-t-transparent animate-spin" />
          <p className="text-muted-foreground">Cargando plan...</p>
        </div>
      </div>
    );
  }

  if (!plan) {
    return (
      <div className="text-center py-12">
        <h2 className="text-xl font-semibold text-red-600">
          Plan no encontrado
        </h2>
        <p className="text-muted-foreground mt-2">
          El plan que buscas no existe o no tienes acceso.
        </p>
      </div>
    );
  }

  const pacienteNombre = plan.paciente?.user
    ? `${plan.paciente.user.nombre} ${plan.paciente.user.apellidos}`
    : "Paciente";

  const planificacion = plan.planificaciones?.[selectedPlanificacion];
  const dias = planificacion?.dias || [];
  const diaActual = dias[selectedDay];
  const comidas = diaActual?.comidas || [];

  // Calculate day totals
  const dayTotals = comidas.reduce(
    (acc: any, comida: any) => {
      (comida.alimentos || []).forEach((ca: any) => {
        if (ca.alimento) {
          const factor = ca.cantidad / 100;
          acc.calorias += (ca.alimento.calorias || 0) * factor;
          acc.proteinas += (ca.alimento.proteinas || 0) * factor;
          acc.carbohidratos += (ca.alimento.carbohidratos || 0) * factor;
          acc.grasas += (ca.alimento.grasas || 0) * factor;
        }
      });
      return acc;
    },
    { calorias: 0, proteinas: 0, carbohidratos: 0, grasas: 0 }
  );

  const handleAddFood = (comidaId: string) => {
    setTargetComidaId(comidaId);
    setShowFoodSearch(true);
  };

  const handleFoodSelected = (alimento: any, cantidad: number) => {
    if (!targetComidaId) return;
    addAlimento.mutate({
      planComidaId: targetComidaId,
      alimentoId: alimento.id,
      cantidad,
    });
    setShowFoodSearch(false);
  };

  const handleShowInterchange = (alimento: any) => {
    setSelectedAlimento(alimento);
    setShowInterchange(true);
  };

  return (
    <div className="space-y-6">
      {/* Top Bar */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold">{plan.nombre}</h1>
          <div className="flex items-center gap-2 mt-1">
            <span className="text-muted-foreground">{pacienteNombre}</span>
            <Badge
              variant={plan.estado === "ACTIVO" ? "default" : "secondary"}
            >
              {ESTADO_LABELS[plan.estado] || plan.estado}
            </Badge>
          </div>
        </div>
        <div className="flex gap-2">
          {plan.estado === "BORRADOR" && (
            <Button
              onClick={() =>
                updateEstado.mutate({ id: plan.id, estado: "ACTIVO" })
              }
              disabled={updateEstado.isLoading}
              className="bg-green-600 hover:bg-green-700"
            >
              Activar Plan
            </Button>
          )}
          {plan.estado === "ACTIVO" && (
            <Button
              variant="outline"
              onClick={() =>
                updateEstado.mutate({ id: plan.id, estado: "COMPLETADO" })
              }
              disabled={updateEstado.isLoading}
            >
              Marcar como Completado
            </Button>
          )}
        </div>
      </div>

      {/* Planificacion selector */}
      {plan.planificaciones && plan.planificaciones.length > 1 && (
        <div className="flex gap-2">
          {plan.planificaciones.map((p: any, i: number) => (
            <Button
              key={p.id}
              variant={selectedPlanificacion === i ? "default" : "outline"}
              size="sm"
              onClick={() => {
                setSelectedPlanificacion(i);
                setSelectedDay(0);
              }}
            >
              {p.nombre || `Semana ${i + 1}`}
            </Button>
          ))}
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Panel - Day Selector */}
        <div className="lg:col-span-2">
          <Card>
            <CardHeader className="py-3 px-4">
              <CardTitle className="text-sm">Dias</CardTitle>
            </CardHeader>
            <CardContent className="p-2">
              <div className="space-y-1">
                {dias.map((dia: any, i: number) => (
                  <button
                    key={dia.id}
                    onClick={() => setSelectedDay(i)}
                    className={`w-full text-left px-3 py-2 rounded-md text-sm transition-colors ${
                      selectedDay === i
                        ? "bg-green-100 text-green-800 font-medium"
                        : "hover:bg-gray-100"
                    }`}
                  >
                    {dia.nombre}
                  </button>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Main Area - Meals */}
        <div className="lg:col-span-7">
          <div className="space-y-4">
            {diaActual ? (
              <>
                <h2 className="text-lg font-semibold">{diaActual.nombre}</h2>
                {comidas.length > 0 ? (
                  comidas.map((comida: any) => (
                    <Card key={comida.id}>
                      <CardHeader className="py-3 px-4">
                        <div className="flex items-center justify-between">
                          <CardTitle className="text-base">
                            {comida.tipo || comida.nombre || "Comida"}
                          </CardTitle>
                          <div className="flex gap-2">
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => handleAddFood(comida.id)}
                            >
                              Anadir alimento
                            </Button>
                          </div>
                        </div>
                      </CardHeader>
                      <CardContent className="px-4 pb-3">
                        {comida.alimentos && comida.alimentos.length > 0 ? (
                          <div className="space-y-2">
                            {comida.alimentos.map((ca: any) => (
                              <div
                                key={ca.id}
                                className="flex items-center justify-between p-2 rounded-md bg-gray-50 hover:bg-gray-100 cursor-pointer"
                                onClick={() =>
                                  handleShowInterchange(ca.alimento)
                                }
                              >
                                <div>
                                  <span className="font-medium text-sm">
                                    {ca.alimento?.nombre || "Alimento"}
                                  </span>
                                  <span className="text-xs text-muted-foreground ml-2">
                                    {ca.cantidad}g
                                  </span>
                                </div>
                                <span className="text-xs text-muted-foreground">
                                  {Math.round(
                                    ((ca.alimento?.calorias || 0) *
                                      ca.cantidad) /
                                      100
                                  )}{" "}
                                  kcal
                                </span>
                              </div>
                            ))}
                            {comida.recetas &&
                              comida.recetas.map((cr: any) => (
                                <div
                                  key={cr.id}
                                  className="flex items-center justify-between p-2 rounded-md bg-blue-50"
                                >
                                  <div>
                                    <span className="font-medium text-sm">
                                      {cr.receta?.nombre || "Receta"}
                                    </span>
                                    <Badge variant="secondary" className="ml-2 text-xs">
                                      Receta
                                    </Badge>
                                  </div>
                                  <span className="text-xs text-muted-foreground">
                                    {cr.raciones} rac.
                                  </span>
                                </div>
                              ))}
                          </div>
                        ) : (
                          <p className="text-sm text-muted-foreground text-center py-4">
                            Sin alimentos. Usa el boton &quot;Anadir
                            alimento&quot; para empezar.
                          </p>
                        )}
                      </CardContent>
                    </Card>
                  ))
                ) : (
                  <Card className="text-center py-8">
                    <CardContent>
                      <p className="text-muted-foreground">
                        Este dia no tiene comidas configuradas.
                      </p>
                    </CardContent>
                  </Card>
                )}
              </>
            ) : (
              <Card className="text-center py-8">
                <CardContent>
                  <p className="text-muted-foreground">
                    Selecciona un dia del calendario para ver sus comidas.
                  </p>
                </CardContent>
              </Card>
            )}
          </div>
        </div>

        {/* Right Panel - Nutrient Summary */}
        <div className="lg:col-span-3">
          <NutrientSummary
            actual={dayTotals}
            target={{
              calorias: plan.caloriasObjetivo,
              proteinas: plan.proteinasObjetivo,
              carbohidratos: plan.carbohidratosObjetivo,
              grasas: plan.grasasObjetivo,
            }}
          />
        </div>
      </div>

      {/* Food Search Dialog */}
      <Dialog open={showFoodSearch} onOpenChange={setShowFoodSearch}>
        <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Buscar Alimento</DialogTitle>
          </DialogHeader>
          <FoodSearch onSelect={handleFoodSelected} />
        </DialogContent>
      </Dialog>

      {/* Interchange Dialog */}
      <Dialog open={showInterchange} onOpenChange={setShowInterchange}>
        <DialogContent className="max-w-lg">
          <DialogHeader>
            <DialogTitle>Alternativas de Intercambio</DialogTitle>
          </DialogHeader>
          {selectedAlimento && (
            <InterchangeSystem
              alimentoId={selectedAlimento.id}
              alimentoNombre={selectedAlimento.nombre}
              onSwap={() => {
                setShowInterchange(false);
                refetch();
              }}
            />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
