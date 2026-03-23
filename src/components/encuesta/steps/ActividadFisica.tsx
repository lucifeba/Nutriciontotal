"use client";

import { type EncuestaData } from "@/types/encuesta.types";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";

interface StepProps {
  data: EncuestaData;
  onChange: (data: Partial<EncuestaData>) => void;
}

export function ActividadFisica({ data, onChange }: StepProps) {
  const showDeporteFields =
    data.nivelActividad &&
    data.nivelActividad !== "sedentario";

  return (
    <div className="space-y-8">
      {/* Nivel de actividad */}
      <div className="space-y-3">
        <Label>Nivel de actividad fisica</Label>
        <RadioGroup
          value={data.nivelActividad || ""}
          onValueChange={(v) => onChange({ nivelActividad: v })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="sedentario" id="act-sedentario" />
            <Label htmlFor="act-sedentario" className="font-normal">
              Sedentario - Poco o ningun ejercicio, trabajo de oficina
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="ligero" id="act-ligero" />
            <Label htmlFor="act-ligero" className="font-normal">
              Ligero - Ejercicio ligero 1-3 dias/semana
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="moderado" id="act-moderado" />
            <Label htmlFor="act-moderado" className="font-normal">
              Moderado - Ejercicio moderado 3-5 dias/semana
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="activo" id="act-activo" />
            <Label htmlFor="act-activo" className="font-normal">
              Activo - Ejercicio intenso 6-7 dias/semana
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="muy_activo" id="act-muy-activo" />
            <Label htmlFor="act-muy-activo" className="font-normal">
              Muy activo - Ejercicio muy intenso, trabajo fisico
            </Label>
          </div>
        </RadioGroup>
      </div>

      {/* Campos condicionales de deporte */}
      {showDeporteFields && (
        <div className="space-y-6 p-4 bg-green-50 rounded-lg border border-green-100">
          <h4 className="font-medium text-green-800">
            Detalles de tu actividad deportiva
          </h4>

          <div className="space-y-2">
            <Label htmlFor="deporte">Que deporte/s practicas</Label>
            <Input
              id="deporte"
              placeholder="Ej: running, padel, natacion, gimnasio..."
              value={data.deportePractica || ""}
              onChange={(e) => onChange({ deportePractica: e.target.value })}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="frecuencia">Frecuencia</Label>
            <Input
              id="frecuencia"
              placeholder="Ej: 3 veces por semana"
              value={data.frecuenciaDeporte || ""}
              onChange={(e) => onChange({ frecuenciaDeporte: e.target.value })}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="duracion">Duracion de cada sesion</Label>
            <Input
              id="duracion"
              placeholder="Ej: 45 minutos, 1 hora..."
              value={data.duracionSesion || ""}
              onChange={(e) => onChange({ duracionSesion: e.target.value })}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="horarioDeporte">Horario habitual de entrenamiento</Label>
            <Input
              id="horarioDeporte"
              placeholder="Ej: manana antes del trabajo, tardes..."
              value={data.horarioDeporte || ""}
              onChange={(e) => onChange({ horarioDeporte: e.target.value })}
            />
          </div>
        </div>
      )}

      {/* Actividad laboral */}
      <div className="space-y-3">
        <Label>Tipo de actividad en el trabajo</Label>
        <RadioGroup
          value={data.actividadDiaria || ""}
          onValueChange={(v) => onChange({ actividadDiaria: v })}
        >
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="sentado" id="lab-sentado" />
            <Label htmlFor="lab-sentado" className="font-normal">
              Mayormente sentado/a (oficina, teletrabajo)
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="mixto" id="lab-mixto" />
            <Label htmlFor="lab-mixto" className="font-normal">
              Mixto (sentado y de pie a partes iguales)
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="pie" id="lab-pie" />
            <Label htmlFor="lab-pie" className="font-normal">
              Mayormente de pie (comercio, hosteleria)
            </Label>
          </div>
          <div className="flex items-center space-x-2">
            <RadioGroupItem value="fisico" id="lab-fisico" />
            <Label htmlFor="lab-fisico" className="font-normal">
              Trabajo fisico (construccion, almacen)
            </Label>
          </div>
        </RadioGroup>
      </div>
    </div>
  );
}
