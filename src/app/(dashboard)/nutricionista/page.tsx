"use client";

import { useSession } from "next-auth/react";
import { trpc } from "@/lib/trpc/client";
import { StatsCard } from "@/components/common/StatsCard";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Users, UserCheck, FileText, ClipboardList, Plus } from "lucide-react";
import Link from "next/link";

export default function NutricionistaDashboard() {
  const { data: session } = useSession();
  const stats = trpc.pacientes.stats.useQuery();
  const pacientes = trpc.pacientes.list.useQuery();

  if (stats.isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <LoadingSpinner text="Cargando dashboard..." />
      </div>
    );
  }

  const recentPacientes = pacientes.data?.slice(0, 5) || [];

  return (
    <div className="space-y-6">
      {/* Welcome */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold text-[#2D5A3D]">
            Bienvenido/a, {session?.user?.name?.split(" ")[0]}
          </h2>
          <p className="text-muted-foreground">Aquí tienes un resumen de tu actividad</p>
        </div>
        <Link href="/nutricionista/pacientes/nuevo">
          <Button className="bg-[#2D5A3D] hover:bg-[#234A31]">
            <Plus className="h-4 w-4 mr-2" />
            Nuevo Paciente
          </Button>
        </Link>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatsCard
          icon={Users}
          title="Total Pacientes"
          value={stats.data?.totalPacientes ?? 0}
          description="Pacientes registrados"
        />
        <StatsCard
          icon={UserCheck}
          title="Pacientes Activos"
          value={stats.data?.pacientesActivos ?? 0}
          description="Con seguimiento activo"
        />
        <StatsCard
          icon={FileText}
          title="Planes Activos"
          value={stats.data?.planesActivos ?? 0}
          description="Planes en curso"
        />
        <StatsCard
          icon={ClipboardList}
          title="Encuestas Pendientes"
          value={stats.data?.encuestasPendientes ?? 0}
          description="Anamnesis por completar"
        />
      </div>

      {/* Recent Patients & Plans */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Últimos pacientes */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="text-lg">Últimos pacientes</CardTitle>
            <Link href="/nutricionista/pacientes">
              <Button variant="ghost" size="sm" className="text-[#C67B4D]">
                Ver todos
              </Button>
            </Link>
          </CardHeader>
          <CardContent>
            {recentPacientes.length === 0 ? (
              <p className="text-muted-foreground text-sm py-4 text-center">
                No tienes pacientes registrados aún
              </p>
            ) : (
              <div className="space-y-3">
                {recentPacientes.map((paciente: any) => (
                  <Link
                    key={paciente.id}
                    href={`/nutricionista/pacientes/${paciente.id}`}
                    className="flex items-center justify-between p-3 rounded-lg hover:bg-muted/50 transition-colors"
                  >
                    <div>
                      <p className="font-medium text-sm">
                        {paciente.user.nombre} {paciente.user.apellidos}
                      </p>
                      <p className="text-xs text-muted-foreground">{paciente.user.email}</p>
                    </div>
                    <div className="flex items-center gap-2">
                      <span
                        className={`text-xs px-2 py-1 rounded-full ${
                          paciente.activo
                            ? "bg-green-100 text-green-700"
                            : "bg-gray-100 text-gray-600"
                        }`}
                      >
                        {paciente.activo ? "Activo" : "Inactivo"}
                      </span>
                      <span className="text-xs text-muted-foreground">
                        {paciente._count.planes} planes
                      </span>
                    </div>
                  </Link>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Planes recientes */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="text-lg">Planes recientes</CardTitle>
            <Link href="/nutricionista/planificador">
              <Button variant="ghost" size="sm" className="text-[#C67B4D]">
                Ver todos
              </Button>
            </Link>
          </CardHeader>
          <CardContent>
            {recentPacientes.length === 0 ? (
              <p className="text-muted-foreground text-sm py-4 text-center">
                No hay planes creados aún
              </p>
            ) : (
              <div className="space-y-3">
                {recentPacientes
                  .filter((p: any) => p._count.planes > 0)
                  .slice(0, 5)
                  .map((paciente: any) => (
                    <div
                      key={paciente.id}
                      className="flex items-center justify-between p-3 rounded-lg hover:bg-muted/50 transition-colors"
                    >
                      <div>
                        <p className="font-medium text-sm">
                          Plan de {paciente.user.nombre} {paciente.user.apellidos}
                        </p>
                        <p className="text-xs text-muted-foreground">
                          {paciente._count.planes} plan(es) asignados
                        </p>
                      </div>
                      <Link href={`/nutricionista/pacientes/${paciente.id}`}>
                        <Button variant="outline" size="sm">
                          Ver
                        </Button>
                      </Link>
                    </div>
                  ))}
                {recentPacientes.filter((p: any) => p._count.planes > 0).length === 0 && (
                  <p className="text-muted-foreground text-sm py-4 text-center">
                    No hay planes creados aún
                  </p>
                )}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
