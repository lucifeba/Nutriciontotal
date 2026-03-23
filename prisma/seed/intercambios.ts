export const intercambiosSeed = {
  LACTEOS: {
    nombre: "Lácteos",
    porRacion: { calorias: 130, proteinas: 7, carbohidratos: 10, grasas: 7 },
    racionesRecomendadasDia: { min: 2, max: 3 },
    descripcion: "Incluye leche, yogur, queso y derivados lácteos",
  },
  FRUTAS: {
    nombre: "Frutas",
    porRacion: { calorias: 60, proteinas: 0.5, carbohidratos: 15, grasas: 0 },
    racionesRecomendadasDia: { min: 3, max: 4 },
    descripcion: "Frutas frescas de temporada preferentemente",
  },
  VERDURAS_HORTALIZAS: {
    nombre: "Verduras y Hortalizas",
    porRacion: { calorias: 25, proteinas: 2, carbohidratos: 4, grasas: 0 },
    racionesRecomendadasDia: { min: 2, max: 4 },
    descripcion: "Verduras frescas, cocidas o en ensalada",
  },
  CEREALES_TUBERCULOS: {
    nombre: "Cereales y Tubérculos",
    porRacion: { calorias: 70, proteinas: 2, carbohidratos: 15, grasas: 0 },
    racionesRecomendadasDia: { min: 4, max: 6 },
    descripcion: "Pan, arroz, pasta, patatas y cereales",
  },
  LEGUMBRES: {
    nombre: "Legumbres",
    porRacion: { calorias: 130, proteinas: 9, carbohidratos: 20, grasas: 1 },
    racionesRecomendadasSemana: { min: 2, max: 4 },
    descripcion: "Lentejas, garbanzos, alubias y otras legumbres",
  },
  CARNES_PESCADOS_HUEVOS: {
    nombre: "Carnes, Pescados y Huevos",
    porRacion: { calorias: 80, proteinas: 12, carbohidratos: 0, grasas: 3 },
    racionesRecomendadasDia: { min: 2, max: 3 },
    descripcion: "Proteínas de origen animal",
  },
  GRASAS: {
    nombre: "Grasas",
    porRacion: { calorias: 45, proteinas: 0, carbohidratos: 0, grasas: 5 },
    racionesRecomendadasDia: { min: 4, max: 8 },
    descripcion: "Aceites, mantequilla y otras grasas",
  },
  FRUTOS_SECOS: {
    nombre: "Frutos Secos",
    porRacion: { calorias: 160, proteinas: 5, carbohidratos: 5, grasas: 14 },
    racionesRecomendadasDia: { min: 1, max: 2 },
    descripcion: "Nueces, almendras, avellanas y semillas",
  },
};
