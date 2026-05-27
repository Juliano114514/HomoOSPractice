import { RouterManager } from 'core';
import { AccountManager } from '../utils/AccountManager';
import { KeyboardAvoidMode } from '@kit.ArkUI';

@Preview
@Component
export struct LoginScreen {
  @State isSubmitting: boolean = false;
  @State isRegistering: boolean = false;

  @State account: string = '';
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State verificationCode: string = '';

  @State codeCountdown: number = 0;
  private timerId: number = 0;

  aboutToAppear(): void {
    // 包含顶部固定内容的表单页（登录、注册、设置等）使用 RESIZE（压缩）模式。
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
  }

  aboutToDisappear(): void {
    clearInterval(this.timerId);
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        this.LoginHeader($r('app.media.avatar'))

        if (this.isRegistering) {
          this.RegisterInputComponent()
        } else {
          this.LoginInputComponent()
        }

        this.BottomBarComponent()
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 24, bottom: 120 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .backgroundColor('#FFFFFF')
  }

  @Builder
  LoginHeader(imgRes: Resource) {
    Column() {
      Text('欢迎登录')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor('#181818')
        .margin({ top: 16, bottom: 28 })

      Image(imgRes)
        .width(88)
        .height(88)
        .borderRadius(44)
        .objectFit(ImageFit.Cover)
        .backgroundColor('#F2F3F5')
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .margin({ bottom: 8 })
  }

  @Builder
  AuthTextInput(placeholder: string, value: string, isPassword: boolean, onValueChange: (value: string) => void) {
    TextInput({ placeholder: placeholder, text: value })
      .type(isPassword ? InputType.Password : InputType.Normal)
      .onChange(onValueChange)
      .height(50)
      .width('100%')
      .borderRadius(12)
      .backgroundColor('#F2F3F5')
      .padding({ left: 16, right: 16 })
      .fontSize(16)
  }

  @Builder
  LoginInputComponent() {
    Column({ space: 14 }) {
      this.AuthTextInput('账号/用户名', this.account, false, (value: string) => {
        this.account = value;
      })
      this.AuthTextInput('密码', this.password, true, (value: string) => {
        this.password = value;
      })
    }
    .width('100%')
  }

  @Builder
  RegisterInputComponent() {
    Column({ space: 14 }) {
      this.AuthTextInput('账号', this.account, false, (value: string) => {
        this.account = value;
      })
      this.AuthTextInput('用户名', this.username, false, (value: string) => {
        this.username = value;
      })
      this.AuthTextInput('密码', this.password, true, (value: string) => {
        this.password = value;
      })
      this.AuthTextInput('确认密码', this.confirmPassword, true, (value: string) => {
        this.confirmPassword = value;
      })

      Row({ space: 12 }) {
        TextInput({ placeholder: '验证码', text: this.verificationCode })
          .onChange((value: string) => this.verificationCode = value)
          .height(52)
          .borderRadius(12)
          .backgroundColor('#F2F3F5')
          .padding({ left: 16, right: 16 })
          .fontSize(16)
          .layoutWeight(1)

        Button(this.codeCountdown === 0 ? '获取验证码' : `${this.codeCountdown}s`)
          .height(52)
          .width(112)
          .borderRadius(12)
          .fontSize(14)
          .enabled(this.codeCountdown === 0 && this.account.length > 0)
          .onClick(() => this.startCountdown())
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  BottomBarComponent() {
    Column({ space: 20 }) {
      Button(this.isRegistering ? '注册' : '登录')
        .width('100%')
        .height(50)
        .borderRadius(12)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .enabled(this.getButtonEnabledState())
        .onClick(async () => await this.handleSubmit())

      Text(this.isRegistering ? '返回登录' : '没有账号？点击注册')
        .fontColor('#007DFF')
        .fontSize(14)
        .onClick(() => {
          this.isSubmitting = false;
          this.isRegistering = !this.isRegistering;
        })
    }
    .width('100%')
    .margin({ top: 12 })
  }

  private getButtonEnabledState(): boolean {
    if (this.isSubmitting) {
      return false;
    }

    if (this.isRegistering) {
      return this.account.length > 0
        && this.username.length > 0
        && this.password.length > 0
        && this.confirmPassword.length > 0
        && this.password === this.confirmPassword;
    }
    return this.account.length > 0 && this.password.length > 0;
  }

  private async handleSubmit(): Promise<void> {
    this.isSubmitting = true;
    let success: boolean;

    if (this.isRegistering) {
      success = await AccountManager.getInstance().register(
        this.account,
        this.username,
        this.password,
      );
      if (success) {
        console.info('LoginScreen', '注册成功，请登录');
        this.isRegistering = false;
      }
    } else {
      success = await AccountManager.getInstance().login(this.account, this.password);
      if (success) {
        RouterManager.getInstance().pop();
      }
    }

    this.isSubmitting = false;
    if (!success) {
      console.warn('LoginScreen', this.isRegistering ? '注册失败' : '用户名或密码错误');
    }
  }

  private startCountdown(): void {
    this.codeCountdown = 60;
    this.timerId = setInterval(() => {
      this.codeCountdown--;
      if (this.codeCountdown <= 0) {
        clearInterval(this.timerId);
      }
    }, 1000);
  }
}
