
@Component
export default struct ItemComponent{

  @State taskContent: string = ''
  @State isFinished: boolean = false


  @Builder
  CreateIcon(icon: Resource){
    Image(icon)
      .width(28)
      .height(28)
      .objectFit(ImageFit.Contain)
      .margin(20)
  }

  build() {
    Row(){
      if (this.isFinished){
        this.CreateIcon($r('app.media.ic_todo_filled'))
      } else {
        this.CreateIcon($r('app.media.ic_todo_empty'))
      }

      Text(this.taskContent)
        .fontSize(20)
        .fontWeight(500)
        .decoration({type: this.isFinished ? TextDecorationType.LineThrough : TextDecorationType.None})  // 删除线
        .opacity(this.isFinished ? 0.5 : 1)
    }
    .borderRadius(24)
    .backgroundColor(Color.White)
    .width('93%')
    .height(65)
    .onClick(() => {
      this.isFinished = !this.isFinished
    })
  }
}