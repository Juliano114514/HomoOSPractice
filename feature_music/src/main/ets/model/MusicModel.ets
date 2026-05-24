export enum PlayMode {
  SEQUENCE = 0,
  LIST_LOOP = 1,
  SINGLE_LOOP = 2,
  RANDOM = 3
}

export interface MusicItem {
  id: string;
  title: string;
  artist: string;
  fileName: string;
  coverName: string;
  lrcName?: string;
  duration: number;
}

export function formatTime(second: number): string {
  const m = Math.floor(second / 60).toString().padStart(2, '0')
  const s = Math.floor(second % 60).toString().padStart(2, '0');
  return `${m}:${s}`;
}