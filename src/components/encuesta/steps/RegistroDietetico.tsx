"use client";

import { useState } from "react";
import { type EncuestaData } from "@/types/encuesta.types";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Checkbox } from "@/components/ui/checkbox";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

interface StepProps {
  data: EncuestaData;
  onChange: (data: Partial<EncuestaData>) => void;
}

interface MealEntry {
  hora: string;
  alimentos: string;
  lugar: string;
  hambreReal: boolean;
}

interface DayRecord {
  desayuno: MealEntry;
  mediaManana: MealEntry;
  almuerzo: MealEntry;
  merienda: MealEntry;
  cena: MealEntry;
}

const COMIDAS = [
  { key: "desayuno", label: "Desayuno", defaultTime: "08:00" },
  { key: "mediaManana", label: "Media manana", defaultTime: "11:00" },
  { key: "almuerzo", label: "Almuerzo", defaultTime: "14:00" },
  { key: "merienda", label: "Merienda", defaultTime: "17:30" },
  { key: "cena", label: "Cena", defaultTime: "21:00" },
];

const LUGARES = [
  { value: "casa", label: "En casa" },
  { value: "trabajo", label: "En el trabajo" },
  { value: "restaurante", label: "Restaurante / bar" },
  { value: "tupper", label: "Tupper" },
  { value: "otro", label: "Otro" },
];

const emptyMeal = (): MealEntry => ({
  hora: "",
  alimentos: "",
  lugar: "",
  hambreReal: true,
});

const emptyDay = (): DayRecord => ({
  desayuno: { ...emptyMeal(), hora: "08:00" },
  mediaManana: { ...emptyMeal(), hora: "11:00" },
  almuerzo: { ...emptyMeal(), hora: "14:00" },
  merienda: { ...emptyMeal(), hora: "17:30" },
  cena: { ...emptyMeal(), hora: "21:00" },
});

export function RegistroDietetico({ data, onChange }: StepProps) {
  const registro = (data.registroDietetico as DayRecord[] | undefined) || [emptyDay()];
  const [numDias, setNumDias] = useState<1 | 3>(registro.length === 3 ? 3 : 1);

  const handleNumDiasChange = (n: 1 | 3) => {
    setNumDias(n);
    if (n === 3 && registro.length < 3) {
      const updated = [...registro];
      while (updated.length < 3) updated.push(emptyDay());
      onChange({ registroDietetico: updated });
    } else if (n === 1) {
      onChange({ registroDietetico: [registro[0]] });
    }
  };

  const updateMeal = (
    dayIndex: number,
    mealKey: string,
    field: keyof MealEntry,
    value: string | boolean
  ) => {
    const updated = [...registro];
    if (!updated[dayIndex]) updated[dayIndex] = emptyDay();
    const day = { ...updated[dayIndex] } as any;
    day[mealKey] = { ...day[mealKey], [field]: value };
    updated[dayIndex] = day;
    onChange({ registroDietetico: updated });
  };

  return (
    <div className="space-y-8">
      <div className="space-y-2">
        <Label>Numero de dias a registrar</Label>
        <p className="text-sm text-muted-foreground">
          Registra lo que has comido en las ultimas 24 horas (1 dia) o en los
          ultimos 3 dias para mayor precision.
        </p>
        <div className="flex gap-2">
          <Button
            type="button"
            variant={numDias === 1 ? "default" : "outline"}
            onClick={() => handleNumDiasChange(1)}
          >
            1 dia
          </Button>
          <Button
            type="button"
            variant={numDias === 3 ? "default" : "outline"}
            onClick={() => handleNumDiasChange(3)}
          >
            3 dias
          </Button>
        </div>
      </div>

      {Array.from({ length: numDias }).map((_, dayIndex) => (
        <div
          key={dayIndex}
          className="space-y-6 p-4 bg-gray-50 rounded-lg border"
        >
          {numDias > 1 && (
            <h4 className="font-semibold text-green-700">
              Dia {dayIndex + 1}
            </h4>
          )}

          {COMIDAS.map((comida) => {
            const meal =
              (registro[dayIndex] as any)?.[comida.key] || emptyMeal();

            return (
              <div
                key={comida.key}
                className="space-y-3 p-3 bg-white rounded-md border"
              >
                <h5 className="font-medium text-sm text-green-800">
                  {comida.label}
                </h5>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <Label className="text-xs">Hora</Label>
                    <Input
                      type="time"
                      value={meal.hora || comida.defaultTime}
                      onChange={(e) =>
                        updateMeal(dayIndex, comida.key, "hora", e.target.value)
                      }
                    />
                  </div>
                  <div className="space-y-1">
                    <Label className="text-xs">Lugar</Label>
                    <Select
                      value={meal.lugar || ""}
                      onValueChange={(v) =>
                        updateMeal(dayIndex, comida.key, "lugar", v)
                      }
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Donde comiste" />
                      </SelectTrigger>
                      <SelectContent>
                        {LUGARES.map((l) => (
                          <SelectItem key={l.value} value={l.value}>
                            {l.label}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                </div>

                <div className="space-y-1">
                  <Label className="text-xs">
                    Alimentos y cantidades aproximadas
                  </Label>
                  <Textarea
                    placeholder="Ej: 2 tostadas de pan integral con aceite de oliva y tomate, 1 cafe con leche semidesnatada..."
                    value={meal.alimentos || ""}
                    onChange={(e) =>
                      updateMeal(
                        dayIndex,
                        comida.key,
                        "alimentos",
                        e.target.value
                      )
                    }
                    rows={2}
                  />
                </div>

                <div className="flex items-center space-x-2">
                  <Checkbox
                    id={`hambre-${dayIndex}-${comida.key}`}
                    checked={meal.hambreReal !== false}
                    onCheckedChange={(checked) =>
                      updateMeal(
                        dayIndex,
                        comida.key,
                        "hambreReal",
                        !!checked
                      )
                    }
                  />
                  <Label
                    htmlFor={`hambre-${dayIndex}-${comida.key}`}
                    className="font-normal text-sm"
                  >
                    Tenia hambre real al comer
                  </Label>
                </div>
              </div>
            );
          })}
        </div>
      ))}
    </div>
  );
}
