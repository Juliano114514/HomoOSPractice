import preferences from '@ohos.data.preferences';
import { UserInfo } from '../model/UserInfo';
import { Log } from 'core';
import { Context } from '@kit.AbilityKit';

const PREF_NAME = 'user_store';
const KEY_CURRENT_UID = 'current_login_uid';
const AUTH_PREFIX = 'auth_';
const UID_MAP_PREFIX = 'uid_map_';
const USER_PREFIX = 'user_';

export class AccountManager {
  private static instance: AccountManager;
  private pref: preferences.Preferences | null = null;

  private constructor() {}

  public static getInstance(): AccountManager {
    if (!AccountManager.instance) {
      AccountManager.instance = new AccountManager();
    }
    return AccountManager.instance;
  }

  public async init(context: Context): Promise<void> {
    try {
      this.pref = await preferences.getPreferences(context, PREF_NAME)
      await this.restoreLoginState()
    } catch (e) {
      Log.error('AccountManager', `Init failed: ${e}`);
    }
  }

  // 恢复登录状态并同步到 AppStorage
  private async restoreLoginState() {
    if (!this.pref) return;
    const uid = await this.pref.get(KEY_CURRENT_UID, '') as string;
    if (uid) {
      const userStr = await this.pref.get(`user_${uid}`, '') as string;
      if (userStr) {
        AppStorage.setOrCreate<UserInfo | null>('currentUser', JSON.parse(userStr));
      }
    } else {
      AppStorage.setOrCreate<UserInfo | null>('currentUser', null);
    }
  }

  // 注册逻辑
  public async register(account: string, username: string, password: string): Promise<boolean> {
    if (!this.pref) return false;
    const accountKey = account.trim();
    const usernameKey = username.trim();
    const pwd = password.trim();
    if (!accountKey || !usernameKey || !pwd) {
      return false;
    }

    // 账号或用户名任一已存在，都视为冲突
    const accountUid = await this.pref.get(`${UID_MAP_PREFIX}${accountKey}`, '') as string;
    const usernameUid = await this.pref.get(`${UID_MAP_PREFIX}${usernameKey}`, '') as string;
    if (accountUid || usernameUid) {
      return false;
    }

    // 简单模拟生成 UID
    const uid = `uid_${new Date().getTime()}`;
    const newUser: UserInfo = {
      uid: uid,
      username: usernameKey,
      isVip: false,
      vipExpireTime: 0
    };

    // 保存双索引：支持账号或用户名登录
    await this.pref.put(`${AUTH_PREFIX}${accountKey}`, pwd);
    await this.pref.put(`${AUTH_PREFIX}${usernameKey}`, pwd);
    await this.pref.put(`${UID_MAP_PREFIX}${accountKey}`, uid);
    await this.pref.put(`${UID_MAP_PREFIX}${usernameKey}`, uid);
    await this.pref.put(`${USER_PREFIX}${uid}`, JSON.stringify(newUser));
    await this.pref.flush();
    return true;
  }

  // 登录逻辑
  public async login(identifier: string, password: string): Promise<boolean> {
    if (!this.pref) return false;
    const loginKey = identifier.trim();
    const pwd = password.trim();
    if (!loginKey || !pwd) {
      return false;
    }

    const savedPwd = await this.pref.get(`${AUTH_PREFIX}${loginKey}`, '') as string;
    if (savedPwd !== pwd) {
      return false;
    }

    const uid = await this.pref.get(`${UID_MAP_PREFIX}${loginKey}`, '') as string;
    if (!uid) {
      return false;
    }
    const userStr = await this.pref.get(`${USER_PREFIX}${uid}`, '') as string;
    if (!userStr) {
      return false;
    }

    // 更新当前 UID 并刷新全局状态
    await this.pref.put(KEY_CURRENT_UID, uid);

    // 兼容老数据：若历史注册只写了账号映射，在成功登录后补齐用户名映射，便于下次用户名直登
    const user = JSON.parse(userStr) as UserInfo;
    if (user.username) {
      const usernameAuthKey = `${AUTH_PREFIX}${user.username}`;
      const usernameUidKey = `${UID_MAP_PREFIX}${user.username}`;
      const existsUsernameUid = await this.pref.get(usernameUidKey, '') as string;
      if (!existsUsernameUid) {
        await this.pref.put(usernameAuthKey, savedPwd);
        await this.pref.put(usernameUidKey, uid);
      }
    }
    await this.pref.flush();
    AppStorage.setOrCreate<UserInfo | null>('currentUser', user);
    return true;
  }


  // 登出逻辑
  public async logout(): Promise<void> {
    if (!this.pref) return;
    await this.pref.put(KEY_CURRENT_UID, '');
    await this.pref.flush();
    AppStorage.setOrCreate<UserInfo | null>('currentUser', null);
  }
}