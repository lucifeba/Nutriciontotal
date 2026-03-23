import { DefaultSession } from "next-auth";

declare module "next-auth" {
  interface Session {
    user: {
      id: string;
      rol: "NUTRICIONISTA" | "PACIENTE";
      nutricionistaId: string | null;
      pacienteId: string | null;
    } & DefaultSession["user"];
  }
}

declare module "next-auth/jwt" {
  interface JWT {
    rol: "NUTRICIONISTA" | "PACIENTE";
    nutricionistaId: string | null;
    pacienteId: string | null;
  }
}
