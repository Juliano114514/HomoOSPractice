import { AbilityConstant, UIAbility, Want } from "@kit.AbilityKit";
import { Log } from "core";
import window from "@ohos.window";
import { AccountManager } from "feature_profile";


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Log.info('EntryAbility', '原神？启动！')
    void AccountManager.getInstance().init(this.context);
  }

  onDestroy(): void {
    Log.info('EntryAbility', '我要玩原神😭')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Log.info('EntryAbility', '少女折寿中')
    AppStorage.setOrCreate<window.WindowStage>('windowStage', windowStage);
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
    AppStorage.setOrCreate<window.WindowStage | null>('windowStage', null);
    Log.info('EntryAbility', 'onWindowStageDestroy triggered');
  }

  onForeground(): void {
    Log.info('EntryAbility', 'onForeground: App came to foreground');
  }

  onBackground(): void {
    Log.info('EntryAbility', 'onBackground: App went to background');
  }
}