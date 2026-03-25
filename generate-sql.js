#!/usr/bin/env node
/**
 * generate-sql.js
 * Generates a complete setup-neon.sql file combining:
 *   1. Schema SQL (from prisma migrate diff)
 *   2. Seed data (users, alimentos, recetas, recetaAlimentos)
 */

const { execSync } = require('child_process');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const path = require('path');
const fs = require('fs');

// ─── Helpers ─────────────────────────────────────────────────────────────────

function uuid() {
  return crypto.randomUUID();
}

/** Escape single quotes for PostgreSQL string literals */
function esc(val) {
  if (val === null || val === undefined) return 'NULL';
  return `'${String(val).replace(/'/g, "''")}'`;
}

function bool(val) {
  return val ? 'true' : 'false';
}

function numOrNull(val) {
  if (val === null || val === undefined) return 'NULL';
  return String(val);
}

function strOrNull(val) {
  if (val === null || val === undefined) return 'NULL';
  return esc(val);
}

/** Convert a JS string array to PostgreSQL ARRAY literal */
function pgArray(arr) {
  if (!arr || arr.length === 0) return "ARRAY[]::TEXT[]";
  const items = arr.map(s => `'${String(s).replace(/'/g, "''")}'`).join(', ');
  return `ARRAY[${items}]`;
}

// ─── Schema SQL ───────────────────────────────────────────────────────────────

console.log('Generating schema SQL...');
const schemaSql = execSync(
  'npx prisma migrate diff --from-empty --to-schema-datamodel prisma/schema.prisma --script',
  { cwd: path.resolve(__dirname) }
).toString();

// ─── Alimentos data ───────────────────────────────────────────────────────────

// Parse alimentos.ts
const alimentos1Raw = fs.readFileSync(path.join(__dirname, 'prisma/seed/alimentos.ts'), 'utf8');
const alimentos2Raw = fs.readFileSync(path.join(__dirname, 'prisma/seed/alimentos2.ts'), 'utf8');

// Strip TypeScript export and eval
function extractArrayFromTs(src, exportName) {
  // Remove the export keyword and variable name, then eval just the array
  const match = src.match(/export\s+const\s+\w+\s*=\s*(\[[\s\S]*\]);?\s*$/m);
  if (!match) {
    // Try without trailing semicolon
    const m2 = src.match(/export\s+const\s+\w+\s*=\s*(\[[\s\S]*\])/);
    if (!m2) throw new Error(`Could not extract array from ${exportName}`);
    return eval(m2[1]);
  }
  return eval(match[1]);
}

const alimentosSeed1 = extractArrayFromTs(alimentos1Raw, 'alimentos.ts');
const alimentosSeed2 = extractArrayFromTs(alimentos2Raw, 'alimentos2.ts');
const allAlimentos = [...alimentosSeed1, ...alimentosSeed2];

console.log(`Loaded ${allAlimentos.length} alimentos`);

// ─── Recetas data ─────────────────────────────────────────────────────────────

const recetasRaw = fs.readFileSync(path.join(__dirname, 'prisma/seed/recetas.ts'), 'utf8');
const recetasSeed = extractArrayFromTs(recetasRaw, 'recetas.ts');

console.log(`Loaded ${recetasSeed.length} recetas`);

// ─── Hash passwords ───────────────────────────────────────────────────────────

console.log('Hashing passwords...');
const nutriHash = bcrypt.hashSync('nutricionista123', 10);
const pacienteHash = bcrypt.hashSync('paciente123', 10);

// ─── Generate IDs ─────────────────────────────────────────────────────────────

const nutriUserID = uuid();
const nutriID = uuid();
const pacienteUserID = uuid();
const pacienteID = uuid();
const pacienteEncuestaToken = uuid();

// Assign IDs to alimentos (keyed by nombre for receta lookup)
const alimentoIdsByNombre = {};
const alimentosWithIds = allAlimentos.map(a => {
  const id = uuid();
  alimentoIdsByNombre[a.nombre] = id;
  return { ...a, id };
});

// Assign IDs to recetas
const recetasWithIds = recetasSeed.map(r => ({ ...r, id: uuid() }));

// ─── Build SQL ────────────────────────────────────────────────────────────────

const lines = [];

