import { TaskDataModel } from '../model/Models'
import ItemComponent from './ItemComponent'

@Preview
@Component
export struct MemoScreen {
  private totalData: Array<String> = []

  aboutToAppear(): void {
    this.totalData = new TaskDataModel().getData()
  }

  build() {
    Column({ space: 6 }) {
      Text('待办事项')
        .fontSize(28)
        .lineHeight(33)
        .fontWeight(FontWeight.Bold)
        .width('80%')
        .margin({
          top: 24,
          bottom: 12
        })
        .textAlign(TextAlign.Start)


      ForEach(this.totalData, (item: string) => {
        ItemComponent({taskContent: item})
      })
    }
    .width('100%')
    .height('100%')
    .background('#F1F3F5')
  }
}
