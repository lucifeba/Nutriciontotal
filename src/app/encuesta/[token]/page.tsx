"use client";

import { useParams } from "next/navigation";
import { trpc } from "@/lib/trpc";
import { EncuestaWizard } from "@/components/encuesta/EncuestaWizard";
import { Card, CardContent } from "@/components/ui/card";

export default function EncuestaPage() {
  const params = useParams();
  const token = params.token as string;

  const { data, isLoading, error } = trpc.encuestas.getByToken.useQuery(
    { token },
    { enabled: !!token }
  );

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-green-50 to-blue-50 flex items-center justify-center">
        <div className="animate-pulse text-center">
          <div className="h-8 w-8 mx-auto mb-4 rounded-full border-4 border-green-500 border-t-transparent animate-spin" />
          <p className="text-muted-foreground">Cargando encuesta...</p>
        </div>
      </div>
    );
  }

  if (error || !data) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-red-50 to-orange-50 flex items-center justify-center p-4">
        <Card className="max-w-md w-full">
          <CardContent className="pt-6 text-center">
            <div className="text-5xl mb-4">&#10060;</div>
            <h2 className="text-xl font-semibold text-red-600 mb-2">
              Enlace no valido
            </h2>
            <p className="text-muted-foreground">
              El enlace de la encuesta no es valido o ha expirado. Por favor,
              contacta con tu nutricionista para obtener un nuevo enlace.
            </p>
          </CardContent>
        </Card>
      </div>
    );
  }

  if (data.completada) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-green-50 to-blue-50 flex items-center justify-center p-4">
        <Card className="max-w-md w-full">
          <CardContent className="pt-6 text-center">
            <div className="text-5xl mb-4">&#9989;</div>
            <h2 className="text-xl font-semibold text-green-600 mb-2">
              Encuesta ya completada
            </h2>
            <p className="text-muted-foreground">
              Ya has completado esta encuesta. Si necesitas modificar alguna
              respuesta, contacta con tu nutricionista.
            </p>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 to-blue-50">
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 rounded-lg bg-green-600 flex items-center justify-center text-white font-bold text-lg">
              NP
            </div>
            <div>
              <h1 className="text-xl font-bold text-green-700">
                NutriPlan Pro
              </h1>
              <p className="text-xs text-muted-foreground">
                Encuesta nutricional
              </p>
            </div>
          </div>
          <div className="text-right">
            <p className="text-sm text-muted-foreground">Hola,</p>
            <p className="font-medium">
              {data.nombre} {data.apellidos}
            </p>
          </div>
        </div>
      </header>

      <main className="max-w-4xl mx-auto px-4 py-8">
        <EncuestaWizard token={token} pacienteNombre={data.nombre} />
      </main>
    </div>
  );
}
