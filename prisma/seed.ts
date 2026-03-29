import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';
import { alimentosSeed } from './seed/alimentos';
import { alimentosSeed2 } from './seed/alimentos2';
import { alimentosSeed3 } from './seed/alimentos3';
import { recetasSeed } from './seed/recetas';
import { recetasSeed2 } from './seed/recetas2';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Iniciando seed de la base de datos...');

  // Clean existing data
  console.log('🧹 Limpiando datos existentes...');
  await prisma.planComidaReceta.deleteMany();
  await prisma.planComidaAlimento.deleteMany();
  await prisma.planComida.deleteMany();
  await prisma.planDia.deleteMany();
  await prisma.planificacion.deleteMany();
  await prisma.planNutricional.deleteMany();
  await prisma.recetaAlimento.deleteMany();
  await prisma.receta.deleteMany();
  await prisma.mensaje.deleteMany();
  await prisma.conversacion.deleteMany();
  await prisma.medicion.deleteMany();
  await prisma.anamnesis.deleteMany();
  await prisma.whatsAppLog.deleteMany();
  await prisma.alimento.deleteMany();
  await prisma.paciente.deleteMany();
  await prisma.nutricionista.deleteMany();
  await prisma.user.deleteMany();

  // Create demo nutricionista
  console.log('👤 Creando usuarios de demostración...');
  const nutriPassword = await bcrypt.hash('nutriplan123', 10);
  const nutriUser = await prisma.user.create({
    data: {
      email: 'nutricionista@nutriplanpro.com',
      password: nutriPassword,
      nombre: 'María',
      apellidos: 'García López',
      rol: 'NUTRICIONISTA',
      telefono: '+34612345678',
      nutricionista: {
        create: {
          numColegiado: 'MAD-1234',
          especialidad: 'Nutrición clínica y deportiva',
          clinica: 'NutriPlan Pro Clinic',
          direccion: 'Calle Gran Vía 1, Madrid',
          whatsappNumber: '+34676002647',
          bio: 'Nutricionista colegiada con 10 años de experiencia en nutrición clínica y deportiva.',
        },
      },
    },
    include: { nutricionista: true },
  });

  // Create demo paciente
  const pacientePassword = await bcrypt.hash('paciente123', 10);
  const pacienteUser = await prisma.user.create({
    data: {
      email: 'paciente@nutriplanpro.com',
      password: pacientePassword,
      nombre: 'Carlos',
      apellidos: 'Martínez Ruiz',
      rol: 'PACIENTE',
      telefono: '+34698765432',
      paciente: {
        create: {
          nutricionistaId: nutriUser.nutricionista!.id,
          fechaNacimiento: new Date('1990-05-15'),
          sexo: 'MASCULINO',
          altura: 178,
          pesoActual: 85,
          pesoObjetivo: 78,
          imc: 26.8,
        },
      },
    },
    include: { paciente: true },
  });

  // Create conversation
  await prisma.conversacion.create({
    data: {
      pacienteId: pacienteUser.paciente!.id,
      ultimoMensaje: '¡Hola! Bienvenido a NutriPlan Pro',
      mensajes: {
        create: {
          remitenteId: nutriUser.id,
          destinatarioId: pacienteUser.id,
          contenido: '¡Hola Carlos! Bienvenido a NutriPlan Pro. Estoy aquí para ayudarte con tu plan nutricional.',
          tipo: 'texto',
          leido: true,
        },
      },
    },
  });

  // Seed alimentos
  console.log('🍎 Insertando alimentos...');
  const allAlimentos = [...alimentosSeed, ...alimentosSeed2, ...alimentosSeed3];

  const createdAlimentos: Record<string, string> = {};

  for (const alimento of allAlimentos) {
    try {
      const created = await prisma.alimento.create({
        data: {
          nombre: alimento.nombre,
          grupoIntercambio: alimento.grupoIntercambio as any,
          subgrupo: alimento.subgrupo || null,
          calorias: alimento.calorias,
          proteinas: alimento.proteinas,
          carbohidratos: alimento.carbohidratos,
          grasas: alimento.grasas,
          fibra: alimento.fibra || null,
          racionIntercambio: alimento.racionIntercambio,
          descripcionRacion: alimento.descripcionRacion || null,
          esAptoVegetariano: alimento.esAptoVegetariano || false,
          esAptoVegano: alimento.esAptoVegano || false,
          contieneLactosa: alimento.contieneLactosa || false,
          contieneGluten: alimento.contieneGluten || false,
          contieneFrutosSecos: alimento.contieneFrutosSecos || false,
          contieneHuevo: alimento.contieneHuevo || false,
          contienePescado: alimento.contienePescado || false,
          contieneMarisco: alimento.contieneMarisco || false,
          contieneSoja: alimento.contieneSoja || false,
          temporada: alimento.temporada || ['todo el año'],
        },
      });
      createdAlimentos[alimento.nombre.toLowerCase()] = created.id;
    } catch (e) {
      console.warn(`⚠️ Error insertando alimento ${alimento.nombre}:`, (e as Error).message);
    }
  }
  console.log(`✅ ${Object.keys(createdAlimentos).length} alimentos insertados`);

  // Seed recetas
  console.log('🍳 Insertando recetas...');
  let recetaCount = 0;

  const allRecetas = [...recetasSeed, ...recetasSeed2];
  for (const receta of allRecetas as any[]) {
    try {
      const ingredientesData = receta.ingredientes
        .map((ing: any) => {
          const alimentoId = createdAlimentos[ing.alimentoNombre.toLowerCase()];
          if (!alimentoId) return null;
          return {
            alimentoId,
            cantidad: ing.cantidad,
            unidad: ing.unidad || 'g',
            notas: ing.notas || null,
          };
        })
        .filter(Boolean);

      await prisma.receta.create({
        data: {
          nombre: receta.nombre,
          descripcion: receta.descripcion || null,
          instrucciones: receta.instrucciones,
          tiempoPreparacion: receta.tiempoPreparacion,
          tiempoCoccion: receta.tiempoCoccion,
          dificultad: receta.dificultad,
          raciones: receta.raciones || 4,
          tipoComida: receta.tipoComida,
          categoria: receta.categoria || null,
          estiloEspanol: receta.estiloEspanol !== false,
          region: receta.region || null,
          caloriasPorRacion: receta.caloriasPorRacion || null,
          proteinasPorRacion: receta.proteinasPorRacion || null,
          carbohidratosPorRacion: receta.carbohidratosPorRacion || null,
          grasasPorRacion: receta.grasasPorRacion || null,
          esAptoVegetariano: receta.esAptoVegetariano || false,
          esAptoVegano: receta.esAptoVegano || false,
          contieneLactosa: Boolean(receta.contieneLactosa),
          contieneGluten: Boolean(receta.contieneGluten),
          alimentos: {
            create: ingredientesData as any[],
          },
        },
      });
      recetaCount++;
    } catch (e) {
      console.warn(`⚠️ Error insertando receta ${receta.nombre}:`, (e as Error).message);
    }
  }
  console.log(`✅ ${recetaCount} recetas insertadas`);

  console.log('');
  console.log('🎉 Seed completado exitosamente!');
  console.log('');
  console.log('📋 Credenciales de acceso:');
  console.log('  Nutricionista: nutricionista@nutriplanpro.com / nutriplan123');
  console.log('  Paciente: paciente@nutriplanpro.com / paciente123');
}

main()
  .catch((e) => {
    console.error('❌ Error en el seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
