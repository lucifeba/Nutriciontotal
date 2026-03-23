"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { signIn } from "next-auth/react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

interface RegistroFormData {
  nombre: string;
  apellidos: string;
  email: string;
  password: string;
  confirmPassword: string;
  rol: "NUTRICIONISTA" | "PACIENTE";
  numColegiado?: string;
  especialidad?: string;
  clinica?: string;
}

export default function RegistroPage() {
  const router = useRouter();
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const { register, handleSubmit, watch, setValue, formState: { errors } } = useForm<RegistroFormData>({
    defaultValues: { rol: "NUTRICIONISTA" },
  });

  const selectedRol = watch("rol");
  const password = watch("password");

  const onSubmit = async (data: RegistroFormData) => {
    setIsLoading(true);
    setError(null);

    if (data.password !== data.confirmPassword) {
      setError("Las contraseñas no coinciden");
      setIsLoading(false);
      return;
    }

    try {
      const res = await fetch("/api/auth/registro", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          nombre: data.nombre,
          apellidos: data.apellidos,
          email: data.email,
          password: data.password,
          rol: data.rol,
          numColegiado: data.numColegiado,
          especialidad: data.especialidad,
          clinica: data.clinica,
        }),
      });

      const result = await res.json();

      if (!res.ok) {
        setError(result.error || "Error al registrar usuario");
        return;
      }

      const signInResult = await signIn("credentials", {
        email: data.email,
        password: data.password,
        redirect: false,
      });

      if (signInResult?.error) {
        setError("Cuenta creada. Por favor, inicia sesión manualmente.");
        router.push("/login");
        return;
      }

      if (data.rol === "NUTRICIONISTA") {
        router.push("/nutricionista");
      } else {
        router.push("/paciente");
      }
    } catch {
      setError("Error al registrar. Inténtalo de nuevo.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#FDFCFA] px-4 py-8">
      <Card className="w-full max-w-lg">
        <CardHeader className="text-center space-y-4">
          <div className="flex items-center justify-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-[#2D5A3D] flex items-center justify-center">
              <span className="text-white font-bold text-lg">N</span>
            </div>
            <CardTitle className="text-2xl text-[#2D5A3D]">NutriPlan Pro</CardTitle>
          </div>
          <CardDescription>Crea tu cuenta profesional</CardDescription>
        </CardHeader>

        <form onSubmit={handleSubmit(onSubmit)}>
          <CardContent className="space-y-4">
            {error && (
              <div className="bg-destructive/10 text-destructive text-sm p-3 rounded-md">
                {error}
              </div>
            )}

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="nombre">Nombre</Label>
                <Input
                  id="nombre"
                  placeholder="Nombre"
                  {...register("nombre", { required: "El nombre es obligatorio" })}
                />
                {errors.nombre && <p className="text-destructive text-sm">{errors.nombre.message}</p>}
              </div>
              <div className="space-y-2">
                <Label htmlFor="apellidos">Apellidos</Label>
                <Input
                  id="apellidos"
                  placeholder="Apellidos"
                  {...register("apellidos", { required: "Los apellidos son obligatorios" })}
                />
                {errors.apellidos && <p className="text-destructive text-sm">{errors.apellidos.message}</p>}
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="email">Correo electrónico</Label>
              <Input
                id="email"
                type="email"
                placeholder="tu@email.com"
                {...register("email", {
                  required: "El correo electrónico es obligatorio",
                  pattern: { value: /^[^\s@]+@[^\s@]+\.[^\s@]+$/, message: "Correo electrónico inválido" },
                })}
              />
              {errors.email && <p className="text-destructive text-sm">{errors.email.message}</p>}
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="password">Contraseña</Label>
                <Input
                  id="password"
                  type="password"
                  placeholder="********"
                  {...register("password", {
                    required: "La contraseña es obligatoria",
                    minLength: { value: 6, message: "Mínimo 6 caracteres" },
                  })}
                />
                {errors.password && <p className="text-destructive text-sm">{errors.password.message}</p>}
              </div>
              <div className="space-y-2">
                <Label htmlFor="confirmPassword">Confirmar contraseña</Label>
                <Input
                  id="confirmPassword"
                  type="password"
                  placeholder="********"
                  {...register("confirmPassword", {
                    required: "Confirma tu contraseña",
                    validate: (value) => value === password || "Las contraseñas no coinciden",
                  })}
                />
                {errors.confirmPassword && <p className="text-destructive text-sm">{errors.confirmPassword.message}</p>}
              </div>
            </div>

            <div className="space-y-2">
              <Label>Tipo de cuenta</Label>
              <Select
                value={selectedRol}
                onValueChange={(value: "NUTRICIONISTA" | "PACIENTE") => setValue("rol", value)}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Selecciona tu rol" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="NUTRICIONISTA">Nutricionista</SelectItem>
                  <SelectItem value="PACIENTE">Paciente</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {selectedRol === "NUTRICIONISTA" && (
              <div className="space-y-4 border-t pt-4">
                <p className="text-sm font-medium text-muted-foreground">Datos profesionales</p>
                <div className="space-y-2">
                  <Label htmlFor="numColegiado">Número de colegiado</Label>
                  <Input id="numColegiado" placeholder="Ej: AND-1234" {...register("numColegiado")} />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="especialidad">Especialidad</Label>
                    <Input id="especialidad" placeholder="Ej: Nutrición deportiva" {...register("especialidad")} />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="clinica">Clínica</Label>
                    <Input id="clinica" placeholder="Nombre de la clínica" {...register("clinica")} />
                  </div>
                </div>
              </div>
            )}
          </CardContent>

          <CardFooter className="flex flex-col space-y-4">
            <Button type="submit" className="w-full bg-[#2D5A3D] hover:bg-[#234A31]" disabled={isLoading}>
              {isLoading ? "Registrando..." : "Crear Cuenta"}
            </Button>
            <p className="text-sm text-muted-foreground text-center">
              ¿Ya tienes cuenta?{" "}
              <Link href="/login" className="text-[#C67B4D] hover:underline font-medium">
                Inicia sesión
              </Link>
            </p>
          </CardFooter>
        </form>
      </Card>
    </div>
  );
}
