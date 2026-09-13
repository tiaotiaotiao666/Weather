import { CityInfo, WeatherNow, Daily, AmapDistrict, CityEntry } from '../model/WeatherModel'
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
  @Trace searchResults: AmapDistrict[] = []
  @Trace cityList: CityEntry[] = [new CityEntry('我的位置', '', '', '', true)]  // 城市列表，"我的位置"永排第一
  @Trace currentEntry: CityEntry | null = null  // 当前条目——芯片高亮与刷新都以它为准

  private async fetchWeatherForEntry(entry: CityEntry): Promise<void> {
    let lon: string = ''
    let lat: string = ''
    if (entry.isMyLocation) {
      // 活动靶：坐标 GPS 现取，还要逆地理把坐标翻译成城市名
      let location = await LocationService.getCurrentLocation()
      lon = location.longitude.toString()
      lat = location.latitude.toString()
      this.currentCity = await AmapService.reverseGeocode(location.latitude, location.longitude)
    } else {
      // 死靶：坐标存死在条目里，定位、逆地理全省
      lon = entry.lon
      lat = entry.lat
      let city = new CityInfo()
      city.name = entry.name
      this.currentCity = city
    }
    let weather = await QWeatherService.fetchWeatherNow(lon, lat)
    let daily = await QWeatherService.fetchWeather7d(lon, lat)
    this.currentWeather = weather
    this.dailyList = daily
  }

  async switchToCity(entry: CityEntry): Promise<void> {
    this.currentEntry = entry
    try {
      this.loading = true
      this.errorMsg = ''
      await this.fetchWeatherForEntry(entry)
    } catch (err) {
      this.errorMsg = '获取天气失败：' + JSON.stringify(err)
    } finally {
      this.loading = false
    }
  }

  async addCity(d: AmapDistrict): Promise<void> {
    // 查重：adcode 身份证比对，已在列表就直接切过去
    for (const item of this.cityList) {
      if (item.adcode === d.adcode) {
        await this.switchToCity(item)
        return
      }
    }
    // 拆坐标："108.948024,34.263161" → ["108.948024", "34.263161"]
    let parts = d.center.split(',')
    let entry = new CityEntry(d.name, parts[0], parts[1], d.adcode, false)
    this.cityList.push(entry)
    await this.switchToCity(entry)
  }

  async loadWeather(context: common.UIAbilityContext): Promise<void> {
    this.loading = true
    this.errorMsg = ''
    try {
      let granted = await LocationService.requestPermissions(context)
      if (!granted) {
        this.errorMsg = '需要位置权限才能获取天气'
        return
      }
      await this.switchToCity(this.cityList[0])  // 开机默认切到"我的位置"
    } catch (err) {
      this.errorMsg = '获取天气失败：' + JSON.stringify(err)
    } finally {
      this.loading = false
    }
  }

  async refreshWeather(): Promise<void> {
    // 刷新当前城市：currentEntry 是西安市就刷西安，不再无脑重走 GPS
    let entry = this.currentEntry
    if (entry === null) {
      return
    }
    try {
      await this.fetchWeatherForEntry(entry)
    } catch (err) {
      console.error(`[refreshWeather] 刷新失败: ${JSON.stringify(err)}`)
    }
  }

  async searchCities(keyword: string): Promise<void> {
    let text = keyword.trim()
    if (text === '') {
      this.searchResults = []
      return
    }
    try {
      let list = await AmapService.searchCity(text)
      let seen: Set<string> = new Set<string>()
      let result: AmapDistrict[] = []
      for (const item of list) {
        if (item.level !== 'city' && item.level !== 'province') {   // 只留市/省两级，区级不要
          continue
        }
        let key = item.citycode !== '' ? item.citycode : item.adcode
        if (!seen.has(key)) {
          seen.add(key)
          result.push(item)
        }
      }
      this.searchResults = result
    } catch (err) {
      this.searchResults = []
      console.error(`[searchCities] 搜索失败: ${JSON.stringify(err)}`)
    }
  }
}

