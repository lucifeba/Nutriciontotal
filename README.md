# NutriPlan Pro - Gestion Nutricional Profesional

Plataforma web para nutricionistas que permite gestionar pacientes, crear planes nutricionales personalizados con sistema de intercambios, y mantener comunicacion directa con los pacientes.

## Tecnologias

- **Frontend**: Next.js 14 (App Router), React 18, Tailwind CSS, Radix UI
- **Backend**: tRPC, NextAuth.js, Prisma ORM
- **Base de datos**: PostgreSQL
- **Otros**: Zod, Zustand, React Hook Form, SuperJSON

## Requisitos previos

- [Node.js](https://nodejs.org/) v18 o superior
- [PostgreSQL](https://www.postgresql.org/) v14 o superior
- npm (incluido con Node.js)

## Instalacion y puesta en marcha

### 1. Clonar el repositorio

```bash
git clone https://github.com/lucifeba/Nutriciontotal.git
cd Nutriciontotal
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Configurar variables de entorno

```bash
cp .env.example .env
```

Edita el archivo `.env` con tus datos:

```env
DATABASE_URL="postgresql://usuario:contraseña@localhost:5432/nutriplan"
NEXTAUTH_SECRET="genera-una-clave-secreta-aqui"
NEXTAUTH_URL="http://localhost:3000"
```

> Para generar un secret seguro puedes usar: `openssl rand -base64 32`

### 4. Crear la base de datos

```bash
# Crear la base de datos en PostgreSQL
psql -U postgres -c "CREATE DATABASE nutriplan;"

# Aplicar el esquema
npx prisma db push

# Cargar datos iniciales (alimentos, recetas de ejemplo, usuarios demo)
npm run db:seed
```

### 5. Iniciar la aplicacion

```bash
npm run dev
```

Abre [http://localhost:3000](http://localhost:3000) en tu navegador.

## Credenciales de demo

| Rol | Email | Password |
|---|---|---|
| Nutricionista | `nutricionista@nutriplanpro.com` | `nutriplan123` |
| Paciente | `paciente@nutriplanpro.com` | `paciente123` |

## Funcionalidades

- **Gestion de pacientes**: Alta, edicion, historial de mediciones
- **Encuesta nutricional**: Anamnesis completa en 8 pasos que el paciente rellena online
- **Planificador nutricional**: Creacion de planes semanales/quincenales con objetivos de macronutrientes
- **Sistema de intercambios**: Busqueda de alimentos con alternativas del mismo grupo nutricional
- **Base de datos de alimentos**: 81+ alimentos con informacion nutricional completa, alergenos y temporada
- **Recetas**: 15+ recetas de cocina espanola con ingredientes y valores por racion
- **Mensajeria**: Chat entre nutricionista y paciente
- **Generacion de PDF**: Exportacion de planes nutricionales

## Scripts disponibles

| Comando | Descripcion |
|---|---|
| `npm run dev` | Servidor de desarrollo |
| `npm run build` | Build de produccion |
| `npm start` | Servidor de produccion |
| `npm run lint` | Linter |
| `npm run db:generate` | Generar cliente Prisma |
| `npm run db:push` | Aplicar esquema a la base de datos |
| `npm run db:seed` | Cargar datos iniciales |
| `npm run db:studio` | Abrir Prisma Studio (explorador visual de la BD) |
| `npm run db:reset` | Resetear BD y recargar datos |

## Estructura del proyecto

```
src/
├── app/                    # Rutas de Next.js (App Router)
│   ├── (auth)/             # Paginas de login y registro
│   ├── (dashboard)/        # Panel del nutricionista y paciente
│   ├── api/                # API routes (auth, tRPC, WhatsApp, PDF)
│   └── encuesta/           # Formulario de anamnesis para pacientes
├── components/             # Componentes React
│   ├── common/             # Componentes reutilizables
│   ├── encuesta/           # Wizard de encuesta nutricional
│   ├── layout/             # Header, Sidebar
│   ├── planificador/       # Planificador nutricional
│   └── ui/                 # Componentes base (Radix UI)
├── hooks/                  # Custom hooks
├── lib/                    # Utilidades, constantes, validadores
├── server/                 # Logica de servidor (tRPC routers, servicios)
├── stores/                 # Estado global (Zustand)
└── types/                  # Definiciones de tipos TypeScript
prisma/
├── schema.prisma           # Esquema de base de datos
├── seed.ts                 # Script de seed principal
└── seed/                   # Datos de seed (alimentos, recetas)
```

## Docker (opcional)

```bash
docker-compose up -d
```

Esto levanta PostgreSQL y la aplicacion en `http://localhost:3000`.
