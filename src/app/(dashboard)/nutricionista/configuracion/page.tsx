"use client";

import { useState, useRef } from "react";
import { trpc } from "@/lib/trpc/client";
import { useSession } from "next-auth/react";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useToast } from "@/components/ui/use-toast";
import { User, Building, Upload, FileText, Download, Check, AlertCircle } from "lucide-react";

export default function ConfiguracionPage() {
  const { data: session, update: updateSession } = useSession();
  const { toast } = useToast();
  const user = session?.user as any;

  const { data: perfil, isLoading, refetch } = trpc.perfil.get.useQuery();

  // Profile form state
  const [nombre, setNombre] = useState("");
  const [apellidos, setApellidos] = useState("");
  const [telefono, setTelefono] = useState("");
  const [numColegiado, setNumColegiado] = useState("");
  const [especialidad, setEspecialidad] = useState("");
  const [clinica, setClinica] = useState("");
  const [direccion, setDireccion] = useState("");
  const [bio, setBio] = useState("");
  const [profileLoaded, setProfileLoaded] = useState(false);

  // Load profile data into form
  if (perfil && !profileLoaded) {
    setNombre(perfil.nombre || "");
    setApellidos(perfil.apellidos || "");
    setTelefono(perfil.telefono || "");
    setNumColegiado(perfil.nutricionista?.numColegiado || "");
    setEspecialidad(perfil.nutricionista?.especialidad || "");
    setClinica(perfil.nutricionista?.clinica || "");
    setDireccion(perfil.nutricionista?.direccion || "");
    setBio(perfil.nutricionista?.bio || "");
    setProfileLoaded(true);
  }

  // Bulk upload state
  const [uploadResult, setUploadResult] = useState<{ created: number; errors: string[]; total: number } | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const updateUserMutation = trpc.perfil.updateUser.useMutation({
    onSuccess: () => {
      toast({ title: "Datos personales actualizados" });
      refetch();
      updateSession();
    },
    onError: (e) => toast({ title: "Error", description: e.message, variant: "destructive" }),
  });

  const updateNutriMutation = trpc.perfil.updateNutricionista.useMutation({
    onSuccess: () => {
      toast({ title: "Datos profesionales actualizados" });
      refetch();
    },
    onError: (e) => toast({ title: "Error", description: e.message, variant: "destructive" }),
  });

  const bulkAlimentosMutation = trpc.perfil.bulkUploadAlimentos.useMutation({
    onSuccess: (data) => {
      setUploadResult(data);
      toast({ title: `${data.created} alimentos importados de ${data.total}` });
    },
    onError: (e) => toast({ title: "Error en importación", description: e.message, variant: "destructive" }),
  });

  const bulkRecetasMutation = trpc.perfil.bulkUploadRecetas.useMutation({
    onSuccess: (data) => {
      setUploadResult(data);
      toast({ title: `${data.created} recetas importadas de ${data.total}` });
    },
    onError: (e) => toast({ title: "Error en importación", description: e.message, variant: "destructive" }),
  });

  const handleSavePersonal = () => {
    updateUserMutation.mutate({ nombre, apellidos, telefono });
  };

  const handleSaveProfesional = () => {
    updateNutriMutation.mutate({ numColegiado, especialidad, clinica, direccion, bio });
  };

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>, type: "alimentos" | "recetas") => {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (ev) => {
      try {
        const text = ev.target?.result as string;
        const data = JSON.parse(text);

        if (!Array.isArray(data)) {
          toast({ title: "Error", description: "El archivo debe contener un array JSON", variant: "destructive" });
          return;
        }

        if (type === "alimentos") {
          bulkAlimentosMutation.mutate(data);
        } else {
          bulkRecetasMutation.mutate(data);
        }
      } catch {
        toast({ title: "Error", description: "El archivo no es JSON válido", variant: "destructive" });
      }
    };
    reader.readAsText(file);
    e.target.value = "";
  };

  const downloadTemplate = (type: "alimentos" | "recetas") => {
    let template: any;
    if (type === "alimentos") {
      template = [
        {
          nombre: "Ejemplo: Leche de cabra",
          grupoIntercambio: "LACTEOS",
          subgrupo: "Leche",
          calorias: 69,
          proteinas: 3.6,
          carbohidratos: 4.5,
          grasas: 4.1,
          fibra: 0,
          racionIntercambio: 200,
          descripcionRacion: "1 vaso",
          esAptoVegetariano: true,
          esAptoVegano: false,
          contieneLactosa: true,
          contieneGluten: false,
          contieneFrutosSecos: false,
          contieneHuevo: false,
          contienePescado: false,
          contieneMarisco: false,
          contieneSoja: false,
        },
      ];
    } else {
      template = [
        {
          nombre: "Ejemplo: Ensalada de tomate",
          descripcion: "Ensalada sencilla de tomate con aceite de oliva",
          instrucciones: "1. Cortar los tomates en rodajas.\n2. Aliñar con aceite, sal y orégano.",
          tiempoPreparacion: 10,
          tiempoCoccion: 0,
          dificultad: "facil",
          raciones: 2,
          tipoComida: ["ALMUERZO", "CENA"],
          categoria: "Ensaladas",
          caloriasPorRacion: 80,
          proteinasPorRacion: 1,
          carbohidratosPorRacion: 4,
          grasasPorRacion: 7,
          ingredientes: [
            { alimentoNombre: "Tomate", cantidad: 300, unidad: "g" },
            { alimentoNombre: "Aceite de oliva virgen extra", cantidad: 20, unidad: "ml" },
          ],
        },
      ];
    }

    const blob = new Blob([JSON.stringify(template, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `plantilla-${type}.json`;
    a.click();
    URL.revokeObjectURL(url);
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <LoadingSpinner text="Cargando perfil..." />
      </div>
    );
  }

  return (
    <div className="space-y-6 max-w-3xl">
      <div>
        <h2 className="text-xl font-bold text-[#2D5A3D]">Configuración</h2>
        <p className="text-sm text-muted-foreground">Gestiona tu perfil y datos</p>
      </div>

      <Tabs defaultValue="perfil" className="space-y-4">
        <TabsList>
          <TabsTrigger value="perfil">Perfil</TabsTrigger>
          <TabsTrigger value="importar">Importar datos</TabsTrigger>
        </TabsList>

        {/* ==================== PERFIL TAB ==================== */}
        <TabsContent value="perfil" className="space-y-6">
          {/* Personal data */}
          <Card className="p-6 space-y-4">
            <h3 className="font-semibold flex items-center gap-2">
              <User className="h-4 w-4" />
              Datos personales
            </h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <Label htmlFor="nombre">Nombre</Label>
                <Input id="nombre" value={nombre} onChange={(e) => setNombre(e.target.value)} />
              </div>
              <div>
                <Label htmlFor="apellidos">Apellidos</Label>
                <Input id="apellidos" value={apellidos} onChange={(e) => setApellidos(e.target.value)} />
              </div>
              <div>
                <Label htmlFor="email">Email</Label>
                <Input id="email" value={perfil?.email || ""} disabled className="bg-gray-50" />
              </div>
              <div>
                <Label htmlFor="telefono">Teléfono</Label>
                <Input id="telefono" value={telefono} onChange={(e) => setTelefono(e.target.value)} placeholder="+34..." />
              </div>
            </div>
            <Button
              onClick={handleSavePersonal}
              disabled={updateUserMutation.isPending}
              className="bg-[#2D5A3D] hover:bg-[#234A31]"
            >
              {updateUserMutation.isPending ? "Guardando..." : "Guardar datos personales"}
            </Button>
          </Card>

          {/* Professional data */}
          <Card className="p-6 space-y-4">
            <h3 className="font-semibold flex items-center gap-2">
              <Building className="h-4 w-4" />
              Datos profesionales
            </h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <Label htmlFor="numColegiado">N.º Colegiado</Label>
                <Input id="numColegiado" value={numColegiado} onChange={(e) => setNumColegiado(e.target.value)} placeholder="MAD-1234" />
              </div>
              <div>
                <Label htmlFor="especialidad">Especialidad</Label>
                <Input id="especialidad" value={especialidad} onChange={(e) => setEspecialidad(e.target.value)} placeholder="Nutrición clínica..." />
              </div>
              <div>
                <Label htmlFor="clinica">Clínica</Label>
                <Input id="clinica" value={clinica} onChange={(e) => setClinica(e.target.value)} placeholder="Nombre de la clínica" />
              </div>
              <div>
                <Label htmlFor="direccion">Dirección</Label>
                <Input id="direccion" value={direccion} onChange={(e) => setDireccion(e.target.value)} placeholder="Calle..." />
              </div>
            </div>
            <div>
              <Label htmlFor="bio">Biografía</Label>
              <Textarea
                id="bio"
                value={bio}
                onChange={(e) => setBio(e.target.value)}
                placeholder="Descripción profesional..."
                rows={3}
              />
            </div>
            <Button
              onClick={handleSaveProfesional}
              disabled={updateNutriMutation.isPending}
              className="bg-[#2D5A3D] hover:bg-[#234A31]"
            >
              {updateNutriMutation.isPending ? "Guardando..." : "Guardar datos profesionales"}
            </Button>
          </Card>
        </TabsContent>

        {/* ==================== IMPORTAR TAB ==================== */}
        <TabsContent value="importar" className="space-y-6">
          {/* Alimentos upload */}
          <Card className="p-6 space-y-4">
            <h3 className="font-semibold flex items-center gap-2">
              <Upload className="h-4 w-4" />
              Importar alimentos
            </h3>
            <p className="text-sm text-muted-foreground">
              Sube un archivo JSON con los alimentos que quieras añadir a la base de datos.
              Descarga la plantilla para ver el formato correcto.
            </p>
            <div className="flex flex-wrap gap-3">
              <Button variant="outline" onClick={() => downloadTemplate("alimentos")}>
                <Download className="h-4 w-4 mr-2" />
                Descargar plantilla alimentos
              </Button>
              <div>
                <input
                  type="file"
                  accept=".json"
                  ref={fileInputRef}
                  className="hidden"
                  onChange={(e) => handleFileUpload(e, "alimentos")}
                />
                <Button
                  onClick={() => fileInputRef.current?.click()}
                  disabled={bulkAlimentosMutation.isPending}
                  className="bg-[#2D5A3D] hover:bg-[#234A31]"
                >
                  <Upload className="h-4 w-4 mr-2" />
                  {bulkAlimentosMutation.isPending ? "Importando..." : "Subir alimentos (.json)"}
                </Button>
              </div>
            </div>

            {/* Grupos reference */}
            <div className="bg-gray-50 rounded-lg p-3">
              <p className="text-xs font-medium mb-2">Grupos de intercambio válidos:</p>
              <div className="flex flex-wrap gap-1">
                {["LACTEOS", "FRUTAS", "VERDURAS_HORTALIZAS", "CEREALES_TUBERCULOS", "LEGUMBRES", "CARNES_PESCADOS_HUEVOS", "GRASAS", "AZUCARES", "BEBIDAS", "FRUTOS_SECOS", "CONDIMENTOS"].map((g) => (
                  <Badge key={g} variant="outline" className="text-[10px]">{g}</Badge>
                ))}
              </div>
            </div>
          </Card>

          {/* Recetas upload */}
          <Card className="p-6 space-y-4">
            <h3 className="font-semibold flex items-center gap-2">
              <FileText className="h-4 w-4" />
              Importar recetas
            </h3>
            <p className="text-sm text-muted-foreground">
              Sube un archivo JSON con las recetas. Los ingredientes se vinculan automáticamente
              con los alimentos existentes en la base de datos por nombre.
            </p>
            <div className="flex flex-wrap gap-3">
              <Button variant="outline" onClick={() => downloadTemplate("recetas")}>
                <Download className="h-4 w-4 mr-2" />
                Descargar plantilla recetas
              </Button>
              <div>
                <input
                  type="file"
                  accept=".json"
                  className="hidden"
                  id="recetas-upload"
                  onChange={(e) => handleFileUpload(e, "recetas")}
                />
                <Button
                  onClick={() => document.getElementById("recetas-upload")?.click()}
                  disabled={bulkRecetasMutation.isPending}
                  className="bg-[#2D5A3D] hover:bg-[#234A31]"
                >
                  <Upload className="h-4 w-4 mr-2" />
                  {bulkRecetasMutation.isPending ? "Importando..." : "Subir recetas (.json)"}
                </Button>
              </div>
            </div>

            {/* Tipo comida reference */}
            <div className="bg-gray-50 rounded-lg p-3">
              <p className="text-xs font-medium mb-2">Tipos de comida válidos (para tipoComida):</p>
              <div className="flex flex-wrap gap-1">
                {["DESAYUNO", "MEDIA_MANANA", "ALMUERZO", "MERIENDA", "CENA", "RECENA"].map((t) => (
                  <Badge key={t} variant="outline" className="text-[10px]">{t}</Badge>
                ))}
              </div>
            </div>
          </Card>

          {/* Upload result */}
          {uploadResult && (
            <Card className="p-4">
              <div className="flex items-center gap-2 mb-2">
                {uploadResult.errors.length === 0 ? (
                  <Check className="h-5 w-5 text-green-600" />
                ) : (
                  <AlertCircle className="h-5 w-5 text-orange-500" />
                )}
                <span className="font-medium">
                  {uploadResult.created} de {uploadResult.total} importados correctamente
                </span>
              </div>
              {uploadResult.errors.length > 0 && (
                <div className="bg-red-50 rounded p-3 mt-2">
                  <p className="text-xs font-medium text-red-700 mb-1">Errores:</p>
                  <ul className="text-xs text-red-600 space-y-1">
                    {uploadResult.errors.map((err, i) => (
                      <li key={i}>{err}</li>
                    ))}
                  </ul>
                </div>
              )}
            </Card>
          )}
        </TabsContent>
      </Tabs>
    </div>
  );
}
