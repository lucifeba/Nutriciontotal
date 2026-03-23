"use client";

import { useSession } from "next-auth/react";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { Sidebar } from "@/components/layout/Sidebar";
import { Header } from "@/components/layout/Header";
import { LoadingSpinner } from "@/components/common/LoadingSpinner";
import { cn } from "@/lib/utils";
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
  X,
} from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { signOut } from "next-auth/react";

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

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const { data: session, status } = useSession();
  const router = useRouter();
  const pathname = usePathname();
  const [mobileSidebarOpen, setMobileSidebarOpen] = useState(false);

  useEffect(() => {
    if (status === "unauthenticated") {
      router.push("/login");
    }
  }, [status, router]);

  useEffect(() => {
    setMobileSidebarOpen(false);
  }, [pathname]);

  if (status === "loading") {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#FDFCFA]">
        <LoadingSpinner text="Cargando..." />
      </div>
    );
  }

  if (!session) {
    return null;
  }

  const rol = (session.user as any)?.rol;
  const navItems = rol === "NUTRICIONISTA" ? nutricionistaNav : pacienteNav;

  return (
    <div className="flex min-h-screen bg-[#FDFCFA]">
      {/* Desktop Sidebar */}
      <Sidebar />

      {/* Mobile Sidebar Overlay */}
      {mobileSidebarOpen && (
        <div className="fixed inset-0 z-50 md:hidden">
          <div
            className="absolute inset-0 bg-black/50"
            onClick={() => setMobileSidebarOpen(false)}
          />
          <aside className="relative w-[260px] h-full bg-[#2D5A3D] text-white flex flex-col">
            <div className="flex items-center justify-between p-4 border-b border-white/10">
              <div className="flex items-center gap-2">
                <div className="w-9 h-9 rounded-lg bg-white/20 flex items-center justify-center">
                  <span className="font-bold text-sm">N</span>
                </div>
                <span className="font-bold text-lg">NutriPlan Pro</span>
              </div>
              <button onClick={() => setMobileSidebarOpen(false)}>
                <X className="h-5 w-5 text-white/70" />
              </button>
            </div>
            <nav className="flex-1 py-4 px-2 space-y-1">
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
                    <Icon className="h-5 w-5" />
                    <span>{item.label}</span>
                  </Link>
                );
              })}
            </nav>
            <div className="border-t border-white/10 p-3">
              <div className="mb-3 px-2">
                <p className="text-sm font-medium truncate">{session.user?.name}</p>
                <p className="text-xs text-white/60">
                  {rol === "NUTRICIONISTA" ? "Nutricionista" : "Paciente"}
                </p>
              </div>
              <button
                className="flex items-center gap-3 w-full px-3 py-2 text-sm text-white/70 hover:text-white hover:bg-white/10 rounded-lg"
                onClick={() => signOut({ callbackUrl: "/login" })}
              >
                <LogOut className="h-5 w-5" />
                <span>Cerrar sesión</span>
              </button>
            </div>
          </aside>
        </div>
      )}

      {/* Main Content */}
      <div className="flex-1 flex flex-col min-w-0">
        <Header onToggleMobileSidebar={() => setMobileSidebarOpen(true)} />
        <main className="flex-1 p-4 md:p-6">{children}</main>
      </div>
    </div>
  );
}
