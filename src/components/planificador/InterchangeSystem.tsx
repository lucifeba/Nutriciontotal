"use client";

import { trpc } from "@/lib/trpc";
import { Badge } from "@/components/ui/badge";

interface InterchangeSystemProps {
  alimentoId: string;
  alimentoNombre: string;
  onSwap: () => void;
}

export function InterchangeSystem({
  alimentoId,
  alimentoNombre,
  onSwap,
}: InterchangeSystemProps) {
  const { data: alternativas, isLoading } =
    trpc.alimentos.getAlternativas.useQuery(
      { alimentoId },
      { enabled: !!alimentoId }
    );

  if (isLoading) {
    return (
      <div className="text-center py-4">
        <p className="text-sm text-muted-foreground">
          Buscando alternativas...
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div className="p-3 bg-gray-50 rounded-lg">
        <p className="text-sm font-medium">Alimento actual:</p>
        <p className="text-lg font-semibold">{alimentoNombre}</p>
      </div>

      {alternativas && alternativas.length > 0 ? (
        <div className="space-y-2">
          <p className="text-sm font-medium text-muted-foreground">
            Alternativas del mismo grupo de intercambio:
          </p>
          {alternativas.map((alt: any) => (
            <button
              key={alt.id}
              onClick={onSwap}
              className="w-full text-left p-3 rounded-md border hover:bg-green-50 hover:border-green-300 transition-colors"
            >
              <div className="flex items-center justify-between">
                <span className="font-medium text-sm">{alt.nombre}</span>
                <Badge variant="outline" className="text-xs">
                  {alt.racionIntercambio}g = 1 racion
                </Badge>
              </div>
              <div className="text-xs text-muted-foreground mt-1">
                {alt.calorias} kcal | P: {alt.proteinas}g | C:{" "}
                {alt.carbohidratos}g | G: {alt.grasas}g (por 100g)
              </div>
            </button>
          ))}
        </div>
      ) : (
        <p className="text-sm text-muted-foreground text-center py-4">
          No se encontraron alternativas en el mismo grupo de intercambio.
        </p>
      )}
    </div>
  );
}
