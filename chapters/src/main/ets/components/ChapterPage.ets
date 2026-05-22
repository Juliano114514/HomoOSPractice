@Component
export struct ChapterScreen {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text('申必小课程\n（施工中）')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
