import { NextAuthOptions } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import { prisma } from "@/lib/prisma";
import bcrypt from "bcryptjs";

export const authOptions: NextAuthOptions = {
  providers: [
    CredentialsProvider({
      name: "credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Contraseña", type: "password" },
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          throw new Error("Credenciales requeridas");
        }

        const user = await prisma.user.findUnique({
          where: { email: credentials.email },
          include: { nutricionista: true, paciente: true },
        });

        if (!user || !user.activo) {
          throw new Error("Usuario no encontrado");
        }

        const isPasswordValid = await bcrypt.compare(credentials.password, user.password);

        if (!isPasswordValid) {
          throw new Error("Contraseña incorrecta");
        }

        return {
          id: user.id,
          email: user.email,
          name: `${user.nombre} ${user.apellidos}`,
          rol: user.rol,
          nutricionistaId: user.nutricionista?.id || null,
          pacienteId: user.paciente?.id || null,
        };
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.rol = (user as any).rol;
        token.nutricionistaId = (user as any).nutricionistaId;
        token.pacienteId = (user as any).pacienteId;
      }
      return token;
    },
    async session({ session, token }) {
      if (session.user) {
        (session.user as any).id = token.sub;
        (session.user as any).rol = token.rol;
        (session.user as any).nutricionistaId = token.nutricionistaId;
        (session.user as any).pacienteId = token.pacienteId;
      }
      return session;
    },
  },
  pages: {
    signIn: "/login",
  },
  session: {
    strategy: "jwt",
  },
  secret: process.env.NEXTAUTH_SECRET,
};
