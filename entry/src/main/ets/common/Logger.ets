import { hilog } from '@kit.PerformanceAnalysisKit';

class Logger{
  private domain: number;  // 日志的域
  private prefix: string;  // 全局统一 TAG 前缀
  // 日志打印格式：%{public}s 表示字符串内容公开可见
  // %{public}s  %{private}s  %{sensitive}s
  // 后两个输出时会变成 ***
  // 可以用 BuildEnv.DEBUG 切换
  private format: string = '%{public}s,%{public}s';

  constructor(
    prefix: string = "HomoTV",
    domain: number = 0xFF00
  ) {
    this.prefix = prefix
    this.domain = domain
  }

  debug(...args: string[]): void {
    hilog.debug(this.domain, this.prefix, this.format, args);
  }

  info(...args: string[]): void {
    hilog.info(this.domain, this.prefix, this.format, args);
  }

  warn(...args: string[]): void {
    hilog.warn(this.domain, this.prefix, this.format, args);
  }

  error(...args: string[]): void {
    hilog.error(this.domain, this.prefix, this.format, args);
  }
}

// 使用 export 关键字对外暴露单例
export const Log = new Logger()