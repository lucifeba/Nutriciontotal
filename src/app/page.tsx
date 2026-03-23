import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function Home() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-[#FDFCFA]">
      <div className="text-center space-y-8 max-w-lg px-6">
        <div className="space-y-4">
          <div className="flex items-center justify-center gap-3">
            <div className="w-12 h-12 rounded-xl bg-[#2D5A3D] flex items-center justify-center">
              <span className="text-white font-bold text-xl">N</span>
            </div>
            <h1 className="text-4xl font-bold text-[#2D5A3D]">NutriPlan Pro</h1>
          </div>
          <p className="text-lg text-muted-foreground">
            Plataforma profesional de gestión nutricional
          </p>
        </div>

        <p className="text-muted-foreground leading-relaxed">
          Gestiona tus pacientes, crea planes nutricionales personalizados y
          realiza un seguimiento completo de su evolución desde una única plataforma.
        </p>

        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Link href="/login">
            <Button size="lg" className="bg-[#2D5A3D] hover:bg-[#234A31] text-white px-8">
              Iniciar Sesión
            </Button>
          </Link>
          <Link href="/registro">
            <Button size="lg" variant="outline" className="border-[#2D5A3D] text-[#2D5A3D] hover:bg-[#2D5A3D]/5 px-8">
              Registrarse
            </Button>
          </Link>
        </div>

        <p className="text-xs text-muted-foreground pt-4">
          Diseñado para nutricionistas y dietistas profesionales
        </p>
      </div>
    </div>
  );
}
