// feature_music/src/main/ets/manager/MusicManager.ets
import media from '@ohos.multimedia.media';
import common from '@ohos.app.ability.common';
import { MusicItem, PlayMode } from '../model/MusicModel';
import { MusicDataHelper } from '../utils/MusicDataHelper';

// 初始化全局状态
AppStorage.setOrCreate<boolean>('music_is_playing', false);
AppStorage.setOrCreate<MusicItem | null>('music_current', null);
AppStorage.setOrCreate<number>('music_progress', 0);
AppStorage.setOrCreate<PlayMode>('music_play_mode', PlayMode.LIST_LOOP);
AppStorage.setOrCreate<MusicItem[]>('music_playlist', []);

export class MusicManager {
  private static instance: MusicManager;
  private player: media.AVPlayer | null = null
  private context: common.UIAbilityContext | null = null
  private currentIndex: number = -1;
  private isPlayerReady: boolean = false

  private constructor() {}

  public static getInstance(): MusicManager {
    if (!MusicManager.instance) {
      MusicManager.instance = new MusicManager();
    }
    return MusicManager.instance;
  }

  public async init(context: common.UIAbilityContext): Promise<void> {
    this.context = context;
    if (!this.player) {
      this.player = await media.createAVPlayer();
      this.setPlayerListeners();
    }
    await this.ensurePlaylistLoaded();
  }

  private async ensurePlaylistLoaded(): Promise<void> {
    const playlist = AppStorage.get<MusicItem[]>('music_playlist') ?? [];
    if (playlist.length > 0 || !this.context) {
      return;
    }
    const list = await MusicDataHelper.buildLocalPlaylist(this.context);
    AppStorage.setOrCreate('music_playlist', list);
  }

  private setPlayerListeners() {
    if(!this.player) return

    // 状态机监听
    this.player.on('stateChange', async (state: media.AVPlayerState, reason: media.StateChangeReason) => {
      switch(state){
        case 'initialized': {
          this.isPlayerReady = false;
          this.player?.prepare();
          break;
        }
        case 'prepared': {
          this.isPlayerReady = true;
          const currentMusic = AppStorage.get<MusicItem>('music_current');
          if (currentMusic) {
            currentMusic.duration = this.player?.duration || 0;
            AppStorage.set('music_current', currentMusic); // 刷新UI总时长
          }
          this.player?.play();
          break;
        }
        case 'playing': {
          AppStorage.set('music_is_playing', true);
          break;
        }
        case 'paused': {}
        case 'stopped': {
          AppStorage.set('music_is_playing', false);
          break;
        }
        case 'completed': {
          this.handleAutoNext();
          break;
        }
      }
    })

    // 进度实时更新监听（自动驱动 Slider 和时间 Text）
    this.player.on('timeUpdate', (time: number) => {
      AppStorage.set('music_progress', time);
    });
  }

  public async play(index: number) {
    const playlist = AppStorage.get<MusicItem[]>('music_playlist') || [];
    if (index < 0 || index >= playlist.length || !this.context || !this.player) return;

    this.currentIndex = index;
    const targetMusic = playlist[index];
    AppStorage.set('music_current', targetMusic);
    AppStorage.set('music_progress', 0);

    // 重置并设置新的数据源
    await this.player.reset();
    let fileDescriptor = await this.context.resourceManager.getRawFd(targetMusic.fileName);
    this.player.fdSrc = fileDescriptor; // 触发 initialized 状态
  }

  public togglePlayPause() {
    const isPlaying = AppStorage.get<boolean>('music_is_playing') || false;
    if (isPlaying) {
      this.player?.pause();
    } else {
      if (this.isPlayerReady) {
        this.player?.play();
      } else {
        this.play(this.currentIndex === -1 ? 0 : this.currentIndex);
      }
    }
  }

  public next() {
    const playlist = AppStorage.get<MusicItem[]>('music_playlist') || [];
    if(playlist.length === 0) return;
    let mode = AppStorage.get<PlayMode>('music_play_mode') || PlayMode.LIST_LOOP;
    let nextIdx = mode === PlayMode.RANDOM
      ? Math.floor(Math.random() * playlist.length)
      : (this.currentIndex + 1) % playlist.length;
    this.play(nextIdx);
  }

  public prev() {
    const playlist = AppStorage.get<MusicItem[]>('music_playlist') || [];
    if(playlist.length === 0) return;
    let nextIdx = this.currentIndex - 1;
    if (nextIdx < 0) nextIdx = playlist.length - 1;
    this.play(nextIdx);
  }

  public seek(ms: number) {
    if (this.isPlayerReady) {
      this.player?.seek(ms, media.SeekMode.SEEK_CLOSEST);
    }
  }

  public switchMode() {
    let mode = AppStorage.get<PlayMode>('music_play_mode') || PlayMode.SEQUENCE;
    AppStorage.set('music_play_mode', (mode + 1) % 4);
  }

  private handleAutoNext() {
    let mode = AppStorage.get<PlayMode>('music_play_mode') ?? PlayMode.LIST_LOOP;
    if (mode === PlayMode.SINGLE_LOOP) {
      this.play(this.currentIndex);
    } else {
      this.next(); // Sequence 模式到达末尾的边界处理可以视产品需求进一步精细化
    }
  }
}