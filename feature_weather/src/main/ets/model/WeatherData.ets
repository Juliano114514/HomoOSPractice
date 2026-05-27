/**
 * 天气数据模型
 * 使用 interface 定义，方便直接接收 JSON 反序列化的结果
 */
export interface WeatherData {
  nums?: number;          // 今日实时请求次数
  cityid?: string;        // 城市ID
  city?: string;          // 城市
  date?: string;          // 日期
  week?: string;          // 星期
  update_time?: string;   // 更新时间
  wea?: string;           // 天气情况
  wea_img?: string;       // 天气标识
  tem?: string;           // 实况温度
  tem_day?: string;       // 白天温度(高温)
  tem_night?: string;     // 夜间温度(低温)
  win?: string;           // 风向
  win_speed?: string;     // 风力
  win_meter?: string;     // 风速
  air?: string;           // 空气质量
  pressure?: string;      // 气压
  humidity?: string;      // 湿度
}