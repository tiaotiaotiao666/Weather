import { http } from '@kit.NetworkKit'
import { WeatherNow, WeatherNowResponse, Daily, DailyResponse } from '../model/WeatherModel'
import { Config } from '../config/Config'

export class QWeatherService {
  static fetchWeatherNow(longitude: string, latitude: string): Promise<WeatherNow> {
    return new Promise<WeatherNow>((resolve, reject) => {
      let url = `https://${Config.QWEATHER_HOST}/v7/weather/now?location=${longitude},${latitude}&key=${Config
        .QWEATHER_KEY}`
      let httpRequest = http.createHttp()
      httpRequest.request(url, {method: http.RequestMethod.GET}, (err, data) => {
        if(!err){
          let resultStr = typeof data.result === 'string' ? data.result as string : JSON.stringify(data.result)
          console.info(`[QWeather] 原始返回: ${resultStr}`)
          let jsonObj = JSON.parse(resultStr) as Record<string, Object>

          let response = new WeatherNowResponse()
          response.code = jsonObj['code'] as string
          response.updateTime = jsonObj['updateTime'] as string
          response.fxLink = jsonObj['fxLink'] as string
          response.now = jsonObj['now'] as Record<string, string>

          if (response.code === '200') {
            let nowObj = response.now
            let weatherNow = new WeatherNow()
            weatherNow.obsTime = nowObj['obsTime']
            weatherNow.temp = nowObj['temp']
            weatherNow.feelsLike = nowObj['feelsLike']
            weatherNow.text = nowObj['text']
            weatherNow.icon = nowObj['icon']
            weatherNow.windDir = nowObj['windDir']
            weatherNow.windScale = nowObj['windScale']
            weatherNow.windSpeed = nowObj['windSpeed']
            weatherNow.humidity = nowObj['humidity']
            weatherNow.precip = nowObj['precip']
            weatherNow.pressure = nowObj['pressure']
            weatherNow.vis = nowObj['vis']
            weatherNow.cloud = nowObj['cloud']
            resolve(weatherNow)
          } else {
            reject(`API错误: code=${response.code}`)
          }

        } else {
          reject(err)
        }
        httpRequest.destroy()
      })
    })
  }

  static fetchWeather7d(longitude: string, latitude: string): Promise<Daily[]> {
    return new Promise<Daily[]>((resolve, reject) => {
      let url = `https://${Config.QWEATHER_HOST}/v7/weather/7d?location=${longitude},${latitude}&key=${Config.QWEATHER_KEY}`
      let httpRequest = http.createHttp()
      httpRequest.request(url, {method: http.RequestMethod.GET}, (err, data) => {
        if(!err){
          let resultStr = typeof data.result === 'string' ? data.result as string : JSON.stringify(data.result)
          let jsonObj = JSON.parse(resultStr) as Record<string, Object>

          let response = new DailyResponse()
          response.code = jsonObj['code'] as string
          response.daily = jsonObj['daily'] as Record<string, string>[]

          if (response.code === '200') {
            let dailyArr = response.daily
            let result: Daily[] = []
            for (let item of dailyArr) {
              let d = new Daily()
              d.fxDate = item['fxDate']
              d.tempMax = item['tempMax']
              d.tempMin = item['tempMin']
              d.iconDay = item['iconDay']
              d.textDay = item['textDay']
              result.push(d)
            }
            resolve(result)
          } else {
            reject(`API错误: code=${response.code}`)
          }
        } else {
          reject(err)
        }
        httpRequest.destroy()
      })
    })
  }
}