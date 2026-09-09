import {CityInfo, WeatherNow, Daily} from '../model/WeatherModel'
import { common } from '@kit.AbilityKit'
import { LocationService } from '../service/LocationService'
import { AmapService } from '../service/AmapService'
import { QWeatherService } from '../service/QWeatherService'

@ObservedV2
export class WeatherViewModel {
  @Trace currentCity: CityInfo = new CityInfo()
  @Trace currentWeather: WeatherNow = new WeatherNow()
  @Trace dailyList: Daily[] = []
  @Trace loading: boolean = false
  @Trace errorMsg: string = ''

  private async fetchAllWeather(context: common.UIAbilityContext): Promise<void>{
    let location = await LocationService.getCurrentLocation()
    let longitude = location.longitude
    let latitude = location.latitude
    let city = await AmapService.reverseGeocode(latitude, longitude)
    let weather = await QWeatherService.fetchWeatherNow(longitude.toString(), latitude.toString())
    let daily = await QWeatherService.fetchWeather7d(longitude.toString(), latitude.toString())
    this.currentCity = city
    this.currentWeather = weather
    this.dailyList = daily
  }

  async loadWeather(context: common.UIAbilityContext): Promise<void> {
    try {
      this.loading = true
      this.errorMsg = ''
      let granted = await LocationService.requestPermissions(context)
      if(!granted){
        this.errorMsg = '需要位置权限才能获取天气'
        return
      }
      await this.fetchAllWeather(context)
    } catch (err){
      this.errorMsg = '获取天气失败：' + JSON.stringify(err)
    } finally {
      this.loading = false
    }
  }

  async refreshWeather(context: common.UIAbilityContext): Promise<void> {
    try{
      await this.fetchAllWeather(context)
    } catch (err){

    }
  }
}

