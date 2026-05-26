import { StudentData } from '../model/Models'
import { StudentGenerator } from '../utils/StudentGenerator';
import { HeaderComponent } from './HeaderComponent'
import { ItemComponent } from './ItemComponent'
import { TableHeadComponent } from './TableHeadComponent'

@Component
export struct RankScreen {

  @Watch("onRefreshClick")
  @State isRefresh: boolean = true
  @State isSorted: boolean = true
  @State studentData: StudentData[] = StudentGenerator.generateStudents(10)

  build() {
    Column(){
      HeaderComponent({
        isRefresh: $isRefresh,
        title: '光荣榜',
        isSorted: $isSorted
      })
      TableHeadComponent({
        paddingValue: {
          left: 16,
          right: 16
        },
        widthVal: '100%'
      })
        .width('92%')
        .margin({
          top: 16,
          bottom: 8
        })
      this.CreateListItem()
    }
    .backgroundColor('#F1F3F5')
    .width('100%')
    .height('100%')
  }

  @Builder
  CreateListItem(){
    Column(){
      List(){
        ForEach(this.studentData, (item: StudentData, index: number) => {
          ListItem(){
            ItemComponent({
              index: index + 1,
              name: item.name,
              grade: item.grade
            })
          }
        })
      }
      .width('100%')
      .height('75%')
      .divider({
        strokeWidth: 0.5,
        startMargin: 16,
        endMargin: 16
      })
    }
    .padding({
      top: 8,
      bottom: 8
    })
    .width('92%')
    .borderRadius(16)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(Color.White)
  }

  onRefreshClick() {
    let tempData = StudentGenerator.generateStudents((Math.random() * 20 + 5))
    if(this.isSorted) tempData = StudentGenerator.sortByGrade(tempData)
    this.studentData = tempData
  }
}
