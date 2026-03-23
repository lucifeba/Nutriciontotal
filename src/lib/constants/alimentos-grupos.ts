export const GRUPOS_INTERCAMBIO = {
  LACTEOS: {
    nombre: "Lácteos",
    icon: "🥛",
    color: "#3B82F6",
    porRacion: { calorias: 130, proteinas: 7, carbohidratos: 10, grasas: 7 },
    ejemplos: [
      { nombre: "Leche entera", racion: "200 ml (1 vaso)" },
      { nombre: "Yogur natural", racion: "125 g (2 unidades)" },
      { nombre: "Queso fresco", racion: "60 g" },
      { nombre: "Queso semicurado", racion: "30 g" },
    ]
  },
  FRUTAS: {
    nombre: "Frutas",
    icon: "🍊",
    color: "#F97316",
    porRacion: { calorias: 60, proteinas: 0.5, carbohidratos: 15, grasas: 0 },
    ejemplos: [
      { nombre: "Manzana", racion: "150 g (1 mediana)" },
      { nombre: "Naranja", racion: "200 g (1 grande)" },
      { nombre: "Plátano", racion: "80 g (1/2 unidad)" },
      { nombre: "Fresas", racion: "200 g" },
      { nombre: "Melocotón", racion: "200 g" },
    ]
  },
  VERDURAS_HORTALIZAS: {
    nombre: "Verduras y Hortalizas",
    icon: "🥬",
    color: "#22C55E",
    porRacion: { calorias: 25, proteinas: 2, carbohidratos: 4, grasas: 0 },
    ejemplos: [
      { nombre: "Lechuga", racion: "200 g" },
      { nombre: "Tomate", racion: "200 g" },
      { nombre: "Judías verdes", racion: "200 g" },
      { nombre: "Espinacas", racion: "200 g" },
      { nombre: "Calabacín", racion: "200 g" },
    ]
  },
  CEREALES_TUBERCULOS: {
    nombre: "Cereales y Tubérculos",
    icon: "🍞",
    color: "#EAB308",
    porRacion: { calorias: 70, proteinas: 2, carbohidratos: 15, grasas: 0 },
    ejemplos: [
      { nombre: "Pan blanco", racion: "30 g (1 rebanada)" },
      { nombre: "Pan integral", racion: "30 g" },
      { nombre: "Arroz (en crudo)", racion: "25 g" },
      { nombre: "Pasta (en crudo)", racion: "25 g" },
      { nombre: "Patata", racion: "80 g" },
      { nombre: "Cereales desayuno", racion: "25 g" },
    ]
  },
  LEGUMBRES: {
    nombre: "Legumbres",
    icon: "🫘",
    color: "#A855F7",
    porRacion: { calorias: 130, proteinas: 9, carbohidratos: 20, grasas: 1 },
    ejemplos: [
      { nombre: "Lentejas (en crudo)", racion: "40 g" },
      { nombre: "Garbanzos (en crudo)", racion: "40 g" },
      { nombre: "Alubias (en crudo)", racion: "40 g" },
    ]
  },
  CARNES_PESCADOS_HUEVOS: {
    nombre: "Carnes, Pescados y Huevos",
    icon: "🥩",
    color: "#EF4444",
    porRacion: { calorias: 80, proteinas: 12, carbohidratos: 0, grasas: 3 },
    ejemplos: [
      { nombre: "Pechuga de pollo", racion: "60 g" },
      { nombre: "Ternera magra", racion: "60 g" },
      { nombre: "Merluza", racion: "80 g" },
      { nombre: "Salmón", racion: "60 g" },
      { nombre: "Huevo", racion: "1 unidad (60 g)" },
      { nombre: "Atún en conserva", racion: "40 g escurrido" },
      { nombre: "Jamón serrano", racion: "30 g" },
    ]
  },
  GRASAS: {
    nombre: "Grasas",
    icon: "🫒",
    color: "#14B8A6",
    porRacion: { calorias: 45, proteinas: 0, carbohidratos: 0, grasas: 5 },
    ejemplos: [
      { nombre: "Aceite de oliva virgen extra", racion: "5 ml (1 cucharadita)" },
      { nombre: "Aguacate", racion: "30 g" },
      { nombre: "Mantequilla", racion: "8 g" },
      { nombre: "Frutos secos", racion: "10 g" },
    ]
  },
  FRUTOS_SECOS: {
    nombre: "Frutos Secos",
    icon: "🥜",
    color: "#D97706",
    porRacion: { calorias: 160, proteinas: 5, carbohidratos: 5, grasas: 14 },
    ejemplos: [
      { nombre: "Nueces", racion: "25 g (5 unidades)" },
      { nombre: "Almendras", racion: "25 g (15 unidades)" },
      { nombre: "Avellanas", racion: "25 g" },
    ]
  },
} as const;

export type GrupoIntercambioKey = keyof typeof GRUPOS_INTERCAMBIO;
