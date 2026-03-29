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



-- ==================== SEED DATA ====================

-- Users
INSERT INTO "User" (id, email, password, nombre, apellidos, rol, telefono, "createdAt", "updatedAt") VALUES ('fd100b9e-5dc7-4104-9b1d-f0a846f4d426', 'nutricionista@nutriplanpro.com', '$2a$10$xVqYLGEES8bfGxM8cDVcpOIMDKp5bCWQJ6R.HYkOzIqCuDmhJWLTu', 'María', 'García López', 'NUTRICIONISTA', '+34612345678', NOW(), NOW());
INSERT INTO "User" (id, email, password, nombre, apellidos, rol, telefono, "createdAt", "updatedAt") VALUES ('abfa8930-8e4a-418e-a437-fe9beb29570f', 'paciente@nutriplanpro.com', '$2a$10$H.WfPdRiJQRIa3hvu3bz5.LjPPATGU5MBhYDlBPyqGGy/UrIFNVG6', 'María', 'López Martín', 'PACIENTE', '+34698765432', NOW(), NOW());

-- Nutricionista
INSERT INTO "Nutricionista" (id, "userId", "numColegiado", especialidad, clinica, direccion, "whatsappNumber", bio) VALUES ('908129b6-9e04-4134-bde2-b308b0cd7882', 'fd100b9e-5dc7-4104-9b1d-f0a846f4d426', 'MAD-1234', 'Nutrición clínica y deportiva', 'NutriPlan Pro Clinic', 'Calle Gran Vía 1, Madrid', '+34676002647', 'Nutricionista colegiada con 10 años de experiencia en nutrición clínica y deportiva.');

-- Paciente
INSERT INTO "Paciente" (id, "userId", "nutricionistaId", "fechaNacimiento", sexo, altura, "pesoActual", "pesoObjetivo", imc, "createdAt", "updatedAt") VALUES ('b88b8fe8-0b11-49eb-af4e-50f6e8734a25', 'abfa8930-8e4a-418e-a437-fe9beb29570f', '908129b6-9e04-4134-bde2-b308b0cd7882', '1990-05-15', 'MASCULINO', 178, 85, 78, 26.8, NOW(), NOW());

-- Conversacion y Mensaje
INSERT INTO "Conversacion" (id, "pacienteId", "ultimoMensaje", "createdAt", "updatedAt") VALUES ('ba9e3648-0466-442b-b6fe-7fa2c22faba9', 'b88b8fe8-0b11-49eb-af4e-50f6e8734a25', '¡Hola! Bienvenido a NutriPlan Pro', NOW(), NOW());
INSERT INTO "Mensaje" (id, "conversacionId", "remitenteId", "destinatarioId", contenido, tipo, leido, "createdAt") VALUES ('ce02c77b-1b0c-4e25-ba62-3f2353c315e6', 'ba9e3648-0466-442b-b6fe-7fa2c22faba9', 'fd100b9e-5dc7-4104-9b1d-f0a846f4d426', 'abfa8930-8e4a-418e-a437-fe9beb29570f', '¡Hola! Bienvenido a NutriPlan Pro. Estoy aquí para ayudarte con tu plan nutricional.', 'texto', true, NOW());

