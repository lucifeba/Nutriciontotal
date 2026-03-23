"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";

interface NutrientData {
  calorias: number;
  proteinas: number;
  carbohidratos: number;
  grasas: number;
}

interface NutrientSummaryProps {
  actual: NutrientData;
  target: NutrientData;
}

function NutrientRow({
  label,
  actual,
  target,
  unit,
  color,
}: {
  label: string;
  actual: number;
  target: number;
  unit: string;
  color: string;
}) {
  const percentage = target > 0 ? Math.min((actual / target) * 100, 100) : 0;

  return (
    <div className="space-y-1">
      <div className="flex items-center justify-between text-sm">
        <span className="font-medium">{label}</span>
        <span className="text-muted-foreground">
          {Math.round(actual)} / {Math.round(target)} {unit}
        </span>
      </div>
      <Progress value={percentage} className={`h-2 ${color}`} />
    </div>
  );
}

export function NutrientSummary({ actual, target }: NutrientSummaryProps) {
  return (
    <Card>
      <CardHeader className="py-3 px-4">
        <CardTitle className="text-sm">Resumen Nutricional</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4 px-4 pb-4">
        <NutrientRow
          label="Calorias"
          actual={actual.calorias}
          target={target.calorias}
          unit="kcal"
          color="[&>div]:bg-orange-500"
        />
        <NutrientRow
          label="Proteinas"
          actual={actual.proteinas}
          target={target.proteinas}
          unit="g"
          color="[&>div]:bg-red-500"
        />
        <NutrientRow
          label="Carbohidratos"
          actual={actual.carbohidratos}
          target={target.carbohidratos}
          unit="g"
          color="[&>div]:bg-blue-500"
        />
        <NutrientRow
          label="Grasas"
          actual={actual.grasas}
          target={target.grasas}
          unit="g"
          color="[&>div]:bg-yellow-500"
        />

        <div className="pt-2 border-t text-xs text-muted-foreground">
          <div className="flex justify-between">
            <span>% Calorias cubierto</span>
            <span className="font-medium">
              {target.calorias > 0
                ? Math.round((actual.calorias / target.calorias) * 100)
                : 0}
              %
            </span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
