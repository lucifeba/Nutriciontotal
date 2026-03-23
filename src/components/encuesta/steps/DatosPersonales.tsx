"use client";

import { type EncuestaData } from "@/types/encuesta.types";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";

interface StepProps {
  data: EncuestaData;
  onChange: (data: Partial<EncuestaData>) => void;
}

export function DatosPersonales({ data, onChange }: StepProps) {
  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <Label htmlFor="ocupacion">Ocupacion</Label>
        <Input
          id="ocupacion"
          placeholder="Ej: Profesor/a, ingeniero/a, estudiante..."
          value={data.ocupacion || ""}
          onChange={(e) => onChange({ ocupacion: e.target.value })}
        />
      </div>

      <div className="space-y-2">
        <Label htmlFor="horarioLaboral">Horario laboral</Label>
        <Input
          id="horarioLaboral"
          placeholder="Ej: 9:00 - 17:00, turnos rotativos..."
          value={data.horarioLaboral || ""}
          onChange={(e) => onChange({ horarioLaboral: e.target.value })}
        />
      </div>

      <div className="space-y-2">
        <Label>Estado civil</Label>
        <Select
          value={data.estadoCivil || ""}
          onValueChange={(value) => onChange({ estadoCivil: value })}
        >
          <SelectTrigger>
            <SelectValue placeholder="Selecciona tu estado civil" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="soltero">Soltero/a</SelectItem>
            <SelectItem value="casado">Casado/a</SelectItem>
            <SelectItem value="divorciado">Divorciado/a</SelectItem>
            <SelectItem value="viudo">Viudo/a</SelectItem>
            <SelectItem value="pareja_de_hecho">Pareja de hecho</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <div className="space-y-2">
        <Label htmlFor="numHijos">Numero de hijos</Label>
        <Input
          id="numHijos"
          type="number"
          min={0}
          max={20}
          placeholder="0"
          value={data.numHijos ?? ""}
          onChange={(e) =>
            onChange({ numHijos: e.target.value ? parseInt(e.target.value) : undefined })
          }
        />
      </div>

      <div className="space-y-2">
        <Label htmlFor="quienCocina">Quien cocina en casa</Label>
        <Input
          id="quienCocina"
          placeholder="Ej: Yo mismo/a, mi pareja, compartimos..."
          value={data.quienCocinaEnCasa || ""}
          onChange={(e) => onChange({ quienCocinaEnCasa: e.target.value })}
        />
      </div>

      <div className="space-y-3">
        <Label>Donde comes con mas frecuencia</Label>
        <RadioGroup
          value={data.comeEnCasaOFuera || ""}
          onValueChange={(value) => onChange({ comeEnCasaOFuera: value })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="casa" id="casa" />
            <Label htmlFor="casa" className="font-normal">
              En casa
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="fuera" id="fuera" />
            <Label htmlFor="fuera" className="font-normal">
              Fuera de casa
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="ambos" id="ambos" />
            <Label htmlFor="ambos" className="font-normal">
              Ambos por igual
            </Label>
          </div>
        </RadioGroup>
      </div>
    </div>
  );
}
