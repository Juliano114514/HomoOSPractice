export class RouterManager {
  private static instance: RouterManager
  private pathStack: NavPathStack = new NavPathStack()

  private constructor() {}

  // 全局路由（单例）
  public static getInstance(): RouterManager{
    if(!RouterManager.instance){
      RouterManager.instance = new RouterManager();
    }
    return RouterManager.instance;
  }

  // 获取导航栈
  public getStack(): NavPathStack{
    return this.pathStack
  }

  /**
   * 压入路由页面
   * @param name 目标页面在 pageMap 中注册的路由名称
   * @param param 传递的参数
   */
  public push(name: string, param?: object): void{
    this.pathStack.pushPathByName(name, param)
  }

  public pop(): void {
    this.pathStack.pop();
  }

  public clear(): void{
    this.pathStack.clear()
  }
}