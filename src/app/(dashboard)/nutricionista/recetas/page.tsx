"use client";

import { useState } from "react";
import { trpc } from "@/lib/trpc/client";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Search, Clock, Users, ChefHat } from "lucide-react";

const TIPOS_COMIDA = [
  { value: "", label: "Todas" },
  { value: "DESAYUNO", label: "Desayuno" },
  { value: "ALMUERZO", label: "Almuerzo" },
  { value: "CENA", label: "Cena" },
  { value: "MERIENDA", label: "Merienda" },
];

export default function RecetasPage() {
  const [search, setSearch] = useState("");
  const [tipoComida, setTipoComida] = useState("");
  const [selectedReceta, setSelectedReceta] = useState<string | null>(null);

  const { data, isLoading } = trpc.recetas.list.useQuery({
    search: search || undefined,
    tipoComida: tipoComida || undefined,
  });

  const { data: recetaDetalle } = trpc.recetas.getById.useQuery(
    { id: selectedReceta! },
    { enabled: !!selectedReceta }
  );

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-bold text-[#2D5A3D]">Recetas</h2>
        <p className="text-sm text-muted-foreground">
          {data?.total || 0} recetas disponibles
        </p>
      </div>

      {/* Filters */}
      <div className="flex flex-col sm:flex-row gap-3">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Buscar receta..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="pl-9"
          />
        </div>
        <div className="flex flex-wrap gap-2">
          {TIPOS_COMIDA.map((t) => (
            <Button
              key={t.value}
              variant={tipoComida === t.value ? "default" : "outline"}
              size="sm"
              onClick={() => setTipoComida(t.value)}
              className={tipoComida === t.value ? "bg-[#2D5A3D] hover:bg-[#234A31]" : ""}
            >
              {t.label}
            </Button>
          ))}
        </div>
      </div>

      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <LoadingSpinner text="Cargando recetas..." />
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          {(data?.recetas || []).map((receta: any) => (
            <Card
              key={receta.id}
              className={`p-4 cursor-pointer transition-all hover:shadow-md ${selectedReceta === receta.id ? "ring-2 ring-[#2D5A3D]" : ""}`}
              onClick={() => setSelectedReceta(selectedReceta === receta.id ? null : receta.id)}
            >
              <div className="flex justify-between items-start mb-2">
                <h3 className="font-semibold text-[#2D5A3D]">{receta.nombre}</h3>
                <Badge variant="outline" className="text-xs">
                  {receta.dificultad}
                </Badge>
              </div>
              <p className="text-sm text-muted-foreground line-clamp-2 mb-3">
                {receta.descripcion}
              </p>
              <div className="flex items-center gap-4 text-xs text-muted-foreground mb-3">
                <span className="flex items-center gap-1">
                  <Clock className="h-3 w-3" />
                  {receta.tiempoPreparacion + receta.tiempoCoccion} min
                </span>
                <span className="flex items-center gap-1">
                  <Users className="h-3 w-3" />
                  {receta.raciones} raciones
                </span>
                {receta.region && (
                  <span className="flex items-center gap-1">
                    <ChefHat className="h-3 w-3" />
                    {receta.region}
                  </span>
                )}
              </div>
              <div className="flex flex-wrap gap-1 mb-3">
                {(receta.tipoComida || []).map((tipo: string) => (
                  <Badge key={tipo} className="text-[10px] bg-[#2D5A3D]/10 text-[#2D5A3D] hover:bg-[#2D5A3D]/20">
                    {tipo.replace("_", " ")}
                  </Badge>
                ))}
              </div>
              {receta.caloriasPorRacion && (
                <div className="grid grid-cols-4 gap-2 text-center text-xs">
                  <div className="bg-gray-50 rounded p-1">
                    <div className="font-medium">{receta.caloriasPorRacion}</div>
                    <div className="text-muted-foreground">kcal</div>
                  </div>
                  <div className="bg-gray-50 rounded p-1">
                    <div className="font-medium">{receta.proteinasPorRacion}g</div>
                    <div className="text-muted-foreground">Prot</div>
                  </div>
                  <div className="bg-gray-50 rounded p-1">
                    <div className="font-medium">{receta.carbohidratosPorRacion}g</div>
                    <div className="text-muted-foreground">Carbs</div>
                  </div>
                  <div className="bg-gray-50 rounded p-1">
                    <div className="font-medium">{receta.grasasPorRacion}g</div>
                    <div className="text-muted-foreground">Grasas</div>
                  </div>
                </div>
              )}

              {/* Detail view */}
              {selectedReceta === receta.id && recetaDetalle && (
                <div className="mt-4 pt-4 border-t space-y-3">
                  <div>
                    <h4 className="text-sm font-semibold mb-1">Ingredientes</h4>
                    <ul className="text-sm text-muted-foreground space-y-1">
                      {recetaDetalle.alimentos?.map((ing: any) => (
                        <li key={ing.id}>
                          {ing.cantidad}{ing.unidad || "g"} {ing.alimento.nombre}
                          {ing.notas && <span className="text-xs"> ({ing.notas})</span>}
                        </li>
                      ))}
                    </ul>
                  </div>
                  <div>
                    <h4 className="text-sm font-semibold mb-1">Instrucciones</h4>
                    <p className="text-sm text-muted-foreground whitespace-pre-line">
                      {recetaDetalle.instrucciones}
                    </p>
                  </div>
                  <div className="flex gap-1 flex-wrap">
                    {recetaDetalle.esAptoVegetariano && <Badge className="bg-green-100 text-green-700 text-[10px]">Vegetariano</Badge>}
                    {recetaDetalle.esAptoVegano && <Badge className="bg-green-100 text-green-700 text-[10px]">Vegano</Badge>}
                    {recetaDetalle.contieneGluten && <Badge variant="destructive" className="text-[10px]">Gluten</Badge>}
                    {recetaDetalle.contieneLactosa && <Badge variant="destructive" className="text-[10px]">Lactosa</Badge>}
                  </div>
                </div>
              )}
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