lines.push(`-- ============================================================`);
lines.push(`-- NutriPlan Pro – Complete setup for Neon PostgreSQL`);
lines.push(`-- Generated: ${new Date().toISOString()}`);
lines.push(`-- ============================================================`);
lines.push(``);

// ─── 1. Schema ────────────────────────────────────────────────────────────────

lines.push(`-- ============================================================`);
lines.push(`-- 1. SCHEMA`);
lines.push(`-- ============================================================`);
lines.push(``);
lines.push(schemaSql.trim());
lines.push(``);

// ─── 2. Users ─────────────────────────────────────────────────────────────────

lines.push(`-- ============================================================`);
lines.push(`-- 2. USERS`);
lines.push(`-- ============================================================`);
lines.push(``);

// Nutricionista User
lines.push(`INSERT INTO "User" ("id","email","password","nombre","apellidos","rol","activo","createdAt","updatedAt") VALUES (`);
lines.push(`  ${esc(nutriUserID)}, 'nutricionista@nutriplanpro.com', ${esc(nutriHash)}, 'Ana', 'García López', 'NUTRICIONISTA'::"Rol", true, NOW(), NOW()`);
lines.push(`);`);
lines.push(``);

// Paciente User
lines.push(`INSERT INTO "User" ("id","email","password","nombre","apellidos","rol","activo","createdAt","updatedAt") VALUES (`);
lines.push(`  ${esc(pacienteUserID)}, 'paciente@ejemplo.com', ${esc(pacienteHash)}, 'Carlos', 'Martínez Ruiz', 'PACIENTE'::"Rol", true, NOW(), NOW()`);
lines.push(`);`);
lines.push(``);

// Nutricionista profile
lines.push(`INSERT INTO "Nutricionista" ("id","userId","numColegiado","especialidad","clinica","whatsappNumber","bio") VALUES (`);
lines.push(`  ${esc(nutriID)}, ${esc(nutriUserID)}, 'AND-12345', 'Nutrición Deportiva y Clínica', 'Clínica NutriSalud', '+34676002647', ${esc('Nutricionista colegiada con más de 10 años de experiencia en nutrición clínica y deportiva.')}`);
lines.push(`);`);
lines.push(``);

// Paciente profile
lines.push(`INSERT INTO "Paciente" ("id","userId","nutricionistaId","activo","fechaAlta","encuestaToken","encuestaCompletada") VALUES (`);
lines.push(`  ${esc(pacienteID)}, ${esc(pacienteUserID)}, ${esc(nutriID)}, true, NOW(), ${esc(pacienteEncuestaToken)}, false`);
lines.push(`);`);
lines.push(``);

// ─── 3. Alimentos ─────────────────────────────────────────────────────────────

lines.push(`-- ============================================================`);
lines.push(`-- 3. ALIMENTOS (${alimentosWithIds.length} items)`);
lines.push(`-- ============================================================`);
lines.push(``);

for (const a of alimentosWithIds) {
  lines.push(`INSERT INTO "Alimento" (`);
  lines.push(`  "id","nombre","grupoIntercambio","subgrupo",`);
  lines.push(`  "calorias","proteinas","carbohidratos","grasas","fibra",`);
  lines.push(`  "racionIntercambio","descripcionRacion",`);
  lines.push(`  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",`);
  lines.push(`  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja",`);
  lines.push(`  "temporada"`);
  lines.push(`) VALUES (`);
  lines.push(`  ${esc(a.id)}, ${esc(a.nombre)}, '${a.grupoIntercambio}'::"GrupoIntercambio", ${strOrNull(a.subgrupo)},`);
  lines.push(`  ${a.calorias}, ${a.proteinas}, ${a.carbohidratos}, ${a.grasas}, ${numOrNull(a.fibra)},`);
  lines.push(`  ${a.racionIntercambio}, ${strOrNull(a.descripcionRacion)},`);
  lines.push(`  ${bool(a.esAptoVegetariano)}, ${bool(a.esAptoVegano)}, ${bool(a.contieneLactosa)}, ${bool(a.contieneGluten)},`);
  lines.push(`  ${bool(a.contieneFrutosSecos)}, ${bool(a.contieneHuevo)}, ${bool(a.contienePescado)}, ${bool(a.contieneMarisco)}, ${bool(a.contieneSoja)},`);
  lines.push(`  ${pgArray(a.temporada)}`);
  lines.push(`);`);
  lines.push(``);
}

