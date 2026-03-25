-- ============================================================
-- NutriPlan Pro – Complete setup for Neon PostgreSQL
-- Generated: 2026-03-25T09:22:41.305Z
-- ============================================================

-- ============================================================
-- 1. SCHEMA
-- ============================================================

-- CreateEnum
CREATE TYPE "Rol" AS ENUM ('NUTRICIONISTA', 'PACIENTE');

-- CreateEnum
CREATE TYPE "Sexo" AS ENUM ('MASCULINO', 'FEMENINO', 'OTRO');

-- CreateEnum
CREATE TYPE "GrupoIntercambio" AS ENUM ('LACTEOS', 'FRUTAS', 'VERDURAS_HORTALIZAS', 'CEREALES_TUBERCULOS', 'LEGUMBRES', 'CARNES_PESCADOS_HUEVOS', 'GRASAS', 'AZUCARES', 'BEBIDAS', 'FRUTOS_SECOS', 'CONDIMENTOS');

-- CreateEnum
CREATE TYPE "EstadoPlan" AS ENUM ('BORRADOR', 'ACTIVO', 'COMPLETADO', 'CANCELADO');

-- CreateEnum
CREATE TYPE "TipoPlan" AS ENUM ('SEMANAL', 'QUINCENAL');

-- CreateEnum
CREATE TYPE "TipoComida" AS ENUM ('DESAYUNO', 'MEDIA_MANANA', 'ALMUERZO', 'MERIENDA', 'CENA', 'RECENA');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "apellidos" TEXT NOT NULL,
    "rol" "Rol" NOT NULL,
    "avatar" TEXT,
    "telefono" TEXT,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Nutricionista" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "numColegiado" TEXT,
    "especialidad" TEXT,
    "clinica" TEXT,
    "direccion" TEXT,
    "whatsappNumber" TEXT DEFAULT '+34676002647',
    "bio" TEXT,

    CONSTRAINT "Nutricionista_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Paciente" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "nutricionistaId" TEXT NOT NULL,
    "fechaNacimiento" TIMESTAMP(3),
    "sexo" "Sexo",
    "altura" DOUBLE PRECISION,
    "pesoActual" DOUBLE PRECISION,
    "pesoObjetivo" DOUBLE PRECISION,
    "imc" DOUBLE PRECISION,
    "porcentajeGrasa" DOUBLE PRECISION,
    "circunferenciaCintura" DOUBLE PRECISION,
    "circunferenciaCadera" DOUBLE PRECISION,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "fechaAlta" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "encuestaToken" TEXT,
    "encuestaCompletada" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Paciente_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Anamnesis" (
    "id" TEXT NOT NULL,
    "pacienteId" TEXT NOT NULL,
    "completadaAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ocupacion" TEXT,
    "estadoCivil" TEXT,
    "numHijos" INTEGER,
    "nivelEstudios" TEXT,
    "patologias" TEXT[],
    "alergias" TEXT[],
    "intolerancias" TEXT[],
    "medicamentos" TEXT[],
    "suplementos" TEXT[],
    "cirugias" TEXT[],
    "antecedentesFamiliares" TEXT[],
    "comidasDia" INTEGER,
    "picoteo" BOOLEAN,
    "cocinaEnCasa" BOOLEAN,
    "comeEnTrabajo" BOOLEAN,
    "prefAlimentarias" TEXT,
    "alimentosNoDeseados" TEXT,
    "alimentosFavoritos" TEXT,
    "consumoAlcohol" TEXT,
    "consumoTabaco" TEXT,
    "consumoAgua" TEXT,
    "registroDietetico" JSONB,
    "actividadFisica" TEXT,
    "frecuenciaEjercicio" TEXT,
    "tipoEjercicio" TEXT,
    "duracionEjercicio" TEXT,
    "horasSueno" DOUBLE PRECISION,
    "calidadSueno" TEXT,
    "objetivoPrincipal" TEXT,
    "objetivoSecundario" TEXT,
    "motivacion" TEXT,
    "expectativas" TEXT,
    "relacionComida" TEXT,
    "episodiosAtracones" BOOLEAN,
    "trastornoAlimentario" BOOLEAN,
    "nivelEstres" TEXT,
    "estadoAnimo" TEXT,
    "consentimiento" BOOLEAN NOT NULL DEFAULT false,
    "consentimientoFecha" TIMESTAMP(3),

    CONSTRAINT "Anamnesis_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Medicion" (
    "id" TEXT NOT NULL,
    "pacienteId" TEXT NOT NULL,
    "fecha" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "peso" DOUBLE PRECISION,
    "porcentajeGrasa" DOUBLE PRECISION,
    "masaMuscular" DOUBLE PRECISION,
    "circunferenciaCintura" DOUBLE PRECISION,
    "circunferenciaCadera" DOUBLE PRECISION,
    "notas" TEXT,

    CONSTRAINT "Medicion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Alimento" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "grupoIntercambio" "GrupoIntercambio" NOT NULL,
    "subgrupo" TEXT,
    "calorias" DOUBLE PRECISION NOT NULL,
    "proteinas" DOUBLE PRECISION NOT NULL,
    "carbohidratos" DOUBLE PRECISION NOT NULL,
    "grasas" DOUBLE PRECISION NOT NULL,
    "fibra" DOUBLE PRECISION,
    "sodio" DOUBLE PRECISION,
    "potasio" DOUBLE PRECISION,
    "calcio" DOUBLE PRECISION,
    "hierro" DOUBLE PRECISION,
    "vitaminaA" DOUBLE PRECISION,
    "vitaminaC" DOUBLE PRECISION,
    "vitaminaD" DOUBLE PRECISION,
    "vitaminaB12" DOUBLE PRECISION,
    "acFolico" DOUBLE PRECISION,
    "racionIntercambio" DOUBLE PRECISION NOT NULL,
    "descripcionRacion" TEXT,
    "esAptoVegetariano" BOOLEAN NOT NULL DEFAULT false,
    "esAptoVegano" BOOLEAN NOT NULL DEFAULT false,
    "contieneLactosa" BOOLEAN NOT NULL DEFAULT false,
    "contieneGluten" BOOLEAN NOT NULL DEFAULT false,
    "contieneFrutosSecos" BOOLEAN NOT NULL DEFAULT false,
    "contieneHuevo" BOOLEAN NOT NULL DEFAULT false,
    "contienePescado" BOOLEAN NOT NULL DEFAULT false,
    "contieneMarisco" BOOLEAN NOT NULL DEFAULT false,
    "contieneSoja" BOOLEAN NOT NULL DEFAULT false,
    "temporada" TEXT[],
    "region" TEXT,

    CONSTRAINT "Alimento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Receta" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT,
    "instrucciones" TEXT NOT NULL,
    "tiempoPreparacion" INTEGER NOT NULL,
    "tiempoCoccion" INTEGER NOT NULL,
    "dificultad" TEXT NOT NULL,
    "raciones" INTEGER NOT NULL DEFAULT 4,
    "imagen" TEXT,
    "tipoComida" TEXT[],
    "categoria" TEXT,
    "estiloEspanol" BOOLEAN NOT NULL DEFAULT true,
    "region" TEXT,
    "caloriasPorRacion" DOUBLE PRECISION,
    "proteinasPorRacion" DOUBLE PRECISION,
    "carbohidratosPorRacion" DOUBLE PRECISION,
    "grasasPorRacion" DOUBLE PRECISION,
    "fibraPorRacion" DOUBLE PRECISION,
    "esAptoVegetariano" BOOLEAN NOT NULL DEFAULT false,
    "esAptoVegano" BOOLEAN NOT NULL DEFAULT false,
    "contieneLactosa" BOOLEAN NOT NULL DEFAULT false,
    "contieneGluten" BOOLEAN NOT NULL DEFAULT false,
    "contieneFrutosSecos" BOOLEAN NOT NULL DEFAULT false,
    "contieneHuevo" BOOLEAN NOT NULL DEFAULT false,
    "contienePescado" BOOLEAN NOT NULL DEFAULT false,
    "contieneMarisco" BOOLEAN NOT NULL DEFAULT false,
    "contieneSoja" BOOLEAN NOT NULL DEFAULT false,
    "nutricionistaId" TEXT,

    CONSTRAINT "Receta_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RecetaAlimento" (
    "id" TEXT NOT NULL,
    "recetaId" TEXT NOT NULL,
    "alimentoId" TEXT NOT NULL,
    "cantidad" DOUBLE PRECISION NOT NULL,
    "unidad" TEXT,
    "notas" TEXT,

    CONSTRAINT "RecetaAlimento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlanNutricional" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "pacienteId" TEXT NOT NULL,
    "nutricionistaId" TEXT NOT NULL,
    "estado" "EstadoPlan" NOT NULL DEFAULT 'BORRADOR',
    "tipoPlan" "TipoPlan" NOT NULL DEFAULT 'SEMANAL',
    "numPlanificaciones" INTEGER NOT NULL DEFAULT 1,
    "fechaInicio" TIMESTAMP(3),
    "fechaFin" TIMESTAMP(3),
    "caloriasObjetivo" DOUBLE PRECISION NOT NULL,
    "proteinasObjetivo" DOUBLE PRECISION NOT NULL,
    "carbohidratosObjetivo" DOUBLE PRECISION NOT NULL,
    "grasasObjetivo" DOUBLE PRECISION NOT NULL,
    "fibraObjetivo" DOUBLE PRECISION,
    "intercambiosConfig" JSONB,
    "comidasActivas" "TipoComida"[],
    "notas" TEXT,
    "observaciones" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PlanNutricional_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Planificacion" (
    "id" TEXT NOT NULL,
    "planId" TEXT NOT NULL,
    "numeroPlan" INTEGER NOT NULL,
    "nombre" TEXT,

    CONSTRAINT "Planificacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlanDia" (
    "id" TEXT NOT NULL,
    "planificacionId" TEXT NOT NULL,
    "diaSemana" INTEGER NOT NULL,
    "nombre" TEXT,
    "caloriasTotal" DOUBLE PRECISION,
    "proteinasTotal" DOUBLE PRECISION,
    "carbohidratosTotal" DOUBLE PRECISION,
    "grasasTotal" DOUBLE PRECISION,
    "fibraTotal" DOUBLE PRECISION,

    CONSTRAINT "PlanDia_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlanComida" (
    "id" TEXT NOT NULL,
    "planDiaId" TEXT NOT NULL,
    "tipoComida" "TipoComida" NOT NULL,
    "hora" TEXT,
    "notas" TEXT,
    "orden" INTEGER NOT NULL DEFAULT 0,
    "caloriasTotal" DOUBLE PRECISION,
    "proteinasTotal" DOUBLE PRECISION,
    "carbohidratosTotal" DOUBLE PRECISION,
    "grasasTotal" DOUBLE PRECISION,
    "fibraTotal" DOUBLE PRECISION,

    CONSTRAINT "PlanComida_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlanComidaAlimento" (
    "id" TEXT NOT NULL,
    "planComidaId" TEXT NOT NULL,
    "alimentoId" TEXT NOT NULL,
    "cantidad" DOUBLE PRECISION NOT NULL,
    "intercambios" DOUBLE PRECISION,
    "notas" TEXT,
    "esIntercambiable" BOOLEAN NOT NULL DEFAULT true,
    "grupoIntercambio" "GrupoIntercambio",
    "alternativas" JSONB,

    CONSTRAINT "PlanComidaAlimento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlanComidaReceta" (
    "id" TEXT NOT NULL,
    "planComidaId" TEXT NOT NULL,
    "recetaId" TEXT NOT NULL,
    "raciones" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "notas" TEXT,

    CONSTRAINT "PlanComidaReceta_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Conversacion" (
    "id" TEXT NOT NULL,
    "pacienteId" TEXT NOT NULL,
    "ultimoMensaje" TEXT,
    "ultimaActividad" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "noLeidos" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "Conversacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Mensaje" (
    "id" TEXT NOT NULL,
    "conversacionId" TEXT NOT NULL,
    "remitenteId" TEXT NOT NULL,
    "destinatarioId" TEXT NOT NULL,
    "contenido" TEXT NOT NULL,
    "tipo" TEXT NOT NULL DEFAULT 'texto',
    "archivoUrl" TEXT,
    "leido" BOOLEAN NOT NULL DEFAULT false,
    "leidoAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Mensaje_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WhatsAppLog" (
    "id" TEXT NOT NULL,
    "telefono" TEXT NOT NULL,
    "tipo" TEXT NOT NULL,
    "contenido" TEXT,
    "estado" TEXT NOT NULL,
    "messageId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WhatsAppLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Nutricionista_userId_key" ON "Nutricionista"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Paciente_userId_key" ON "Paciente"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Paciente_encuestaToken_key" ON "Paciente"("encuestaToken");

-- CreateIndex
CREATE UNIQUE INDEX "Anamnesis_pacienteId_key" ON "Anamnesis"("pacienteId");

-- CreateIndex
CREATE UNIQUE INDEX "Conversacion_pacienteId_key" ON "Conversacion"("pacienteId");

-- AddForeignKey
ALTER TABLE "Nutricionista" ADD CONSTRAINT "Nutricionista_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Paciente" ADD CONSTRAINT "Paciente_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Paciente" ADD CONSTRAINT "Paciente_nutricionistaId_fkey" FOREIGN KEY ("nutricionistaId") REFERENCES "Nutricionista"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Anamnesis" ADD CONSTRAINT "Anamnesis_pacienteId_fkey" FOREIGN KEY ("pacienteId") REFERENCES "Paciente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Medicion" ADD CONSTRAINT "Medicion_pacienteId_fkey" FOREIGN KEY ("pacienteId") REFERENCES "Paciente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Receta" ADD CONSTRAINT "Receta_nutricionistaId_fkey" FOREIGN KEY ("nutricionistaId") REFERENCES "Nutricionista"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecetaAlimento" ADD CONSTRAINT "RecetaAlimento_recetaId_fkey" FOREIGN KEY ("recetaId") REFERENCES "Receta"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecetaAlimento" ADD CONSTRAINT "RecetaAlimento_alimentoId_fkey" FOREIGN KEY ("alimentoId") REFERENCES "Alimento"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanNutricional" ADD CONSTRAINT "PlanNutricional_pacienteId_fkey" FOREIGN KEY ("pacienteId") REFERENCES "Paciente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanNutricional" ADD CONSTRAINT "PlanNutricional_nutricionistaId_fkey" FOREIGN KEY ("nutricionistaId") REFERENCES "Nutricionista"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Planificacion" ADD CONSTRAINT "Planificacion_planId_fkey" FOREIGN KEY ("planId") REFERENCES "PlanNutricional"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanDia" ADD CONSTRAINT "PlanDia_planificacionId_fkey" FOREIGN KEY ("planificacionId") REFERENCES "Planificacion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanComida" ADD CONSTRAINT "PlanComida_planDiaId_fkey" FOREIGN KEY ("planDiaId") REFERENCES "PlanDia"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanComidaAlimento" ADD CONSTRAINT "PlanComidaAlimento_planComidaId_fkey" FOREIGN KEY ("planComidaId") REFERENCES "PlanComida"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanComidaAlimento" ADD CONSTRAINT "PlanComidaAlimento_alimentoId_fkey" FOREIGN KEY ("alimentoId") REFERENCES "Alimento"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanComidaReceta" ADD CONSTRAINT "PlanComidaReceta_planComidaId_fkey" FOREIGN KEY ("planComidaId") REFERENCES "PlanComida"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanComidaReceta" ADD CONSTRAINT "PlanComidaReceta_recetaId_fkey" FOREIGN KEY ("recetaId") REFERENCES "Receta"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversacion" ADD CONSTRAINT "Conversacion_pacienteId_fkey" FOREIGN KEY ("pacienteId") REFERENCES "Paciente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mensaje" ADD CONSTRAINT "Mensaje_conversacionId_fkey" FOREIGN KEY ("conversacionId") REFERENCES "Conversacion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mensaje" ADD CONSTRAINT "Mensaje_remitenteId_fkey" FOREIGN KEY ("remitenteId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mensaje" ADD CONSTRAINT "Mensaje_destinatarioId_fkey" FOREIGN KEY ("destinatarioId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ============================================================
-- 2. USERS
-- ============================================================

INSERT INTO "User" ("id","email","password","nombre","apellidos","rol","activo","createdAt","updatedAt") VALUES (
  '28dd0c3e-8314-483f-828e-73aa21a33faf', 'nutricionista@nutriplanpro.com', '$2b$10$Ebzco2TzeVLpNk.OazwDQete4o3WEqiEUZPWcj3eWzsYh1AvlJWfm', 'María', 'García López', 'NUTRICIONISTA'::"Rol", true, NOW(), NOW()
);

INSERT INTO "User" ("id","email","password","nombre","apellidos","rol","activo","createdAt","updatedAt") VALUES (
  'ccd2ff44-446f-435b-8009-a9da93bdea8c', 'paciente@nutriplanpro.com', '$2b$10$.DD2h.ChA6aH2oqb0JpQ6ua5KW/cbajIiuzUUxvQR8aMfpp3N5G1y', 'Carlos', 'Martínez Ruiz', 'PACIENTE'::"Rol", true, NOW(), NOW()
);

INSERT INTO "Nutricionista" ("id","userId","numColegiado","especialidad","clinica","direccion","whatsappNumber","bio") VALUES (
  'b666b7a7-250a-4d31-ab3d-7566b7b997f1', '28dd0c3e-8314-483f-828e-73aa21a33faf', 'MAD-1234', 'Nutrición clínica y deportiva', 'NutriPlan Pro Clinic', 'Calle Gran Vía 1, Madrid', '+34676002647', 'Nutricionista colegiada con 10 años de experiencia en nutrición clínica y deportiva.'
);

INSERT INTO "Paciente" ("id","userId","nutricionistaId","fechaNacimiento","sexo","altura","pesoActual","pesoObjetivo","imc","activo","fechaAlta","encuestaToken","encuestaCompletada") VALUES (
  'ef913e7c-9c44-4c8f-a6e3-faf450bf4356', 'ccd2ff44-446f-435b-8009-a9da93bdea8c', 'b666b7a7-250a-4d31-ab3d-7566b7b997f1', '1990-05-15', 'MASCULINO'::"Sexo", 178, 85, 78, 26.8, true, NOW(), 'd8788781-8e57-44ac-86f4-e21ad0720a92', false
);

-- ============================================================
-- 3. ALIMENTOS (81 items)
-- ============================================================

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'ed87c4ba-d91e-43ba-9760-4e12a1d70258', 'Leche entera', 'LACTEOS'::"GrupoIntercambio", 'Leche',
  63, 3.1, 4.7, 3.5, 0,
  200, '1 vaso',
  true, false, true, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'c685b9b6-61bc-49fe-b067-9dd5da0af730', 'Leche desnatada', 'LACTEOS'::"GrupoIntercambio", 'Leche',
  34, 3.4, 4.8, 0.1, 0,
  200, '1 vaso',
  true, false, true, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'cd4e9791-7c5e-4b1a-9dea-c619c99ca470', 'Yogur natural', 'LACTEOS'::"GrupoIntercambio", 'Yogur',
  61, 3.5, 4.7, 3.3, 0,
  125, '1 unidad',
  true, false, true, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '84b311c2-cad9-4211-8d73-12acfeb6e2f4', 'Queso fresco', 'LACTEOS'::"GrupoIntercambio", 'Queso',
  174, 11.3, 2.5, 13.3, 0,
  60, '2 lonchas',
  true, false, true, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'a0c5d143-7717-4b2c-9cd3-0a51a15987b0', 'Queso manchego', 'LACTEOS'::"GrupoIntercambio", 'Queso',
  376, 26, 0.5, 30, 0,
  30, '1 loncha gruesa',
  true, false, true, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'eac43659-14a1-4ffe-bab6-0f3d6ee25273', 'Requesón', 'LACTEOS'::"GrupoIntercambio", 'Queso',
  96, 13.6, 1.4, 4.3, 0,
  100, '1 tarrina pequeña',
  true, false, true, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '071a4e73-ddd9-4af9-8887-b96d255aeb89', 'Manzana', 'FRUTAS'::"GrupoIntercambio", NULL,
  52, 0.3, 13.8, 0.2, 2.4,
  150, '1 unidad mediana',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['otoño', 'invierno']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '61c7a85d-f217-4a85-9ce8-186ccc4cc057', 'Plátano', 'FRUTAS'::"GrupoIntercambio", NULL,
  89, 1.1, 22.8, 0.3, 2.6,
  80, '1 unidad pequeña',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'e4d4ee04-2cd4-4186-8c10-8f5f31a8c5e5', 'Naranja', 'FRUTAS'::"GrupoIntercambio", NULL,
  47, 0.9, 11.7, 0.1, 2.4,
  200, '1 unidad mediana',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['invierno', 'primavera']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '0708ac89-ae64-4df0-905b-f05f1ab01d96', 'Fresa', 'FRUTAS'::"GrupoIntercambio", NULL,
  33, 0.7, 7.7, 0.3, 2,
  200, '8-10 unidades',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['primavera']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '5e896858-84d5-4614-aa3b-bfaea7429d0e', 'Uva', 'FRUTAS'::"GrupoIntercambio", NULL,
  69, 0.7, 18.1, 0.2, 0.9,
  100, '1 racimo pequeño',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['otoño']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'fc12fabd-291c-49b7-9f75-7cfc186c5668', 'Pera', 'FRUTAS'::"GrupoIntercambio", NULL,
  57, 0.4, 15.2, 0.1, 3.1,
  150, '1 unidad mediana',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['otoño', 'invierno']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'b10d9c63-84e2-44b9-ba47-8d528ae5ddf2', 'Melocotón', 'FRUTAS'::"GrupoIntercambio", NULL,
  39, 0.9, 9.5, 0.3, 1.5,
  200, '1 unidad mediana',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '12db43cf-f46d-495e-8747-2de1243d4d83', 'Sandía', 'FRUTAS'::"GrupoIntercambio", NULL,
  30, 0.6, 7.6, 0.2, 0.4,
  250, '1 tajada',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'ef40584b-b58d-4ee7-93f8-8b036661c083', 'Melón', 'FRUTAS'::"GrupoIntercambio", NULL,
  34, 0.8, 8.2, 0.2, 0.9,
  250, '1 tajada',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '00f8f249-d725-4f40-9305-6b93a5995221', 'Kiwi', 'FRUTAS'::"GrupoIntercambio", NULL,
  61, 1.1, 14.7, 0.5, 3,
  100, '1 unidad',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['invierno', 'primavera']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '018dc619-7f1d-43f6-9c94-fc2aa3253acb', 'Piña', 'FRUTAS'::"GrupoIntercambio", NULL,
  50, 0.5, 13.1, 0.1, 1.4,
  150, '2 rodajas',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'dc5944b3-2cfa-41af-a653-cf3a12623ca1', 'Mandarina', 'FRUTAS'::"GrupoIntercambio", NULL,
  53, 0.8, 13.3, 0.3, 1.8,
  150, '2 unidades',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['invierno']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'd85753ee-998f-4d85-a279-36651a685f69', 'Tomate', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  18, 0.9, 3.9, 0.2, 1.2,
  200, '1 unidad mediana',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'ba10ce46-0cfc-4f88-b5c1-d694e601195e', 'Lechuga', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  15, 1.4, 2.9, 0.2, 1.3,
  100, '1 plato de ensalada',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '50651b76-df78-4de1-b69a-f7f51ad90dfd', 'Pepino', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  16, 0.7, 3.6, 0.1, 0.5,
  200, '1 unidad',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['primavera', 'verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '491476ed-ae0e-4332-90b6-fedfbebac7d5', 'Zanahoria', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  41, 0.9, 9.6, 0.2, 2.8,
  100, '1 unidad mediana',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '515a2d9c-3df2-4d77-a1d8-dda80cbd5f7e', 'Cebolla', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  40, 1.1, 9.3, 0.1, 1.7,
  100, '1 unidad mediana',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'fb1b552c-a1ce-4207-82f2-303edfd425f2', 'Pimiento rojo', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  31, 1, 6, 0.3, 2.1,
  150, '1 unidad',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '568ebad0-f152-439a-aa3b-9df702a3ec4b', 'Pimiento verde', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  20, 0.9, 4.6, 0.2, 1.7,
  150, '1 unidad',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'ab39a973-1215-4eb5-a4fe-6fe5d4ec1074', 'Espinacas', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  23, 2.9, 3.6, 0.4, 2.2,
  200, '1 plato',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['otoño', 'invierno', 'primavera']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '92a00467-024c-4311-8754-a8e69fc15507', 'Brócoli', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  34, 2.8, 6.6, 0.4, 2.6,
  200, '1 plato',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['otoño', 'invierno']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '6a065dfb-5d01-4a44-acd1-3e6067200293', 'Calabacín', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  17, 1.2, 3.1, 0.3, 1,
  200, '1 unidad mediana',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['primavera', 'verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'c3c4ec82-72b8-4b03-81e3-0652502d4f0e', 'Judías verdes', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  31, 1.8, 7, 0.1, 3.4,
  200, '1 plato',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['primavera', 'verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '9e5cc663-18bb-403b-930a-a541eed127ae', 'Berenjena', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", NULL,
  25, 1, 5.9, 0.2, 3,
  200, '1 unidad mediana',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'c567f947-d190-4ce0-8374-5d6f189ff508', 'Champiñón', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", 'Setas',
  22, 3.1, 3.3, 0.3, 1,
  200, '6-8 unidades',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '341a59f3-187c-4b29-9f16-d4b9faa1c620', 'Ajo', 'VERDURAS_HORTALIZAS'::"GrupoIntercambio", 'Condimento',
  149, 6.4, 33.1, 0.5, 2.1,
  5, '1 diente',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '4e70e0bb-5012-4f09-93e8-870347b7902d', 'Arroz blanco', 'CEREALES_TUBERCULOS'::"GrupoIntercambio", 'Cereales',
  130, 2.7, 28.2, 0.3, 0.4,
  60, '3 cucharadas soperas en crudo',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'd0e2fd21-711f-4368-a8a9-c2a1c6415525', 'Pan integral', 'CEREALES_TUBERCULOS'::"GrupoIntercambio", 'Pan',
  247, 13, 41.3, 3.4, 6.8,
  40, '2 rebanadas',
  true, true, false, true,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '12c359b6-2d84-4431-9031-e72c044a04e0', 'Pasta', 'CEREALES_TUBERCULOS'::"GrupoIntercambio", 'Cereales',
  131, 5, 25.4, 1.1, 1.8,
  60, '60g en crudo',
  true, true, false, true,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '95391b4c-ae80-4337-97d4-90eba56e84ef', 'Patata', 'CEREALES_TUBERCULOS'::"GrupoIntercambio", 'Tubérculos',
  77, 2, 17.5, 0.1, 2.2,
  150, '1 unidad mediana',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'd2697ce8-a559-40a9-ba21-1a47f7a15939', 'Avena', 'CEREALES_TUBERCULOS'::"GrupoIntercambio", 'Cereales',
  389, 16.9, 66.3, 6.9, 10.6,
  30, '3 cucharadas soperas',
  true, true, false, true,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '807ffc3b-a95b-499e-81cd-e8c7d02285c6', 'Pan blanco', 'CEREALES_TUBERCULOS'::"GrupoIntercambio", 'Pan',
  265, 9.4, 49.1, 3.2, 2.7,
  40, '2 rebanadas',
  true, true, false, true,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '95e2d390-335a-4bf6-a48d-90891e0dfd5d', 'Maíz', 'CEREALES_TUBERCULOS'::"GrupoIntercambio", 'Cereales',
  86, 3.3, 18.7, 1.4, 2,
  100, '1 mazorca pequeña',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '5c99afc8-56ca-460d-bbe7-3cab359a9ff0', 'Quinoa', 'CEREALES_TUBERCULOS'::"GrupoIntercambio", 'Pseudocereal',
  120, 4.4, 21.3, 1.9, 2.8,
  60, '3 cucharadas soperas en crudo',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'cc76fd07-7c19-43e1-accd-b8de5744a5cb', 'Lentejas', 'LEGUMBRES'::"GrupoIntercambio", NULL,
  353, 24.6, 54, 1.1, 10.7,
  60, '3 cucharadas soperas en crudo',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '972bb32d-4b18-4015-931b-68c03fecc424', 'Garbanzos', 'LEGUMBRES'::"GrupoIntercambio", NULL,
  364, 19.3, 55, 5, 15.5,
  60, '3 cucharadas soperas en crudo',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'dd08b414-a80f-4b55-adb7-b81f7c5d9d11', 'Alubias blancas', 'LEGUMBRES'::"GrupoIntercambio", NULL,
  333, 21.1, 52.5, 1.6, 15.2,
  60, '3 cucharadas soperas en crudo',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'ecaba0fd-eaba-49a7-b994-7dfcb9a91f66', 'Judiones', 'LEGUMBRES'::"GrupoIntercambio", NULL,
  329, 20.2, 50.8, 1.4, 14,
  60, '3 cucharadas soperas en crudo',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '0c23b81a-3cc6-4c23-be69-9da996082899', 'Guisantes', 'LEGUMBRES'::"GrupoIntercambio", NULL,
  341, 24.5, 49, 1.2, 16.6,
  60, '3 cucharadas soperas en crudo',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '00207ef3-2c83-476f-a8e6-892abad11b2b', 'Lentejas rojas', 'LEGUMBRES'::"GrupoIntercambio", NULL,
  358, 25.4, 56.3, 1.3, 7.4,
  60, '3 cucharadas soperas en crudo',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '7c6f3fdb-cfdc-489c-95f0-1385f21bca94', 'Habas secas', 'LEGUMBRES'::"GrupoIntercambio", NULL,
  341, 26.1, 46, 1.5, 13.1,
  60, '3 cucharadas soperas en crudo',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '13037213-90d5-49df-a5c5-9a78c6eba69d', 'Pechuga de pollo', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Carnes magras',
  165, 31, 0, 3.6, 0,
  100, '1 filete mediano',
  false, false, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'ab6892b9-0a76-46d1-a626-8222e449b518', 'Ternera', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Carnes magras',
  131, 22, 0, 4.8, 0,
  100, '1 filete mediano',
  false, false, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '0cc474b1-cec7-4eea-92e9-a8c96d431885', 'Cerdo', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Carnes magras',
  143, 26.2, 0, 3.5, 0,
  100, '1 filete mediano',
  false, false, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '90095d70-003e-4f99-8ceb-6fceac46a56a', 'Chuleta de cerdo', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Carnes semigrasa',
  215, 22.4, 0, 13.8, 0,
  100, '1 chuleta mediana',
  false, false, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '924f1c64-1362-40f6-9ece-87176dbacaac', 'Huevo', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Huevos',
  155, 13, 1.1, 11, 0,
  60, '1 huevo mediano',
  true, false, false, false,
  false, true, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '3d53eca5-8b1f-4e53-9923-a82d0e4a4b08', 'Salmón', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Pescado azul',
  208, 20.4, 0, 13.6, 0,
  130, '1 rodaja mediana',
  false, false, false, false,
  false, false, true, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'f969539e-4ac0-4bc8-9f1c-2753f3f22a4a', 'Merluza', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Pescado blanco',
  82, 17.2, 0, 1.3, 0,
  130, '1 rodaja mediana',
  false, false, false, false,
  false, false, true, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'ea41a860-8cc3-4de7-bf3a-0a3dfe8abf85', 'Atún', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Pescado azul',
  144, 23.3, 0, 4.9, 0,
  130, '1 rodaja mediana',
  false, false, false, false,
  false, false, true, false, false,
  ARRAY['primavera', 'verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '2718510f-f753-4669-96b4-ba1064fd3119', 'Sardinas', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Pescado azul',
  208, 24.6, 0, 11.5, 0,
  130, '4-5 sardinas medianas',
  false, false, false, false,
  false, false, true, false, false,
  ARRAY['primavera', 'verano']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'a2c1521e-114b-4be1-9528-2f628bcf48bd', 'Gambas', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Marisco',
  99, 20.3, 0.2, 1.7, 0,
  130, '8-10 gambas medianas',
  false, false, false, false,
  false, false, false, true, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '1d53189e-1c00-4358-950c-98a578024c88', 'Pulpo', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Marisco',
  82, 14.9, 2.2, 1, 0,
  130, '1 ración mediana',
  false, false, false, false,
  false, false, false, true, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '4d5b6bf1-23ef-49e3-9377-825d120f6517', 'Jamón serrano', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Embutidos y fiambres',
  241, 31, 0, 12.8, 0,
  40, '2-3 lonchas finas',
  false, false, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '8b1c229f-8b31-4908-aed1-88663a20255e', 'Jamón york', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Embutidos y fiambres',
  131, 18.4, 1.5, 5.8, 0,
  40, '2-3 lonchas',
  false, false, true, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '8101371e-41f7-44ab-bc66-bd4b88814da5', 'Pavo', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Carnes magras',
  135, 30, 0, 1.2, 0,
  100, '1 filete mediano',
  false, false, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '4b068f93-995b-4dde-a8fc-0bee2e06ef04', 'Muslo de pollo', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Carnes semigrasa',
  177, 24.2, 0, 8.4, 0,
  100, '1 muslo mediano sin piel',
  false, false, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '485f506c-e85c-446b-b11e-38355c244316', 'Bacalao fresco', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Pescado blanco',
  82, 18, 0, 0.7, 0,
  130, '1 trozo mediano',
  false, false, false, false,
  false, false, true, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '09f4bc20-b4b2-4b4d-8709-e250ba622afc', 'Lubina', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Pescado blanco',
  97, 18.4, 0, 2.5, 0,
  130, '1 ración mediana',
  false, false, false, false,
  false, false, true, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '4e995d83-a4a7-49e3-8b8a-6e08cd89c5e4', 'Mejillones', 'CARNES_PESCADOS_HUEVOS'::"GrupoIntercambio", 'Marisco',
  86, 11.9, 3.7, 2.2, 0,
  130, '15-20 mejillones',
  false, false, false, false,
  false, false, false, true, false,
  ARRAY['otoño', 'invierno']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 'Aceite de oliva virgen extra', 'GRASAS'::"GrupoIntercambio", 'Aceites vegetales',
  884, 0, 0, 100, 0,
  10, '1 cucharada sopera',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'c251cf2c-bfb5-478a-964d-945fccacb0ee', 'Mantequilla', 'GRASAS'::"GrupoIntercambio", 'Grasas animales',
  717, 0.9, 0.1, 81.1, 0,
  12, '1 porción individual',
  true, false, true, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '4dedd88e-c55d-4ea1-ad4b-0dde90890f3c', 'Aguacate', 'GRASAS'::"GrupoIntercambio", 'Grasas vegetales',
  160, 2, 8.5, 14.7, 6.7,
  70, 'medio aguacate',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['otoño', 'invierno']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '587a6c42-f76a-450c-9fb1-6cbc96a7c463', 'Aceitunas', 'GRASAS'::"GrupoIntercambio", 'Grasas vegetales',
  145, 1, 3.8, 13.9, 3.3,
  30, '8-10 aceitunas',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '4d3fde3a-c900-455e-9fc6-3cd8b4ad9b03', 'Aceitunas negras', 'GRASAS'::"GrupoIntercambio", 'Grasas vegetales',
  115, 0.8, 6.3, 10.7, 3.2,
  30, '8-10 aceitunas',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'b3f10127-2edc-4763-baca-a5e9a8b3a80b', 'Aceite de girasol', 'GRASAS'::"GrupoIntercambio", 'Aceites vegetales',
  884, 0, 0, 100, 0,
  10, '1 cucharada sopera',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'c276ac58-fc5d-45a0-95b1-38b76eff6edb', 'Almendras', 'FRUTOS_SECOS'::"GrupoIntercambio", NULL,
  579, 21.2, 21.6, 49.9, 12.5,
  20, '15-20 almendras',
  true, true, false, false,
  true, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'a5600695-e2e8-4c1e-968e-ed826f304ce3', 'Nueces', 'FRUTOS_SECOS'::"GrupoIntercambio", NULL,
  654, 15.2, 13.7, 65.2, 6.7,
  20, '4-5 nueces enteras',
  true, true, false, false,
  true, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '30fc2c42-77c4-4050-b359-29785731d341', 'Avellanas', 'FRUTOS_SECOS'::"GrupoIntercambio", NULL,
  628, 15, 16.7, 60.8, 9.7,
  20, '15-18 avellanas',
  true, true, false, false,
  true, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'bc0290da-2ea9-4e86-aa7b-1259e4cf5912', 'Pistachos', 'FRUTOS_SECOS'::"GrupoIntercambio", NULL,
  560, 20.2, 27.2, 45.3, 10.6,
  20, '25-30 pistachos',
  true, true, false, false,
  true, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '6f5579bb-1bbc-49b9-8ef1-d95b8add1e68', 'Semillas de chía', 'FRUTOS_SECOS'::"GrupoIntercambio", 'Semillas',
  486, 16.5, 42.1, 30.7, 34.4,
  15, '1 cucharada sopera',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '9ca6e582-33d9-44b9-b887-020d5b94eabc', 'Semillas de lino', 'FRUTOS_SECOS'::"GrupoIntercambio", 'Semillas',
  534, 18.3, 28.9, 42.2, 27.3,
  15, '1 cucharada sopera',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '3531ee6e-d925-4290-a43f-b8bac04afe1d', 'Piñones', 'FRUTOS_SECOS'::"GrupoIntercambio", NULL,
  673, 13.7, 13.1, 68.4, 3.7,
  20, '2 cucharadas soperas',
  true, true, false, false,
  true, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  'a2b7cdf8-d257-4c61-b73a-dd785684a157', 'Anacardos', 'FRUTOS_SECOS'::"GrupoIntercambio", NULL,
  553, 18.2, 30.2, 43.9, 3.3,
  20, '15-18 anacardos',
  true, true, false, false,
  true, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '0f25f7bc-1add-4113-9f65-37e4e085077c', 'Semillas de calabaza', 'FRUTOS_SECOS'::"GrupoIntercambio", 'Semillas',
  559, 30.2, 10.7, 49.1, 6,
  15, '1 cucharada sopera',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

INSERT INTO "Alimento" (
  "id","nombre","grupoIntercambio","subgrupo",
  "calorias","proteinas","carbohidratos","grasas","fibra",
  "racionIntercambio","descripcionRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",
  "temporada"
) VALUES (
  '1692385b-9de8-4e31-aa05-b6b613467f32', 'Semillas de girasol', 'FRUTOS_SECOS'::"GrupoIntercambio", 'Semillas',
  584, 20.8, 20, 51.5, 8.6,
  15, '1 cucharada sopera',
  true, true, false, false,
  false, false, false, false, false,
  ARRAY['todo el año']
);

-- ============================================================
-- 4. RECETAS (15 items)
-- ============================================================

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  'f10376e0-3c09-439d-a0ff-af4702cf4d29', 'Gazpacho andaluz', 'Sopa fría tradicional de Andalucía, perfecta para los meses de verano. Elaborada con hortalizas frescas y aceite de oliva virgen extra.', '1. Lavar y trocear los tomates, el pepino, el pimiento, la cebolla y el ajo.
2. Introducir todas las verduras en el vaso de la batidora.
3. Añadir el aceite de oliva virgen extra, el vinagre y la sal.
4. Triturar hasta obtener una textura fina y homogénea.
5. Colar si se desea una textura más fina.
6. Refrigerar durante al menos 2 horas antes de servir.
7. Servir frío con tropezones de pepino, pimiento y cebolla picados.',
  20, 0, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Sopas y cremas', true, 'Andalucía',
  120, 2, 10, 8,
  true, true, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  'e10f25e4-e94d-4257-8d5c-ad6c0ba8cbc8', 'Tortilla española', 'La tortilla de patatas es uno de los platos más emblemáticos de la cocina española. Jugosa por dentro y dorada por fuera.', '1. Pelar y cortar las patatas en láminas finas.
2. Pelar y cortar la cebolla en juliana fina.
3. Calentar abundante aceite de oliva en una sartén y freír las patatas a fuego medio junto con la cebolla hasta que estén tiernas (unos 20 minutos).
4. Escurrir bien el aceite sobrante.
5. Batir los huevos en un bol grande con una pizca de sal.
6. Mezclar las patatas y la cebolla con los huevos batidos.
7. Calentar un poco de aceite en una sartén antiadherente y verter la mezcla.
8. Cocinar a fuego medio-bajo durante 5 minutos.
9. Dar la vuelta con la ayuda de un plato y cocinar otros 3-4 minutos.
10. Servir templada o a temperatura ambiente.',
  15, 30, 'media', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Platos principales', true, NULL,
  320, 14, 28, 18,
  true, false, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  '7f9470fd-4bf8-45ef-9c3b-d3f62da603e5', 'Ensalada mediterránea', 'Ensalada fresca y colorida con ingredientes típicos de la dieta mediterránea. Ligera y nutritiva.', '1. Lavar y escurrir la lechuga, cortarla en trozos.
2. Cortar los tomates en gajos.
3. Pelar y cortar el pepino en rodajas.
4. Cortar el aguacate por la mitad, retirar el hueso y cortarlo en láminas.
5. Añadir las aceitunas.
6. Disponer todos los ingredientes en una fuente.
7. Aliñar con aceite de oliva virgen extra y sal al gusto.
8. Servir inmediatamente.',
  15, 0, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Ensaladas', true, NULL,
  180, 3, 8, 15,
  true, true, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  '325219ca-07cf-4bc2-9b98-ee85d1338c4b', 'Pollo al ajillo', 'Receta clásica de la cocina española. El pollo se cocina lentamente en aceite de oliva con abundante ajo, resultando tierno y muy aromático.', '1. Cortar la pechuga de pollo en trozos medianos y salpimentar.
2. Pelar y laminar los ajos.
3. Calentar el aceite de oliva en una cazuela o sartén amplia.
4. Dorar los ajos laminados hasta que estén ligeramente dorados y reservar.
5. En el mismo aceite, sellar los trozos de pollo por todos los lados a fuego fuerte.
6. Bajar el fuego, incorporar los ajos reservados.
7. Añadir un chorro de vino blanco (opcional) y dejar reducir.
8. Tapar y cocinar a fuego lento durante 15-20 minutos hasta que el pollo esté bien hecho.
9. Servir caliente con su propia salsa.',
  10, 25, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Platos principales', true, 'Castilla',
  280, 35, 2, 14,
  false, false, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  '1e9b0e05-52e2-4592-b45a-ff9c62d2646f', 'Lentejas estofadas', 'Guiso tradicional español de lentejas con verduras. Un plato reconfortante, económico y muy nutritivo, ideal para los meses fríos.', '1. Lavar las lentejas bajo el grifo y escurrir.
2. Pelar y picar la zanahoria, la patata, la cebolla y el ajo.
3. Cortar el pimiento verde en trozos pequeños.
4. En una olla grande, calentar el aceite de oliva y sofreír la cebolla, el ajo y el pimiento durante 5 minutos.
5. Añadir la zanahoria y la patata, y sofreír 2 minutos más.
6. Incorporar las lentejas y cubrir con agua fría (el doble de volumen que las lentejas).
7. Llevar a ebullición y bajar el fuego.
8. Cocinar a fuego lento durante 30-40 minutos hasta que las lentejas estén tiernas.
9. Rectificar de sal y servir caliente.',
  15, 40, 'facil', 4,
  ARRAY['ALMUERZO'], 'Legumbres', true, NULL,
  350, 22, 48, 8,
  true, true, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  'f4c2eb3a-94cd-452d-a904-353cf0565c10', 'Merluza a la plancha con verduras', 'Merluza fresca a la plancha acompañada de verduras salteadas. Un plato ligero, saludable y muy sabroso.', '1. Salpimentar los lomos de merluza.
2. Lavar y cortar el calabacín en rodajas, el brócoli en ramilletes y las judías verdes en trozos.
3. Hervir o cocer al vapor el brócoli y las judías verdes durante 5-6 minutos. Escurrir.
4. En una sartén con un poco de aceite, saltear el calabacín hasta que esté dorado.
5. Añadir el brócoli y las judías verdes al salteado y mantener caliente.
6. En otra sartén con aceite de oliva caliente, cocinar la merluza 3-4 minutos por cada lado.
7. Servir la merluza sobre la cama de verduras.
8. Aliñar con un chorrito de aceite de oliva virgen extra en crudo.',
  10, 15, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Pescados', true, NULL,
  220, 28, 8, 9,
  false, false, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  '245140cf-41f8-458d-b3d7-a58f039c0d7b', 'Garbanzos con espinacas', 'Plato típico de la cocina andaluza y sevillana. Un guiso de cuaresma sencillo, saciante y lleno de sabor gracias al pimentón y el comino.', '1. Si se usan garbanzos secos, ponerlos en remojo la noche anterior y cocerlos hasta que estén tiernos. También se pueden usar garbanzos de bote escurridos.
2. Lavar bien las espinacas.
3. Pelar y picar la cebolla y los ajos.
4. En una cazuela, calentar el aceite de oliva y sofreír la cebolla hasta que esté transparente.
5. Añadir el ajo picado y cocinar 1 minuto más.
6. Incorporar el tomate rallado y cocinar 5 minutos.
7. Añadir las espinacas y dejar que se cocinen hasta que se reduzcan.
8. Incorporar los garbanzos cocidos y un poco de caldo de su cocción.
9. Sazonar con pimentón, comino y sal.
10. Cocinar todo junto a fuego lento durante 10 minutos para que se integren los sabores.',
  15, 20, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Legumbres', true, 'Andalucía',
  310, 18, 38, 10,
  true, true, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  'f0d9de11-cb07-4e43-8207-24ab6883764c', 'Salmón al horno con patatas', 'Salmón jugoso horneado sobre una cama de patatas. Un plato completo, elegante y fácil de preparar que es rico en omega-3.', '1. Precalentar el horno a 200°C.
2. Pelar las patatas y cortarlas en rodajas finas.
3. Cortar la cebolla en aros finos.
4. Disponer las patatas y la cebolla en una fuente de horno, aliñar con aceite de oliva y sal.
5. Hornear las patatas durante 25 minutos a 200°C.
6. Salpimentar los lomos de salmón.
7. Colocar el salmón sobre las patatas y regar con un poco de aceite.
8. Hornear 12-15 minutos más hasta que el salmón esté hecho pero jugoso.
9. Servir directamente de la fuente.',
  15, 40, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Pescados', true, NULL,
  420, 32, 30, 20,
  false, false, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  '5f200b6e-503a-493a-9761-fea3d4e01b57', 'Pisto manchego', 'El pisto es un plato tradicional de La Mancha a base de verduras de la huerta. Similar al ratatouille francés pero con personalidad propia.', '1. Lavar y cortar todas las verduras en dados pequeños: calabacín, berenjena, pimientos y cebolla.
2. Pelar y picar el ajo.
3. Rallar o triturar los tomates.
4. En una sartén amplia o cazuela, calentar el aceite de oliva.
5. Sofreír la cebolla y el ajo a fuego medio durante 5 minutos.
6. Añadir los pimientos y cocinar 5 minutos más.
7. Incorporar el calabacín y la berenjena, cocinar 8-10 minutos.
8. Añadir el tomate triturado y salar.
9. Cocinar a fuego lento durante 20 minutos, removiendo de vez en cuando.
10. El pisto debe quedar con las verduras tiernas pero no deshechas.',
  20, 40, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Verduras', true, 'Castilla-La Mancha',
  150, 3, 14, 9,
  true, true, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  'e5fbd3e0-e184-47d2-8f1a-791a9074a43d', 'Ensalada César con pollo', 'Versión española de la clásica ensalada César, con pechuga de pollo a la plancha, queso y una salsa cremosa.', '1. Salpimentar la pechuga de pollo y cocinarla a la plancha con un poco de aceite hasta que esté dorada y bien hecha (unos 6-7 minutos por lado).
2. Dejar reposar el pollo 5 minutos y cortarlo en tiras.
3. Lavar y cortar la lechuga en trozos.
4. Cortar el pan en dados pequeños y tostarlos en una sartén con un poco de aceite hasta que estén crujientes.
5. Rallar o cortar el queso en láminas finas.
6. Montar la ensalada: disponer la lechuga como base, colocar las tiras de pollo encima.
7. Añadir los picatostes y el queso.
8. Aliñar con aceite de oliva virgen extra y servir.',
  15, 15, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Ensaladas', false, NULL,
  350, 32, 15, 18,
  false, false, true, true,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  '5fbca1f2-9b5f-40e6-bad3-72ff7098d2d3', 'Crema de calabacín', 'Crema suave y reconfortante de calabacín. Ligera, digestiva y perfecta como entrante o cena ligera.', '1. Pelar y picar la cebolla y la patata en trozos.
2. Lavar y cortar el calabacín en rodajas (no es necesario pelarlo).
3. En una olla, calentar el aceite de oliva y sofreír la cebolla hasta que esté transparente.
4. Añadir la patata y el calabacín, y rehogar 3-4 minutos.
5. Cubrir con agua o caldo de verduras.
6. Cocinar a fuego medio durante 20 minutos hasta que todas las verduras estén tiernas.
7. Triturar con batidora hasta obtener una crema fina.
8. Añadir un chorrito de leche si se desea más cremosa.
9. Rectificar de sal y servir con un hilo de aceite de oliva virgen extra.',
  10, 25, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Sopas y cremas', true, NULL,
  130, 4, 15, 6,
  true, false, true, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  '11691ff6-5c4d-46a5-8123-576bab2270e6', 'Arroz con verduras', 'Arroz salteado con verduras de temporada. Un plato completo, colorido y muy versátil que se puede adaptar a las verduras disponibles.', '1. Cocinar el arroz según las instrucciones del paquete. Escurrir y reservar.
2. Lavar y cortar todas las verduras: pimiento rojo en tiras, judías verdes en trozos, guisantes, calabacín en dados y zanahoria en rodajas finas.
3. Picar el ajo.
4. En un wok o sartén amplia, calentar el aceite de oliva.
5. Saltear el ajo 30 segundos.
6. Añadir la zanahoria y las judías verdes, cocinar 5 minutos.
7. Incorporar el pimiento, el calabacín y los guisantes, cocinar 5 minutos más.
8. Añadir el arroz cocido y mezclar bien con las verduras.
9. Saltear todo junto 3-4 minutos a fuego fuerte.
10. Salpimentar y servir caliente.',
  15, 25, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Arroces', true, NULL,
  290, 8, 48, 7,
  true, true, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  '1b0922c7-7928-4090-8268-1e4ff08b5ec5', 'Pechuga de pavo a la plancha', 'Pechuga de pavo a la plancha con guarnición de ensalada. Un plato alto en proteínas y bajo en grasa, ideal para una cena ligera y saludable.', '1. Salpimentar las pechugas de pavo.
2. Calentar una plancha o sartén con un poco de aceite de oliva.
3. Cocinar las pechugas de pavo 4-5 minutos por cada lado hasta que estén doradas y bien hechas.
4. Mientras tanto, preparar la guarnición: lavar y cortar la lechuga, el tomate en rodajas y el pepino.
5. Disponer la ensalada en los platos.
6. Colocar la pechuga de pavo cortada en láminas sobre la ensalada.
7. Aliñar con aceite de oliva virgen extra.
8. Servir inmediatamente.',
  10, 10, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Carnes', true, NULL,
  200, 34, 5, 5,
  false, false, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  'fdbcc366-0386-4826-b631-90a7c26f2002', 'Hummus casero', 'Hummus cremoso elaborado con garbanzos cocidos. Un aperitivo saludable de inspiración mediterránea, perfecto para untar con pan o crudités.', '1. Si se usan garbanzos secos, ponerlos en remojo la noche anterior y cocerlos hasta que estén muy tiernos. También se pueden usar garbanzos de bote, bien escurridos.
2. Pelar los ajos.
3. Colocar los garbanzos en el vaso de la batidora o procesador.
4. Añadir el ajo, el aceite de oliva virgen extra y un poco de agua de la cocción.
5. Triturar hasta obtener una crema fina y homogénea.
6. Si queda muy espeso, añadir un poco más de agua.
7. Salpimentar al gusto.
8. Servir en un plato con un chorrito de aceite de oliva por encima y unas semillas de chía como decoración.
9. Acompañar con pan integral tostado o palitos de zanahoria.',
  10, 0, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Aperitivos', false, NULL,
  220, 10, 24, 10,
  true, true, false, false,
  false, false, false, false, false
);

INSERT INTO "Receta" (
  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",
  "tipoComida","categoria","estiloEspanol","region",
  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",
  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",
  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"
) VALUES (
  'a1e1b174-ac9c-49e4-867b-9e7f66799b2b', 'Bowl de quinoa mediterráneo', 'Bowl nutritivo con quinoa como base, acompañado de verduras frescas, aguacate y frutos secos. Un plato moderno con ingredientes mediterráneos.', '1. Cocinar la quinoa: lavar bien bajo el grifo, poner en una olla con el doble de agua y cocinar 15 minutos hasta que absorba el agua. Dejar reposar tapada 5 minutos.
2. Lavar y cortar el tomate en dados.
3. Cortar el pepino en medias lunas.
4. Cortar el aguacate en láminas.
5. Lavar las espinacas frescas.
6. Tostar ligeramente las almendras en una sartén sin aceite.
7. Montar los bowls: poner una base de quinoa en cada plato.
8. Disponer las espinacas, el tomate, el pepino y el aguacate de forma ordenada.
9. Añadir las almendras tostadas y las aceitunas.
10. Aliñar con aceite de oliva virgen extra y sal.
11. Servir a temperatura ambiente.',
  15, 20, 'facil', 4,
  ARRAY['ALMUERZO', 'CENA'], 'Bowls', false, NULL,
  380, 12, 35, 22,
  true, true, false, false,
  false, false, false, false, false
);

-- ============================================================
-- 5. RECETA-ALIMENTO RELATIONSHIPS
-- ============================================================

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'dbb18b88-67a9-4cec-905f-db753b1c4514', 'f10376e0-3c09-439d-a0ff-af4702cf4d29', 'd85753ee-998f-4d85-a279-36651a685f69', 500, 'g', 'maduros'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '954c0210-5c95-4f8c-bdf8-07ee9c6db66e', 'f10376e0-3c09-439d-a0ff-af4702cf4d29', '50651b76-df78-4de1-b69a-f7f51ad90dfd', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'd7b65cd5-53f2-46bc-a8c4-dd439b970fcd', 'f10376e0-3c09-439d-a0ff-af4702cf4d29', '568ebad0-f152-439a-aa3b-9df702a3ec4b', 80, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '78d8a3f1-b0f7-4ce5-9c13-b6459c69227b', 'f10376e0-3c09-439d-a0ff-af4702cf4d29', '515a2d9c-3df2-4d77-a1d8-dda80cbd5f7e', 50, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '885e9599-df6f-4642-b38c-59bd52da5234', 'f10376e0-3c09-439d-a0ff-af4702cf4d29', '341a59f3-187c-4b29-9f16-d4b9faa1c620', 5, 'g', '1 diente'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '40431793-b64a-4fe1-ad2b-b9eeb88b96ac', 'f10376e0-3c09-439d-a0ff-af4702cf4d29', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 40, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '0ed298c2-bc15-40f0-8470-b43cf86a6698', 'e10f25e4-e94d-4257-8d5c-ad6c0ba8cbc8', '95391b4c-ae80-4337-97d4-90eba56e84ef', 400, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '80330aa6-662d-4686-8f63-1a0e38703f25', 'e10f25e4-e94d-4257-8d5c-ad6c0ba8cbc8', '924f1c64-1362-40f6-9ece-87176dbacaac', 240, 'g', '4 huevos'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'af6caa98-185b-440a-8323-aa82bdaa2f0d', 'e10f25e4-e94d-4257-8d5c-ad6c0ba8cbc8', '515a2d9c-3df2-4d77-a1d8-dda80cbd5f7e', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'f6ef1467-5314-4e30-b88f-2a30b3e5a8ce', 'e10f25e4-e94d-4257-8d5c-ad6c0ba8cbc8', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 60, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '3c51ecac-1805-4f05-ae65-1b2ce996f285', '7f9470fd-4bf8-45ef-9c3b-d3f62da603e5', 'ba10ce46-0cfc-4f88-b5c1-d694e601195e', 200, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'edbb8546-ba58-47e5-ada5-f8e6d4f2129f', '7f9470fd-4bf8-45ef-9c3b-d3f62da603e5', 'd85753ee-998f-4d85-a279-36651a685f69', 200, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'dc66fceb-1762-4ccf-8f6c-b12e4a8e5421', '7f9470fd-4bf8-45ef-9c3b-d3f62da603e5', '50651b76-df78-4de1-b69a-f7f51ad90dfd', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'a64ecdc5-79ff-4eea-bfaa-10be5ace72bb', '7f9470fd-4bf8-45ef-9c3b-d3f62da603e5', '4dedd88e-c55d-4ea1-ad4b-0dde90890f3c', 150, 'g', '1 aguacate'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'fcccc984-2caa-4181-9a8d-2db7ae76e420', '7f9470fd-4bf8-45ef-9c3b-d3f62da603e5', '587a6c42-f76a-450c-9fb1-6cbc96a7c463', 60, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'baa747c2-867c-4e8d-9b33-0af9bd0ddeb8', '7f9470fd-4bf8-45ef-9c3b-d3f62da603e5', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 30, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '2ddf0ca3-4d2f-4cfe-aed2-c9fd1bbd1cae', '325219ca-07cf-4bc2-9b98-ee85d1338c4b', '13037213-90d5-49df-a5c5-9a78c6eba69d', 600, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'b2c1d8bf-34cc-447c-a584-7bfe6784ac88', '325219ca-07cf-4bc2-9b98-ee85d1338c4b', '341a59f3-187c-4b29-9f16-d4b9faa1c620', 30, 'g', '6-8 dientes'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '9239134a-29e9-41ba-8a1f-9e8e8cdc68ae', '325219ca-07cf-4bc2-9b98-ee85d1338c4b', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 50, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'c826bbb1-fd54-4221-ac85-32bb605af022', '1e9b0e05-52e2-4592-b45a-ff9c62d2646f', 'cc76fd07-7c19-43e1-accd-b8de5744a5cb', 300, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '0d034a0c-30b6-446f-83ad-b1666b17648a', '1e9b0e05-52e2-4592-b45a-ff9c62d2646f', '491476ed-ae0e-4332-90b6-fedfbebac7d5', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'b4ee9b8d-f21a-4f46-9afb-0b562f1266c0', '1e9b0e05-52e2-4592-b45a-ff9c62d2646f', '95391b4c-ae80-4337-97d4-90eba56e84ef', 200, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '48d67219-2db3-404e-827a-6798ebdb809a', '1e9b0e05-52e2-4592-b45a-ff9c62d2646f', '515a2d9c-3df2-4d77-a1d8-dda80cbd5f7e', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '6024f7d1-a33d-41ed-b061-f75239eab236', '1e9b0e05-52e2-4592-b45a-ff9c62d2646f', '568ebad0-f152-439a-aa3b-9df702a3ec4b', 80, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'fbf32c09-5c96-4988-a18c-6b5e0864df47', '1e9b0e05-52e2-4592-b45a-ff9c62d2646f', '341a59f3-187c-4b29-9f16-d4b9faa1c620', 5, 'g', '1 diente'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'd545e786-dafc-44aa-adc1-268b28775973', '1e9b0e05-52e2-4592-b45a-ff9c62d2646f', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 30, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'e9a8efc6-bbeb-4d8c-8f8c-d1a766e32ce7', 'f4c2eb3a-94cd-452d-a904-353cf0565c10', 'f969539e-4ac0-4bc8-9f1c-2753f3f22a4a', 500, 'g', '4 lomos'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '964ccb64-22a2-41fe-9342-15a31e081718', 'f4c2eb3a-94cd-452d-a904-353cf0565c10', '6a065dfb-5d01-4a44-acd1-3e6067200293', 200, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'dc1cb1b1-3918-4308-95c7-e588b0a9f39b', 'f4c2eb3a-94cd-452d-a904-353cf0565c10', '92a00467-024c-4311-8754-a8e69fc15507', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'b5c3e6f6-a5f3-45d8-9c1f-a2043dba2897', 'f4c2eb3a-94cd-452d-a904-353cf0565c10', 'c3c4ec82-72b8-4b03-81e3-0652502d4f0e', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '4833bbf8-72a2-4561-aeb1-eab23bbf63e8', 'f4c2eb3a-94cd-452d-a904-353cf0565c10', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 30, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'ca683106-9a3d-4f8e-b971-71af6d3d3157', '245140cf-41f8-458d-b3d7-a58f039c0d7b', '972bb32d-4b18-4015-931b-68c03fecc424', 350, 'g', 'cocidos o de bote'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '30084166-b009-4e23-8d7b-967f622cbd3b', '245140cf-41f8-458d-b3d7-a58f039c0d7b', 'ab39a973-1215-4eb5-a4fe-6fe5d4ec1074', 300, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '4b42aa6f-8e7a-46a8-b67d-6c5757c606ce', '245140cf-41f8-458d-b3d7-a58f039c0d7b', '515a2d9c-3df2-4d77-a1d8-dda80cbd5f7e', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '2d682f0c-4baa-4aa6-b240-d64846e5c6f5', '245140cf-41f8-458d-b3d7-a58f039c0d7b', '341a59f3-187c-4b29-9f16-d4b9faa1c620', 10, 'g', '2 dientes'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'f75887aa-6961-4452-86e0-1a98f43ac058', '245140cf-41f8-458d-b3d7-a58f039c0d7b', 'd85753ee-998f-4d85-a279-36651a685f69', 100, 'g', 'rallado'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '79144322-79f3-41e8-bc7a-153dbe5083ba', '245140cf-41f8-458d-b3d7-a58f039c0d7b', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 30, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '00f347c4-5bc2-4657-95df-39b170512cd1', 'f0d9de11-cb07-4e43-8207-24ab6883764c', '3d53eca5-8b1f-4e53-9923-a82d0e4a4b08', 500, 'g', '4 lomos'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '757d84aa-3905-4d1b-92af-ba8ceb393679', 'f0d9de11-cb07-4e43-8207-24ab6883764c', '95391b4c-ae80-4337-97d4-90eba56e84ef', 400, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '2b1b5e9d-68d8-48b8-bc35-de58b5941634', 'f0d9de11-cb07-4e43-8207-24ab6883764c', '515a2d9c-3df2-4d77-a1d8-dda80cbd5f7e', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'bd396611-cd65-4ad7-9a81-561b50023c1d', 'f0d9de11-cb07-4e43-8207-24ab6883764c', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 30, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'ea711435-5304-4b9a-823a-8a626aa6e4dd', '5f200b6e-503a-493a-9761-fea3d4e01b57', '6a065dfb-5d01-4a44-acd1-3e6067200293', 200, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '52b4fc45-bafd-4065-91f1-c8f4c863ca40', '5f200b6e-503a-493a-9761-fea3d4e01b57', '9e5cc663-18bb-403b-930a-a541eed127ae', 200, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '9812b764-752f-49ba-b10a-50428e0792b0', '5f200b6e-503a-493a-9761-fea3d4e01b57', 'fb1b552c-a1ce-4207-82f2-303edfd425f2', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '445aef30-81f8-4e2c-b0ad-95cc1c0b516c', '5f200b6e-503a-493a-9761-fea3d4e01b57', '568ebad0-f152-439a-aa3b-9df702a3ec4b', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '70b03493-ec21-46a6-8655-41bf9661192f', '5f200b6e-503a-493a-9761-fea3d4e01b57', '515a2d9c-3df2-4d77-a1d8-dda80cbd5f7e', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '72d7abbc-4f24-4f7d-87d0-32b57f0f1bbe', '5f200b6e-503a-493a-9761-fea3d4e01b57', 'd85753ee-998f-4d85-a279-36651a685f69', 300, 'g', 'triturado'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'c50b335d-948d-450b-9456-0ef03dd6b9d1', '5f200b6e-503a-493a-9761-fea3d4e01b57', '341a59f3-187c-4b29-9f16-d4b9faa1c620', 5, 'g', '1 diente'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '767f9ec1-c161-4d94-8291-28ecfb5cc451', '5f200b6e-503a-493a-9761-fea3d4e01b57', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 40, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'b813bf80-b36e-413f-bc0f-d8ae28bb4471', 'e5fbd3e0-e184-47d2-8f1a-791a9074a43d', '13037213-90d5-49df-a5c5-9a78c6eba69d', 400, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '76dd9ebc-b92e-4b45-a00f-b86cc702ba80', 'e5fbd3e0-e184-47d2-8f1a-791a9074a43d', 'ba10ce46-0cfc-4f88-b5c1-d694e601195e', 300, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '5d49267c-c8a8-4923-bcc9-1e65b2533584', 'e5fbd3e0-e184-47d2-8f1a-791a9074a43d', '84b311c2-cad9-4211-8d73-12acfeb6e2f4', 80, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '596370cf-d5c2-40b4-97b7-4983b223b04e', 'e5fbd3e0-e184-47d2-8f1a-791a9074a43d', '807ffc3b-a95b-499e-81cd-e8c7d02285c6', 80, 'g', 'para picatostes'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '9469a3f0-ec91-4f16-87f8-49a410df9a79', 'e5fbd3e0-e184-47d2-8f1a-791a9074a43d', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 30, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'e21c3f26-9663-49e9-b3b9-df366ac3630f', '5fbca1f2-9b5f-40e6-bad3-72ff7098d2d3', '6a065dfb-5d01-4a44-acd1-3e6067200293', 500, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '7bc9f9f6-55d6-473e-9c37-1ee4d12754eb', '5fbca1f2-9b5f-40e6-bad3-72ff7098d2d3', '95391b4c-ae80-4337-97d4-90eba56e84ef', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'da3a3075-86e5-42db-88bf-a86c43c37daa', '5fbca1f2-9b5f-40e6-bad3-72ff7098d2d3', '515a2d9c-3df2-4d77-a1d8-dda80cbd5f7e', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '1ab8ae99-e67d-4b66-a2f9-8913a515d34a', '5fbca1f2-9b5f-40e6-bad3-72ff7098d2d3', 'ed87c4ba-d91e-43ba-9760-4e12a1d70258', 100, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '5f13ebf0-27cd-49ef-b1c7-21d0e58e8233', '5fbca1f2-9b5f-40e6-bad3-72ff7098d2d3', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 20, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '4247e9b8-2043-40b4-b7b3-86509bb65b34', '11691ff6-5c4d-46a5-8123-576bab2270e6', '4e70e0bb-5012-4f09-93e8-870347b7902d', 280, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'e983a9dc-a1b3-4485-9bde-e956e68e23c5', '11691ff6-5c4d-46a5-8123-576bab2270e6', 'fb1b552c-a1ce-4207-82f2-303edfd425f2', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '9661c7f7-3bae-4dab-85b1-99d847e34bd9', '11691ff6-5c4d-46a5-8123-576bab2270e6', 'c3c4ec82-72b8-4b03-81e3-0652502d4f0e', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'da26a117-5c4f-404f-874c-c149b27fa7cf', '11691ff6-5c4d-46a5-8123-576bab2270e6', '0c23b81a-3cc6-4c23-be69-9da996082899', 80, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '7fe2fc57-e8ea-4fa4-9c66-17ae3784062d', '11691ff6-5c4d-46a5-8123-576bab2270e6', '6a065dfb-5d01-4a44-acd1-3e6067200293', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '1922b195-fc1c-4ca1-afd1-e1be0a691423', '11691ff6-5c4d-46a5-8123-576bab2270e6', '491476ed-ae0e-4332-90b6-fedfbebac7d5', 80, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '964f8450-c5c0-48aa-8412-698250951f96', '11691ff6-5c4d-46a5-8123-576bab2270e6', '341a59f3-187c-4b29-9f16-d4b9faa1c620', 5, 'g', '1 diente'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '6aaadc55-e462-4e34-8a3c-7dac5537b051', '11691ff6-5c4d-46a5-8123-576bab2270e6', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 25, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '541db142-5440-4cd6-85ba-d178833675f7', '1b0922c7-7928-4090-8268-1e4ff08b5ec5', '8101371e-41f7-44ab-bc66-bd4b88814da5', 500, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '97a78544-753a-4c3f-9dbd-bc087d284165', '1b0922c7-7928-4090-8268-1e4ff08b5ec5', 'ba10ce46-0cfc-4f88-b5c1-d694e601195e', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '9aa8c14b-5a42-490f-a09f-b7c9727b8d9c', '1b0922c7-7928-4090-8268-1e4ff08b5ec5', 'd85753ee-998f-4d85-a279-36651a685f69', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '1fa367f2-735d-4797-90c9-9f230b2a7df1', '1b0922c7-7928-4090-8268-1e4ff08b5ec5', '50651b76-df78-4de1-b69a-f7f51ad90dfd', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'db0dd846-8536-4a0e-9ae4-04c8c8010e92', '1b0922c7-7928-4090-8268-1e4ff08b5ec5', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 20, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '12db90a8-bb58-4df2-88ce-32a11abe6e9a', 'fdbcc366-0386-4826-b631-90a7c26f2002', '972bb32d-4b18-4015-931b-68c03fecc424', 400, 'g', 'cocidos'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'de557b27-8820-4292-b659-d930bf3942d8', 'fdbcc366-0386-4826-b631-90a7c26f2002', '341a59f3-187c-4b29-9f16-d4b9faa1c620', 5, 'g', '1 diente'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'a346f8fd-a5b8-4bce-8556-053c327f333d', 'fdbcc366-0386-4826-b631-90a7c26f2002', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 40, 'ml', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '34e317b6-377e-4abb-8898-1a33a45e1862', 'fdbcc366-0386-4826-b631-90a7c26f2002', '6f5579bb-1bbc-49b9-8ef1-d95b8add1e68', 10, 'g', 'para decorar'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'c40702e7-89df-4b6b-bebe-11b1bfe4c051', 'a1e1b174-ac9c-49e4-867b-9e7f66799b2b', '5c99afc8-56ca-460d-bbe7-3cab359a9ff0', 200, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '05288755-74e6-4770-8563-b61a068cffc0', 'a1e1b174-ac9c-49e4-867b-9e7f66799b2b', 'd85753ee-998f-4d85-a279-36651a685f69', 150, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  'dbc50690-58d2-4bdd-82de-730a10e90349', 'a1e1b174-ac9c-49e4-867b-9e7f66799b2b', '50651b76-df78-4de1-b69a-f7f51ad90dfd', 100, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '78b39df5-3680-4f98-b277-0a540c3fbfa8', 'a1e1b174-ac9c-49e4-867b-9e7f66799b2b', '4dedd88e-c55d-4ea1-ad4b-0dde90890f3c', 150, 'g', '1 aguacate'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '02c388ad-24d2-47fd-9e29-abd9cfa5a77a', 'a1e1b174-ac9c-49e4-867b-9e7f66799b2b', 'ab39a973-1215-4eb5-a4fe-6fe5d4ec1074', 100, 'g', 'frescas'
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '4b1bbd71-f59e-45fe-926e-0f679a997ca9', 'a1e1b174-ac9c-49e4-867b-9e7f66799b2b', 'c276ac58-fc5d-45a0-95b1-38b76eff6edb', 40, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '4c2b9215-3425-4f36-a5ac-587bc5c03e36', 'a1e1b174-ac9c-49e4-867b-9e7f66799b2b', '587a6c42-f76a-450c-9fb1-6cbc96a7c463', 40, 'g', NULL
);

INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (
  '180cc0e5-979d-4c0c-a0cb-640343314c51', 'a1e1b174-ac9c-49e4-867b-9e7f66799b2b', '6a153403-6ae7-45d7-bcdc-2961f8deee1c', 30, 'ml', NULL
);

-- ============================================================
-- 6. CONVERSACION Y MENSAJE DE BIENVENIDA
-- ============================================================

INSERT INTO "Conversacion" ("id","pacienteId","ultimoMensaje","ultimaActividad","noLeidos") VALUES (
  'conv-001-bienvenida', 'ef913e7c-9c44-4c8f-a6e3-faf450bf4356', '¡Hola! Bienvenido a NutriPlan Pro', NOW(), 0
);

INSERT INTO "Mensaje" ("id","conversacionId","remitenteId","destinatarioId","contenido","tipo","leido","createdAt") VALUES (
  'msg-001-bienvenida', 'conv-001-bienvenida', '28dd0c3e-8314-483f-828e-73aa21a33faf', 'ccd2ff44-446f-435b-8009-a9da93bdea8c', '¡Hola Carlos! Bienvenido a NutriPlan Pro. Estoy aquí para ayudarte con tu plan nutricional.', 'texto', true, NOW()
);
