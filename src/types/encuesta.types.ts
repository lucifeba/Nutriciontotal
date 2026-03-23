export interface EncuestaData {
  // Step 1: Datos personales
  ocupacion?: string;
  horarioLaboral?: string;
  estadoCivil?: string;
  numHijos?: number;
  quienCocinaEnCasa?: string;
  comeEnCasaOFuera?: string;
  // Step 2: Historial médico
  patologias?: string[];
  patologiasDetalle?: string;
  alergias?: string[];
  intolerancias?: string[];
  medicacionActual?: string;
  suplementos?: string;
  cirugiasPrevias?: string;
  antecedentesFamiliares?: string[];
  problemaDigestivo?: string[];
  transitoIntestinal?: string;
  // Step 3: Hábitos alimentarios
  numComidasDia?: number;
  horarioComidas?: Record<string, string>;
  picoteoEntreMeals?: boolean;
  comeRapidoOLento?: string;
  dondeComeMasFrec?: string;
  cocinaSiNo?: boolean;
  habilidadCocina?: string;
  tiempoParaCocinar?: string;
  alimentosQueNoGustan?: string[];
  alimentosPreferidos?: string[];
  bebidasHabituales?: string[];
  litrosAguaDia?: number;
  consumoAlcohol?: string;
  tipoAlcohol?: string;
  consumoTabaco?: boolean;
  cigarrillosDia?: number;
  // Step 4: Registro dietético
  registroDietetico?: any;
  // Step 5: Actividad física
  nivelActividad?: string;
  deportePractica?: string;
  frecuenciaDeporte?: string;
  duracionSesion?: string;
  horarioDeporte?: string;
  actividadDiaria?: string;
  // Step 6: Objetivos
  motivoConsulta?: string;
  objetivoPrincipal?: string;
  dietasPrevias?: string[];
  resultadoDietasPrevias?: string;
  pesoMaxHistorico?: number;
  pesoMinAdulto?: number;
  expectativaPlazo?: string;
  // Step 7: Aspecto psicológico
  relacionComida?: string;
  comePorAnsiedad?: boolean;
  episodiosAtracones?: boolean;
  sentimientoCulpa?: boolean;
  nivelEstres?: number;
  calidadSueno?: string;
  horasSueno?: number;
  nivelMotivacion?: number;
  // Step 8: Consentimiento
  aceptaPoliticaPrivacidad?: boolean;
  aceptaTratamientoDatos?: boolean;
  firmaDigital?: string;
}

export interface RegistroDieteticoEntry {
  comida: string;
  hora: string;
  alimentos: string;
  lugar: string;
  hambreReal: boolean;
}