-- Alimentos (156 total)
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('70d690b1-bee5-4be4-bb7e-6d3f751a2f3f', 'Leche entera', 'LACTEOS', 'Leche', 63, 3.1, 4.7, 3.5, NULL, 200, '1 vaso', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('edfadb0c-6b1f-48e7-8965-fe8f10dc63ed', 'Leche desnatada', 'LACTEOS', 'Leche', 34, 3.4, 4.8, 0.1, NULL, 200, '1 vaso', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('2a42a231-f9ae-42b4-903f-49ccc3686ed3', 'Yogur natural', 'LACTEOS', 'Yogur', 61, 3.5, 4.7, 3.3, NULL, 125, '1 unidad', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('ac80004a-2239-42fc-b7d2-2038604c3676', 'Queso fresco', 'LACTEOS', 'Queso', 174, 11.3, 2.5, 13.3, NULL, 60, '2 lonchas', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('4f9f6eee-929e-495f-84ee-fd801a719040', 'Queso manchego', 'LACTEOS', 'Queso', 376, 26, 0.5, 30, NULL, 30, '1 loncha gruesa', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('ce56df27-c8db-4bd7-83dc-c6dbda1e36b9', 'Requesón', 'LACTEOS', 'Queso', 96, 13.6, 1.4, 4.3, NULL, 100, '1 tarrina pequeña', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('7ca01354-89c5-45d0-b9cb-cf717df520ff', 'Manzana', 'FRUTAS', NULL, 52, 0.3, 13.8, 0.2, 2.4, 150, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('71c42525-94b5-4d2f-a621-fb599870147e', 'Plátano', 'FRUTAS', NULL, 89, 1.1, 22.8, 0.3, 2.6, 80, '1 unidad pequeña', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('5f9e4e27-ab25-4345-a4d6-2d5466967a60', 'Naranja', 'FRUTAS', NULL, 47, 0.9, 11.7, 0.1, 2.4, 200, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"invierno","primavera"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('ffc45918-8446-44fe-a9e0-0f6530a17027', 'Fresa', 'FRUTAS', NULL, 33, 0.7, 7.7, 0.3, 2, 200, '8-10 unidades', true, true, false, false, false, false, false, false, false, '{"primavera"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('fd6c8291-0b21-452c-81f7-9d7d03954855', 'Uva', 'FRUTAS', NULL, 69, 0.7, 18.1, 0.2, 0.9, 100, '1 racimo pequeño', true, true, false, false, false, false, false, false, false, '{"otoño"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('4bea6e26-e922-4bca-87c6-680b73240f3c', 'Pera', 'FRUTAS', NULL, 57, 0.4, 15.2, 0.1, 3.1, 150, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('1b518ff7-9552-4a6c-a3d3-0277123ba9c5', 'Melocotón', 'FRUTAS', NULL, 39, 0.9, 9.5, 0.3, 1.5, 200, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('fe8c4e14-815a-4336-88a8-4b07dd1ca783', 'Sandía', 'FRUTAS', NULL, 30, 0.6, 7.6, 0.2, 0.4, 250, '1 tajada', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('e8993deb-f40b-472d-be87-4134277d5594', 'Melón', 'FRUTAS', NULL, 34, 0.8, 8.2, 0.2, 0.9, 250, '1 tajada', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('19de0e87-2295-45f8-8ecf-e58a09ee3203', 'Kiwi', 'FRUTAS', NULL, 61, 1.1, 14.7, 0.5, 3, 100, '1 unidad', true, true, false, false, false, false, false, false, false, '{"invierno","primavera"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('760c92e8-f5f1-464d-8fd5-6ad1cec37c9a', 'Piña', 'FRUTAS', NULL, 50, 0.5, 13.1, 0.1, 1.4, 150, '2 rodajas', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('a44bb7e9-0872-4dd6-81a7-5c7945f24773', 'Mandarina', 'FRUTAS', NULL, 53, 0.8, 13.3, 0.3, 1.8, 150, '2 unidades', true, true, false, false, false, false, false, false, false, '{"invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('0cf62664-c768-408e-9d5c-e3ff9b619745', 'Tomate', 'VERDURAS_HORTALIZAS', NULL, 18, 0.9, 3.9, 0.2, 1.2, 200, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('96ea7f66-cfda-4aba-8bde-51beb14c1f48', 'Lechuga', 'VERDURAS_HORTALIZAS', NULL, 15, 1.4, 2.9, 0.2, 1.3, 100, '1 plato de ensalada', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('013fc351-1cb6-4035-9f4d-c874d3976b09', 'Pepino', 'VERDURAS_HORTALIZAS', NULL, 16, 0.7, 3.6, 0.1, 0.5, 200, '1 unidad', true, true, false, false, false, false, false, false, false, '{"primavera","verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('4797d7bc-cea4-45db-bcbd-894e4a37179b', 'Zanahoria', 'VERDURAS_HORTALIZAS', NULL, 41, 0.9, 9.6, 0.2, 2.8, 100, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('e20fd3b0-5551-4eda-bd55-68b8c283fa45', 'Cebolla', 'VERDURAS_HORTALIZAS', NULL, 40, 1.1, 9.3, 0.1, 1.7, 100, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('031ef32f-ae88-4362-aa5e-ab9982983df7', 'Pimiento rojo', 'VERDURAS_HORTALIZAS', NULL, 31, 1, 6, 0.3, 2.1, 150, '1 unidad', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('01e0e42f-f54f-4ead-b02e-c5e26a90a6e1', 'Pimiento verde', 'VERDURAS_HORTALIZAS', NULL, 20, 0.9, 4.6, 0.2, 1.7, 150, '1 unidad', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('ec9e1c4d-9b2d-4bd3-83ab-8801750e8fbc', 'Espinacas', 'VERDURAS_HORTALIZAS', NULL, 23, 2.9, 3.6, 0.4, 2.2, 200, '1 plato', true, true, false, false, false, false, false, false, false, '{"otoño","invierno","primavera"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('52595d0d-32e4-4c7c-9e63-14bff7c573e8', 'Brócoli', 'VERDURAS_HORTALIZAS', NULL, 34, 2.8, 6.6, 0.4, 2.6, 200, '1 plato', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('58b5fe1f-7250-479e-a8a6-74215c4eef8c', 'Calabacín', 'VERDURAS_HORTALIZAS', NULL, 17, 1.2, 3.1, 0.3, 1, 200, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"primavera","verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('8737b15b-4506-47e2-9dee-a9f832cb6f48', 'Judías verdes', 'VERDURAS_HORTALIZAS', NULL, 31, 1.8, 7, 0.1, 3.4, 200, '1 plato', true, true, false, false, false, false, false, false, false, '{"primavera","verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('99970995-5e92-40d4-a217-e5c20e370811', 'Berenjena', 'VERDURAS_HORTALIZAS', NULL, 25, 1, 5.9, 0.2, 3, 200, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('426156dc-e082-48ac-8db9-38c14b5a6cbd', 'Champiñón', 'VERDURAS_HORTALIZAS', 'Setas', 22, 3.1, 3.3, 0.3, 1, 200, '6-8 unidades', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 'Ajo', 'VERDURAS_HORTALIZAS', 'Condimento', 149, 6.4, 33.1, 0.5, 2.1, 5, '1 diente', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('a4df24a0-5d5e-4c1a-af39-2bfcd0e0f8ac', 'Arroz blanco', 'CEREALES_TUBERCULOS', 'Cereales', 130, 2.7, 28.2, 0.3, 0.4, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('0e4a144e-e9a8-4e15-beda-8bb741246e30', 'Pan integral', 'CEREALES_TUBERCULOS', 'Pan', 247, 13, 41.3, 3.4, 6.8, 40, '2 rebanadas', true, true, false, true, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('0e701242-ab76-4e8f-ae4a-9d4714df423e', 'Pasta', 'CEREALES_TUBERCULOS', 'Cereales', 131, 5, 25.4, 1.1, 1.8, 60, '60g en crudo', true, true, false, true, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('86c84342-6b45-4c3d-a7e4-03a32e7f896e', 'Patata', 'CEREALES_TUBERCULOS', 'Tubérculos', 77, 2, 17.5, 0.1, 2.2, 150, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('799518ff-1bf1-41d5-939c-d835c9c84f3d', 'Avena', 'CEREALES_TUBERCULOS', 'Cereales', 389, 16.9, 66.3, 6.9, 10.6, 30, '3 cucharadas soperas', true, true, false, true, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('efcc7d8c-5c41-4d79-9f40-6175c7e432db', 'Pan blanco', 'CEREALES_TUBERCULOS', 'Pan', 265, 9.4, 49.1, 3.2, 2.7, 40, '2 rebanadas', true, true, false, true, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('dd917f29-1533-44ef-8832-ef88194bc62f', 'Maíz', 'CEREALES_TUBERCULOS', 'Cereales', 86, 3.3, 18.7, 1.4, 2, 100, '1 mazorca pequeña', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('d7552046-940a-4a7e-b575-70d83e143dc1', 'Quinoa', 'CEREALES_TUBERCULOS', 'Pseudocereal', 120, 4.4, 21.3, 1.9, 2.8, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('5d4e86d8-4987-4f35-8a07-a0bd24f16ae3', 'Lentejas', 'LEGUMBRES', NULL, 353, 24.6, 54, 1.1, 10.7, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('cd50880d-ac6d-4564-a1f4-9dec5298c8e1', 'Garbanzos', 'LEGUMBRES', NULL, 364, 19.3, 55, 5, 15.5, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('debd3546-06e1-4724-a4f9-ff6ca16d8f8f', 'Alubias blancas', 'LEGUMBRES', NULL, 333, 21.1, 52.5, 1.6, 15.2, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('eab7eba7-a6f7-4d9a-b0e3-a9cbf058796e', 'Judiones', 'LEGUMBRES', NULL, 329, 20.2, 50.8, 1.4, 14, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('e592bee9-125c-4e54-965b-5168a5d819ae', 'Guisantes', 'LEGUMBRES', NULL, 341, 24.5, 49, 1.2, 16.6, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('d19aaef4-7040-48ff-85ea-e8f0cf1fcca5', 'Lentejas rojas', 'LEGUMBRES', NULL, 358, 25.4, 56.3, 1.3, 7.4, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('fcbfa81a-80ca-43f2-be47-ffbc6caa5682', 'Habas secas', 'LEGUMBRES', NULL, 341, 26.1, 46, 1.5, 13.1, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('7ff780b9-f9a4-4a2a-8563-c4a7d102daba', 'Pechuga de pollo', 'CARNES_PESCADOS_HUEVOS', 'Carnes magras', 165, 31, 0, 3.6, NULL, 100, '1 filete mediano', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('294f7579-1f90-4b00-ae42-214f9ed1ec20', 'Ternera', 'CARNES_PESCADOS_HUEVOS', 'Carnes magras', 131, 22, 0, 4.8, NULL, 100, '1 filete mediano', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('fe25960f-6071-4d78-b572-9003874e0048', 'Cerdo', 'CARNES_PESCADOS_HUEVOS', 'Carnes magras', 143, 26.2, 0, 3.5, NULL, 100, '1 filete mediano', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('9e49e501-0991-4193-a53a-e05567199477', 'Chuleta de cerdo', 'CARNES_PESCADOS_HUEVOS', 'Carnes semigrasa', 215, 22.4, 0, 13.8, NULL, 100, '1 chuleta mediana', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('c47669f8-11a4-4742-a764-71f6b7667188', 'Huevo', 'CARNES_PESCADOS_HUEVOS', 'Huevos', 155, 13, 1.1, 11, NULL, 60, '1 huevo mediano', true, false, false, false, false, true, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('e6c5e7e6-c71d-41f0-853e-633105bb9075', 'Salmón', 'CARNES_PESCADOS_HUEVOS', 'Pescado azul', 208, 20.4, 0, 13.6, NULL, 130, '1 rodaja mediana', false, false, false, false, false, false, true, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('b9f2feb2-b7f9-497b-8080-1e41fc71da68', 'Merluza', 'CARNES_PESCADOS_HUEVOS', 'Pescado blanco', 82, 17.2, 0, 1.3, NULL, 130, '1 rodaja mediana', false, false, false, false, false, false, true, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('eb55bb9a-159f-4f56-98d2-0f70ce233a48', 'Atún', 'CARNES_PESCADOS_HUEVOS', 'Pescado azul', 144, 23.3, 0, 4.9, NULL, 130, '1 rodaja mediana', false, false, false, false, false, false, true, false, false, '{"primavera","verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('c4c8b7fa-96e8-48a0-b317-5a49f1cae4a0', 'Sardinas', 'CARNES_PESCADOS_HUEVOS', 'Pescado azul', 208, 24.6, 0, 11.5, NULL, 130, '4-5 sardinas medianas', false, false, false, false, false, false, true, false, false, '{"primavera","verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('011e4fd0-a00b-4c99-b513-e4fe491826a1', 'Gambas', 'CARNES_PESCADOS_HUEVOS', 'Marisco', 99, 20.3, 0.2, 1.7, NULL, 130, '8-10 gambas medianas', false, false, false, false, false, false, false, true, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('947728c4-2582-4959-b16e-32c2238187e1', 'Pulpo', 'CARNES_PESCADOS_HUEVOS', 'Marisco', 82, 14.9, 2.2, 1, NULL, 130, '1 ración mediana', false, false, false, false, false, false, false, true, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('d599ab63-a8aa-4020-b6b9-7bd41a8257e2', 'Jamón serrano', 'CARNES_PESCADOS_HUEVOS', 'Embutidos y fiambres', 241, 31, 0, 12.8, NULL, 40, '2-3 lonchas finas', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('d18ae0ec-f4e7-4daf-9924-85cb0e9d0227', 'Jamón york', 'CARNES_PESCADOS_HUEVOS', 'Embutidos y fiambres', 131, 18.4, 1.5, 5.8, NULL, 40, '2-3 lonchas', false, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('9e5f2b46-4a12-4a78-8e40-9655534d1935', 'Pavo', 'CARNES_PESCADOS_HUEVOS', 'Carnes magras', 135, 30, 0, 1.2, NULL, 100, '1 filete mediano', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('45103287-71a2-41b0-a369-428de105dee7', 'Muslo de pollo', 'CARNES_PESCADOS_HUEVOS', 'Carnes semigrasa', 177, 24.2, 0, 8.4, NULL, 100, '1 muslo mediano sin piel', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('a93c5690-1db0-47df-a9d5-dee5da31059b', 'Bacalao fresco', 'CARNES_PESCADOS_HUEVOS', 'Pescado blanco', 82, 18, 0, 0.7, NULL, 130, '1 trozo mediano', false, false, false, false, false, false, true, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('6e559c59-7801-402a-b036-74379884f773', 'Lubina', 'CARNES_PESCADOS_HUEVOS', 'Pescado blanco', 97, 18.4, 0, 2.5, NULL, 130, '1 ración mediana', false, false, false, false, false, false, true, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('330bffc1-6a8e-4002-a5c2-f21ae1f3fa0e', 'Mejillones', 'CARNES_PESCADOS_HUEVOS', 'Marisco', 86, 11.9, 3.7, 2.2, NULL, 130, '15-20 mejillones', false, false, false, false, false, false, false, true, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 'Aceite de oliva virgen extra', 'GRASAS', 'Aceites vegetales', 884, 0, 0, 100, NULL, 10, '1 cucharada sopera', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('1628667e-452d-4cea-9236-e5a6b4a5a8b4', 'Mantequilla', 'GRASAS', 'Grasas animales', 717, 0.9, 0.1, 81.1, NULL, 12, '1 porción individual', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('f43b19a4-a1e6-48db-8d59-e6d2d9a66383', 'Aguacate', 'GRASAS', 'Grasas vegetales', 160, 2, 8.5, 14.7, 6.7, 70, 'medio aguacate', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('2a1a5d89-5c88-4470-9afd-0429f87443f7', 'Aceitunas', 'GRASAS', 'Grasas vegetales', 145, 1, 3.8, 13.9, 3.3, 30, '8-10 aceitunas', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('d5aabfd2-c863-4cdc-a2ef-91654a6d1bcc', 'Aceitunas negras', 'GRASAS', 'Grasas vegetales', 115, 0.8, 6.3, 10.7, 3.2, 30, '8-10 aceitunas', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('d541c64f-7034-4ba0-a50d-5a07153e0e06', 'Aceite de girasol', 'GRASAS', 'Aceites vegetales', 884, 0, 0, 100, NULL, 10, '1 cucharada sopera', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('b33779af-f2f7-441d-b749-762e45141fa2', 'Almendras', 'FRUTOS_SECOS', NULL, 579, 21.2, 21.6, 49.9, 12.5, 20, '15-20 almendras', true, true, false, false, true, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('8fecbd5b-79a1-4019-b570-ada7373fadcc', 'Nueces', 'FRUTOS_SECOS', NULL, 654, 15.2, 13.7, 65.2, 6.7, 20, '4-5 nueces enteras', true, true, false, false, true, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('bb59e1d0-0d6b-43b0-b3ad-fcfa5c417a0d', 'Avellanas', 'FRUTOS_SECOS', NULL, 628, 15, 16.7, 60.8, 9.7, 20, '15-18 avellanas', true, true, false, false, true, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('10abcf84-f191-4f72-af6e-b9906765156c', 'Pistachos', 'FRUTOS_SECOS', NULL, 560, 20.2, 27.2, 45.3, 10.6, 20, '25-30 pistachos', true, true, false, false, true, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('6147f4d1-db87-4d1c-a71a-74813139e2de', 'Semillas de chía', 'FRUTOS_SECOS', 'Semillas', 486, 16.5, 42.1, 30.7, 34.4, 15, '1 cucharada sopera', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('f4f2f939-2858-4bf0-8fdf-581e8fbdbe51', 'Semillas de lino', 'FRUTOS_SECOS', 'Semillas', 534, 18.3, 28.9, 42.2, 27.3, 15, '1 cucharada sopera', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('5ba58dfe-e10d-4555-93b9-a39bf6f5143f', 'Piñones', 'FRUTOS_SECOS', NULL, 673, 13.7, 13.1, 68.4, 3.7, 20, '2 cucharadas soperas', true, true, false, false, true, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('2973f1ae-5aa6-4507-8257-e4f11830a539', 'Anacardos', 'FRUTOS_SECOS', NULL, 553, 18.2, 30.2, 43.9, 3.3, 20, '15-18 anacardos', true, true, false, false, true, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('877aabb7-2587-4d90-b8ed-c39a22660a75', 'Semillas de calabaza', 'FRUTOS_SECOS', 'Semillas', 559, 30.2, 10.7, 49.1, 6, 15, '1 cucharada sopera', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('95244ce1-9091-43b1-8bd5-b248b0540477', 'Semillas de girasol', 'FRUTOS_SECOS', 'Semillas', 584, 20.8, 20, 51.5, 8.6, 15, '1 cucharada sopera', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('5d9a03a2-42c1-490a-96aa-952d1aead63b', 'Leche semidesnatada', 'LACTEOS', 'Leche', 46, 3.2, 4.8, 1.6, NULL, 200, '1 vaso', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('40721e20-bafb-45e0-bd7c-0152bf7c95ea', 'Yogur griego', 'LACTEOS', 'Yogur', 97, 9, 3.6, 5, NULL, 125, '1 unidad', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('c00cd3df-e554-489a-876e-4d08c5adf0b1', 'Queso de cabra', 'LACTEOS', 'Queso', 364, 21.6, 0.1, 30.5, NULL, 30, '1 loncha gruesa', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('eaf90c35-2845-4e0e-96ed-ba2ff8ee8cf5', 'Queso de Burgos', 'LACTEOS', 'Queso', 174, 15, 2.5, 11, NULL, 60, '1 porción', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('9dba564a-cfe7-4e9e-990a-739dddc3b13b', 'Kéfir', 'LACTEOS', 'Lácteos fermentados', 41, 3.3, 4.7, 1, NULL, 200, '1 vaso', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('e399ae02-23d0-48e7-a1e1-ff6c69fdba52', 'Nata líquida', 'LACTEOS', 'Nata', 308, 2.1, 3.4, 31.7, NULL, 30, '2 cucharadas soperas', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('ea7b0dc8-2864-48fa-be5f-0214fd1581fe', 'Queso mozzarella', 'LACTEOS', 'Queso', 280, 27.5, 3.1, 17.1, NULL, 40, '1 bola pequeña', true, false, true, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('7050e25d-7ab1-42d1-a4e3-6bf9da64972d', 'Cereza', 'FRUTAS', NULL, 63, 1.1, 16, 0.2, 2.1, 120, '15-20 cerezas', true, true, false, false, false, false, false, false, false, '{"primavera","verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('a0c75005-0a0c-409d-b040-3325cc376a25', 'Ciruela', 'FRUTAS', NULL, 46, 0.7, 11.4, 0.3, 1.4, 150, '2-3 unidades', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('35e7e949-8018-4761-93a2-95cb050bb99d', 'Albaricoque', 'FRUTAS', NULL, 48, 1.4, 11.1, 0.4, 2, 150, '3-4 unidades', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('eecfcaae-8b58-4805-a16c-e219cd9f131c', 'Higo', 'FRUTAS', NULL, 74, 0.8, 19.2, 0.3, 2.9, 120, '2-3 higos', true, true, false, false, false, false, false, false, false, '{"verano","otoño"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('301be52e-535e-4258-8ccf-195cb0e118e3', 'Granada', 'FRUTAS', NULL, 68, 1.7, 17.2, 1.2, 4, 100, '1 unidad pequeña', true, true, false, false, false, false, false, false, false, '{"otoño"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('e1030f25-45d7-4310-98bd-af5cd2615d48', 'Mango', 'FRUTAS', NULL, 60, 0.8, 15, 0.4, 1.6, 120, 'medio mango', true, true, false, false, false, false, false, false, false, '{"verano","otoño"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('20ce360c-897a-4060-950c-6deccba5b441', 'Papaya', 'FRUTAS', NULL, 43, 0.5, 10.8, 0.3, 1.7, 200, '1 porción grande', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('2ea2501a-3eae-418c-a267-762d0620a610', 'Frambuesa', 'FRUTAS', NULL, 52, 1.2, 11.9, 0.7, 6.5, 125, '1 tarrina', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('616662a5-0e45-4508-aa44-0dee838e0bb8', 'Arándano', 'FRUTAS', NULL, 57, 0.7, 14.5, 0.3, 2.4, 125, '1 tarrina', true, true, false, false, false, false, false, false, false, '{"verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('374f68bd-c07b-48f3-b23b-2625d9f3ae97', 'Limón', 'FRUTAS', NULL, 29, 1.1, 9.3, 0.3, 2.8, 100, '1 unidad', true, true, false, false, false, false, false, false, false, '{"invierno","primavera"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('09f82e2a-ec09-4af3-ae40-410cfb55341b', 'Pomelo', 'FRUTAS', NULL, 42, 0.8, 10.7, 0.1, 1.6, 200, 'medio pomelo', true, true, false, false, false, false, false, false, false, '{"invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('74f62e11-0aaf-4744-9486-2bb2b7b23ad7', 'Caqui', 'FRUTAS', NULL, 70, 0.6, 18.6, 0.2, 3.6, 120, '1 unidad', true, true, false, false, false, false, false, false, false, '{"otoño"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('9bf8edad-e100-4997-b1a0-86d20c30e2ad', 'Níspero', 'FRUTAS', NULL, 47, 0.4, 12.1, 0.2, 1.7, 150, '3-4 unidades', true, true, false, false, false, false, false, false, false, '{"primavera"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('cb06ba88-dbc2-4ce6-a9c1-40e0e4d5f2a8', 'Coliflor', 'VERDURAS_HORTALIZAS', NULL, 25, 1.9, 5, 0.3, 2, 200, '1 plato', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('c85d7885-f804-434f-aa20-73c5bba4df07', 'Col rizada (kale)', 'VERDURAS_HORTALIZAS', NULL, 49, 4.3, 8.8, 0.9, 3.6, 100, '1 plato', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('0459a308-463b-4c25-b477-104a656cfdd5', 'Acelga', 'VERDURAS_HORTALIZAS', NULL, 19, 1.8, 3.7, 0.2, 1.6, 200, '1 plato', true, true, false, false, false, false, false, false, false, '{"otoño","invierno","primavera"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('f85786c8-a56c-448a-9c4d-f0abbe803973', 'Alcachofa', 'VERDURAS_HORTALIZAS', NULL, 47, 3.3, 10.5, 0.2, 5.4, 150, '2 alcachofas medianas', true, true, false, false, false, false, false, false, false, '{"otoño","invierno","primavera"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('8ad2904f-6c41-4b0c-949a-72e8aa8bff9a', 'Espárrago verde', 'VERDURAS_HORTALIZAS', NULL, 20, 2.2, 3.9, 0.1, 2.1, 200, '6-8 espárragos', true, true, false, false, false, false, false, false, false, '{"primavera"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('953f23d2-ce04-40cc-8e9f-1f24a2e50be4', 'Espárrago blanco', 'VERDURAS_HORTALIZAS', NULL, 20, 2.2, 3.1, 0.2, 1.7, 200, '6-8 espárragos', true, true, false, false, false, false, false, false, false, '{"primavera"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('e909baee-fc81-4b43-82ff-05293ad80041', 'Puerro', 'VERDURAS_HORTALIZAS', NULL, 61, 1.5, 14.2, 0.3, 1.8, 150, '1 puerro mediano', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('27b13b87-e358-4eec-808a-2d7bf521cac9', 'Remolacha', 'VERDURAS_HORTALIZAS', NULL, 43, 1.6, 9.6, 0.2, 2.8, 150, '1 unidad mediana', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('ea812e4b-01a7-43b7-ac25-39b0f57b92e6', 'Rábano', 'VERDURAS_HORTALIZAS', NULL, 16, 0.7, 3.4, 0.1, 1.6, 100, '5-6 rabanitos', true, true, false, false, false, false, false, false, false, '{"primavera","verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('8136f14e-dca9-4778-a543-d4bc368ca963', 'Apio', 'VERDURAS_HORTALIZAS', NULL, 16, 0.7, 3, 0.2, 1.6, 150, '2-3 tallos', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('7be22e13-83e2-41d2-9633-3a1efd29e6dc', 'Nabo', 'VERDURAS_HORTALIZAS', NULL, 28, 0.9, 6.4, 0.1, 1.8, 150, '1 nabo mediano', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('73434dc7-95b0-4d39-94a8-b5fd63de68e3', 'Calabaza', 'VERDURAS_HORTALIZAS', NULL, 26, 1, 6.5, 0.1, 0.5, 200, '1 ración', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('5f9a2086-cd1e-4f0f-8793-248e6cc921d0', 'Boniato', 'CEREALES_TUBERCULOS', 'Tubérculos', 86, 1.6, 20.1, 0.1, 3, 120, '1 boniato pequeño', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('bc3cf808-07ca-40a5-9ad9-9b34722cc426', 'Rúcula', 'VERDURAS_HORTALIZAS', NULL, 25, 2.6, 3.7, 0.7, 1.6, 50, '1 puñado generoso', true, true, false, false, false, false, false, false, false, '{"primavera","otoño"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('4095e421-12cc-4c8d-93be-8710d294fceb', 'Canónigos', 'VERDURAS_HORTALIZAS', NULL, 21, 2, 3.6, 0.4, 1.5, 80, '1 bolsa pequeña', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('d43c69d6-dfb9-4caf-ba66-f09401f41817', 'Col lombarda', 'VERDURAS_HORTALIZAS', NULL, 31, 1.4, 7.4, 0.2, 2.1, 200, '1 plato', true, true, false, false, false, false, false, false, false, '{"otoño","invierno"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('2d76f341-d03b-4e7f-9eac-5ef44b46055c', 'Setas variadas', 'VERDURAS_HORTALIZAS', 'Setas', 22, 3.1, 3.3, 0.3, 1, 200, '1 plato', true, true, false, false, false, false, false, false, false, '{"otoño"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('7dff0008-3eb0-42cd-9d9b-8bcc5e9107c2', 'Arroz integral', 'CEREALES_TUBERCULOS', 'Cereales', 111, 2.6, 23, 0.9, 1.8, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('76a0251f-f3ff-44d0-a579-26908c84c9b9', 'Cuscús', 'CEREALES_TUBERCULOS', 'Cereales', 112, 3.8, 23.2, 0.2, 1.4, 60, '60g en crudo', true, true, false, true, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('1a69a2bb-cc4c-433b-91bb-34ad841741d8', 'Pasta integral', 'CEREALES_TUBERCULOS', 'Cereales', 124, 5.3, 23.5, 1.1, 3.9, 60, '60g en crudo', true, true, false, true, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('77e54425-9648-4145-8ae6-35947b8d2f0c', 'Pan de centeno', 'CEREALES_TUBERCULOS', 'Pan', 259, 8.5, 48.3, 3.3, 5.8, 40, '2 rebanadas', true, true, false, true, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('02cafb4a-f638-4698-b0ea-5e093ea1e118', 'Tortitas de arroz', 'CEREALES_TUBERCULOS', 'Cereales', 387, 8, 81, 2.8, 4.2, 20, '2 tortitas', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('52f1843d-53da-4530-88d2-49cd0bef0fae', 'Mijo', 'CEREALES_TUBERCULOS', 'Cereales', 378, 11, 72.8, 4.2, 8.5, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('bba641b5-9a5d-4e56-aa72-89c2c4671100', 'Trigo sarraceno', 'CEREALES_TUBERCULOS', 'Pseudocereal', 343, 13.3, 71.5, 3.4, 10, 60, '3 cucharadas soperas en crudo', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('47d697e5-4938-4873-8736-95ea454d4eee', 'Conejo', 'CARNES_PESCADOS_HUEVOS', 'Carnes magras', 136, 20.1, 0, 6, NULL, 100, '1 ración mediana', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('e0f70616-3e71-4848-9890-a6371725ec8f', 'Cordero (pierna)', 'CARNES_PESCADOS_HUEVOS', 'Carnes semigrasa', 203, 18.2, 0, 14.2, NULL, 100, '1 ración mediana', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('58fc19c9-ec2f-4dc4-a484-1cb2659f2b5e', 'Solomillo de ternera', 'CARNES_PESCADOS_HUEVOS', 'Carnes magras', 118, 22, 0, 3.2, NULL, 100, '1 filete mediano', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('52921a89-fc28-41a0-ba2f-2638c90e5cbf', 'Chorizo', 'CARNES_PESCADOS_HUEVOS', 'Embutidos y fiambres', 455, 24.1, 2, 38.3, NULL, 30, '3-4 rodajas', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('0373be5c-3ce4-43f9-872c-8250b5c70195', 'Lomo embuchado', 'CARNES_PESCADOS_HUEVOS', 'Embutidos y fiambres', 186, 33, 0.5, 5.8, NULL, 40, '3-4 lonchas', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('f321d685-a158-4883-88b6-68af2ac888a5', 'Morcilla', 'CARNES_PESCADOS_HUEVOS', 'Embutidos y fiambres', 379, 14.6, 18, 27.8, NULL, 50, '1 rodaja gruesa', false, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('bbbd4a5a-7982-4936-b5ad-c904b0a5f2bb', 'Dorada', 'CARNES_PESCADOS_HUEVOS', 'Pescado blanco', 96, 19.8, 0, 1.8, NULL, 130, '1 ración mediana', false, false, false, false, false, false, true, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('6c907195-3afa-446e-ad1d-37c56c99fff6', 'Rape', 'CARNES_PESCADOS_HUEVOS', 'Pescado blanco', 76, 14.8, 0, 1.9, NULL, 130, '1 ración mediana', false, false, false, false, false, false, true, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('69920173-cc0d-4b37-8aaa-0985cf6c02b3', 'Lenguado', 'CARNES_PESCADOS_HUEVOS', 'Pescado blanco', 86, 17.5, 0, 1.8, NULL, 130, '1 ración mediana', false, false, false, false, false, false, true, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('f3917d81-815c-4665-9cfd-fdd0ce2de351', 'Boquerón', 'CARNES_PESCADOS_HUEVOS', 'Pescado azul', 131, 20.3, 0, 5.2, NULL, 130, '8-10 boquerones', false, false, false, false, false, false, true, false, false, '{"primavera","verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('55fe6c50-50bd-49fb-abb7-3006d671a75a', 'Caballa', 'CARNES_PESCADOS_HUEVOS', 'Pescado azul', 205, 18.6, 0, 13.9, NULL, 130, '1 ración mediana', false, false, false, false, false, false, true, false, false, '{"primavera","verano"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('6aca5012-d734-42c9-a864-f91871751b37', 'Trucha', 'CARNES_PESCADOS_HUEVOS', 'Pescado azul', 119, 20.5, 0, 3.5, NULL, 130, '1 trucha mediana', false, false, false, false, false, false, true, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('56549b79-74ee-4bab-9791-112faf050838', 'Calamar', 'CARNES_PESCADOS_HUEVOS', 'Marisco', 92, 15.6, 3.1, 1.4, NULL, 130, '1 ración mediana', false, false, false, false, false, false, false, true, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('25bc64a2-536b-42b1-9036-f4df621992a8', 'Almejas', 'CARNES_PESCADOS_HUEVOS', 'Marisco', 74, 12.8, 2.2, 1, NULL, 130, '15-20 almejas', false, false, false, false, false, false, false, true, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('4c787ed5-383f-4644-b26c-d519738b834a', 'Langostino', 'CARNES_PESCADOS_HUEVOS', 'Marisco', 90, 18.9, 0.2, 1.4, NULL, 130, '6-8 langostinos', false, false, false, false, false, false, false, true, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('8d53fb7b-d803-494e-84b2-5e086d3e064a', 'Sepia', 'CARNES_PESCADOS_HUEVOS', 'Marisco', 79, 16.2, 0.7, 0.7, NULL, 130, '1 ración mediana', false, false, false, false, false, false, false, true, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('439bde9b-1107-4fbb-bd1a-c0a86e5c8252', 'Atún en conserva al natural', 'CARNES_PESCADOS_HUEVOS', 'Conservas', 103, 23.6, 0, 0.8, NULL, 80, '1 lata pequeña escurrida', false, false, false, false, false, false, true, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('8dd6ac64-11d5-474a-b340-07b65ae65aa9', 'Aceite de coco', 'GRASAS', 'Aceites vegetales', 862, 0, 0, 100, NULL, 10, '1 cucharada sopera', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('1d6035f0-7fd1-4383-8ba9-2c2670c379df', 'Aceite de linaza', 'GRASAS', 'Aceites vegetales', 884, 0, 0, 100, NULL, 10, '1 cucharada sopera', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('d38e823f-71e2-4af6-a7da-447315b5801b', 'Tahini (pasta de sésamo)', 'GRASAS', 'Grasas vegetales', 595, 17, 21.2, 53.8, 9.3, 15, '1 cucharada sopera', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('c233820c-de46-4d0e-9a49-45adf905d186', 'Soja texturizada', 'LEGUMBRES', NULL, 336, 50, 30, 1.2, 17.5, 30, '30g en seco', true, true, false, false, false, false, false, false, true, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('93469be2-f2fb-428d-9154-28695b60d20e', 'Tofu', 'LEGUMBRES', NULL, 76, 8.1, 1.9, 4.8, 0.3, 125, '1 bloque pequeño', true, true, false, false, false, false, false, false, true, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('a951791d-6983-44c6-b390-9419a7c2911e', 'Edamame', 'LEGUMBRES', NULL, 121, 11.9, 8.6, 5.2, 5.2, 80, '1 ración', true, true, false, false, false, false, false, false, true, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('4c25307d-481e-43a5-87d7-8c03399f0591', 'Bebida de avena', 'LACTEOS', 'Bebidas vegetales', 43, 0.3, 6.7, 1.5, 0.8, 200, '1 vaso', true, true, false, true, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('bf3999f1-d230-45de-ae12-fc10564ff3d9', 'Bebida de soja', 'LACTEOS', 'Bebidas vegetales', 33, 2.9, 0.6, 1.8, 0.6, 200, '1 vaso', true, true, false, false, false, false, false, false, true, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('9821eb08-988e-452c-930a-544e9f8904f4', 'Bebida de almendras', 'LACTEOS', 'Bebidas vegetales', 24, 0.5, 3, 1.1, 0.3, 200, '1 vaso', true, true, false, false, true, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('98ae74fe-b77f-4536-adb4-3935f86a19a6', 'Miel', 'CEREALES_TUBERCULOS', 'Azúcares', 304, 0.3, 82.4, 0, 0.2, 15, '1 cucharada sopera', true, false, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('30847297-2719-4dda-991c-cc1c04e96056', 'Chocolate negro 85%', 'GRASAS', 'Otros', 580, 12, 19, 46, 13, 20, '2-3 onzas', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('d1643882-3778-450d-a76c-70f2c98fd8d5', 'Dátil', 'FRUTAS', 'Fruta desecada', 277, 1.8, 75, 0.2, 6.7, 30, '2-3 dátiles', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('6213cf33-c1d9-4548-ad37-e79c5b9ac5de', 'Pasas', 'FRUTAS', 'Fruta desecada', 299, 3.1, 79.2, 0.5, 3.7, 30, '1 puñado pequeño', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());
INSERT INTO "Alimento" (id, nombre, "grupoIntercambio", subgrupo, calorias, proteinas, carbohidratos, grasas, fibra, "racionIntercambio", "descripcionRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "contieneFrutosSecos", "contieneHuevo", "contienePescado", "contieneMarisco", "contieneSoja", temporada, "createdAt", "updatedAt") VALUES ('ef8fb5c3-2d1a-4473-8d23-7c63e2eef1cf', 'Orejones de albaricoque', 'FRUTAS', 'Fruta desecada', 241, 3.4, 62.6, 0.5, 7.3, 30, '4-5 orejones', true, true, false, false, false, false, false, false, false, '{"todo el año"}', NOW(), NOW());

-- Recetas (44 total)
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('8fa88468-531d-4e88-b0fe-be3befe682e2', 'Gazpacho andaluz', 'Sopa fría tradicional de Andalucía, perfecta para los meses de verano. Elaborada con hortalizas frescas y aceite de oliva virgen extra.', '1. Lavar y trocear los tomates, el pepino, el pimiento, la cebolla y el ajo.
2. Introducir todas las verduras en el vaso de la batidora.
3. Añadir el aceite de oliva virgen extra, el vinagre y la sal.
4. Triturar hasta obtener una textura fina y homogénea.
5. Colar si se desea una textura más fina.
6. Refrigerar durante al menos 2 horas antes de servir.
7. Servir frío con tropezones de pepino, pimiento y cebolla picados.', 20, 0, 'facil', 4, '{"ALMUERZO","CENA"}', 'Sopas y cremas', true, 'Andalucía', 120, 2, 10, 8, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('cfa16cca-a950-4a47-a6ba-6d7453ee9107', '8fa88468-531d-4e88-b0fe-be3befe682e2', '0cf62664-c768-408e-9d5c-e3ff9b619745', 500, 'g', 'maduros');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e8627673-6b56-4af4-926e-53934df97478', '8fa88468-531d-4e88-b0fe-be3befe682e2', '013fc351-1cb6-4035-9f4d-c874d3976b09', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('4a308882-e5a5-44d0-8793-391dfb43b94a', '8fa88468-531d-4e88-b0fe-be3befe682e2', '01e0e42f-f54f-4ead-b02e-c5e26a90a6e1', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('48faad74-6510-4db8-9ce7-5eb06013af24', '8fa88468-531d-4e88-b0fe-be3befe682e2', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 50, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('c7405f77-1e9c-4181-bede-8563784b8da1', '8fa88468-531d-4e88-b0fe-be3befe682e2', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', '1 diente');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('911ac686-f3e1-45e6-bfc3-09a6895e0b43', '8fa88468-531d-4e88-b0fe-be3befe682e2', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 40, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('ec7eb331-f5ab-4ed5-9d87-48135d9d493d', 'Tortilla española', 'La tortilla de patatas es uno de los platos más emblemáticos de la cocina española. Jugosa por dentro y dorada por fuera.', '1. Pelar y cortar las patatas en láminas finas.
2. Pelar y cortar la cebolla en juliana fina.
3. Calentar abundante aceite de oliva en una sartén y freír las patatas a fuego medio junto con la cebolla hasta que estén tiernas (unos 20 minutos).
4. Escurrir bien el aceite sobrante.
5. Batir los huevos en un bol grande con una pizca de sal.
6. Mezclar las patatas y la cebolla con los huevos batidos.
7. Calentar un poco de aceite en una sartén antiadherente y verter la mezcla.
8. Cocinar a fuego medio-bajo durante 5 minutos.
9. Dar la vuelta con la ayuda de un plato y cocinar otros 3-4 minutos.
10. Servir templada o a temperatura ambiente.', 15, 30, 'media', 4, '{"ALMUERZO","CENA"}', 'Platos principales', true, NULL, 320, 14, 28, 18, true, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('02194f00-6620-46cb-b329-ad60a73a65eb', 'ec7eb331-f5ab-4ed5-9d87-48135d9d493d', '86c84342-6b45-4c3d-a7e4-03a32e7f896e', 400, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('1cf7f9c1-73ff-4ea6-ba87-9d7f8d728b40', 'ec7eb331-f5ab-4ed5-9d87-48135d9d493d', 'c47669f8-11a4-4742-a764-71f6b7667188', 240, 'g', '4 huevos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('d2876eda-e8df-465b-b9db-6ef17ae9f7b3', 'ec7eb331-f5ab-4ed5-9d87-48135d9d493d', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('5530cf6f-c1f2-4a3a-9d98-90cbc112e590', 'ec7eb331-f5ab-4ed5-9d87-48135d9d493d', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 60, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('7081124a-927d-47f4-a1f9-17369a145f9f', 'Ensalada mediterránea', 'Ensalada fresca y colorida con ingredientes típicos de la dieta mediterránea. Ligera y nutritiva.', '1. Lavar y escurrir la lechuga, cortarla en trozos.
2. Cortar los tomates en gajos.
3. Pelar y cortar el pepino en rodajas.
4. Cortar el aguacate por la mitad, retirar el hueso y cortarlo en láminas.
5. Añadir las aceitunas.
6. Disponer todos los ingredientes en una fuente.
7. Aliñar con aceite de oliva virgen extra y sal al gusto.
8. Servir inmediatamente.', 15, 0, 'facil', 4, '{"ALMUERZO","CENA"}', 'Ensaladas', true, NULL, 180, 3, 8, 15, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('9ca28a2b-b319-49f4-b776-b808b46bfeb1', '7081124a-927d-47f4-a1f9-17369a145f9f', '96ea7f66-cfda-4aba-8bde-51beb14c1f48', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('915a7128-459e-426d-80a3-abfbe4b77a4f', '7081124a-927d-47f4-a1f9-17369a145f9f', '0cf62664-c768-408e-9d5c-e3ff9b619745', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e742e3c3-7016-4589-a545-c9445f7dafe2', '7081124a-927d-47f4-a1f9-17369a145f9f', '013fc351-1cb6-4035-9f4d-c874d3976b09', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('505cf4a1-7ef8-4e37-bf2b-bd188359b927', '7081124a-927d-47f4-a1f9-17369a145f9f', 'f43b19a4-a1e6-48db-8d59-e6d2d9a66383', 150, 'g', '1 aguacate');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('360f386a-c9e5-4414-9d43-d5ea710a23f5', '7081124a-927d-47f4-a1f9-17369a145f9f', '2a1a5d89-5c88-4470-9afd-0429f87443f7', 60, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('77945d7c-f1e5-40d5-a1dd-0a49685b66cf', '7081124a-927d-47f4-a1f9-17369a145f9f', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('64a0a6cb-aa21-43b6-8d59-1964d8a42bfb', 'Pollo al ajillo', 'Receta clásica de la cocina española. El pollo se cocina lentamente en aceite de oliva con abundante ajo, resultando tierno y muy aromático.', '1. Cortar la pechuga de pollo en trozos medianos y salpimentar.
2. Pelar y laminar los ajos.
3. Calentar el aceite de oliva en una cazuela o sartén amplia.
4. Dorar los ajos laminados hasta que estén ligeramente dorados y reservar.
5. En el mismo aceite, sellar los trozos de pollo por todos los lados a fuego fuerte.
6. Bajar el fuego, incorporar los ajos reservados.
7. Añadir un chorro de vino blanco (opcional) y dejar reducir.
8. Tapar y cocinar a fuego lento durante 15-20 minutos hasta que el pollo esté bien hecho.
9. Servir caliente con su propia salsa.', 10, 25, 'facil', 4, '{"ALMUERZO","CENA"}', 'Platos principales', true, 'Castilla', 280, 35, 2, 14, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('da6f5810-c89e-4338-8a8f-99c2cffe982d', '64a0a6cb-aa21-43b6-8d59-1964d8a42bfb', '7ff780b9-f9a4-4a2a-8563-c4a7d102daba', 600, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('a9932d07-f1c7-4afe-a957-ee979948df68', '64a0a6cb-aa21-43b6-8d59-1964d8a42bfb', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 30, 'g', '6-8 dientes');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('343bdf17-0de2-499d-bd9b-c46bdecd32ce', '64a0a6cb-aa21-43b6-8d59-1964d8a42bfb', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 50, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('fe354ed6-1390-4042-8c0c-b7f2f27bab17', 'Lentejas estofadas', 'Guiso tradicional español de lentejas con verduras. Un plato reconfortante, económico y muy nutritivo, ideal para los meses fríos.', '1. Lavar las lentejas bajo el grifo y escurrir.
2. Pelar y picar la zanahoria, la patata, la cebolla y el ajo.
3. Cortar el pimiento verde en trozos pequeños.
4. En una olla grande, calentar el aceite de oliva y sofreír la cebolla, el ajo y el pimiento durante 5 minutos.
5. Añadir la zanahoria y la patata, y sofreír 2 minutos más.
6. Incorporar las lentejas y cubrir con agua fría (el doble de volumen que las lentejas).
7. Llevar a ebullición y bajar el fuego.
8. Cocinar a fuego lento durante 30-40 minutos hasta que las lentejas estén tiernas.
9. Rectificar de sal y servir caliente.', 15, 40, 'facil', 4, '{"ALMUERZO"}', 'Legumbres', true, NULL, 350, 22, 48, 8, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('c0678d4c-60dc-45ea-ac47-9c7e20fc8c7f', 'fe354ed6-1390-4042-8c0c-b7f2f27bab17', '5d4e86d8-4987-4f35-8a07-a0bd24f16ae3', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('2dec3ca5-2c7f-4d4d-9759-a53d24eae132', 'fe354ed6-1390-4042-8c0c-b7f2f27bab17', '4797d7bc-cea4-45db-bcbd-894e4a37179b', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('cd7eb3e6-d6bc-4e3e-879c-cdf979ab7acf', 'fe354ed6-1390-4042-8c0c-b7f2f27bab17', '86c84342-6b45-4c3d-a7e4-03a32e7f896e', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b15dcc81-5f60-4cc1-9b79-b1c43853241f', 'fe354ed6-1390-4042-8c0c-b7f2f27bab17', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('9471b273-470f-4861-adca-4b1e9757da59', 'fe354ed6-1390-4042-8c0c-b7f2f27bab17', '01e0e42f-f54f-4ead-b02e-c5e26a90a6e1', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('33dd0e31-3fdc-4aa3-9f82-d679864a14b4', 'fe354ed6-1390-4042-8c0c-b7f2f27bab17', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', '1 diente');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('c94a76c6-6d08-41a8-85ad-0187b4357338', 'fe354ed6-1390-4042-8c0c-b7f2f27bab17', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('d6578002-31d7-453d-a368-4fadc1347a62', 'Merluza a la plancha con verduras', 'Merluza fresca a la plancha acompañada de verduras salteadas. Un plato ligero, saludable y muy sabroso.', '1. Salpimentar los lomos de merluza.
2. Lavar y cortar el calabacín en rodajas, el brócoli en ramilletes y las judías verdes en trozos.
3. Hervir o cocer al vapor el brócoli y las judías verdes durante 5-6 minutos. Escurrir.
4. En una sartén con un poco de aceite, saltear el calabacín hasta que esté dorado.
5. Añadir el brócoli y las judías verdes al salteado y mantener caliente.
6. En otra sartén con aceite de oliva caliente, cocinar la merluza 3-4 minutos por cada lado.
7. Servir la merluza sobre la cama de verduras.
8. Aliñar con un chorrito de aceite de oliva virgen extra en crudo.', 10, 15, 'facil', 4, '{"ALMUERZO","CENA"}', 'Pescados', true, NULL, 220, 28, 8, 9, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('43550aaa-6d49-4cfb-83e4-5dc1e37d0469', 'd6578002-31d7-453d-a368-4fadc1347a62', 'b9f2feb2-b7f9-497b-8080-1e41fc71da68', 500, 'g', '4 lomos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3e121686-5943-40ef-b30c-0803b15e711f', 'd6578002-31d7-453d-a368-4fadc1347a62', '58b5fe1f-7250-479e-a8a6-74215c4eef8c', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('745058d2-d86f-4da9-8f6f-496c1f8596f9', 'd6578002-31d7-453d-a368-4fadc1347a62', '52595d0d-32e4-4c7c-9e63-14bff7c573e8', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('bca4eb2e-cd92-463a-b81e-ba1123039546', 'd6578002-31d7-453d-a368-4fadc1347a62', '8737b15b-4506-47e2-9dee-a9f832cb6f48', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('67830090-54d1-4b3e-bee2-2af7b8ea1894', 'd6578002-31d7-453d-a368-4fadc1347a62', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('4f13dd43-eac9-42c0-814a-84ac36c2c37c', 'Garbanzos con espinacas', 'Plato típico de la cocina andaluza y sevillana. Un guiso de cuaresma sencillo, saciante y lleno de sabor gracias al pimentón y el comino.', '1. Si se usan garbanzos secos, ponerlos en remojo la noche anterior y cocerlos hasta que estén tiernos. También se pueden usar garbanzos de bote escurridos.
2. Lavar bien las espinacas.
3. Pelar y picar la cebolla y los ajos.
4. En una cazuela, calentar el aceite de oliva y sofreír la cebolla hasta que esté transparente.
5. Añadir el ajo picado y cocinar 1 minuto más.
6. Incorporar el tomate rallado y cocinar 5 minutos.
7. Añadir las espinacas y dejar que se cocinen hasta que se reduzcan.
8. Incorporar los garbanzos cocidos y un poco de caldo de su cocción.
9. Sazonar con pimentón, comino y sal.
10. Cocinar todo junto a fuego lento durante 10 minutos para que se integren los sabores.', 15, 20, 'facil', 4, '{"ALMUERZO","CENA"}', 'Legumbres', true, 'Andalucía', 310, 18, 38, 10, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('a50d0daa-5c53-4d1e-9e8d-e20b1d6f1479', '4f13dd43-eac9-42c0-814a-84ac36c2c37c', 'cd50880d-ac6d-4564-a1f4-9dec5298c8e1', 350, 'g', 'cocidos o de bote');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e0c6c93c-3928-4e36-9605-d6847636c8f4', '4f13dd43-eac9-42c0-814a-84ac36c2c37c', 'ec9e1c4d-9b2d-4bd3-83ab-8801750e8fbc', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('91b8866e-30f9-4574-a027-3284b0a25505', '4f13dd43-eac9-42c0-814a-84ac36c2c37c', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('ba2fb3f3-234d-4b0b-9bfa-7ad33f2332d2', '4f13dd43-eac9-42c0-814a-84ac36c2c37c', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 10, 'g', '2 dientes');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('1882b965-f9a5-4130-a5b0-7f53012e0726', '4f13dd43-eac9-42c0-814a-84ac36c2c37c', '0cf62664-c768-408e-9d5c-e3ff9b619745', 100, 'g', 'rallado');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('288d182d-ccaa-4906-be9a-bb4c6dd60f17', '4f13dd43-eac9-42c0-814a-84ac36c2c37c', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('dc4bdf4f-00d2-4149-83d9-8336d2dca639', 'Salmón al horno con patatas', 'Salmón jugoso horneado sobre una cama de patatas. Un plato completo, elegante y fácil de preparar que es rico en omega-3.', '1. Precalentar el horno a 200°C.
2. Pelar las patatas y cortarlas en rodajas finas.
3. Cortar la cebolla en aros finos.
4. Disponer las patatas y la cebolla en una fuente de horno, aliñar con aceite de oliva y sal.
5. Hornear las patatas durante 25 minutos a 200°C.
6. Salpimentar los lomos de salmón.
7. Colocar el salmón sobre las patatas y regar con un poco de aceite.
8. Hornear 12-15 minutos más hasta que el salmón esté hecho pero jugoso.
9. Servir directamente de la fuente.', 15, 40, 'facil', 4, '{"ALMUERZO","CENA"}', 'Pescados', true, NULL, 420, 32, 30, 20, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('06cfc92d-a9fe-4cfe-a30d-0bf310386b23', 'dc4bdf4f-00d2-4149-83d9-8336d2dca639', 'e6c5e7e6-c71d-41f0-853e-633105bb9075', 500, 'g', '4 lomos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b8549c05-9bea-425e-b8d1-a210a6653900', 'dc4bdf4f-00d2-4149-83d9-8336d2dca639', '86c84342-6b45-4c3d-a7e4-03a32e7f896e', 400, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('79d916bb-292c-43e9-abb0-faa8ec9bec38', 'dc4bdf4f-00d2-4149-83d9-8336d2dca639', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('ae948f21-4aff-44ad-babe-87d569234321', 'dc4bdf4f-00d2-4149-83d9-8336d2dca639', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('9188b840-8712-4a73-affb-a4ad62f4ca7f', 'Pisto manchego', 'El pisto es un plato tradicional de La Mancha a base de verduras de la huerta. Similar al ratatouille francés pero con personalidad propia.', '1. Lavar y cortar todas las verduras en dados pequeños: calabacín, berenjena, pimientos y cebolla.
2. Pelar y picar el ajo.
3. Rallar o triturar los tomates.
4. En una sartén amplia o cazuela, calentar el aceite de oliva.
5. Sofreír la cebolla y el ajo a fuego medio durante 5 minutos.
6. Añadir los pimientos y cocinar 5 minutos más.
7. Incorporar el calabacín y la berenjena, cocinar 8-10 minutos.
8. Añadir el tomate triturado y salar.
9. Cocinar a fuego lento durante 20 minutos, removiendo de vez en cuando.
10. El pisto debe quedar con las verduras tiernas pero no deshechas.', 20, 40, 'facil', 4, '{"ALMUERZO","CENA"}', 'Verduras', true, 'Castilla-La Mancha', 150, 3, 14, 9, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('179107d1-e5e3-494a-ad78-69f9cb69c04c', '9188b840-8712-4a73-affb-a4ad62f4ca7f', '58b5fe1f-7250-479e-a8a6-74215c4eef8c', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('a7141f37-4543-4119-8253-ba780d93f0cd', '9188b840-8712-4a73-affb-a4ad62f4ca7f', '99970995-5e92-40d4-a217-e5c20e370811', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('bf0b56b7-157b-4df1-8a4b-49c5523f95f3', '9188b840-8712-4a73-affb-a4ad62f4ca7f', '031ef32f-ae88-4362-aa5e-ab9982983df7', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('f004b02b-50a6-4ff5-b92f-a4524fea3466', '9188b840-8712-4a73-affb-a4ad62f4ca7f', '01e0e42f-f54f-4ead-b02e-c5e26a90a6e1', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('94eb7be4-dde8-4713-8851-49b0592bf4c5', '9188b840-8712-4a73-affb-a4ad62f4ca7f', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b0e99b7b-aae1-443d-a3cb-9643b2fe2d04', '9188b840-8712-4a73-affb-a4ad62f4ca7f', '0cf62664-c768-408e-9d5c-e3ff9b619745', 300, 'g', 'triturado');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('0b887efb-cbe8-4d4a-afe3-1274b0ff6806', '9188b840-8712-4a73-affb-a4ad62f4ca7f', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', '1 diente');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('5fe48e9f-8d95-4a5a-9839-62c298319b9d', '9188b840-8712-4a73-affb-a4ad62f4ca7f', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 40, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('da18d359-ece1-43c1-a8cc-d2bdaf051cca', 'Ensalada César con pollo', 'Versión española de la clásica ensalada César, con pechuga de pollo a la plancha, queso y una salsa cremosa.', '1. Salpimentar la pechuga de pollo y cocinarla a la plancha con un poco de aceite hasta que esté dorada y bien hecha (unos 6-7 minutos por lado).
2. Dejar reposar el pollo 5 minutos y cortarlo en tiras.
3. Lavar y cortar la lechuga en trozos.
4. Cortar el pan en dados pequeños y tostarlos en una sartén con un poco de aceite hasta que estén crujientes.
5. Rallar o cortar el queso en láminas finas.
6. Montar la ensalada: disponer la lechuga como base, colocar las tiras de pollo encima.
7. Añadir los picatostes y el queso.
8. Aliñar con aceite de oliva virgen extra y servir.', 15, 15, 'facil', 4, '{"ALMUERZO","CENA"}', 'Ensaladas', false, NULL, 350, 32, 15, 18, false, false, true, true, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('164cc6f6-1ce2-403d-a34c-b2f2f543b822', 'da18d359-ece1-43c1-a8cc-d2bdaf051cca', '7ff780b9-f9a4-4a2a-8563-c4a7d102daba', 400, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('ac496256-0ebb-4c69-a15d-a40ecc9deeaf', 'da18d359-ece1-43c1-a8cc-d2bdaf051cca', '96ea7f66-cfda-4aba-8bde-51beb14c1f48', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('d5273fc6-b558-4e41-bbe3-52df89c193cf', 'da18d359-ece1-43c1-a8cc-d2bdaf051cca', 'ac80004a-2239-42fc-b7d2-2038604c3676', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('30745526-10b6-49ad-8871-4795f6c34af4', 'da18d359-ece1-43c1-a8cc-d2bdaf051cca', 'efcc7d8c-5c41-4d79-9f40-6175c7e432db', 80, 'g', 'para picatostes');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('0f9a6d66-14b1-414f-b18b-259794afe9f3', 'da18d359-ece1-43c1-a8cc-d2bdaf051cca', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('f952380f-7616-4014-a0da-1283a999c1fd', 'Crema de calabacín', 'Crema suave y reconfortante de calabacín. Ligera, digestiva y perfecta como entrante o cena ligera.', '1. Pelar y picar la cebolla y la patata en trozos.
2. Lavar y cortar el calabacín en rodajas (no es necesario pelarlo).
3. En una olla, calentar el aceite de oliva y sofreír la cebolla hasta que esté transparente.
4. Añadir la patata y el calabacín, y rehogar 3-4 minutos.
5. Cubrir con agua o caldo de verduras.
6. Cocinar a fuego medio durante 20 minutos hasta que todas las verduras estén tiernas.
7. Triturar con batidora hasta obtener una crema fina.
8. Añadir un chorrito de leche si se desea más cremosa.
9. Rectificar de sal y servir con un hilo de aceite de oliva virgen extra.', 10, 25, 'facil', 4, '{"ALMUERZO","CENA"}', 'Sopas y cremas', true, NULL, 130, 4, 15, 6, true, false, true, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('75c6bbbd-6ad7-4f83-90ab-5d0e4b83bb24', 'f952380f-7616-4014-a0da-1283a999c1fd', '58b5fe1f-7250-479e-a8a6-74215c4eef8c', 500, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('10ea3802-75ab-4d55-a36d-fdc0013b9666', 'f952380f-7616-4014-a0da-1283a999c1fd', '86c84342-6b45-4c3d-a7e4-03a32e7f896e', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3394ac63-efdf-4b52-90db-6cffc84e7df8', 'f952380f-7616-4014-a0da-1283a999c1fd', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('f32af66d-98e7-41f4-a2bf-a89e706c796e', 'f952380f-7616-4014-a0da-1283a999c1fd', '70d690b1-bee5-4be4-bb7e-6d3f751a2f3f', 100, 'ml', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b5acf1f7-33a7-4a00-b562-56f99c73b2ff', 'f952380f-7616-4014-a0da-1283a999c1fd', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 20, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('640e8b5c-e1e0-467c-95fd-b887990d87ca', 'Arroz con verduras', 'Arroz salteado con verduras de temporada. Un plato completo, colorido y muy versátil que se puede adaptar a las verduras disponibles.', '1. Cocinar el arroz según las instrucciones del paquete. Escurrir y reservar.
2. Lavar y cortar todas las verduras: pimiento rojo en tiras, judías verdes en trozos, guisantes, calabacín en dados y zanahoria en rodajas finas.
3. Picar el ajo.
4. En un wok o sartén amplia, calentar el aceite de oliva.
5. Saltear el ajo 30 segundos.
6. Añadir la zanahoria y las judías verdes, cocinar 5 minutos.
7. Incorporar el pimiento, el calabacín y los guisantes, cocinar 5 minutos más.
8. Añadir el arroz cocido y mezclar bien con las verduras.
9. Saltear todo junto 3-4 minutos a fuego fuerte.
10. Salpimentar y servir caliente.', 15, 25, 'facil', 4, '{"ALMUERZO","CENA"}', 'Arroces', true, NULL, 290, 8, 48, 7, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('8611b30c-c27c-4c08-92b5-23f3e0ad5c77', '640e8b5c-e1e0-467c-95fd-b887990d87ca', 'a4df24a0-5d5e-4c1a-af39-2bfcd0e0f8ac', 280, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('469d93ce-0a9a-4800-9116-be1d00196423', '640e8b5c-e1e0-467c-95fd-b887990d87ca', '031ef32f-ae88-4362-aa5e-ab9982983df7', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('7fe4ce24-000d-43fb-99bb-5ee3eb91ae2e', '640e8b5c-e1e0-467c-95fd-b887990d87ca', '8737b15b-4506-47e2-9dee-a9f832cb6f48', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('ebc0c761-7fd6-4be2-80b1-ff05811b307b', '640e8b5c-e1e0-467c-95fd-b887990d87ca', 'e592bee9-125c-4e54-965b-5168a5d819ae', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3de3082e-f44b-4cc0-84ea-164ced4ad333', '640e8b5c-e1e0-467c-95fd-b887990d87ca', '58b5fe1f-7250-479e-a8a6-74215c4eef8c', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('2e90a907-7326-4f4a-8b43-20b1c9d1fdee', '640e8b5c-e1e0-467c-95fd-b887990d87ca', '4797d7bc-cea4-45db-bcbd-894e4a37179b', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e74f1a7f-8ed7-49d2-be00-9df07c44fc22', '640e8b5c-e1e0-467c-95fd-b887990d87ca', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', '1 diente');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b6f27c46-e8f2-4d1f-8b69-55ea3534c79f', '640e8b5c-e1e0-467c-95fd-b887990d87ca', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 25, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('4f115482-bd1d-44d8-b221-a5a5d51a6ea5', 'Pechuga de pavo a la plancha', 'Pechuga de pavo a la plancha con guarnición de ensalada. Un plato alto en proteínas y bajo en grasa, ideal para una cena ligera y saludable.', '1. Salpimentar las pechugas de pavo.
2. Calentar una plancha o sartén con un poco de aceite de oliva.
3. Cocinar las pechugas de pavo 4-5 minutos por cada lado hasta que estén doradas y bien hechas.
4. Mientras tanto, preparar la guarnición: lavar y cortar la lechuga, el tomate en rodajas y el pepino.
5. Disponer la ensalada en los platos.
6. Colocar la pechuga de pavo cortada en láminas sobre la ensalada.
7. Aliñar con aceite de oliva virgen extra.
8. Servir inmediatamente.', 10, 10, 'facil', 4, '{"ALMUERZO","CENA"}', 'Carnes', true, NULL, 200, 34, 5, 5, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('1ffc9504-e6b4-48c1-8bcc-ae95c47d225d', '4f115482-bd1d-44d8-b221-a5a5d51a6ea5', '9e5f2b46-4a12-4a78-8e40-9655534d1935', 500, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3ddf29ea-99a2-4b01-a1f2-e2bdf5ff8eb3', '4f115482-bd1d-44d8-b221-a5a5d51a6ea5', '96ea7f66-cfda-4aba-8bde-51beb14c1f48', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('4e90a1d9-c909-40b8-9975-4ba6ef5967a0', '4f115482-bd1d-44d8-b221-a5a5d51a6ea5', '0cf62664-c768-408e-9d5c-e3ff9b619745', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e256a911-8a76-4563-b9ca-26d1f592e5dd', '4f115482-bd1d-44d8-b221-a5a5d51a6ea5', '013fc351-1cb6-4035-9f4d-c874d3976b09', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('5bb708e2-1524-4f6b-8c5e-e0342ad453df', '4f115482-bd1d-44d8-b221-a5a5d51a6ea5', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 20, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('8f854e84-3459-4f21-bb6e-df5618aef844', 'Hummus casero', 'Hummus cremoso elaborado con garbanzos cocidos. Un aperitivo saludable de inspiración mediterránea, perfecto para untar con pan o crudités.', '1. Si se usan garbanzos secos, ponerlos en remojo la noche anterior y cocerlos hasta que estén muy tiernos. También se pueden usar garbanzos de bote, bien escurridos.
2. Pelar los ajos.
3. Colocar los garbanzos en el vaso de la batidora o procesador.
4. Añadir el ajo, el aceite de oliva virgen extra y un poco de agua de la cocción.
5. Triturar hasta obtener una crema fina y homogénea.
6. Si queda muy espeso, añadir un poco más de agua.
7. Salpimentar al gusto.
8. Servir en un plato con un chorrito de aceite de oliva por encima y unas semillas de chía como decoración.
9. Acompañar con pan integral tostado o palitos de zanahoria.', 10, 0, 'facil', 4, '{"ALMUERZO","CENA"}', 'Aperitivos', false, NULL, 220, 10, 24, 10, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b948fad4-b9dc-410e-a04b-ac74d230fcb3', '8f854e84-3459-4f21-bb6e-df5618aef844', 'cd50880d-ac6d-4564-a1f4-9dec5298c8e1', 400, 'g', 'cocidos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('c22fdee0-fcd5-4a48-babe-2d5c58b7a9c5', '8f854e84-3459-4f21-bb6e-df5618aef844', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', '1 diente');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('f0b0e2d1-969f-4a02-ab14-60d940a00b93', '8f854e84-3459-4f21-bb6e-df5618aef844', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 40, 'ml', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('1abefaa1-dee9-496b-ad34-8a63daa1d82d', '8f854e84-3459-4f21-bb6e-df5618aef844', '6147f4d1-db87-4d1c-a71a-74813139e2de', 10, 'g', 'para decorar');
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('825e56bd-da83-4ff3-9149-c3bce0045057', 'Bowl de quinoa mediterráneo', 'Bowl nutritivo con quinoa como base, acompañado de verduras frescas, aguacate y frutos secos. Un plato moderno con ingredientes mediterráneos.', '1. Cocinar la quinoa: lavar bien bajo el grifo, poner en una olla con el doble de agua y cocinar 15 minutos hasta que absorba el agua. Dejar reposar tapada 5 minutos.
2. Lavar y cortar el tomate en dados.
3. Cortar el pepino en medias lunas.
4. Cortar el aguacate en láminas.
5. Lavar las espinacas frescas.
6. Tostar ligeramente las almendras en una sartén sin aceite.
7. Montar los bowls: poner una base de quinoa en cada plato.
8. Disponer las espinacas, el tomate, el pepino y el aguacate de forma ordenada.
9. Añadir las almendras tostadas y las aceitunas.
10. Aliñar con aceite de oliva virgen extra y sal.
11. Servir a temperatura ambiente.', 15, 20, 'facil', 4, '{"ALMUERZO","CENA"}', 'Bowls', false, NULL, 380, 12, 35, 22, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('0a691955-e69e-41d1-a24f-e8f9384c6a86', '825e56bd-da83-4ff3-9149-c3bce0045057', 'd7552046-940a-4a7e-b575-70d83e143dc1', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('0cd1197a-f348-43f6-a98b-013c8431525d', '825e56bd-da83-4ff3-9149-c3bce0045057', '0cf62664-c768-408e-9d5c-e3ff9b619745', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('623077ca-ddeb-4c7e-9858-b6a895bdb54a', '825e56bd-da83-4ff3-9149-c3bce0045057', '013fc351-1cb6-4035-9f4d-c874d3976b09', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('19c0aa73-a522-4b14-9900-562ff879de76', '825e56bd-da83-4ff3-9149-c3bce0045057', 'f43b19a4-a1e6-48db-8d59-e6d2d9a66383', 150, 'g', '1 aguacate');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('2eb2d177-9696-41a0-8b5e-cf2252379c30', '825e56bd-da83-4ff3-9149-c3bce0045057', 'ec9e1c4d-9b2d-4bd3-83ab-8801750e8fbc', 100, 'g', 'frescas');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('45988b27-0eb7-4941-a61e-68039232c974', '825e56bd-da83-4ff3-9149-c3bce0045057', 'b33779af-f2f7-441d-b749-762e45141fa2', 40, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('7c41e81b-becd-40d7-ad4b-32842008af7a', '825e56bd-da83-4ff3-9149-c3bce0045057', '2a1a5d89-5c88-4470-9afd-0429f87443f7', 40, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('95e974b2-c2f1-429f-a9f0-667296690e36', '825e56bd-da83-4ff3-9149-c3bce0045057', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('6b65a961-a687-4f80-ad05-4e5ca1157c83', 'Paella valenciana', 'El plato más emblemático de Valencia. Arroz con pollo, judías verdes y garrofón cocinado en paellera.', '1. Calentar aceite en la paellera y dorar el pollo troceado.
2. Añadir judías verdes y sofreír 3 minutos.
3. Agregar tomate rallado y sofreír hasta que oscurezca.
4. Añadir pimentón, remover rápido y cubrir con agua.
5. Hervir a fuego fuerte 20 minutos.
6. Rectificar de sal, añadir el arroz distribuyéndolo bien.
7. Cocinar a fuego fuerte 7 minutos y luego medio 13 minutos.
8. Dejar reposar 5 minutos tapada con un paño.', 20, 45, 'media', 4, '{"ALMUERZO"}', 'Arroces', true, 'Valencia', 450, 28, 52, 14, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b7a5dbaf-99c9-4acc-8367-e77738730c41', '6b65a961-a687-4f80-ad05-4e5ca1157c83', 'a4df24a0-5d5e-4c1a-af39-2bfcd0e0f8ac', 320, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('caa3c356-1bca-46e7-8755-f15a2881a925', '6b65a961-a687-4f80-ad05-4e5ca1157c83', '45103287-71a2-41b0-a369-428de105dee7', 400, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('c704d8f7-d1e2-4f7d-a884-e062e1ce63fc', '6b65a961-a687-4f80-ad05-4e5ca1157c83', '8737b15b-4506-47e2-9dee-a9f832cb6f48', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('80a0a224-669d-4e82-841c-fd008e80deaa', '6b65a961-a687-4f80-ad05-4e5ca1157c83', '0cf62664-c768-408e-9d5c-e3ff9b619745', 100, 'g', 'rallado');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('834c510d-5e84-45cc-90dd-86dab03e52fc', '6b65a961-a687-4f80-ad05-4e5ca1157c83', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 50, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('d43ea364-6b56-4667-b115-329d8b494be6', 'Salmorejo cordobés', 'Crema fría de tomate típica de Córdoba, más espesa que el gazpacho. Se sirve con virutas de jamón y huevo duro.', '1. Trocear los tomates maduros.
2. Remojar el pan en agua y escurrir.
3. Triturar tomates, pan, ajo y aceite de oliva hasta obtener crema fina.
4. Colar para eliminar pieles y semillas.
5. Refrigerar mínimo 2 horas.
6. Servir con virutas de jamón serrano y huevo duro picado.', 15, 0, 'facil', 4, '{"ALMUERZO","CENA"}', 'Sopas y cremas', true, 'Andalucía', 210, 8, 18, 12, false, false, false, true, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('6bd3ecea-7e3f-4a35-9c90-0f5c2f699e8c', 'd43ea364-6b56-4667-b115-329d8b494be6', '0cf62664-c768-408e-9d5c-e3ff9b619745', 600, 'g', 'maduros');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('26d1b44c-90ea-4f82-a7a7-6032995e01ef', 'd43ea364-6b56-4667-b115-329d8b494be6', 'efcc7d8c-5c41-4d79-9f40-6175c7e432db', 100, 'g', 'del día anterior');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('309e8e82-5cd6-4dbb-9784-8aeb627aa483', 'd43ea364-6b56-4667-b115-329d8b494be6', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 50, 'ml', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('de4ba188-461c-4be5-a077-162282b31b9a', 'd43ea364-6b56-4667-b115-329d8b494be6', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', '1 diente');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('de78c856-b4ce-45fc-a4ba-cbe63c76a241', 'd43ea364-6b56-4667-b115-329d8b494be6', 'd599ab63-a8aa-4020-b6b9-7bd41a8257e2', 40, 'g', 'para decorar');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('765ffe37-00d8-4a5f-99f9-f33e7f5a53c9', 'd43ea364-6b56-4667-b115-329d8b494be6', 'c47669f8-11a4-4742-a764-71f6b7667188', 60, 'g', '1 huevo duro');
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('ce74fb28-895c-47c9-be1e-795f2a96034d', 'Fabada asturiana', 'Guiso tradicional de Asturias con fabes (alubias blancas), chorizo y morcilla. Plato reconfortante de invierno.', '1. Poner las alubias en remojo la noche anterior.
2. Escurrir y colocar en olla grande cubiertas de agua fría.
3. Añadir chorizo y morcilla enteros.
4. Llevar a ebullición y bajar el fuego.
5. Cocinar a fuego lento 2 horas, añadiendo agua fría si es necesario.
6. Salar al final de la cocción.
7. Dejar reposar 10 minutos antes de servir.
8. Cortar los embutidos en rodajas y servir con las fabes.', 15, 120, 'media', 4, '{"ALMUERZO"}', 'Legumbres', true, 'Asturias', 520, 28, 45, 26, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e56352e9-6bc2-4be7-b347-4890b157b6dd', 'ce74fb28-895c-47c9-be1e-795f2a96034d', 'debd3546-06e1-4724-a4f9-ff6ca16d8f8f', 400, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('4dc2e409-f092-4afb-991e-c3fbd0a21073', 'ce74fb28-895c-47c9-be1e-795f2a96034d', '52921a89-fc28-41a0-ba2f-2638c90e5cbf', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b3051db5-dd21-4a63-9726-87821dcf3a31', 'ce74fb28-895c-47c9-be1e-795f2a96034d', 'f321d685-a158-4883-88b6-68af2ac888a5', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('c0d04258-cd14-49dc-8f7e-70f0ade57d6e', 'ce74fb28-895c-47c9-be1e-795f2a96034d', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('2cfdd4b3-4664-4903-b9ed-d5e14909b546', 'ce74fb28-895c-47c9-be1e-795f2a96034d', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 20, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('9d273b8f-87be-4214-90e5-496fa5f6cc08', 'Pulpo a la gallega', 'Plato típico gallego. Pulpo cocido servido sobre patata con pimentón y aceite de oliva.', '1. Congelar el pulpo previamente para ablandar la fibra.
2. Hervir agua abundante en una olla grande.
3. Asustar el pulpo sumergiéndolo 3 veces antes de dejarlo en el agua.
4. Cocer 40-50 minutos hasta que esté tierno.
5. Cocer las patatas peladas y cortadas en rodajas en el mismo agua.
6. Cortar el pulpo con tijeras.
7. Disponer las patatas en plato de madera, colocar el pulpo encima.
8. Aliñar con aceite de oliva, pimentón y sal gorda.', 10, 50, 'media', 4, '{"ALMUERZO","CENA"}', 'Pescados', true, 'Galicia', 280, 22, 20, 12, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('55e3a71f-86aa-43f3-969c-a9dd192b91a1', '9d273b8f-87be-4214-90e5-496fa5f6cc08', '947728c4-2582-4959-b16e-32c2238187e1', 500, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('6fcc4938-e885-49ba-898d-6f20f235dd93', '9d273b8f-87be-4214-90e5-496fa5f6cc08', '86c84342-6b45-4c3d-a7e4-03a32e7f896e', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('af57e86c-cfe2-427a-ba3a-dc0602f96810', '9d273b8f-87be-4214-90e5-496fa5f6cc08', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 40, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('37a13337-7b05-4cda-bbfc-96a61617944d', 'Caldo gallego', 'Sopa reconfortante gallega con grelos, patatas y alubias blancas.', '1. Poner las alubias en remojo la noche anterior.
2. Cocer las alubias en agua fría durante 1 hora.
3. Pelar y trocear las patatas, añadir a la olla.
4. Lavar y trocear las acelgas, añadir.
5. Cocinar 30 minutos más.
6. Salar y añadir un chorrito de aceite de oliva al servir.', 15, 90, 'facil', 4, '{"ALMUERZO","CENA"}', 'Sopas y cremas', true, 'Galicia', 280, 14, 38, 8, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('6975720d-d153-45f8-a741-27241f342061', '37a13337-7b05-4cda-bbfc-96a61617944d', 'debd3546-06e1-4724-a4f9-ff6ca16d8f8f', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('ed6b80a7-e459-43ec-b36c-d2771c26618e', '37a13337-7b05-4cda-bbfc-96a61617944d', '86c84342-6b45-4c3d-a7e4-03a32e7f896e', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('320855ee-df57-4e44-bebe-5be488294984', '37a13337-7b05-4cda-bbfc-96a61617944d', '0459a308-463b-4c25-b477-104a656cfdd5', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('cc0c839c-4639-4a0a-8ebe-8cf8520ca7e1', '37a13337-7b05-4cda-bbfc-96a61617944d', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 20, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('c602baae-0379-4315-9337-1c33f903b043', 'Escalivada catalana', 'Verduras asadas al horno típicas de Cataluña. Sencillo y lleno de sabor.', '1. Precalentar el horno a 200°C.
2. Lavar las berenjenas, pimientos y cebollas.
3. Colocar las verduras enteras en una bandeja de horno.
4. Asar 45-60 minutos, dando la vuelta a mitad.
5. Dejar enfriar envueltas en papel de periódico.
6. Pelar y cortar en tiras.
7. Aliñar con aceite de oliva virgen extra y sal.', 10, 60, 'facil', 4, '{"ALMUERZO","CENA"}', 'Verduras', true, 'Cataluña', 140, 3, 12, 9, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('d2863094-0169-4ad7-83a0-16cf781dc545', 'c602baae-0379-4315-9337-1c33f903b043', '99970995-5e92-40d4-a217-e5c20e370811', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e0bb4dc8-1b2c-4605-9c90-1a11d4629e63', 'c602baae-0379-4315-9337-1c33f903b043', '031ef32f-ae88-4362-aa5e-ab9982983df7', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3d5694e3-2922-4f31-9820-12bffef517ed', 'c602baae-0379-4315-9337-1c33f903b043', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('dae82b68-16e0-401c-b67f-6a268967e091', 'c602baae-0379-4315-9337-1c33f903b043', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('14af2c66-7cff-403c-bd3a-66370cddcc02', 'Revuelto de setas y gambas', 'Revuelto cremoso de huevos con setas de temporada y gambas. Plato elegante y rápido.', '1. Pelar las gambas y reservar.
2. Limpiar y laminar las setas.
3. Picar el ajo finamente.
4. Saltear las setas en aceite de oliva 5 minutos.
5. Añadir las gambas y el ajo, cocinar 2 minutos.
6. Batir los huevos ligeramente con sal.
7. Verter los huevos sobre las setas y gambas.
8. Remover suavemente a fuego bajo hasta que cuaje cremoso.
9. Servir inmediatamente.', 10, 10, 'facil', 4, '{"CENA"}', 'Platos principales', true, NULL, 250, 22, 3, 16, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e806755f-5a9c-45ae-aa18-1cace73b5587', '14af2c66-7cff-403c-bd3a-66370cddcc02', 'c47669f8-11a4-4742-a764-71f6b7667188', 240, 'g', '4 huevos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('0d6ca793-6c19-403f-96b9-e360e40c7ffc', '14af2c66-7cff-403c-bd3a-66370cddcc02', '011e4fd0-a00b-4c99-b513-e4fe491826a1', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('662372ff-b9ad-47a8-b666-47b4138942a4', '14af2c66-7cff-403c-bd3a-66370cddcc02', '426156dc-e082-48ac-8db9-38c14b5a6cbd', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('65f02dfb-d8d8-4bec-8a93-69979819088e', '14af2c66-7cff-403c-bd3a-66370cddcc02', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('f68d5db9-74a1-45af-9b63-95a69578db22', '14af2c66-7cff-403c-bd3a-66370cddcc02', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 25, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('8f5346e3-ddd1-43f3-906b-7d8ff52706a4', 'Crema de calabaza', 'Crema suave y dulce de calabaza, ideal para otoño e invierno. Reconfortante y ligera.', '1. Pelar y trocear la calabaza y la patata.
2. Picar la cebolla.
3. Sofreír la cebolla en aceite de oliva 5 minutos.
4. Añadir calabaza y patata, cubrir con caldo de verduras.
5. Cocinar 25 minutos hasta que estén tiernas.
6. Triturar hasta obtener crema fina.
7. Servir con un chorrito de aceite y semillas de calabaza.', 10, 30, 'facil', 4, '{"ALMUERZO","CENA"}', 'Sopas y cremas', true, NULL, 120, 3, 18, 4, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('15446018-1884-4687-86e2-fc1a4572bdae', '8f5346e3-ddd1-43f3-906b-7d8ff52706a4', '73434dc7-95b0-4d39-94a8-b5fd63de68e3', 500, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('eff9e81b-fcce-424c-842f-547338f93e18', '8f5346e3-ddd1-43f3-906b-7d8ff52706a4', '86c84342-6b45-4c3d-a7e4-03a32e7f896e', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('763316b3-d1d4-440b-b137-db562e1fa09d', '8f5346e3-ddd1-43f3-906b-7d8ff52706a4', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('fba26e8d-b471-4c1b-9ac9-9057b47d2efd', '8f5346e3-ddd1-43f3-906b-7d8ff52706a4', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 20, 'ml', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('1eb22c1d-0cc3-48ef-bdc0-69f9b7b4686c', '8f5346e3-ddd1-43f3-906b-7d8ff52706a4', '877aabb7-2587-4d90-b8ed-c39a22660a75', 15, 'g', 'para decorar');
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('fba918e8-d49c-456e-be68-8c86d11fcf12', 'Bacalao al pil-pil', 'Plato emblemático del País Vasco. Bacalao en salsa emulsionada de ajo y aceite.', '1. Desalar el bacalao 48 horas cambiando el agua.
2. Laminar los ajos y dorarlos en aceite de oliva suave. Reservar.
3. En el mismo aceite templado, colocar el bacalao con la piel hacia arriba.
4. Cocinar a fuego muy bajo 10 minutos.
5. Retirar el bacalao y con el aceite de la cazuela hacer movimientos circulares para emulsionar la gelatina del bacalao.
6. Ir añadiendo cucharadas de agua hasta lograr la salsa.
7. Colocar el bacalao en la salsa y servir con los ajos.', 15, 20, 'dificil', 4, '{"ALMUERZO","CENA"}', 'Pescados', true, 'País Vasco', 320, 24, 2, 24, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('75b8a5a3-430e-4aef-be0a-8855be66c7ff', 'fba918e8-d49c-456e-be68-8c86d11fcf12', 'a93c5690-1db0-47df-a9d5-dee5da31059b', 500, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('7cd069c4-12af-4b54-8fdc-15a0caccf118', 'fba918e8-d49c-456e-be68-8c86d11fcf12', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 20, 'g', '4-5 dientes');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('823e7162-43b1-41b2-9937-845e100cd108', 'fba918e8-d49c-456e-be68-8c86d11fcf12', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 100, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('c559d2b6-38a5-4158-ac7a-e95c1df73b89', 'Patatas bravas', 'Tapa madrileña por excelencia. Patatas fritas con salsa brava picante.', '1. Pelar y cortar las patatas en dados grandes.
2. Freír en aceite abundante hasta dorar.
3. Para la salsa: sofreír cebolla y ajo picados.
4. Añadir tomate rallado y pimentón.
5. Cocinar 10 minutos y triturar.
6. Servir las patatas calientes con la salsa por encima.', 15, 25, 'facil', 4, '{"ALMUERZO","CENA"}', 'Aperitivos', true, 'Madrid', 280, 4, 32, 15, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('aa874079-d8aa-45fd-aa6e-76dae0292e4b', 'c559d2b6-38a5-4158-ac7a-e95c1df73b89', '86c84342-6b45-4c3d-a7e4-03a32e7f896e', 500, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('8e281105-703a-4014-9914-213abb85f127', 'c559d2b6-38a5-4158-ac7a-e95c1df73b89', '0cf62664-c768-408e-9d5c-e3ff9b619745', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('275d2e82-f895-4234-950e-e30e1499c844', 'c559d2b6-38a5-4158-ac7a-e95c1df73b89', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 50, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('0b491763-20fb-41ca-95dd-b6485c19a877', 'c559d2b6-38a5-4158-ac7a-e95c1df73b89', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('ce2daf7f-011f-46ab-9e69-1fb672c0df96', 'c559d2b6-38a5-4158-ac7a-e95c1df73b89', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 40, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('549918c7-8a0c-42e4-8b9d-81d0babc11f9', 'Conejo al ajillo', 'Receta tradicional castellana de conejo confitado con ajo y hierbas aromáticas.', '1. Trocear el conejo y salpimentar.
2. Dorar en cazuela con aceite de oliva a fuego fuerte.
3. Añadir los ajos enteros pelados.
4. Bajar el fuego, añadir un chorro de vino blanco.
5. Tapar y cocinar a fuego lento 45 minutos.
6. Servir con su salsa.', 10, 50, 'media', 4, '{"ALMUERZO"}', 'Carnes', true, 'Castilla', 310, 28, 2, 20, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e38773c3-f4c5-488d-990a-889facf523f3', '549918c7-8a0c-42e4-8b9d-81d0babc11f9', '47d697e5-4938-4873-8736-95ea454d4eee', 600, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('d9553565-5ae5-4022-b619-99dfde638df1', '549918c7-8a0c-42e4-8b9d-81d0babc11f9', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 30, 'g', '8-10 dientes');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e140e8a8-b305-44de-b3c0-4a734bf1fa9b', '549918c7-8a0c-42e4-8b9d-81d0babc11f9', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 50, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('b3d2ff29-bcd5-476c-9e2d-c4314c10e927', 'Ensalada de garbanzos', 'Ensalada fresca y nutritiva con garbanzos, verduras crujientes y vinagreta de limón.', '1. Escurrir los garbanzos cocidos.
2. Cortar tomate, pepino y cebolla en dados.
3. Picar la rúcula.
4. Mezclar todo en un bol.
5. Aliñar con aceite de oliva, zumo de limón y sal.
6. Servir a temperatura ambiente.', 15, 0, 'facil', 4, '{"ALMUERZO","CENA"}', 'Ensaladas', true, NULL, 260, 12, 30, 10, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b0ae55a2-0571-4300-84f3-f373c725a82f', 'b3d2ff29-bcd5-476c-9e2d-c4314c10e927', 'cd50880d-ac6d-4564-a1f4-9dec5298c8e1', 400, 'g', 'cocidos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('5f1961a4-119b-42fe-afca-7501767c1054', 'b3d2ff29-bcd5-476c-9e2d-c4314c10e927', '0cf62664-c768-408e-9d5c-e3ff9b619745', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('67b32348-6e1e-4a4e-b3d6-52ecb77c4c75', 'b3d2ff29-bcd5-476c-9e2d-c4314c10e927', '013fc351-1cb6-4035-9f4d-c874d3976b09', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('f62fd778-d0a7-4796-98a7-5f5b58325415', 'b3d2ff29-bcd5-476c-9e2d-c4314c10e927', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 50, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3238a4df-76e6-4390-b392-7d7770acfb7e', 'b3d2ff29-bcd5-476c-9e2d-c4314c10e927', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('09341b2f-3333-47a0-979c-671547e4b0d0', 'b3d2ff29-bcd5-476c-9e2d-c4314c10e927', '374f68bd-c07b-48f3-b23b-2625d9f3ae97', 30, 'ml', 'zumo');
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('dc3ca001-55d0-4c4b-99c9-d06289d7303c', 'Albóndigas en salsa de tomate', 'Albóndigas caseras de ternera en salsa de tomate casera. Un clásico familiar.', '1. Mezclar la carne picada con huevo, pan rallado, ajo y perejil.
2. Formar bolas con las manos.
3. Freír las albóndigas en aceite hasta dorar.
4. Para la salsa: sofreír cebolla y ajo picados.
5. Añadir tomate rallado y cocinar 15 minutos.
6. Incorporar las albóndigas a la salsa.
7. Cocinar a fuego lento 20 minutos.', 20, 40, 'media', 4, '{"ALMUERZO","CENA"}', 'Carnes', true, NULL, 380, 28, 15, 22, false, false, false, true, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('66e529c9-bedf-4473-87d7-fe574ed030c3', 'dc3ca001-55d0-4c4b-99c9-d06289d7303c', '294f7579-1f90-4b00-ae42-214f9ed1ec20', 400, 'g', 'carne picada');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('390b6151-b51a-445e-a633-1235be2fc1c2', 'dc3ca001-55d0-4c4b-99c9-d06289d7303c', 'c47669f8-11a4-4742-a764-71f6b7667188', 60, 'g', '1 huevo');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('c2674ea0-314f-4d87-8b49-a50a5ed5ed37', 'dc3ca001-55d0-4c4b-99c9-d06289d7303c', 'efcc7d8c-5c41-4d79-9f40-6175c7e432db', 30, 'g', 'rallado');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('58fca39f-b548-4edf-8f58-14baf22513c2', 'dc3ca001-55d0-4c4b-99c9-d06289d7303c', '0cf62664-c768-408e-9d5c-e3ff9b619745', 400, 'g', 'rallado');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('bc5aa80e-614c-4f15-a5c5-685643750bb9', 'dc3ca001-55d0-4c4b-99c9-d06289d7303c', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3260e505-1172-48e6-a825-b2fac5eb4dba', 'dc3ca001-55d0-4c4b-99c9-d06289d7303c', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('781a0336-8ee2-48f6-9a1d-531807b51970', 'dc3ca001-55d0-4c4b-99c9-d06289d7303c', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('742cdc47-0eaf-4451-bf89-f2ab4db9c488', 'Arroz negro con calamares', 'Arroz teñido con tinta de calamar, típico del Mediterráneo español.', '1. Limpiar los calamares y reservar la tinta.
2. Cortar los calamares en anillas.
3. Sofreír cebolla y ajo picados.
4. Añadir los calamares y cocinar 5 minutos.
5. Añadir tomate rallado y la tinta disuelta en caldo.
6. Incorporar el arroz y cubrir con caldo caliente.
7. Cocinar 18-20 minutos sin remover.', 15, 25, 'media', 4, '{"ALMUERZO"}', 'Arroces', true, 'Valencia', 380, 18, 50, 10, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('8f163e96-6302-4bcf-a143-97d943cce5fb', '742cdc47-0eaf-4451-bf89-f2ab4db9c488', 'a4df24a0-5d5e-4c1a-af39-2bfcd0e0f8ac', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('0ac3a0a8-99ac-4fd6-9891-92c2f95ad522', '742cdc47-0eaf-4451-bf89-f2ab4db9c488', '56549b79-74ee-4bab-9791-112faf050838', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('355a7dbb-47a7-4d29-84d0-21fbcaa0c6db', '742cdc47-0eaf-4451-bf89-f2ab4db9c488', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('fbe512ce-6977-4139-916c-4213fdd508c8', '742cdc47-0eaf-4451-bf89-f2ab4db9c488', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('8a1ba767-6ee2-4cf0-9bb6-8bde5b3f3e97', '742cdc47-0eaf-4451-bf89-f2ab4db9c488', '0cf62664-c768-408e-9d5c-e3ff9b619745', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('768d3aad-e4fa-47a9-a5a3-8b301e233e73', '742cdc47-0eaf-4451-bf89-f2ab4db9c488', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('85174125-73ed-4cf4-a01e-58f21981208e', 'Tortilla de espinacas', 'Variante saludable de la tortilla española, con espinacas frescas y cebolla.', '1. Lavar las espinacas y saltearlas brevemente.
2. Picar la cebolla y sofreír hasta transparentar.
3. Batir los huevos con sal.
4. Mezclar espinacas y cebolla con los huevos.
5. Cuajar en sartén antiadherente 4-5 minutos por cada lado.
6. Servir templada.', 10, 15, 'facil', 4, '{"ALMUERZO","CENA"}', 'Platos principales', true, NULL, 180, 13, 4, 12, true, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('0f181de2-6db8-4a32-8a6e-134f7bbeb104', '85174125-73ed-4cf4-a01e-58f21981208e', 'c47669f8-11a4-4742-a764-71f6b7667188', 240, 'g', '4 huevos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('a5f65de1-cf01-4b95-9af6-af773b795987', '85174125-73ed-4cf4-a01e-58f21981208e', 'ec9e1c4d-9b2d-4bd3-83ab-8801750e8fbc', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b8123dad-65db-4417-b58f-141bc2dcd697', '85174125-73ed-4cf4-a01e-58f21981208e', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('87e87bdb-c1e6-4324-a265-dee669febb1f', '85174125-73ed-4cf4-a01e-58f21981208e', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 20, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('170908a0-d3ee-4e91-8295-8bdd711478f4', 'Sopa de ajo castellana', 'Sopa tradicional castellana, humilde y reconfortante, con pan, ajo y pimentón.', '1. Laminar los ajos y dorar en aceite de oliva.
2. Añadir el pan cortado en rebanadas finas.
3. Agregar pimentón y remover rápido.
4. Cubrir con caldo de pollo caliente.
5. Cocinar 10 minutos.
6. Cascar un huevo por persona sobre la sopa.
7. Gratinar al horno 5 minutos.', 10, 20, 'facil', 4, '{"CENA"}', 'Sopas y cremas', true, 'Castilla', 220, 12, 22, 10, true, false, false, true, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('1c07c426-dbd1-4029-a3c1-93c49805848d', '170908a0-d3ee-4e91-8295-8bdd711478f4', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 20, 'g', '4-5 dientes');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('8bc05328-c851-4835-9b37-5721f52c3f3d', '170908a0-d3ee-4e91-8295-8bdd711478f4', 'efcc7d8c-5c41-4d79-9f40-6175c7e432db', 100, 'g', 'del día anterior');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3ef7b369-1e86-4ce2-b0a8-2d1d3b57764e', '170908a0-d3ee-4e91-8295-8bdd711478f4', 'c47669f8-11a4-4742-a764-71f6b7667188', 240, 'g', '4 huevos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('115b3a9f-d38b-4bb1-898b-ce0d7226ec0d', '170908a0-d3ee-4e91-8295-8bdd711478f4', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('e6a236df-fa22-4b22-83e7-9878c852f5e3', 'Ensalada de lentejas', 'Ensalada templada de lentejas con verduras frescas. Nutritiva y saciante.', '1. Cocer las lentejas 25 minutos. Escurrir y templar.
2. Cortar tomate, pimiento rojo y cebolla en dados.
3. Mezclar las lentejas con las verduras.
4. Aliñar con aceite de oliva y vinagre.
5. Servir templada o fría.', 10, 25, 'facil', 4, '{"ALMUERZO","CENA"}', 'Ensaladas', true, NULL, 290, 18, 38, 8, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('7794443b-d214-4c7b-9f62-3da17de68010', 'e6a236df-fa22-4b22-83e7-9878c852f5e3', '5d4e86d8-4987-4f35-8a07-a0bd24f16ae3', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('09b7f698-0e83-4168-a2c0-bbd50f2d6426', 'e6a236df-fa22-4b22-83e7-9878c852f5e3', '0cf62664-c768-408e-9d5c-e3ff9b619745', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('a0f783b7-fa07-40c7-932a-44df5b9542d4', 'e6a236df-fa22-4b22-83e7-9878c852f5e3', '031ef32f-ae88-4362-aa5e-ab9982983df7', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('9e6249a4-9a9d-421d-b1e8-8059cf46a09e', 'e6a236df-fa22-4b22-83e7-9878c852f5e3', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('f27af911-1bc0-45e9-adf3-06aa5a74c289', 'e6a236df-fa22-4b22-83e7-9878c852f5e3', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('c4ae2aae-5eba-4468-963c-b8adc24442ce', 'Dorada al horno con verduras', 'Dorada fresca al horno sobre cama de verduras mediterráneas.', '1. Precalentar horno a 190°C.
2. Cortar patatas, cebolla y tomate en rodajas.
3. Disponer las verduras en fuente de horno.
4. Aliñar con aceite, sal y hierbas.
5. Hornear 15 minutos.
6. Colocar la dorada limpia encima.
7. Hornear 25 minutos más.', 15, 40, 'facil', 4, '{"ALMUERZO","CENA"}', 'Pescados', true, NULL, 290, 26, 22, 10, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('4131a598-8129-48ed-baf7-c5c2b9721f3d', 'c4ae2aae-5eba-4468-963c-b8adc24442ce', 'bbbd4a5a-7982-4936-b5ad-c904b0a5f2bb', 500, 'g', '2 doradas');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('112fa388-9226-40a7-b2b5-7ce895ccffc8', 'c4ae2aae-5eba-4468-963c-b8adc24442ce', '86c84342-6b45-4c3d-a7e4-03a32e7f896e', 300, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('43dbdac3-744a-407c-840d-e6939576d2cc', 'c4ae2aae-5eba-4468-963c-b8adc24442ce', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('c6c53091-ad65-4598-be84-5ca55c04df00', 'c4ae2aae-5eba-4468-963c-b8adc24442ce', '0cf62664-c768-408e-9d5c-e3ff9b619745', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('d45c0c74-e6a2-47a9-9d04-6a95306d9455', 'c4ae2aae-5eba-4468-963c-b8adc24442ce', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('d832d57d-3252-4250-b05b-4ef39ea405da', 'Wok de verduras con pollo', 'Salteado rápido de verduras variadas con pollo. Saludable y colorido.', '1. Cortar la pechuga de pollo en tiras y salpimentar.
2. Cortar todas las verduras en juliana fina.
3. Calentar aceite en wok a fuego fuerte.
4. Saltear el pollo 4-5 minutos. Reservar.
5. Saltear las verduras 3-4 minutos (deben quedar crujientes).
6. Incorporar el pollo de nuevo.
7. Servir caliente.', 15, 10, 'facil', 4, '{"ALMUERZO","CENA"}', 'Platos principales', false, NULL, 240, 30, 10, 8, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('9b4a37e7-8ab7-4a7e-b9a4-26dd176f94da', 'd832d57d-3252-4250-b05b-4ef39ea405da', '7ff780b9-f9a4-4a2a-8563-c4a7d102daba', 400, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e7e6e133-7d92-4d74-b410-57968da372c7', 'd832d57d-3252-4250-b05b-4ef39ea405da', '031ef32f-ae88-4362-aa5e-ab9982983df7', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('63aeec9a-ef95-41db-99ef-1d070d61214d', 'd832d57d-3252-4250-b05b-4ef39ea405da', '58b5fe1f-7250-479e-a8a6-74215c4eef8c', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('8750f2f6-aa22-43cd-b986-8ba8710d97e4', 'd832d57d-3252-4250-b05b-4ef39ea405da', '4797d7bc-cea4-45db-bcbd-894e4a37179b', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('2779e070-b3d0-489e-83f5-e79c5ff4fdd9', 'd832d57d-3252-4250-b05b-4ef39ea405da', '52595d0d-32e4-4c7c-9e63-14bff7c573e8', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('28d1fe15-b5be-4e88-ab3a-9acd1592c500', 'd832d57d-3252-4250-b05b-4ef39ea405da', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 20, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('a7797886-4baf-46e5-ba6d-812d0da2c285', 'Sardinas a la plancha', 'Sardinas frescas a la plancha con ajo y perejil. Sencillo, sabroso y rico en omega-3.', '1. Limpiar las sardinas (quitar escamas y tripas).
2. Salar ligeramente.
3. Calentar la plancha a fuego fuerte.
4. Cocinar las sardinas 2-3 minutos por cada lado.
5. Servir con un picadillo de ajo y perejil con aceite de oliva.', 10, 6, 'facil', 4, '{"ALMUERZO","CENA"}', 'Pescados', true, NULL, 250, 28, 1, 14, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('61f4ed20-d9b9-4135-849e-eb9beedb001b', 'a7797886-4baf-46e5-ba6d-812d0da2c285', 'c4c8b7fa-96e8-48a0-b317-5a49f1cae4a0', 500, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('0ffa45e4-b041-4e74-ac55-92838e5ad5ae', 'a7797886-4baf-46e5-ba6d-812d0da2c285', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 10, 'g', '2 dientes');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('7936faa8-8e2b-4611-a1a2-18938a9b92f9', 'a7797886-4baf-46e5-ba6d-812d0da2c285', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 20, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('d1a1c624-235c-47c3-9849-e209cb0e7d45', 'Gazpacho de sandía', 'Versión veraniega y refrescante del gazpacho tradicional con sandía.', '1. Trocear la sandía sin pepitas y el tomate.
2. Triturar con pepino, aceite y vinagre.
3. Colar si se desea.
4. Refrigerar 2 horas mínimo.
5. Servir muy frío.', 10, 0, 'facil', 4, '{"ALMUERZO","CENA"}', 'Sopas y cremas', true, NULL, 90, 1, 12, 5, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('353e2f16-c8ec-40e5-ba80-e5cc4e918c4c', 'd1a1c624-235c-47c3-9849-e209cb0e7d45', 'fe8c4e14-815a-4336-88a8-4b07dd1ca783', 400, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('735d0822-b010-4640-b3c3-e1e449a7db6a', 'd1a1c624-235c-47c3-9849-e209cb0e7d45', '0cf62664-c768-408e-9d5c-e3ff9b619745', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e773020c-102c-422f-8865-371f946312df', 'd1a1c624-235c-47c3-9849-e209cb0e7d45', '013fc351-1cb6-4035-9f4d-c874d3976b09', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b02500d8-fc98-4a96-b367-e0acfbb13a40', 'd1a1c624-235c-47c3-9849-e209cb0e7d45', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 20, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('5be5be35-5f26-4523-b4ae-5440c7c41108', 'Cuscús con verduras', 'Cuscús rápido con verduras salteadas y especias. Plato completo y ligero.', '1. Preparar el cuscús con agua hirviendo según indicaciones.
2. Cortar calabacín, pimiento y zanahoria en dados.
3. Saltear las verduras en aceite 8 minutos.
4. Añadir garbanzos cocidos y calentar.
5. Mezclar el cuscús con las verduras.
6. Aliñar con aceite de oliva y servir.', 10, 10, 'facil', 4, '{"ALMUERZO","CENA"}', 'Platos principales', false, NULL, 320, 12, 48, 8, true, true, false, true, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('7ed9e2af-4df7-49c0-990e-a54022deaf44', '5be5be35-5f26-4523-b4ae-5440c7c41108', '76a0251f-f3ff-44d0-a579-26908c84c9b9', 240, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('5088904a-fa8c-4bae-8c7e-fd55e956b35d', '5be5be35-5f26-4523-b4ae-5440c7c41108', '58b5fe1f-7250-479e-a8a6-74215c4eef8c', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('283ab305-fbeb-48c9-9a28-9a6865e098ed', '5be5be35-5f26-4523-b4ae-5440c7c41108', '031ef32f-ae88-4362-aa5e-ab9982983df7', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('888bc562-c142-43d9-9e7d-1e1641072383', '5be5be35-5f26-4523-b4ae-5440c7c41108', '4797d7bc-cea4-45db-bcbd-894e4a37179b', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('8d2ac86a-6d65-4733-bc18-dd9c4be07b77', '5be5be35-5f26-4523-b4ae-5440c7c41108', 'cd50880d-ac6d-4564-a1f4-9dec5298c8e1', 150, 'g', 'cocidos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('4703d983-b614-4718-8c3b-c4a1556f6dcc', '5be5be35-5f26-4523-b4ae-5440c7c41108', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 25, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('90f11dd6-a9d8-4994-aba9-997af9c839c3', 'Brochetas de pollo con verduras', 'Brochetas coloridas de pollo marinado con verduras. Ideal para barbacoa o plancha.', '1. Cortar pollo en dados grandes.
2. Marinar con aceite, ajo picado, limón y sal 30 minutos.
3. Cortar pimiento y cebolla en trozos para ensartar.
4. Montar las brochetas alternando pollo y verduras.
5. Cocinar a la plancha o barbacoa 5-6 minutos por lado.
6. Servir calientes.', 15, 12, 'facil', 4, '{"ALMUERZO","CENA"}', 'Carnes', false, NULL, 230, 32, 6, 8, false, false, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('c0c2b0e1-3463-4b2e-a119-fe857161dcee', '90f11dd6-a9d8-4994-aba9-997af9c839c3', '7ff780b9-f9a4-4a2a-8563-c4a7d102daba', 500, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('0d3424ed-7665-495b-9c4c-2a3e97ea2357', '90f11dd6-a9d8-4994-aba9-997af9c839c3', '031ef32f-ae88-4362-aa5e-ab9982983df7', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('9c14b3cb-059d-497b-a561-a0a4ee756016', '90f11dd6-a9d8-4994-aba9-997af9c839c3', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('07237ff8-be50-4c09-81bc-14e5a010f4bd', '90f11dd6-a9d8-4994-aba9-997af9c839c3', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 25, 'ml', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b808fb4e-2a85-458f-8ab6-9bf6e3a25e7f', '90f11dd6-a9d8-4994-aba9-997af9c839c3', '374f68bd-c07b-48f3-b23b-2625d9f3ae97', 30, 'ml', 'zumo');
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('d5677d60-26c2-454c-8a53-2ffadfb468d1', 'Menestra de verduras', 'Guiso navarro de verduras de temporada. Plato colorido y muy nutritivo.', '1. Cocer por separado alcachofas, judías verdes y guisantes.
2. Picar cebolla y ajo.
3. Sofreír cebolla y ajo en aceite.
4. Añadir las verduras cocidas y zanahoria en rodajas.
5. Rehogar todo junto 10 minutos.
6. Salar y servir caliente.', 15, 30, 'media', 4, '{"ALMUERZO","CENA"}', 'Verduras', true, 'Navarra', 160, 6, 18, 7, true, true, false, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('5156b68e-eea5-4de5-98bf-360ad0dfb220', 'd5677d60-26c2-454c-8a53-2ffadfb468d1', 'f85786c8-a56c-448a-9c4d-f0abbe803973', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('94d421d1-6813-4c3f-a5c4-7d18b50c886e', 'd5677d60-26c2-454c-8a53-2ffadfb468d1', '8737b15b-4506-47e2-9dee-a9f832cb6f48', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('5297aa2f-f269-465e-8a82-23eea64bd092', 'd5677d60-26c2-454c-8a53-2ffadfb468d1', 'e592bee9-125c-4e54-965b-5168a5d819ae', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('8bde845c-f0e6-476a-a610-d3d04dd91aaa', 'd5677d60-26c2-454c-8a53-2ffadfb468d1', '4797d7bc-cea4-45db-bcbd-894e4a37179b', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('6409dd87-bd4a-4a77-8c96-cdfda38470b5', 'd5677d60-26c2-454c-8a53-2ffadfb468d1', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('5b39ae04-c5fe-4800-9cf8-b4a5a1624b6a', 'd5677d60-26c2-454c-8a53-2ffadfb468d1', 'c191ccb7-c7c5-44b1-9f9a-9b97c9806834', 5, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('1c4d9ca2-ff24-4856-8d79-f61260f89fbd', 'd5677d60-26c2-454c-8a53-2ffadfb468d1', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 25, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('c115fc5a-07e3-4108-aa47-f605d1a75634', 'Tostada de aguacate con huevo', 'Desayuno moderno y nutritivo. Pan integral con aguacate machacado y huevo escalfado.', '1. Tostar las rebanadas de pan integral.
2. Machacar el aguacate con tenedor, sal y limón.
3. Untar el aguacate en las tostadas.
4. Escalfar los huevos en agua con vinagre.
5. Colocar un huevo sobre cada tostada.
6. Salpimentar y servir.', 5, 5, 'facil', 2, '{"DESAYUNO"}', 'Desayunos', false, NULL, 340, 14, 28, 20, true, false, false, true, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('7215fb7e-e689-42f8-9c2d-d945dc00b810', 'c115fc5a-07e3-4108-aa47-f605d1a75634', '0e4a144e-e9a8-4e15-beda-8bb741246e30', 80, 'g', '2 rebanadas');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('ab17c9b4-7518-4e82-bf02-44997f0d1485', 'c115fc5a-07e3-4108-aa47-f605d1a75634', 'f43b19a4-a1e6-48db-8d59-e6d2d9a66383', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('b68cafec-67b1-4498-adc0-b7b865a3e4a2', 'c115fc5a-07e3-4108-aa47-f605d1a75634', 'c47669f8-11a4-4742-a764-71f6b7667188', 120, 'g', '2 huevos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('a48ba252-2539-4f1b-beee-5295513dfac4', 'c115fc5a-07e3-4108-aa47-f605d1a75634', '374f68bd-c07b-48f3-b23b-2625d9f3ae97', 10, 'ml', 'unas gotas');
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('5473b9b8-b004-4639-9e93-83a17d0d953f', 'Porridge de avena con frutas', 'Gachas de avena cremosas con frutas frescas. Desayuno energético y saciante.', '1. Calentar la leche en un cazo.
2. Añadir la avena y cocinar 5 minutos removiendo.
3. Servir en bol.
4. Cortar el plátano en rodajas y añadir fresas.
5. Espolvorear con semillas de chía.
6. Añadir un chorrito de miel si se desea.', 5, 5, 'facil', 2, '{"DESAYUNO"}', 'Desayunos', false, NULL, 310, 12, 50, 7, true, false, true, true, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3a625e78-f818-43dc-ad79-14985d937d74', '5473b9b8-b004-4639-9e93-83a17d0d953f', '799518ff-1bf1-41d5-939c-d835c9c84f3d', 60, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('d47b5e3a-627c-42db-a782-01916b98ee0b', '5473b9b8-b004-4639-9e93-83a17d0d953f', '5d9a03a2-42c1-490a-96aa-952d1aead63b', 300, 'ml', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('1a990a7d-309c-4012-a34d-6b66436dbd38', '5473b9b8-b004-4639-9e93-83a17d0d953f', '71c42525-94b5-4d2f-a621-fb599870147e', 80, 'g', '1 plátano');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('af996ebb-aba6-4d4c-970e-30ef04539868', '5473b9b8-b004-4639-9e93-83a17d0d953f', 'ffc45918-8446-44fe-a9e0-0f6530a17027', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('28bfa78c-f256-45ce-8292-43d64c63eb02', '5473b9b8-b004-4639-9e93-83a17d0d953f', '6147f4d1-db87-4d1c-a71a-74813139e2de', 10, 'g', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('f7ea2fe3-5a04-436f-b6ce-464b9b9e3b84', 'Fideuá', 'Plato marinero similar a la paella pero con fideos en lugar de arroz. Típico de Gandía.', '1. Hacer un fumet con cabezas de gamba y agua.
2. Sofreír las gambas y calamares en aceite.
3. Añadir tomate rallado y sofreír.
4. Incorporar los fideos y tostar ligeramente.
5. Añadir el fumet caliente.
6. Cocinar 10-12 minutos hasta que los fideos absorban el caldo.
7. Gratinar en el horno 2 minutos.', 15, 25, 'media', 4, '{"ALMUERZO"}', 'Arroces', true, 'Valencia', 360, 22, 42, 12, false, false, false, true, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('e087d73c-242e-40f2-8813-8ac5b0768937', 'f7ea2fe3-5a04-436f-b6ce-464b9b9e3b84', '0e701242-ab76-4e8f-ae4a-9d4714df423e', 280, 'g', 'fideos gruesos');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('ea9b95e4-6b3c-4226-8a9f-809a2648d84b', 'f7ea2fe3-5a04-436f-b6ce-464b9b9e3b84', '011e4fd0-a00b-4c99-b513-e4fe491826a1', 200, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('dbd79162-ed5f-4cec-a4d0-ef98d1653c74', 'f7ea2fe3-5a04-436f-b6ce-464b9b9e3b84', '56549b79-74ee-4bab-9791-112faf050838', 150, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3bc99f9d-7ded-4792-930e-fd111a91ebbd', 'f7ea2fe3-5a04-436f-b6ce-464b9b9e3b84', '0cf62664-c768-408e-9d5c-e3ff9b619745', 100, 'g', 'rallado');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('3ec6709b-0943-4093-bb30-4a58dcf3106a', 'f7ea2fe3-5a04-436f-b6ce-464b9b9e3b84', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 30, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('32b2c794-7e07-4caf-ba54-cc32ed23aacc', 'Berenjenas rellenas', 'Berenjenas asadas rellenas de verduras y carne. Plato completo y sabroso.', '1. Cortar berenjenas por la mitad y vaciar parte de la pulpa.
2. Picar la pulpa, cebolla, pimiento y tomate.
3. Sofreír la carne picada con las verduras.
4. Rellenar las berenjenas con la mezcla.
5. Espolvorear con queso rallado.
6. Hornear a 180°C durante 30 minutos.', 20, 35, 'media', 4, '{"ALMUERZO","CENA"}', 'Verduras', true, NULL, 280, 18, 14, 16, false, false, true, false, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('01bbca0a-4bc3-421b-bbba-20e6320acad2', '32b2c794-7e07-4caf-ba54-cc32ed23aacc', '99970995-5e92-40d4-a217-e5c20e370811', 400, 'g', '2 berenjenas');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('a8675e37-5a75-433c-a8c7-355a167cc4cd', '32b2c794-7e07-4caf-ba54-cc32ed23aacc', '294f7579-1f90-4b00-ae42-214f9ed1ec20', 200, 'g', 'carne picada');
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('d2bc241c-807c-4f14-8fe9-e0d79217516f', '32b2c794-7e07-4caf-ba54-cc32ed23aacc', 'e20fd3b0-5551-4eda-bd55-68b8c283fa45', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('6286986a-0bed-462a-b29f-ed3edbf14ba5', '32b2c794-7e07-4caf-ba54-cc32ed23aacc', '031ef32f-ae88-4362-aa5e-ab9982983df7', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('4ac54fa4-0358-4c63-8c7d-7622af87425d', '32b2c794-7e07-4caf-ba54-cc32ed23aacc', '0cf62664-c768-408e-9d5c-e3ff9b619745', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('84ccfda4-9cda-46b4-a49e-a6a3b4392813', '32b2c794-7e07-4caf-ba54-cc32ed23aacc', 'ea7b0dc8-2864-48fa-be5f-0214fd1581fe', 60, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('998153fd-7a40-4728-8f38-8cff7e320a3d', '32b2c794-7e07-4caf-ba54-cc32ed23aacc', '96f95e25-df7d-4eea-bfc5-4785f5bba1ab', 20, 'ml', NULL);
INSERT INTO "Receta" (id, nombre, descripcion, instrucciones, "tiempoPreparacion", "tiempoCoccion", dificultad, raciones, "tipoComida", categoria, "estiloEspanol", region, "caloriasPorRacion", "proteinasPorRacion", "carbohidratosPorRacion", "grasasPorRacion", "esAptoVegetariano", "esAptoVegano", "contieneLactosa", "contieneGluten", "createdAt", "updatedAt") VALUES ('a59514a5-c076-437e-a546-703e64a0785a', 'Smoothie verde energético', 'Batido verde nutritivo con espinacas, plátano y kiwi. Perfecto para empezar el día.', '1. Lavar las espinacas.
2. Pelar el plátano y el kiwi.
3. Triturar todo con la bebida de avena.
4. Añadir semillas de chía.
5. Servir frío.', 5, 0, 'facil', 2, '{"DESAYUNO"}', 'Desayunos', false, NULL, 170, 4, 32, 3, true, true, false, true, NOW(), NOW());
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('ec2b2d86-2b3c-4025-97a9-3969b19acadf', 'a59514a5-c076-437e-a546-703e64a0785a', 'ec9e1c4d-9b2d-4bd3-83ab-8801750e8fbc', 60, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('9fe9c8fe-fc43-4a1c-867d-ced37a6278ff', 'a59514a5-c076-437e-a546-703e64a0785a', '71c42525-94b5-4d2f-a621-fb599870147e', 80, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('6d0caa4d-8d9f-4d8f-9b63-a4a21ccde09a', 'a59514a5-c076-437e-a546-703e64a0785a', '19de0e87-2295-45f8-8ecf-e58a09ee3203', 100, 'g', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('a9810f78-ed50-4046-a8ee-0144f14a2b50', 'a59514a5-c076-437e-a546-703e64a0785a', '4c25307d-481e-43a5-87d7-8c03399f0591', 200, 'ml', NULL);
INSERT INTO "RecetaAlimento" (id, "recetaId", "alimentoId", cantidad, unidad, notas) VALUES ('84e97ebb-e6a4-41cb-a7c7-84dea2d07049', 'a59514a5-c076-437e-a546-703e64a0785a', '6147f4d1-db87-4d1c-a71a-74813139e2de', 10, 'g', NULL);
