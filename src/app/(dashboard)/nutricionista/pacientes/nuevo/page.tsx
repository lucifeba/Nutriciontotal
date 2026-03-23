"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { useRouter } from "next/navigation";
import { trpc } from "@/lib/trpc/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { useToast } from "@/components/ui/use-toast";
import { ArrowLeft, Check, Copy, MessageCircle } from "lucide-react";
import Link from "next/link";

interface NuevoPacienteForm {
  nombre: string;
  apellidos: string;
  email: string;
  telefono?: string;
  fechaNacimiento?: string;
  sexo?: "MASCULINO" | "FEMENINO" | "OTRO";
  altura?: number;
  pesoActual?: number;
  pesoObjetivo?: number;
}

export default function NuevoPacientePage() {
  const router = useRouter();
  const { toast } = useToast();
  const [showSuccessDialog, setShowSuccessDialog] = useState(false);
  const [createdData, setCreatedData] = useState<{
    tempPassword: string;
    encuestaToken: string;
    nombre: string;
  } | null>(null);

  const { register, handleSubmit, setValue, formState: { errors } } = useForm<NuevoPacienteForm>();

  const createMutation = trpc.pacientes.create.useMutation({
    onSuccess: (data) => {
      setCreatedData({
        tempPassword: data.tempPassword,
        encuestaToken: data.encuestaToken || "",
        nombre: `${data.user.nombre} ${data.user.apellidos}`,
      });
      setShowSuccessDialog(true);
    },
    onError: (error) => {
      toast({
        title: "Error",
        description: error.message || "Error al crear el paciente",
        variant: "destructive",
      });
    },
  });

  const onSubmit = (data: NuevoPacienteForm) => {
    createMutation.mutate({
      ...data,
      altura: data.altura ? Number(data.altura) : undefined,
      pesoActual: data.pesoActual ? Number(data.pesoActual) : undefined,
      pesoObjetivo: data.pesoObjetivo ? Number(data.pesoObjetivo) : undefined,
    });
  };

  const encuestaUrl = createdData?.encuestaToken
    ? `${typeof window !== "undefined" ? window.location.origin : ""}/encuesta/${createdData.encuestaToken}`
    : "";

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text);
    toast({ title: "Copiado", description: "Texto copiado al portapapeles" });
  };

  const sendWhatsApp = () => {
    const message = encodeURIComponent(
      `Hola ${createdData?.nombre}, te he registrado en NutriPlan Pro.\n\nTu contraseña temporal es: ${createdData?.tempPassword}\n\nPor favor, completa tu encuesta de anamnesis aquí: ${encuestaUrl}`
    );
    window.open(`https://wa.me/?text=${message}`, "_blank");
  };

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div className="flex items-center gap-4">
        <Link href="/nutricionista/pacientes">
          <Button variant="ghost" size="icon">
            <ArrowLeft className="h-5 w-5" />
          </Button>
        </Link>
        <div>
          <h2 className="text-xl font-bold text-[#2D5A3D]">Nuevo Paciente</h2>
          <p className="text-sm text-muted-foreground">Registra un nuevo paciente en tu consulta</p>
        </div>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Datos del paciente</CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
            {/* Datos personales */}
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="nombre">Nombre *</Label>
                <Input
                  id="nombre"
                  placeholder="Nombre"
                  {...register("nombre", { required: "El nombre es obligatorio" })}
                />
                {errors.nombre && <p className="text-destructive text-sm">{errors.nombre.message}</p>}
              </div>
              <div className="space-y-2">
                <Label htmlFor="apellidos">Apellidos *</Label>
                <Input
                  id="apellidos"
                  placeholder="Apellidos"
                  {...register("apellidos", { required: "Los apellidos son obligatorios" })}
                />
                {errors.apellidos && <p className="text-destructive text-sm">{errors.apellidos.message}</p>}
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="email">Email *</Label>
                <Input
                  id="email"
                  type="email"
                  placeholder="paciente@email.com"
                  {...register("email", {
                    required: "El email es obligatorio",
                    pattern: { value: /^[^\s@]+@[^\s@]+\.[^\s@]+$/, message: "Email inválido" },
                  })}
                />
                {errors.email && <p className="text-destructive text-sm">{errors.email.message}</p>}
              </div>
              <div className="space-y-2">
                <Label htmlFor="telefono">Teléfono</Label>
                <Input id="telefono" placeholder="+34 600 000 000" {...register("telefono")} />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="fechaNacimiento">Fecha de nacimiento</Label>
                <Input id="fechaNacimiento" type="date" {...register("fechaNacimiento")} />
              </div>
              <div className="space-y-2">
                <Label>Sexo</Label>
                <Select onValueChange={(value) => setValue("sexo", value as any)}>
                  <SelectTrigger>
                    <SelectValue placeholder="Seleccionar" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="MASCULINO">Masculino</SelectItem>
                    <SelectItem value="FEMENINO">Femenino</SelectItem>
                    <SelectItem value="OTRO">Otro</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            {/* Datos antropométricos */}
            <div className="border-t pt-4">
              <p className="text-sm font-medium text-muted-foreground mb-4">Datos antropométricos</p>
              <div className="grid grid-cols-3 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="altura">Altura (cm)</Label>
                  <Input
                    id="altura"
                    type="number"
                    step="0.1"
                    placeholder="170"
                    {...register("altura", { valueAsNumber: true })}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="pesoActual">Peso actual (kg)</Label>
                  <Input
                    id="pesoActual"
                    type="number"
                    step="0.1"
                    placeholder="70"
                    {...register("pesoActual", { valueAsNumber: true })}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="pesoObjetivo">Peso objetivo (kg)</Label>
                  <Input
                    id="pesoObjetivo"
                    type="number"
                    step="0.1"
                    placeholder="65"
                    {...register("pesoObjetivo", { valueAsNumber: true })}
                  />
                </div>
              </div>
            </div>

            <Button
              type="submit"
              className="w-full bg-[#2D5A3D] hover:bg-[#234A31]"
              disabled={createMutation.isLoading}
            >
              {createMutation.isLoading ? "Creando paciente..." : "Crear Paciente"}
            </Button>
          </form>
        </CardContent>
      </Card>

      {/* Success Dialog */}
      <Dialog open={showSuccessDialog} onOpenChange={setShowSuccessDialog}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2 text-[#2D5A3D]">
              <Check className="h-5 w-5" />
              Paciente creado con éxito
            </DialogTitle>
            <DialogDescription>
              Se ha creado la cuenta para {createdData?.nombre}
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label className="text-sm font-medium">Contraseña temporal</Label>
              <div className="flex items-center gap-2">
                <code className="flex-1 bg-muted px-3 py-2 rounded text-sm font-mono">
                  {createdData?.tempPassword}
                </code>
                <Button
                  variant="outline"
                  size="icon"
                  onClick={() => copyToClipboard(createdData?.tempPassword || "")}
                >
                  <Copy className="h-4 w-4" />
                </Button>
              </div>
            </div>

            <div className="space-y-2">
              <Label className="text-sm font-medium">Enlace de encuesta</Label>
              <div className="flex items-center gap-2">
                <code className="flex-1 bg-muted px-3 py-2 rounded text-sm font-mono truncate">
                  {encuestaUrl}
                </code>
                <Button
                  variant="outline"
                  size="icon"
                  onClick={() => copyToClipboard(encuestaUrl)}
                >
                  <Copy className="h-4 w-4" />
                </Button>
              </div>
            </div>

            <div className="flex gap-2 pt-2">
              <Button
                variant="outline"
                className="flex-1"
                onClick={sendWhatsApp}
              >
                <MessageCircle className="h-4 w-4 mr-2" />
                Enviar por WhatsApp
              </Button>
              <Button
                className="flex-1 bg-[#2D5A3D] hover:bg-[#234A31]"
                onClick={() => {
                  setShowSuccessDialog(false);
                  router.push("/nutricionista/pacientes");
                }}
              >
                Ir a Pacientes
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
