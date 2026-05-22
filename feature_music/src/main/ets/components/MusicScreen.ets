@Component
export struct MusicScreen {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text('音乐播放器\n（施工中）')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
