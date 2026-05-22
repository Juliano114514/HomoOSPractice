import { AbilityConstant, UIAbility, Want } from "@kit.AbilityKit";
import { Log } from "core";
import window from "@ohos.window";


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Log.info('EntryAbility', '原神？启动！')
  }

  onDestroy(): void {
    Log.info('EntryAbility', '我要玩原神😭')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Log.info('EntryAbility', '少女折寿中')
    // 挂载UI这一块
    windowStage.loadContent('pages/Index', (err, data) => {
      if(err.code){
        Log.error('EntryAbility', `孩子们，这并不好笑. Cause: ${JSON.stringify(err) ?? '未知' }'`)
        return
      }
      Log.info('EntryAbility', "谢谢，出来了")
    })
  }

  onWindowStageDestroy(): void {
    Log.info('EntryAbility', 'onWindowStageDestroy triggered');
  }

  onForeground(): void {
    Log.info('EntryAbility', 'onForeground: App came to foreground');
  }

  onBackground(): void {
    Log.info('EntryAbility', 'onBackground: App went to background');
  }
}