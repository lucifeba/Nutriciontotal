"use client";

import { type EncuestaData } from "@/types/encuesta.types";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { Textarea } from "@/components/ui/textarea";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";

interface StepProps {
  data: EncuestaData;
  onChange: (data: Partial<EncuestaData>) => void;
}

const PATOLOGIAS = [
  "Diabetes tipo 1",
  "Diabetes tipo 2",
  "Hipertension",
  "Hipotiroidismo",
  "Hipertiroidismo",
  "Hipercolesterolemia",
  "Hipertrigliceridemia",
  "Sindrome de ovario poliquistico",
  "Enfermedad celiaca",
  "Enfermedad de Crohn",
  "Colitis ulcerosa",
  "Sindrome de intestino irritable",
  "Insuficiencia renal",
  "Anemia",
  "Hiperuricemia / Gota",
  "Cancer",
  "Trastorno de conducta alimentaria",
  "Ninguna",
];

const ALERGIAS = [
  "Leche",
  "Huevo",
  "Pescado",
  "Marisco",
  "Frutos secos",
  "Cacahuete",
  "Soja",
  "Trigo",
  "Sesamo",
  "Mostaza",
  "Apio",
  "Moluscos",
  "Altramuces",
  "Ninguna",
];

const INTOLERANCIAS = [
  "Lactosa",
  "Fructosa",
  "Sorbitol",
  "Gluten (sensibilidad no celiaca)",
  "Histamina",
  "Ninguna",
];

const ANTECEDENTES = [
  "Diabetes",
  "Hipertension",
  "Enfermedad cardiovascular",
  "Obesidad",
  "Cancer",
  "Enfermedades tiroideas",
  "Ninguno",
];

const PROBLEMAS_DIGESTIVOS = [
  "Acidez / reflujo",
  "Gases / hinchazón",
  "Estrenimiento",
  "Diarreas frecuentes",
  "Nauseas",
  "Dolor abdominal",
  "Ninguno",
];

function CheckboxGroup({
  label,
  options,
  selected,
  onToggle,
}: {
  label: string;
  options: string[];
  selected: string[];
  onToggle: (value: string) => void;
}) {
  return (
    <div className="space-y-3">
      <Label>{label}</Label>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
        {options.map((option) => (
          <div key={option} className="flex items-center space-x-2">
            <Checkbox
              id={`cb-${option}`}
              checked={selected.includes(option)}
              onCheckedChange={() => onToggle(option)}
            />
            <Label htmlFor={`cb-${option}`} className="font-normal text-sm">
              {option}
            </Label>
          </div>
        ))}
      </div>
    </div>
  );
}

export function HistorialMedico({ data, onChange }: StepProps) {
  const toggleItem = (field: keyof EncuestaData, value: string) => {
    const current = (data[field] as string[]) || [];
    const updated = current.includes(value)
      ? current.filter((item) => item !== value)
      : [...current, value];
    onChange({ [field]: updated });
  };

  return (
    <div className="space-y-8">
      <CheckboxGroup
        label="Patologias diagnosticadas"
        options={PATOLOGIAS}
        selected={data.patologias || []}
        onToggle={(v) => toggleItem("patologias", v)}
      />

      <div className="space-y-2">
        <Label htmlFor="patologiasDetalle">
          Detalla otras patologias si las hay
        </Label>
        <Textarea
          id="patologiasDetalle"
          placeholder="Describe cualquier otra patologia..."
          value={data.patologiasDetalle || ""}
          onChange={(e) => onChange({ patologiasDetalle: e.target.value })}
        />
      </div>

      <CheckboxGroup
        label="Alergias alimentarias"
        options={ALERGIAS}
        selected={data.alergias || []}
        onToggle={(v) => toggleItem("alergias", v)}
      />

      <CheckboxGroup
        label="Intolerancias"
        options={INTOLERANCIAS}
        selected={data.intolerancias || []}
        onToggle={(v) => toggleItem("intolerancias", v)}
      />

      <div className="space-y-2">
        <Label htmlFor="medicacion">Medicacion actual</Label>
        <Textarea
          id="medicacion"
          placeholder="Indica los medicamentos que tomas actualmente y la dosis..."
          value={data.medicacionActual || ""}
          onChange={(e) => onChange({ medicacionActual: e.target.value })}
        />
      </div>

      <div className="space-y-2">
        <Label htmlFor="suplementos">Suplementos</Label>
        <Textarea
          id="suplementos"
          placeholder="Ej: Vitamina D, hierro, omega 3..."
          value={data.suplementos || ""}
          onChange={(e) => onChange({ suplementos: e.target.value })}
        />
      </div>

      <div className="space-y-2">
        <Label htmlFor="cirugias">Cirugias previas</Label>
        <Textarea
          id="cirugias"
          placeholder="Indica si has tenido alguna cirugia relevante..."
          value={data.cirugiasPrevias || ""}
          onChange={(e) => onChange({ cirugiasPrevias: e.target.value })}
        />
      </div>

      <CheckboxGroup
        label="Antecedentes familiares"
        options={ANTECEDENTES}
        selected={data.antecedentesFamiliares || []}
        onToggle={(v) => toggleItem("antecedentesFamiliares", v)}
      />

      <CheckboxGroup
        label="Problemas digestivos"
        options={PROBLEMAS_DIGESTIVOS}
        selected={data.problemaDigestivo || []}
        onToggle={(v) => toggleItem("problemaDigestivo", v)}
      />

      <div className="space-y-3">
        <Label>Transito intestinal</Label>
        <RadioGroup
          value={data.transitoIntestinal || ""}
          onValueChange={(v) => onChange({ transitoIntestinal: v })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="normal" id="transito-normal" />
            <Label htmlFor="transito-normal" className="font-normal">
              Normal (1-2 veces al dia)
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="estrenimiento" id="transito-estrenimiento" />
            <Label htmlFor="transito-estrenimiento" className="font-normal">
              Estrenimiento (menos de 3 veces por semana)
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="diarrea" id="transito-diarrea" />
            <Label htmlFor="transito-diarrea" className="font-normal">
              Diarreas frecuentes (mas de 3 veces al dia)
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="alternante" id="transito-alternante" />
            <Label htmlFor="transito-alternante" className="font-normal">
              Alternante (periodos de estrenimiento y diarrea)
            </Label>
          </div>
        </RadioGroup>
      </div>
    </div>
  );
}
