"use client";

import { type EncuestaData } from "@/types/encuesta.types";
import { Label } from "@/components/ui/label";
import { Slider } from "@/components/ui/slider";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";

interface StepProps {
  data: EncuestaData;
  onChange: (data: Partial<EncuestaData>) => void;
}

export function AspectoPsicologico({ data, onChange }: StepProps) {
  return (
    <div className="space-y-8">
      {/* Relacion con la comida */}
      <div className="space-y-3">
        <Label>Como describirias tu relacion con la comida</Label>
        <RadioGroup
          value={data.relacionComida || ""}
          onValueChange={(v) => onChange({ relacionComida: v })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="buena" id="rel-buena" />
            <Label htmlFor="rel-buena" className="font-normal">
              Buena - como con normalidad y disfruto
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="regular" id="rel-regular" />
            <Label htmlFor="rel-regular" className="font-normal">
              Regular - a veces me preocupo en exceso
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="mala" id="rel-mala" />
            <Label htmlFor="rel-mala" className="font-normal">
              Mala - la comida me genera ansiedad frecuentemente
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="conflictiva" id="rel-conflictiva" />
            <Label htmlFor="rel-conflictiva" className="font-normal">
              Conflictiva - tengo una relacion muy complicada con la comida
            </Label>
          </div>
        </RadioGroup>
      </div>

      {/* Come por ansiedad */}
      <div className="space-y-3">
        <Label>Comes por ansiedad, aburrimiento o emociones</Label>
        <RadioGroup
          value={
            data.comePorAnsiedad === true
              ? "frecuentemente"
              : data.comePorAnsiedad === false
              ? "nunca"
              : (data as any).comePorAnsiedadFrecuencia || ""
          }
          onValueChange={(v) => {
            if (v === "nunca") onChange({ comePorAnsiedad: false });
            else if (v === "frecuentemente" || v === "siempre") onChange({ comePorAnsiedad: true });
            else onChange({ comePorAnsiedad: undefined });
          }}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="nunca" id="ansiedad-nunca" />
            <Label htmlFor="ansiedad-nunca" className="font-normal">Nunca</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="a_veces" id="ansiedad-aveces" />
            <Label htmlFor="ansiedad-aveces" className="font-normal">A veces</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="frecuentemente" id="ansiedad-frec" />
            <Label htmlFor="ansiedad-frec" className="font-normal">Frecuentemente</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="siempre" id="ansiedad-siempre" />
            <Label htmlFor="ansiedad-siempre" className="font-normal">Siempre</Label>
          </div>
        </RadioGroup>
      </div>

      {/* Atracones */}
      <div className="space-y-3">
        <Label>Tienes episodios de atracones (comer grandes cantidades sin control)</Label>
        <RadioGroup
          value={
            data.episodiosAtracones === true
              ? "si"
              : data.episodiosAtracones === false
              ? "no"
              : ""
          }
          onValueChange={(v) => onChange({ episodiosAtracones: v === "si" })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="si" id="atracones-si" />
            <Label htmlFor="atracones-si" className="font-normal">Si</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="no" id="atracones-no" />
            <Label htmlFor="atracones-no" className="font-normal">No</Label>
          </div>
        </RadioGroup>
      </div>

      {/* Culpa */}
      <div className="space-y-3">
        <Label>Sientes culpa despues de comer</Label>
        <RadioGroup
          value={
            data.sentimientoCulpa === true
              ? "frecuentemente"
              : data.sentimientoCulpa === false
              ? "nunca"
              : ""
          }
          onValueChange={(v) => {
            onChange({ sentimientoCulpa: v === "frecuentemente" });
          }}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="nunca" id="culpa-nunca" />
            <Label htmlFor="culpa-nunca" className="font-normal">Nunca</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="a_veces" id="culpa-aveces" />
            <Label htmlFor="culpa-aveces" className="font-normal">A veces</Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="frecuentemente" id="culpa-frec" />
            <Label htmlFor="culpa-frec" className="font-normal">Frecuentemente</Label>
          </div>
        </RadioGroup>
      </div>

      {/* Nivel de estres */}
      <div className="space-y-3">
        <Label>
          Nivel de estres actual: {data.nivelEstres ?? 5}/10
        </Label>
        <Slider
          min={1}
          max={10}
          step={1}
          value={[data.nivelEstres ?? 5]}
          onValueChange={(v) => onChange({ nivelEstres: v[0] })}
        />
        <div className="flex justify-between text-xs text-muted-foreground">
          <span>1 - Muy bajo</span>
          <span>5 - Moderado</span>
          <span>10 - Muy alto</span>
        </div>
      </div>

      {/* Calidad sueno */}
      <div className="space-y-3">
        <Label>Calidad del sueno</Label>
        <RadioGroup
          value={data.calidadSueno || ""}
          onValueChange={(v) => onChange({ calidadSueno: v })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="buena" id="sueno-buena" />
            <Label htmlFor="sueno-buena" className="font-normal">
              Buena - duermo bien y me despierto descansado/a
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="regular" id="sueno-regular" />
            <Label htmlFor="sueno-regular" className="font-normal">
              Regular - me cuesta dormir o me despierto cansado/a
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="mala" id="sueno-mala" />
            <Label htmlFor="sueno-mala" className="font-normal">
              Mala - insomnio o sueno muy interrumpido
            </Label>
          </div>
        </RadioGroup>
      </div>

      {/* Horas de sueno */}
      <div className="space-y-3">
        <Label>
          Horas de sueno: {data.horasSueno ?? 7}h
        </Label>
        <Slider
          min={4}
          max={12}
          step={0.5}
          value={[data.horasSueno ?? 7]}
          onValueChange={(v) => onChange({ horasSueno: v[0] })}
        />
        <div className="flex justify-between text-xs text-muted-foreground">
          <span>4h</span>
          <span>8h</span>
          <span>12h</span>
        </div>
      </div>

      {/* Motivacion */}
      <div className="space-y-3">
        <Label>
          Nivel de motivacion para el cambio: {data.nivelMotivacion ?? 7}/10
        </Label>
        <Slider
          min={1}
          max={10}
          step={1}
          value={[data.nivelMotivacion ?? 7]}
          onValueChange={(v) => onChange({ nivelMotivacion: v[0] })}
        />
        <div className="flex justify-between text-xs text-muted-foreground">
          <span>1 - Poca</span>
          <span>5 - Media</span>
          <span>10 - Maxima</span>
        </div>
      </div>
    </div>
  );
}
