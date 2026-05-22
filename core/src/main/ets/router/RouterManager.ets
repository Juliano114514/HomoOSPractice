export class RouterManager {
  private static instance: RouterManager;
  private pathStack: NavPathStack = new NavPathStack();

  private constructor() {}

  public static getInstance(): RouterManager {
    if (!RouterManager.instance) {
      RouterManager.instance = new RouterManager();
    }
    return RouterManager.instance;
  }

  public getStack(): NavPathStack {
    return this.pathStack;
  }

  public push(name: string, param?: object): void {
    this.pathStack.pushPathByName(name, param);
  }

  public pop(): void {
    this.pathStack.pop();
  }

  public clear(): void {
    this.pathStack.clear();
  }
}