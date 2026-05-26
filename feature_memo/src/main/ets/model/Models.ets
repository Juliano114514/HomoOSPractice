
export class TaskDataModel{
  private tasks: Array<String> = [
    "哼哼哼啊啊啊",
    "压力马斯内",
    "好时代，来临力"
  ]

  getData(): Array<String> {
    return this.tasks
  }
}

// new TaskDataModel()