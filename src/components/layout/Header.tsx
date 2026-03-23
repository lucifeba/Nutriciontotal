"use client";

import { useState } from "react";
import { usePathname } from "next/navigation";
import { useSession, signOut } from "next-auth/react";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Menu, Bell, User, LogOut } from "lucide-react";
import Link from "next/link";

const pageTitles: Record<string, string> = {
  "/nutricionista": "Dashboard",
  "/nutricionista/pacientes": "Pacientes",
  "/nutricionista/pacientes/nuevo": "Nuevo Paciente",
  "/nutricionista/planificador": "Planificador",
  "/nutricionista/alimentos": "Base de Alimentos",
  "/nutricionista/recetas": "Recetas",
  "/nutricionista/mensajes": "Mensajes",
  "/nutricionista/configuracion": "Configuración",
  "/paciente": "Dashboard",
  "/paciente/mis-planes": "Mis Planes",
  "/paciente/mensajes": "Mensajes",
  "/paciente/perfil": "Perfil",
};

function getPageTitle(pathname: string): string {
  if (pageTitles[pathname]) return pageTitles[pathname];
  if (pathname.includes("/pacientes/") && !pathname.includes("nuevo")) return "Ficha del Paciente";
  if (pathname.includes("/mis-planes/")) return "Detalle del Plan";
  return "NutriPlan Pro";
}

interface HeaderProps {
  onToggleMobileSidebar?: () => void;
}

export function Header({ onToggleMobileSidebar }: HeaderProps) {
  const pathname = usePathname();
  const { data: session } = useSession();
  const userName = session?.user?.name || "Usuario";
  const initials = userName.split(" ").map((n) => n[0]).join("").slice(0, 2).toUpperCase();

  const pageTitle = getPageTitle(pathname);

  return (
    <header className="sticky top-0 z-30 flex items-center justify-between h-16 px-4 md:px-6 bg-[#FDFCFA] border-b">
      <div className="flex items-center gap-3">
        <Button
          variant="ghost"
          size="icon"
          className="md:hidden"
          onClick={onToggleMobileSidebar}
        >
          <Menu className="h-5 w-5" />
        </Button>
        <h1 className="text-lg font-semibold text-[#2D5A3D]">{pageTitle}</h1>
      </div>

      <div className="flex items-center gap-2">
        <Button variant="ghost" size="icon" className="relative">
          <Bell className="h-5 w-5 text-muted-foreground" />
        </Button>

        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="relative h-9 w-9 rounded-full">
              <Avatar className="h-9 w-9">
                <AvatarFallback className="bg-[#2D5A3D] text-white text-xs">
                  {initials}
                </AvatarFallback>
              </Avatar>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-48">
            <div className="px-2 py-1.5">
              <p className="text-sm font-medium">{userName}</p>
              <p className="text-xs text-muted-foreground">
                {(session?.user as any)?.rol === "NUTRICIONISTA" ? "Nutricionista" : "Paciente"}
              </p>
            </div>
            <DropdownMenuSeparator />
            <DropdownMenuItem asChild>
              <Link href={(session?.user as any)?.rol === "NUTRICIONISTA" ? "/nutricionista/configuracion" : "/paciente/perfil"}>
                <User className="mr-2 h-4 w-4" />
                Mi Perfil
              </Link>
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={() => signOut({ callbackUrl: "/login" })}>
              <LogOut className="mr-2 h-4 w-4" />
              Cerrar sesión
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}
