
@Component
export struct ItemComponent{
  index: number = 0
  name: string = ''
  grade: number = 0

  @State isSelected: boolean = false

  build() {
    Row(){
      // 排名
      Column(){
        if(this.isTop3()){
          this.CreateTop3Index(this.index)
        } else {
          this.CreateNormalIndex(this.index)
        }
      }
      .width('20%')
      .alignItems(HorizontalAlign.Start)

      // 姓名
      Text(this.name)
        .width('50%')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor( this.isSelected ? Color.Blue : '#182431')

      Text(this.grade.toString())
        .width('30%')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor( this.isSelected ? Color.Blue : '#182431')
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .onClick(() => {
      this.isSelected = !this.isSelected
    })
  }

  @Builder
  CreateTop3Index(index: number){
    Row(){
      Text(index.toString())
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
    }
    .justifyContent(FlexAlign.Center)
    .borderRadius(14)
    .size({ width: 28, height: 28 })
    .backgroundColor(Color.Blue)
  }

  @Builder
  CreateNormalIndex(index: number){
    Text(index.toString())
      .lineHeight(28)
      .textAlign(TextAlign.Center)
      .fontSize(16)
      .fontWeight(FontWeight.Regular)
      .width(28)
  }


  isTop3(): boolean{
    return this.index === 1 || this.index === 2 || this.index === 3
  }
}