"use client";

import { useState } from "react";
import { trpc } from "@/lib/trpc";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";

interface PlanCreatorProps {
  onSuccess: () => void;
  onCancel: () => void;
}

export function PlanCreator({ onSuccess, onCancel }: PlanCreatorProps) {
  const [nombre, setNombre] = useState("");
  const [pacienteId, setPacienteId] = useState("");
  const [tipoPlan, setTipoPlan] = useState("SEMANAL");
  const [caloriasObjetivo, setCaloriasObjetivo] = useState(2000);
  const [proteinasObjetivo, setProteinasObjetivo] = useState(80);
  const [carbohidratosObjetivo, setCarbohidratosObjetivo] = useState(250);
  const [grasasObjetivo, setGrasasObjetivo] = useState(70);
  const [numPlanificaciones, setNumPlanificaciones] = useState(1);
  const [notas, setNotas] = useState("");

  const { data: pacientes } = trpc.pacientes.list.useQuery();

  const createPlan = trpc.planes.create.useMutation({
    onSuccess: () => onSuccess(),
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!nombre || !pacienteId) return;

    createPlan.mutate({
      nombre,
      pacienteId,
      tipoPlan: tipoPlan as "SEMANAL" | "QUINCENAL",
      numPlanificaciones,
      comidasActivas: ["DESAYUNO", "MEDIA_MANANA", "ALMUERZO", "MERIENDA", "CENA"],
      caloriasObjetivo,
      proteinasObjetivo,
      carbohidratosObjetivo,
      grasasObjetivo,
    });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="space-y-2">
        <Label htmlFor="nombre">Nombre del plan</Label>
        <Input
          id="nombre"
          value={nombre}
          onChange={(e) => setNombre(e.target.value)}
          placeholder="Ej: Plan de perdida de peso - Semana 1"
          required
        />
      </div>

      <div className="space-y-2">
        <Label htmlFor="paciente">Paciente</Label>
        <Select value={pacienteId} onValueChange={setPacienteId}>
          <SelectTrigger>
            <SelectValue placeholder="Seleccionar paciente" />
          </SelectTrigger>
          <SelectContent>
            {pacientes?.map((p: any) => (
              <SelectItem key={p.id} value={p.id}>
                {p.user?.nombre} {p.user?.apellidos}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="space-y-2">
        <Label htmlFor="tipoPlan">Tipo de plan</Label>
        <Select value={tipoPlan} onValueChange={setTipoPlan}>
          <SelectTrigger>
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="SEMANAL">Semanal</SelectItem>
            <SelectItem value="QUINCENAL">Quincenal</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label htmlFor="calorias">Calorias objetivo</Label>
          <Input
            id="calorias"
            type="number"
            value={caloriasObjetivo}
            onChange={(e) => setCaloriasObjetivo(Number(e.target.value))}
            min={800}
            max={5000}
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="proteinas">Proteinas (g)</Label>
          <Input
            id="proteinas"
            type="number"
            value={proteinasObjetivo}
            onChange={(e) => setProteinasObjetivo(Number(e.target.value))}
            min={20}
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="carbohidratos">Carbohidratos (g)</Label>
          <Input
            id="carbohidratos"
            type="number"
            value={carbohidratosObjetivo}
            onChange={(e) => setCarbohidratosObjetivo(Number(e.target.value))}
            min={50}
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="grasas">Grasas (g)</Label>
          <Input
            id="grasas"
            type="number"
            value={grasasObjetivo}
            onChange={(e) => setGrasasObjetivo(Number(e.target.value))}
            min={20}
          />
        </div>
      </div>

      <div className="space-y-2">
        <Label htmlFor="notas">Notas (opcional)</Label>
        <Textarea
          id="notas"
          value={notas}
          onChange={(e) => setNotas(e.target.value)}
          placeholder="Observaciones adicionales..."
          rows={3}
        />
      </div>

      <div className="flex gap-2 justify-end pt-2">
        <Button type="button" variant="outline" onClick={onCancel}>
          Cancelar
        </Button>
        <Button
          type="submit"
          disabled={createPlan.isLoading || !nombre || !pacienteId}
        >
          {createPlan.isLoading ? "Creando..." : "Crear Plan"}
        </Button>
      </div>
    </form>
  );
}
