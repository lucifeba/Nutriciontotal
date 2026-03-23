# NutriPlan Pro - Gestion Nutricional Profesional

Plataforma web para nutricionistas: gestion de pacientes, planes nutricionales con sistema de intercambios, anamnesis online y comunicacion directa.

## Stack

- **Frontend**: Next.js 14, React 18, Tailwind CSS, Radix UI
- **Backend**: tRPC, NextAuth.js, Prisma ORM
- **Base de datos**: PostgreSQL (Neon serverless)
- **Despliegue**: Vercel

---

## Despliegue en produccion (Vercel + Neon)

### Paso 1: Crear base de datos en Neon (gratis)

1. Ve a [neon.tech](https://neon.tech) y crea una cuenta
2. Crea un nuevo proyecto (elige region `eu-central-1` para Europa)
3. Copia las dos connection strings que te da Neon:
   - **Pooled connection** → sera tu `DATABASE_URL`
   - **Direct connection** → sera tu `DIRECT_URL`

### Paso 2: Desplegar en Vercel (gratis)

1. Ve a [vercel.com](https://vercel.com) y conecta tu cuenta de GitHub
2. Haz clic en **"Add New Project"**
3. Importa el repositorio `Nutriciontotal`
4. En la seccion **Environment Variables**, anade estas variables:

| Variable | Valor |
|---|---|
| `DATABASE_URL` | La connection string **pooled** de Neon (con `?sslmode=require&pgbouncer=true`) |
| `DIRECT_URL` | La connection string **direct** de Neon (con `?sslmode=require`) |
| `NEXTAUTH_SECRET` | Genera uno con `openssl rand -base64 32` |
| `NEXTAUTH_URL` | `https://tu-proyecto.vercel.app` |
| `NEXT_PUBLIC_APP_URL` | `https://tu-proyecto.vercel.app` |
| `NEXT_PUBLIC_APP_NAME` | `NutriPlan Pro` |

5. Haz clic en **Deploy**

### Paso 3: Crear tablas y cargar datos

Despues del primer deploy, ejecuta en tu maquina local (con las mismas variables de entorno de Neon):

```bash
# Clona el repo si no lo tienes
git clone https://github.com/lucifeba/Nutriciontotal.git
cd Nutriciontotal
npm install

# Copia y configura el .env con las credenciales de Neon
cp .env.example .env
# Edita .env con los datos de Neon

# Crea las tablas en la base de datos
npx prisma db push

# Carga los datos iniciales (alimentos, recetas, usuarios demo)
npm run db:seed
```

### Listo

Tu app esta en `https://tu-proyecto.vercel.app`. Cada vez que hagas push a GitHub, Vercel redespliega automaticamente.

---

## Credenciales de demo

| Rol | Email | Password |
|---|---|---|
| Nutricionista | `nutricionista@nutriplanpro.com` | `nutriplan123` |
| Paciente | `paciente@nutriplanpro.com` | `paciente123` |

---

## Desarrollo local

```bash
git clone https://github.com/lucifeba/Nutriciontotal.git
cd Nutriciontotal
npm install
cp .env.example .env         # editar con tus datos
npx prisma db push           # crear tablas
npm run db:seed              # cargar datos iniciales
npm run dev                  # http://localhost:3000
```

> Para desarrollo local puedes usar la misma base de datos de Neon, o una PostgreSQL local.

## Funcionalidades

- **Gestion de pacientes**: Alta, edicion, historial de mediciones
- **Encuesta nutricional**: Anamnesis completa en 8 pasos que el paciente rellena online
- **Planificador nutricional**: Planes semanales/quincenales con objetivos de macronutrientes
- **Sistema de intercambios**: Alimentos alternativos del mismo grupo nutricional
- **Base de datos de alimentos**: 81+ alimentos con informacion nutricional, alergenos y temporada
- **Recetas**: 15+ recetas de cocina espanola con ingredientes y valores por racion
- **Mensajeria**: Chat entre nutricionista y paciente
- **PDF**: Exportacion de planes nutricionales

## Scripts

| Comando | Descripcion |
|---|---|
| `npm run dev` | Servidor de desarrollo |
| `npm run build` | Build de produccion |
| `npm start` | Servidor de produccion |
| `npm run lint` | Linter |
| `npm run db:push` | Crear/actualizar tablas en la BD |
| `npm run db:seed` | Cargar datos iniciales |
| `npm run db:studio` | Prisma Studio (explorador visual) |
| `npm run db:reset` | Resetear BD y recargar datos |

## Estructura del proyecto

```
src/
├── app/                    # Rutas (Next.js App Router)
│   ├── (auth)/             # Login y registro
│   ├── (dashboard)/        # Panel nutricionista y paciente
│   ├── api/                # API (auth, tRPC, WhatsApp, PDF)
│   └── encuesta/           # Formulario de anamnesis
├── components/             # Componentes React
├── hooks/                  # Custom hooks
├── lib/                    # Utilidades, constantes, validadores
├── server/                 # tRPC routers y servicios
├── stores/                 # Estado global (Zustand)
└── types/                  # Tipos TypeScript
prisma/
├── schema.prisma           # Esquema de base de datos
├── seed.ts                 # Script de seed
└── seed/                   # Datos (alimentos, recetas)
```
