"use client";

import { useState } from "react";
import { trpc } from "@/lib/trpc";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";

interface FoodSearchProps {
  onSelect: (alimento: any, cantidad: number) => void;
}

export function FoodSearch({ onSelect }: FoodSearchProps) {
  const [query, setQuery] = useState("");
  const [cantidad, setCantidad] = useState(100);
  const [selectedId, setSelectedId] = useState<string | null>(null);

  const { data: alimentos, isLoading } = trpc.alimentos.search.useQuery(
    { query },
    { enabled: query.length >= 2 }
  );

  const selectedAlimento = alimentos?.find((a: any) => a.id === selectedId);

  return (
    <div className="space-y-4">
      <Input
        placeholder="Buscar alimento..."
        value={query}
        onChange={(e) => {
          setQuery(e.target.value);
          setSelectedId(null);
        }}
        autoFocus
      />

      {isLoading && (
        <p className="text-sm text-muted-foreground text-center py-4">
          Buscando...
        </p>
      )}

      {alimentos && alimentos.length > 0 && !selectedId && (
        <div className="max-h-64 overflow-y-auto space-y-1">
          {alimentos.map((alimento: any) => (
            <button
              key={alimento.id}
              onClick={() => setSelectedId(alimento.id)}
              className="w-full text-left p-2 rounded-md hover:bg-gray-100 transition-colors"
            >
              <div className="flex items-center justify-between">
                <span className="text-sm font-medium">{alimento.nombre}</span>
                <Badge variant="outline" className="text-xs">
                  {alimento.grupoIntercambio?.replace(/_/g, " ")}
                </Badge>
              </div>
              <div className="text-xs text-muted-foreground mt-1">
                {alimento.calorias} kcal | P: {alimento.proteinas}g | C:{" "}
                {alimento.carbohidratos}g | G: {alimento.grasas}g (por 100g)
              </div>
            </button>
          ))}
        </div>
      )}

      {alimentos && alimentos.length === 0 && query.length >= 2 && (
        <p className="text-sm text-muted-foreground text-center py-4">
          No se encontraron alimentos
        </p>
      )}

      {selectedAlimento && (
        <div className="border rounded-lg p-4 space-y-3">
          <div>
            <h4 className="font-medium">{selectedAlimento.nombre}</h4>
            <p className="text-xs text-muted-foreground">
              {selectedAlimento.calorias} kcal por 100g
            </p>
          </div>

          <div className="flex items-center gap-3">
            <label className="text-sm font-medium">Cantidad (g):</label>
            <Input
              type="number"
              value={cantidad}
              onChange={(e) => setCantidad(Number(e.target.value))}
              className="w-24"
              min={1}
            />
          </div>

          <div className="text-xs text-muted-foreground">
            Aporte: {Math.round((selectedAlimento.calorias * cantidad) / 100)}{" "}
            kcal | P:{" "}
            {Math.round((selectedAlimento.proteinas * cantidad) / 100)}g | C:{" "}
            {Math.round((selectedAlimento.carbohidratos * cantidad) / 100)}g |
            G: {Math.round((selectedAlimento.grasas * cantidad) / 100)}g
          </div>

          <div className="flex gap-2">
            <Button
              onClick={() => onSelect(selectedAlimento, cantidad)}
              className="flex-1"
            >
              Anadir al plan
            </Button>
            <Button
              variant="outline"
              onClick={() => setSelectedId(null)}
            >
              Cancelar
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}
