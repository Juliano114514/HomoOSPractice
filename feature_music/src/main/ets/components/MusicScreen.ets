import common from '@ohos.app.ability.common';
import { RouterManager } from 'core';
import { MusicItem } from '../model/MusicModel';
import { MusicManager } from '../manager/MusicManager';

@Preview
@Component
export struct MusicScreen {
  @StorageProp('music_current') currentMusic: MusicItem | null = null;
  @StorageProp('music_is_playing') isPlaying: boolean = false;
  @StorageLink('music_playlist') playlist: MusicItem[] = [];
  @State isLoading: boolean = true;

  private musicManager = MusicManager.getInstance();

  async aboutToAppear(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    await this.musicManager.init(context);
    this.isLoading = false;
  }

  @Builder
  CoverThumbnail(coverName: string) {
    if (coverName) {
      Image($rawfile(coverName))
        .width(50)
        .height(50)
        .borderRadius(8)
        .backgroundColor('#EEEEEE')
    } else {
      Column() {
        Text('♪')
          .fontSize(20)
          .fontColor('#999999')
      }
      .width(50)
      .height(50)
      .borderRadius(8)
      .backgroundColor('#EEEEEE')
      .justifyContent(FlexAlign.Center)
    }
  }

  @Builder
  MusicItemBuilder(item: MusicItem, index: number) {
    Row() {
      this.CoverThumbnail(item.coverName)

      Column() {
        Text(item.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.currentMusic?.id === item.id ? '#007DFF' : '#333333')
        Text(item.artist)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 12 })

      if (this.currentMusic?.id === item.id) {
        Text(this.isPlaying ? '🎶 播放中' : '⏸ 暂停')
          .fontSize(12)
          .fontColor('#007DFF')
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 8 })
    .onClick(() => {
      if (this.currentMusic?.id !== item.id) {
        this.musicManager.play(index);
      }
      RouterManager.getInstance().push('MusicPlayer');
    })
  }

  @Builder
  PlaylistContent() {
    if (this.isLoading) {
      Text('加载中...')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 40 })
    } else if (this.playlist.length === 0) {
      Text('暂无本地音乐，请将 mp3 放入 rawfile 目录')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 40 })
        .padding({ left: 16, right: 16 })
    } else {
      List() {
        ForEach(this.playlist, (item: MusicItem, index: number) => {
          ListItem() {
            this.MusicItemBuilder(item, index)
          }
        }, (item: MusicItem) => item.id)
      }
      .padding({ left: 16, right: 16 })
      .layoutWeight(1)
    }
  }

  build() {
    Column() {
      Text('本地音乐')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20, left: 16 })
        .alignSelf(ItemAlign.Start)

      this.PlaylistContent()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
