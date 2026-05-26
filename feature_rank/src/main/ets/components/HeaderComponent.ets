import { common } from "@kit.AbilityKit";

@Preview
@Component
export struct HeaderComponent {
  // 建议将 title 作为 prop 传入（用 @Prop 代替 @State 方便父组件更新）
  @Prop title: string = ''
  @Link isRefresh: boolean
  @Link isSorted: boolean
  private iconFilledRes: Resource = $r('app.media.ic_todo_filled')
  private iconEmptyRes: Resource = $r('app.media.ic_todo_empty')

  build() {
    Row() {
      // 左侧控制区：返回键 + 标题
      Row() {
        Stack() {
          Image($r('app.media.ic_public_back'))
            .height(24)
            .width(24)
            .fillColor($r('sys.color.ohos_id_color_titlebar_icon'))
        }
        .width(48)
        .height(48)
        .onClick(() => {
          const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          context.terminateSelf()
        })

        Text(this.title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ left: 8 })
      }
      .layoutWeight(1)
      .height('100%')
      .justifyContent(FlexAlign.Start)

      // 右侧控制区：排序 + 刷新
      Row({ space: 4 }) {
        this.CreateSortedSwitch()
        Stack() {
          Image($r('app.media.ic_public_refresh'))
            .height(24)
            .width(24)
            .fillColor($r('sys.color.ohos_id_color_titlebar_icon'))
        }
        .width(48)
        .height(48)
        .onClick(() => {
          this.isRefresh = !this.isRefresh
        })
      }
      .justifyContent(FlexAlign.End)
      .height('100%')
    }
    .width('100%')
    .height(56)
    .padding({
      left: 8,
      right: 8,
    })
  }

  @Builder
  CreateSortedSwitch(){
    Row() {
      Image(this.isSorted ? this.iconFilledRes : this.iconEmptyRes)
        .width(20)
        .height(20)
        .fillColor($r('sys.color.ohos_id_color_primary'))

      Text("按成绩排序")
        .fontSize(14)
        .margin({ left: 8 })
        .fontColor($r('sys.color.ohos_id_color_primary'))
    }
    .height(48)
    .padding({ left: 8, right: 8 })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.isSorted = !this.isSorted
    })
  }
}