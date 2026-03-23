"use client";

import { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useSession, signOut } from "next-auth/react";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import {
  LayoutDashboard,
  Users,
  CalendarDays,
  Apple,
  UtensilsCrossed,
  MessageSquare,
  Settings,
  FileText,
  User,
  LogOut,
  ChevronLeft,
  ChevronRight,
} from "lucide-react";

const nutricionistaNav = [
  { href: "/nutricionista", label: "Dashboard", icon: LayoutDashboard },
  { href: "/nutricionista/pacientes", label: "Pacientes", icon: Users },
  { href: "/nutricionista/planificador", label: "Planificador", icon: CalendarDays },
  { href: "/nutricionista/alimentos", label: "Alimentos", icon: Apple },
  { href: "/nutricionista/recetas", label: "Recetas", icon: UtensilsCrossed },
  { href: "/nutricionista/mensajes", label: "Mensajes", icon: MessageSquare },
  { href: "/nutricionista/configuracion", label: "Configuración", icon: Settings },
];

const pacienteNav = [
  { href: "/paciente", label: "Dashboard", icon: LayoutDashboard },
  { href: "/paciente/mis-planes", label: "Mis Planes", icon: FileText },
  { href: "/paciente/mensajes", label: "Mensajes", icon: MessageSquare },
  { href: "/paciente/perfil", label: "Perfil", icon: User },
];

export function Sidebar() {
  const [collapsed, setCollapsed] = useState(false);
  const pathname = usePathname();
  const { data: session } = useSession();

  const rol = (session?.user as any)?.rol;
  const navItems = rol === "NUTRICIONISTA" ? nutricionistaNav : pacienteNav;
  const userName = session?.user?.name || "Usuario";

  return (
    <aside
      className={cn(
        "hidden md:flex flex-col h-screen bg-[#2D5A3D] text-white transition-all duration-300 sticky top-0",
        collapsed ? "w-[70px]" : "w-[260px]"
      )}
    >
      {/* Logo */}
      <div className="flex items-center gap-2 p-4 border-b border-white/10">
        <div className="w-9 h-9 rounded-lg bg-white/20 flex items-center justify-center flex-shrink-0">
          <span className="font-bold text-sm">N</span>
        </div>
        {!collapsed && <span className="font-bold text-lg">NutriPlan Pro</span>}
      </div>

      {/* Navigation */}
      <nav className="flex-1 py-4 px-2 space-y-1 overflow-y-auto">
        {navItems.map((item) => {
          const isActive = pathname === item.href || pathname.startsWith(item.href + "/");
          const Icon = item.icon;
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm transition-colors",
                isActive
                  ? "bg-white/20 text-white font-medium"
                  : "text-white/70 hover:text-white hover:bg-white/10"
              )}
            >
              <Icon className="h-5 w-5 flex-shrink-0" />
              {!collapsed && <span>{item.label}</span>}
            </Link>
          );
        })}
      </nav>

      {/* User info and logout */}
      <div className="border-t border-white/10 p-3">
        {!collapsed && (
          <div className="mb-3 px-2">
            <p className="text-sm font-medium truncate">{userName}</p>
            <p className="text-xs text-white/60">
              {rol === "NUTRICIONISTA" ? "Nutricionista" : "Paciente"}
            </p>
          </div>
        )}
        <Button
          variant="ghost"
          className="w-full justify-start text-white/70 hover:text-white hover:bg-white/10"
          onClick={() => signOut({ callbackUrl: "/login" })}
        >
          <LogOut className="h-5 w-5 flex-shrink-0" />
          {!collapsed && <span className="ml-3">Cerrar sesión</span>}
        </Button>
      </div>

      {/* Collapse toggle */}
      <button
        onClick={() => setCollapsed(!collapsed)}
        className="absolute -right-3 top-20 w-6 h-6 rounded-full bg-[#2D5A3D] border-2 border-white/20 flex items-center justify-center text-white hover:bg-[#234A31] transition-colors"
      >
        {collapsed ? <ChevronRight className="h-3 w-3" /> : <ChevronLeft className="h-3 w-3" />}
      </button>
    </aside>
  );
}
