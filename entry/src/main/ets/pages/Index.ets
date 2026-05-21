import { Log } from '../common/Logger';

@Entry
@Component
struct Index {
  // @State 装饰器，对标 Compose 的 remember { mutableStateOf() }
  @State message: string = 'Hello HomoOS';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .margin({ bottom: 20 })

        Button('Click to Test Logger')
          .width('60%')
          .height(48)
          .onClick(() => {
            // 用 message 是为了更新响应式UI
            this.message = "哼哼哼啊啊啊啊啊"
            Log.info('IndexPage', '压力马斯内')
          })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.background_primary'))
  }
}