import http from '@ohos.net.http';
import { WeatherData } from '../model/WeatherData';

export class WeatherApi {
  private static readonly BASE_URL = "https://v1.yiketianqi.com/free/day";

  public static async getWeather(
    appid: string,
    appsecret: string,
    city: string,
    unescape: string = "1"
  ): Promise<WeatherData> {
    const httpRequest = http.createHttp()
    const url = `${WeatherApi.BASE_URL}?appid=${appid}&appsecret=${appsecret}&city=${encodeURIComponent(city)}&unescape=${unescape}`;

    try{
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 10000,
        readTimeout: 10000
      })

      if(response.responseCode === http.ResponseCode.OK) {
        const weatherData: WeatherData = JSON.parse(response.result as string)
        return weatherData
      } else {
        return Promise.reject(new Error(`网络请求失败，状态码: ${response.responseCode}`));
      }

    } catch (error) {
      return Promise.reject(new Error(`请求发生异常: ${JSON.stringify(error)}`));
    } finally {

    }
  }

}