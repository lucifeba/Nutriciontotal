"use client";

import { type EncuestaData } from "@/types/encuesta.types";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Checkbox } from "@/components/ui/checkbox";
import { Slider } from "@/components/ui/slider";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
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

const BEBIDAS = [
  "Agua",
  "Cafe",
  "Te / infusiones",
  "Refrescos azucarados",
  "Refrescos zero / light",
  "Zumos naturales",
  "Zumos envasados",
  "Bebidas energeticas",
  "Leche",
  "Bebidas vegetales",
];

const COMIDAS_LABELS: Record<string, string> = {
  desayuno: "Desayuno",
  mediaManana: "Media manana",
  almuerzo: "Almuerzo",
  merienda: "Merienda",
  cena: "Cena",
  recena: "Recena",
  otros: "Otros",
};

export function HabitosAlimentarios({ data, onChange }: StepProps) {
  const numComidas = data.numComidasDia || 3;
  const horarios = data.horarioComidas || {};

  const updateHorario = (comida: string, hora: string) => {
    onChange({
      horarioComidas: { ...horarios, [comida]: hora },
    });
  };

  const toggleBebida = (bebida: string) => {
    const current = data.bebidasHabituales || [];
    const updated = current.includes(bebida)
      ? current.filter((b) => b !== bebida)
      : [...current, bebida];
    onChange({ bebidasHabituales: updated });
  };

  return (
    <div className="space-y-8">
      {/* Numero de comidas */}
      <div className="space-y-2">
        <Label>Numero de comidas al dia: {numComidas}</Label>
        <div className="flex items-center gap-2">
          {[1, 2, 3, 4, 5, 6, 7].map((n) => (
            <button
              key={n}
              type="button"
              onClick={() => onChange({ numComidasDia: n })}
              className={`h-10 w-10 rounded-full border-2 font-medium transition-colors ${
                numComidas === n
                  ? "bg-green-600 text-white border-green-600"
                  : "border-gray-300 hover:border-green-400"
              }`}
            >
              {n}
            </button>
          ))}
        </div>
      </div>

      {/* Horarios de comidas */}
      <div className="space-y-3">
        <Label>Horarios habituales de cada comida</Label>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          {Object.entries(COMIDAS_LABELS)
            .slice(0, numComidas)
            .map(([key, label]) => (
              <div key={key} className="flex items-center gap-2">
                <span className="text-sm w-28 text-muted-foreground">
                  {label}:
                </span>
                <Input
                  type="time"
                  className="w-32"
                  value={horarios[key] || ""}
                  onChange={(e) => updateHorario(key, e.target.value)}
                />
              </div>
            ))}
        </div>
      </div>

      {/* Picoteo */}
      <div className="space-y-3">
        <Label>Picoteas entre horas</Label>
        <RadioGroup
          value={
            data.picoteoEntreMeals === true
              ? "si"
              : data.picoteoEntreMeals === false
              ? "no"
              : (data as any).picoteoFrecuencia || ""
          }
          onValueChange={(v) => {
            if (v === "si") onChange({ picoteoEntreMeals: true });
            else if (v === "no") onChange({ picoteoEntreMeals: false });
            else onChange({ picoteoEntreMeals: undefined, ...(({ picoteoFrecuencia: v } as any)) });
          }}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="si" id="picoteo-si" />
            <Label htmlFor="picoteo-si" className="font-normal">Si</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="no" id="picoteo-no" />
            <Label htmlFor="picoteo-no" className="font-normal">No</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="a_veces" id="picoteo-aveces" />
            <Label htmlFor="picoteo-aveces" className="font-normal">A veces</Label>
          </div>
        </RadioGroup>
      </div>

      {/* Velocidad al comer */}
      <div className="space-y-3">
        <Label>Velocidad al comer</Label>
        <RadioGroup
          value={data.comeRapidoOLento || ""}
          onValueChange={(v) => onChange({ comeRapidoOLento: v })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="rapido" id="vel-rapido" />
            <Label htmlFor="vel-rapido" className="font-normal">Rapido (menos de 15 min)</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="normal" id="vel-normal" />
            <Label htmlFor="vel-normal" className="font-normal">Normal (15-30 min)</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="lento" id="vel-lento" />
            <Label htmlFor="vel-lento" className="font-normal">Lento (mas de 30 min)</Label>
          </div>
        </RadioGroup>
      </div>

      {/* Donde come */}
      <div className="space-y-3">
        <Label>Donde comes habitualmente</Label>
        <RadioGroup
          value={data.dondeComeMasFrec || ""}
          onValueChange={(v) => onChange({ dondeComeMasFrec: v })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="mesa" id="donde-mesa" />
            <Label htmlFor="donde-mesa" className="font-normal">En la mesa</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="sofa" id="donde-sofa" />
            <Label htmlFor="donde-sofa" className="font-normal">En el sofa</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="trabajo" id="donde-trabajo" />
            <Label htmlFor="donde-trabajo" className="font-normal">En el trabajo</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="varia" id="donde-varia" />
            <Label htmlFor="donde-varia" className="font-normal">Varia segun el dia</Label>
          </div>
        </RadioGroup>
      </div>

      {/* Cocina */}
      <div className="space-y-3">
        <Label>Cocinas habitualmente</Label>
        <RadioGroup
          value={
            data.cocinaSiNo === true
              ? "si"
              : data.cocinaSiNo === false
              ? "no"
              : ""
          }
          onValueChange={(v) => onChange({ cocinaSiNo: v === "si" })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="si" id="cocina-si" />
            <Label htmlFor="cocina-si" className="font-normal">Si</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="no" id="cocina-no" />
            <Label htmlFor="cocina-no" className="font-normal">No</Label>
          </div>
        </RadioGroup>
      </div>

      {/* Habilidad cocina */}
      <div className="space-y-2">
        <Label>Habilidad en la cocina</Label>
        <Select
          value={data.habilidadCocina || ""}
          onValueChange={(v) => onChange({ habilidadCocina: v })}
        >
          <SelectTrigger>
            <SelectValue placeholder="Selecciona tu nivel" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="basico">Basico - solo platos sencillos</SelectItem>
            <SelectItem value="intermedio">Intermedio - platos variados</SelectItem>
            <SelectItem value="avanzado">Avanzado - me gusta cocinar y experimentar</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Tiempo para cocinar */}
      <div className="space-y-2">
        <Label>Tiempo disponible para cocinar</Label>
        <Select
          value={data.tiempoParaCocinar || ""}
          onValueChange={(v) => onChange({ tiempoParaCocinar: v })}
        >
          <SelectTrigger>
            <SelectValue placeholder="Selecciona el tiempo" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="menos_15">Menos de 15 minutos</SelectItem>
            <SelectItem value="15_30">15-30 minutos</SelectItem>
            <SelectItem value="30_60">30-60 minutos</SelectItem>
            <SelectItem value="mas_60">Mas de 60 minutos</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Alimentos que no gustan */}
      <div className="space-y-2">
        <Label htmlFor="noGustan">Alimentos que no te gustan</Label>
        <Textarea
          id="noGustan"
          placeholder="Ej: brocoli, higado, berenjenas..."
          value={(data.alimentosQueNoGustan || []).join(", ")}
          onChange={(e) =>
            onChange({
              alimentosQueNoGustan: e.target.value
                .split(",")
                .map((s) => s.trim())
                .filter(Boolean),
            })
          }
        />
        <p className="text-xs text-muted-foreground">Separa los alimentos con comas</p>
      </div>

      {/* Alimentos preferidos */}
      <div className="space-y-2">
        <Label htmlFor="preferidos">Alimentos preferidos</Label>
        <Textarea
          id="preferidos"
          placeholder="Ej: pollo, arroz, frutas..."
          value={(data.alimentosPreferidos || []).join(", ")}
          onChange={(e) =>
            onChange({
              alimentosPreferidos: e.target.value
                .split(",")
                .map((s) => s.trim())
                .filter(Boolean),
            })
          }
        />
        <p className="text-xs text-muted-foreground">Separa los alimentos con comas</p>
      </div>

      {/* Bebidas */}
      <div className="space-y-3">
        <Label>Bebidas habituales</Label>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
          {BEBIDAS.map((bebida) => (
            <div key={bebida} className="flex items-center space-x-2">
              <Checkbox
                id={`beb-${bebida}`}
                checked={(data.bebidasHabituales || []).includes(bebida)}
                onCheckedChange={() => toggleBebida(bebida)}
              />
              <Label htmlFor={`beb-${bebida}`} className="font-normal text-sm">
                {bebida}
              </Label>
            </div>
          ))}
        </div>
      </div>

      {/* Agua */}
      <div className="space-y-3">
        <Label>
          Litros de agua al dia: {data.litrosAguaDia ?? 1.5} L
        </Label>
        <Slider
          min={0}
          max={4}
          step={0.25}
          value={[data.litrosAguaDia ?? 1.5]}
          onValueChange={(v) => onChange({ litrosAguaDia: v[0] })}
        />
        <div className="flex justify-between text-xs text-muted-foreground">
          <span>0 L</span>
          <span>1 L</span>
          <span>2 L</span>
          <span>3 L</span>
          <span>4 L</span>
        </div>
      </div>

      {/* Alcohol */}
      <div className="space-y-2">
        <Label>Consumo de alcohol</Label>
        <Select
          value={data.consumoAlcohol || ""}
          onValueChange={(v) => onChange({ consumoAlcohol: v })}
        >
          <SelectTrigger>
            <SelectValue placeholder="Selecciona una opcion" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="nunca">Nunca</SelectItem>
            <SelectItem value="ocasional">Ocasionalmente (eventos sociales)</SelectItem>
            <SelectItem value="fines_semana">Fines de semana</SelectItem>
            <SelectItem value="varias_semana">Varias veces por semana</SelectItem>
            <SelectItem value="diario">A diario</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {data.consumoAlcohol && data.consumoAlcohol !== "nunca" && (
        <div className="space-y-2">
          <Label htmlFor="tipoAlcohol">Que tipo de alcohol sueles consumir</Label>
          <Input
            id="tipoAlcohol"
            placeholder="Ej: cerveza, vino, combinados..."
            value={data.tipoAlcohol || ""}
            onChange={(e) => onChange({ tipoAlcohol: e.target.value })}
          />
        </div>
      )}

      {/* Tabaco */}
      <div className="space-y-3">
        <Label>Fumador/a</Label>
        <RadioGroup
          value={
            data.consumoTabaco === true
              ? "si"
              : data.consumoTabaco === false
              ? "no"
              : ""
          }
          onValueChange={(v) =>
            onChange({ consumoTabaco: v === "si", cigarrillosDia: v === "no" ? undefined : data.cigarrillosDia })
          }
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="si" id="fuma-si" />
            <Label htmlFor="fuma-si" className="font-normal">Si</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="no" id="fuma-no" />
            <Label htmlFor="fuma-no" className="font-normal">No</Label>
          </div>
        </RadioGroup>
      </div>

      {data.consumoTabaco && (
        <div className="space-y-2">
          <Label htmlFor="cigarrillos">Cigarrillos al dia</Label>
          <Input
            id="cigarrillos"
            type="number"
            min={1}
            max={100}
            placeholder="Numero de cigarrillos"
            value={data.cigarrillosDia ?? ""}
            onChange={(e) =>
              onChange({ cigarrillosDia: e.target.value ? parseInt(e.target.value) : undefined })
            }
          />
        </div>
      )}
    </div>
  );
}
