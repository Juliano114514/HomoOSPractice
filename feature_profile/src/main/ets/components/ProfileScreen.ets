import { AccountManager } from '../utils/AccountManager';
import { LoginScreen } from './LoginScreen';
import { UserInfo } from '../model/UserInfo';

@Component
export struct ProfileScreen {
  @StorageLink('currentUser') currentUser: UserInfo | null = null;

  aboutToAppear(): void {
    // 避免首次进入时 StorageKey 不存在导致的异常
    AppStorage.setOrCreate<UserInfo | null>('currentUser', this.currentUser);
  }

  build() {
    if (!this.currentUser) {
      LoginScreen();
    } else {
      Column({ space: 16 }) {
        Text('个人页')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)

        Text(`用户名：${this.currentUser.username}`)
          .fontSize(16)
          .fontColor('#333333')

        Button('退出登录')
          .margin({ top: 12 })
          .onClick(async () => {
            await AccountManager.getInstance().logout();
          })
      }
      .padding(24)
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)
    }
  }
}