// ─── 4. Recetas ───────────────────────────────────────────────────────────────

lines.push(`-- ============================================================`);
lines.push(`-- 4. RECETAS (${recetasWithIds.length} items)`);
lines.push(`-- ============================================================`);
lines.push(``);

for (const r of recetasWithIds) {
  // sinLactosa / sinGluten in seed -> contieneLactosa / contieneGluten are inverted
  const contieneLactosa = r.sinLactosa === true ? false : (r.sinLactosa === false ? true : false);
  const contieneGluten = r.sinGluten === true ? false : (r.sinGluten === false ? true : false);

  lines.push(`INSERT INTO "Receta" (`);
  lines.push(`  "id","nombre","descripcion","instrucciones","tiempoPreparacion","tiempoCoccion","dificultad","raciones",`);
  lines.push(`  "tipoComida","categoria","estiloEspanol","region",`);
  lines.push(`  "caloriasPorRacion","proteinasPorRacion","carbohidratosPorRacion","grasasPorRacion",`);
  lines.push(`  "esAptoVegetariano","esAptoVegano","contieneLactosa","contieneGluten",`);
  lines.push(`  "contieneFrutosSecos","contieneHuevo","contienePescado","contieneMarisco","contieneSoja"`);
  lines.push(`) VALUES (`);
  lines.push(`  ${esc(r.id)}, ${esc(r.nombre)}, ${strOrNull(r.descripcion)}, ${esc(r.instrucciones)},`);
  lines.push(`  ${r.tiempoPreparacion}, ${r.tiempoCoccion}, ${esc(r.dificultad)}, ${r.raciones},`);
  lines.push(`  ${pgArray(r.tipoComida)}, ${strOrNull(r.categoria)}, ${bool(r.estiloEspanol)}, ${strOrNull(r.region)},`);
  lines.push(`  ${numOrNull(r.caloriasPorRacion)}, ${numOrNull(r.proteinasPorRacion)}, ${numOrNull(r.carbohidratosPorRacion)}, ${numOrNull(r.grasasPorRacion)},`);
  lines.push(`  ${bool(r.esAptoVegetariano)}, ${bool(r.esAptoVegano)}, ${bool(contieneLactosa)}, ${bool(contieneGluten)},`);
  lines.push(`  false, false, false, false, false`);
  lines.push(`);`);
  lines.push(``);
}

// ─── 5. RecetaAlimento ────────────────────────────────────────────────────────

lines.push(`-- ============================================================`);
lines.push(`-- 5. RECETA-ALIMENTO RELATIONSHIPS`);
lines.push(`-- ============================================================`);
lines.push(``);

let missingAlimentos = [];

for (const r of recetasWithIds) {
  if (!r.ingredientes || r.ingredientes.length === 0) continue;
  for (const ing of r.ingredientes) {
    const alimentoId = alimentoIdsByNombre[ing.alimentoNombre];
    if (!alimentoId) {
      missingAlimentos.push(`${r.nombre} -> ${ing.alimentoNombre}`);
      continue;
    }
    const raId = uuid();
    lines.push(`INSERT INTO "RecetaAlimento" ("id","recetaId","alimentoId","cantidad","unidad","notas") VALUES (`);
    lines.push(`  ${esc(raId)}, ${esc(r.id)}, ${esc(alimentoId)}, ${ing.cantidad}, ${strOrNull(ing.unidad)}, ${strOrNull(ing.notas || null)}`);
    lines.push(`);`);
    lines.push(``);
  }
}

if (missingAlimentos.length > 0) {
  console.warn('WARNING: Could not find alimentos for these ingredientes:');
  missingAlimentos.forEach(m => console.warn('  -', m));
}

// ─── Write output ─────────────────────────────────────────────────────────────

const outputPath = path.join(__dirname, 'setup-neon.sql');
fs.writeFileSync(outputPath, lines.join('\n'), 'utf8');

console.log(`\nDone! Output written to: ${outputPath}`);
console.log(`  - ${alimentosWithIds.length} alimentos`);
console.log(`  - ${recetasWithIds.length} recetas`);

// Count RecetaAlimento entries
let raCount = 0;
for (const r of recetasWithIds) {
  if (r.ingredientes) raCount += r.ingredientes.filter(i => alimentoIdsByNombre[i.alimentoNombre]).length;
}
console.log(`  - ${raCount} RecetaAlimento links`);
