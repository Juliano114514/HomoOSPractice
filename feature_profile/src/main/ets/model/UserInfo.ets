export interface UserInfo {
  uid: string;
  username: string;
  isVip: boolean;
  vipExpireTime: number; // 时间戳
  avatar?: string;
}