import { GrupoIntercambio } from '@prisma/client';

export interface AlimentoSeed {
  nombre: string;
  grupoIntercambio: GrupoIntercambio;
  subgrupo?: string;
  calorias: number;
  proteinas: number;
  carbohidratos: number;
  grasas: number;
  fibra?: number;
  racionIntercambio: number;
  descripcionRacion?: string;
  esAptoVegetariano?: boolean;
  esAptoVegano?: boolean;
  contieneLactosa?: boolean;
  contieneGluten?: boolean;
  contieneFrutosSecos?: boolean;
  contieneHuevo?: boolean;
  contienePescado?: boolean;
  contieneMarisco?: boolean;
  contieneSoja?: boolean;
  temporada?: string[];
}
