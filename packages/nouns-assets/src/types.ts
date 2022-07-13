export interface NounSeed {
  background: number;
  hide: number;
  horns: number;
  head: number;
  outfit: number;
  eyes: number;
  snout: number;
}

export interface EncodedImage {
  filename: string;
  data: string;
}

export interface NounData {
  parts: EncodedImage[];
  background: string;
}
