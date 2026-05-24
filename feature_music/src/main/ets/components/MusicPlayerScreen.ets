import { MusicManager } from '../manager/MusicManager';
import { MusicItem, PlayMode, formatTime } from '../model/MusicModel';

@Preview
@Component
export struct MusicPlayerScreen {
  // 使用 @StorageLink 双向绑定状态，自动触发 UI 刷新
  @StorageLink('music_is_playing') isPlaying: boolean = false;
  @StorageLink('music_current') currentMusic: MusicItem | null = null;
  @StorageLink('music_progress') progress: number = 0;
  @StorageLink('music_play_mode') playMode: PlayMode = PlayMode.LIST_LOOP;

  private musicManager = MusicManager.getInstance();

  // 获取播放模式对应的文本
  private getModeText(): string {
    switch (this.playMode) {
      case PlayMode.SEQUENCE: return '🔁 顺序播放';
      case PlayMode.LIST_LOOP: return '🔄 列表循环';
      case PlayMode.SINGLE_LOOP: return '🔂 单曲循环';
      case PlayMode.RANDOM: return '🔀 随机播放';
      default: return '未知';
    }
  }

  @Builder
  CoverArea() {
    if (this.currentMusic?.coverName) {
      Image($rawfile(this.currentMusic.coverName))
        .width(280)
        .height(280)
        .borderRadius(140)
        .margin({ top: 60, bottom: 40 })
        .shadow({ radius: 30, color: 'rgba(0,0,0,0.15)', offsetY: 15 })
        .animation({ duration: 500 })
    } else {
      // 无封面时的缺省UI
      Circle({ width: 280, height: 280 })
        .fill('#E0E0E0')
        .margin({ top: 60, bottom: 40 })
    }
  }

  @Builder
  InfoArea() {
    Column() {
      Text(this.currentMusic?.title || '未知曲目')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 12 })
      Text(this.currentMusic?.artist || '未知歌手')
        .fontSize(16)
        .fontColor('#666666')
    }.margin({ bottom: 40 })
  }

  @Builder
  ProgressArea() {
    Row() {
      Text(formatTime(this.progress)).fontSize(12).fontColor('#999')
      Slider({
        value: this.progress,
        min: 0,
        max: this.currentMusic?.duration || 100,
        style: SliderStyle.OutSet
      })
        .layoutWeight(1)
        .selectedColor('#007DFF')
        .onChange((value: number, mode: SliderChangeMode) => {
          if (mode === SliderChangeMode.End || mode === SliderChangeMode.Click) {
            this.musicManager.seek(value);
          }
        })
      Text(formatTime(this.currentMusic?.duration || 0)).fontSize(12).fontColor('#999')
    }
    .width('85%')
    .margin({ bottom: 30 })
  }

  @Builder
  ControlArea() {
    Row() {
      Text(this.getModeText())
        .fontSize(24)
        .onClick(() => this.musicManager.switchMode())
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Text('⏮')
        .fontSize(36)
        .onClick(() => this.musicManager.prev())

      Text(this.isPlaying ? '⏸' : '▶️')
        .fontSize(56) // 稍微放大主按钮
        .margin({ left: 30, right: 30 })
        .onClick(() => this.musicManager.togglePlayPause())

      Text('⏭')
        .fontSize(36)
        .onClick(() => this.musicManager.next())

      Text('≡') // 预留歌单列表按钮占位
        .fontSize(28)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  build() {
    NavDestination() {
      Column() {
        if (this.currentMusic) {
          this.CoverArea()
          this.InfoArea()
          this.ProgressArea()
          this.ControlArea()
        } else {
          Text('暂无播放内容').fontSize(20).fontColor('#999').margin({ top: 200 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FAFAFA')
    }
    .title('播放详情')
  }
}