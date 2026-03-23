export const ESTRUCTURA_COMIDAS = {
  DESAYUNO: { nombre: "Desayuno", horaDefault: "08:00", orden: 1 },
  MEDIA_MANANA: { nombre: "Media Mañana", horaDefault: "11:00", orden: 2 },
  ALMUERZO: { nombre: "Almuerzo", horaDefault: "14:00", orden: 3 },
  MERIENDA: { nombre: "Merienda", horaDefault: "17:30", orden: 4 },
  CENA: { nombre: "Cena", horaDefault: "21:00", orden: 5 },
  RECENA: { nombre: "Recena", horaDefault: "23:00", orden: 6 },
} as const;

export const DIAS_SEMANA = [
  { numero: 1, nombre: "Lunes", abrev: "Lun" },
  { numero: 2, nombre: "Martes", abrev: "Mar" },
  { numero: 3, nombre: "Miércoles", abrev: "Mié" },
  { numero: 4, nombre: "Jueves", abrev: "Jue" },
  { numero: 5, nombre: "Viernes", abrev: "Vie" },
  { numero: 6, nombre: "Sábado", abrev: "Sáb" },
  { numero: 7, nombre: "Domingo", abrev: "Dom" },
] as const;
