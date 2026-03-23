"use client";

import { trpc } from "@/lib/trpc/client";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { DataTable, Column } from "@/components/common/DataTable";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Eye, CalendarDays } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";

interface PacienteRow {
  id: string;
  nombre: string;
  email: string;
  telefono: string;
  activo: boolean;
  encuestaCompletada: boolean;
  planes: number;
}

export default function PacientesPage() {
  const router = useRouter();
  const { data: pacientes, isLoading } = trpc.pacientes.list.useQuery();

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <LoadingSpinner text="Cargando pacientes..." />
      </div>
    );
  }

  const rows: PacienteRow[] = (pacientes || []).map((p: any) => ({
    id: p.id,
    nombre: `${p.user.nombre} ${p.user.apellidos}`,
    email: p.user.email,
    telefono: p.user.telefono || "-",
    activo: p.activo,
    encuestaCompletada: p.encuestaCompletada,
    planes: p._count.planes,
  }));

  const columns: Column<PacienteRow>[] = [
    { key: "nombre", header: "Nombre" },
    { key: "email", header: "Email" },
    { key: "telefono", header: "Teléfono" },
    {
      key: "activo",
      header: "Estado",
      searchable: false,
      render: (item) => (
        <Badge variant={item.activo ? "default" : "secondary"} className={item.activo ? "bg-green-100 text-green-700 hover:bg-green-100" : ""}>
          {item.activo ? "Activo" : "Inactivo"}
        </Badge>
      ),
    },
    {
      key: "encuestaCompletada",
      header: "Encuesta",
      searchable: false,
      render: (item) => (
        <Badge variant={item.encuestaCompletada ? "default" : "outline"} className={item.encuestaCompletada ? "bg-blue-100 text-blue-700 hover:bg-blue-100" : "text-orange-600 border-orange-300"}>
          {item.encuestaCompletada ? "Completada" : "Pendiente"}
        </Badge>
      ),
    },
    {
      key: "planes",
      header: "Planes",
      searchable: false,
      render: (item) => <span className="font-medium">{item.planes}</span>,
    },
    {
      key: "id",
      header: "Acciones",
      searchable: false,
      render: (item) => (
        <div className="flex items-center gap-2">
          <Link href={`/nutricionista/pacientes/${item.id}`}>
            <Button variant="ghost" size="sm">
              <Eye className="h-4 w-4 mr-1" />
              Ver ficha
            </Button>
          </Link>
          <Button variant="ghost" size="sm" className="text-[#C67B4D]">
            <CalendarDays className="h-4 w-4 mr-1" />
            Crear plan
          </Button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold text-[#2D5A3D]">Pacientes</h2>
          <p className="text-sm text-muted-foreground">Gestiona tus pacientes y su seguimiento</p>
        </div>
        <Link href="/nutricionista/pacientes/nuevo">
          <Button className="bg-[#2D5A3D] hover:bg-[#234A31]">
            <Plus className="h-4 w-4 mr-2" />
            Nuevo Paciente
          </Button>
        </Link>
      </div>

      <DataTable
        columns={columns}
        data={rows}
        searchPlaceholder="Buscar por nombre o email..."
        onRowClick={(item) => router.push(`/nutricionista/pacientes/${item.id}`)}
      />
    </div>
  );
}
