@Component
export struct VideoScreen {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text('视频页\n（施工中）')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
