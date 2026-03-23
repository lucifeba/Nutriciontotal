"use client";

import { type EncuestaData } from "@/types/encuesta.types";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Checkbox } from "@/components/ui/checkbox";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";

interface StepProps {
  data: EncuestaData;
  onChange: (data: Partial<EncuestaData>) => void;
}

const OBJETIVOS = [
  { value: "perder_peso", label: "Perder peso / grasa" },
  { value: "ganar_masa", label: "Ganar masa muscular" },
  { value: "mejorar_composicion", label: "Mejorar composicion corporal" },
  { value: "mejorar_salud", label: "Mejorar salud general" },
  { value: "rendimiento_deportivo", label: "Mejorar rendimiento deportivo" },
  { value: "aprender_comer", label: "Aprender a comer mejor" },
  { value: "relacion_comida", label: "Mejorar relacion con la comida" },
  { value: "gestion_patologia", label: "Gestion de patologia" },
  { value: "embarazo_lactancia", label: "Embarazo / Lactancia" },
  { value: "otro", label: "Otro" },
];

const DIETAS_PREVIAS = [
  "Dieta hipocalorica",
  "Dieta cetogenica / keto",
  "Dieta proteinada",
  "Ayuno intermitente",
  "Dieta Dukan",
  "Dieta de la zona",
  "Dieta paleo",
  "Batidos / sustitutivos",
  "Pastillas / productos para adelgazar",
  "Con nutricionista",
  "Por mi cuenta",
  "Ninguna",
];

export function ObjetivosExpectativas({ data, onChange }: StepProps) {
  const toggleDieta = (dieta: string) => {
    const current = data.dietasPrevias || [];
    const updated = current.includes(dieta)
      ? current.filter((d) => d !== dieta)
      : [...current, dieta];
    onChange({ dietasPrevias: updated });
  };

  return (
    <div className="space-y-8">
      {/* Motivo consulta */}
      <div className="space-y-2">
        <Label htmlFor="motivoConsulta">
          Motivo de la consulta
        </Label>
        <Textarea
          id="motivoConsulta"
          placeholder="Cuentanos por que has decidido acudir a un nutricionista..."
          value={data.motivoConsulta || ""}
          onChange={(e) => onChange({ motivoConsulta: e.target.value })}
          rows={4}
        />
      </div>

      {/* Objetivo principal */}
      <div className="space-y-3">
        <Label>Objetivo principal</Label>
        <RadioGroup
          value={data.objetivoPrincipal || ""}
          onValueChange={(v) => onChange({ objetivoPrincipal: v })}
        >
          {OBJETIVOS.map((obj) => (
            <div key={obj.value} className="flex items-center space-x-2">
              <RadioGroupItem value={obj.value} id={`obj-${obj.value}`} />
              <Label htmlFor={`obj-${obj.value}`} className="font-normal">
                {obj.label}
              </Label>
            </div>
          ))}
        </RadioGroup>
      </div>

      {/* Dietas previas */}
      <div className="space-y-3">
        <Label>Dietas o metodos que hayas seguido anteriormente</Label>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
          {DIETAS_PREVIAS.map((dieta) => (
            <div key={dieta} className="flex items-center space-x-2">
              <Checkbox
                id={`dieta-${dieta}`}
                checked={(data.dietasPrevias || []).includes(dieta)}
                onCheckedChange={() => toggleDieta(dieta)}
              />
              <Label htmlFor={`dieta-${dieta}`} className="font-normal text-sm">
                {dieta}
              </Label>
            </div>
          ))}
        </div>
      </div>

      {/* Resultados previos */}
      <div className="space-y-2">
        <Label htmlFor="resultados">
          Resultados de las dietas anteriores
        </Label>
        <Textarea
          id="resultados"
          placeholder="Que resultados obtuviste y por que dejaste la dieta..."
          value={data.resultadoDietasPrevias || ""}
          onChange={(e) => onChange({ resultadoDietasPrevias: e.target.value })}
        />
      </div>

      {/* Pesos historicos */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label htmlFor="pesoMax">Peso maximo historico (kg)</Label>
          <Input
            id="pesoMax"
            type="number"
            min={30}
            max={300}
            step={0.1}
            placeholder="Ej: 95"
            value={data.pesoMaxHistorico ?? ""}
            onChange={(e) =>
              onChange({
                pesoMaxHistorico: e.target.value
                  ? parseFloat(e.target.value)
                  : undefined,
              })
            }
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="pesoMin">Peso minimo en edad adulta (kg)</Label>
          <Input
            id="pesoMin"
            type="number"
            min={30}
            max={300}
            step={0.1}
            placeholder="Ej: 58"
            value={data.pesoMinAdulto ?? ""}
            onChange={(e) =>
              onChange({
                pesoMinAdulto: e.target.value
                  ? parseFloat(e.target.value)
                  : undefined,
              })
            }
          />
        </div>
      </div>

      {/* Expectativa plazo */}
      <div className="space-y-3">
        <Label>En que plazo esperas alcanzar tus objetivos</Label>
        <RadioGroup
          value={data.expectativaPlazo || ""}
          onValueChange={(v) => onChange({ expectativaPlazo: v })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="1_mes" id="plazo-1" />
            <Label htmlFor="plazo-1" className="font-normal">1 mes</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="3_meses" id="plazo-3" />
            <Label htmlFor="plazo-3" className="font-normal">3 meses</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="6_meses" id="plazo-6" />
            <Label htmlFor="plazo-6" className="font-normal">6 meses</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="1_ano" id="plazo-12" />
            <Label htmlFor="plazo-12" className="font-normal">1 ano</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="sin_prisa" id="plazo-sp" />
            <Label htmlFor="plazo-sp" className="font-normal">
              Sin prisa, quiero hacerlo bien
            </Label>
          </div>
        </RadioGroup>
      </div>
    </div>
  );
}
