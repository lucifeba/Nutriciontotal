import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import bcrypt from "bcryptjs";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { nombre, apellidos, email, password, rol, numColegiado, especialidad, clinica } = body;

    if (!nombre || !apellidos || !email || !password || !rol) {
      return NextResponse.json(
        { error: "Todos los campos obligatorios deben estar completos" },
        { status: 400 }
      );
    }

    if (password.length < 6) {
      return NextResponse.json(
        { error: "La contraseña debe tener al menos 6 caracteres" },
        { status: 400 }
      );
    }

    if (!["NUTRICIONISTA", "PACIENTE"].includes(rol)) {
      return NextResponse.json(
        { error: "Rol inválido" },
        { status: 400 }
      );
    }

    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      return NextResponse.json(
        { error: "Ya existe un usuario con este correo electrónico" },
        { status: 409 }
      );
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        nombre,
        apellidos,
        rol,
        ...(rol === "NUTRICIONISTA" && {
          nutricionista: {
            create: {
              numColegiado: numColegiado || null,
              especialidad: especialidad || null,
              clinica: clinica || null,
            },
          },
        }),
      },
      include: {
        nutricionista: true,
      },
    });

    const { password: _, ...userWithoutPassword } = user;

    return NextResponse.json(userWithoutPassword, { status: 201 });
  } catch (error) {
    console.error("Error en registro:", error);
    return NextResponse.json(
      { error: "Error interno del servidor" },
      { status: 500 }
    );
  }
}
