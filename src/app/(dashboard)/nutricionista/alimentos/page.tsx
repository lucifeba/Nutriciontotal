"use client";

import { useState } from "react";
import { trpc } from "@/lib/trpc/client";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Search, Apple, ChevronLeft, ChevronRight } from "lucide-react";

const GRUPOS = [
  { value: "", label: "Todos" },
  { value: "LACTEOS", label: "Lácteos" },
  { value: "FRUTAS", label: "Frutas" },
  { value: "VERDURAS_HORTALIZAS", label: "Verduras" },
  { value: "CEREALES_TUBERCULOS", label: "Cereales" },
  { value: "LEGUMBRES", label: "Legumbres" },
  { value: "CARNES_PESCADOS_HUEVOS", label: "Carnes/Pescados" },
  { value: "GRASAS", label: "Grasas" },
  { value: "FRUTOS_SECOS", label: "Frutos secos" },
];

const grupoLabel: Record<string, string> = {
  LACTEOS: "Lácteos",
  FRUTAS: "Frutas",
  VERDURAS_HORTALIZAS: "Verduras",
  CEREALES_TUBERCULOS: "Cereales",
  LEGUMBRES: "Legumbres",
  CARNES_PESCADOS_HUEVOS: "Carnes/Pescados",
  GRASAS: "Grasas",
  AZUCARES: "Azúcares",
  BEBIDAS: "Bebidas",
  FRUTOS_SECOS: "Frutos secos",
  CONDIMENTOS: "Condimentos",
};

export default function AlimentosPage() {
  const [search, setSearch] = useState("");
  const [grupo, setGrupo] = useState("");
  const [page, setPage] = useState(1);

  const { data, isLoading } = trpc.alimentos.list.useQuery({
    search: search || undefined,
    grupo: grupo || undefined,
    page,
    limit: 20,
  });

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-bold text-[#2D5A3D]">Base de Alimentos</h2>
        <p className="text-sm text-muted-foreground">
          {data?.total || 0} alimentos en la base de datos
        </p>
      </div>

      {/* Filters */}
      <div className="flex flex-col sm:flex-row gap-3">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Buscar alimento..."
            value={search}
            onChange={(e) => { setSearch(e.target.value); setPage(1); }}
            className="pl-9"
          />
        </div>
        <div className="flex flex-wrap gap-2">
          {GRUPOS.map((g) => (
            <Button
              key={g.value}
              variant={grupo === g.value ? "default" : "outline"}
              size="sm"
              onClick={() => { setGrupo(g.value); setPage(1); }}
              className={grupo === g.value ? "bg-[#2D5A3D] hover:bg-[#234A31]" : ""}
            >
              {g.label}
            </Button>
          ))}
        </div>
      </div>

      {/* Table */}
      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <LoadingSpinner text="Cargando alimentos..." />
        </div>
      ) : (
        <>
          <div className="rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Nombre</TableHead>
                  <TableHead>Grupo</TableHead>
                  <TableHead className="text-right">Calorías</TableHead>
                  <TableHead className="text-right">Proteínas</TableHead>
                  <TableHead className="text-right">Carbos</TableHead>
                  <TableHead className="text-right">Grasas</TableHead>
                  <TableHead>Ración</TableHead>
                  <TableHead>Alérgenos</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {(data?.alimentos || []).length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={8} className="text-center py-8 text-muted-foreground">
                      No se encontraron alimentos
                    </TableCell>
                  </TableRow>
                ) : (
                  (data?.alimentos || []).map((a: any) => (
                    <TableRow key={a.id}>
                      <TableCell className="font-medium">{a.nombre}</TableCell>
                      <TableCell>
                        <Badge variant="outline" className="text-xs">
                          {grupoLabel[a.grupoIntercambio] || a.grupoIntercambio}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-right">{a.calorias}</TableCell>
                      <TableCell className="text-right">{a.proteinas}g</TableCell>
                      <TableCell className="text-right">{a.carbohidratos}g</TableCell>
                      <TableCell className="text-right">{a.grasas}g</TableCell>
                      <TableCell className="text-xs text-muted-foreground">
                        {a.racionIntercambio}g - {a.descripcionRacion}
                      </TableCell>
                      <TableCell>
                        <div className="flex gap-1 flex-wrap">
                          {a.contieneGluten && <Badge variant="destructive" className="text-[10px] px-1">Gluten</Badge>}
                          {a.contieneLactosa && <Badge variant="destructive" className="text-[10px] px-1">Lactosa</Badge>}
                          {a.contieneFrutosSecos && <Badge variant="destructive" className="text-[10px] px-1">F.Secos</Badge>}
                          {a.contieneHuevo && <Badge variant="destructive" className="text-[10px] px-1">Huevo</Badge>}
                          {a.contienePescado && <Badge variant="destructive" className="text-[10px] px-1">Pescado</Badge>}
                          {a.contieneMarisco && <Badge variant="destructive" className="text-[10px] px-1">Marisco</Badge>}
                        </div>
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>

          {/* Pagination */}
          {(data?.pages || 1) > 1 && (
            <div className="flex items-center justify-between">
              <p className="text-sm text-muted-foreground">
                Página {page} de {data?.pages}
              </p>
              <div className="flex items-center gap-2">
                <Button variant="outline" size="sm" onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page === 1}>
                  <ChevronLeft className="h-4 w-4" />
                </Button>
                <Button variant="outline" size="sm" onClick={() => setPage((p) => Math.min(data?.pages || 1, p + 1))} disabled={page === (data?.pages || 1)}>
                  <ChevronRight className="h-4 w-4" />
                </Button>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  );
}
