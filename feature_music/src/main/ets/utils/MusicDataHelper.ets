import common from '@ohos.app.ability.common';
import { MusicItem } from '../model/MusicModel';

export class MusicDataHelper {
  // 扫描 rawfile 目录
  public static async buildLocalPlaylist(context: common.UIAbilityContext): Promise<MusicItem[]> {
    const rm = context.resourceManager
    let rawFiles: string[] = []
    try {
      rawFiles = await rm.getRawFileList('')
    } catch (e) {
      console.error('Failed to get raw files', e);
      return [];
    }

    // 过滤并去重
    const mp3Files = Array.from(new Set(rawFiles.filter(f => f.endsWith('.mp3')))).sort();
    const playlist: MusicItem[] = []

    mp3Files.forEach((mp3Name) => {
      // 通过文件名解析，标准命名如 "刘森 - 过去来的人.mp3"
      const baseName = mp3Name.substring(0, mp3Name.lastIndexOf('.'));
      const parts = baseName.split(' - ');
      const artist = parts.length > 1 ? parts[0] : 'Unknown';
      const title = parts.length > 1 ? parts[1] : baseName;

      // 匹配同名资源
      const coverName = rawFiles.includes(`${baseName}.jpg`) ? `${baseName}.jpg` : '';
      const lrcName = rawFiles.includes(`${baseName}.lrc`) ? `${baseName}.lrc` : '';

      playlist.push({
        id: `local_${baseName}`,
        title: title,
        artist: artist,
        fileName: mp3Name,
        coverName: coverName,
        lrcName: lrcName,
        duration: 0 // 在 AVPlayer prepare 后由底层提供准确时长
      })
    })
    return playlist
  }
}