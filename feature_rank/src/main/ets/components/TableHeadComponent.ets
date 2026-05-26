
@Preview
@Component
export struct TableHeadComponent{
  paddingValue: Padding | Length = 0
  widthVal: Length = 0

  build() {
    Row(){
      Text('排名')
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .fontColor('#989A9C')
        .width('20%')

      Text('姓名')
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .fontColor('#989A9C')
        .width('50%')

      Text('成绩')
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .fontColor('#989A9C')
        .width('30%')
    }
    .width(this.widthVal)
    .height(40)
    .padding(this.paddingValue)
    .alignItems(VerticalAlign.Center)

  }
}