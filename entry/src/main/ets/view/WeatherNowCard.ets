import { CityInfo, WeatherNow } from '../model/WeatherModel'

@ComponentV2
export struct WeatherNowCard {
  @Require @Param city: CityInfo
  @Require @Param weather: WeatherNow
  build() {
    Column() {
      Text(this.city.name + '·' + this.city.district)
        .fontColor(Color.White)
        .fontSize(20)

      // 天气图标：和风图标库CDN，文件名就是API返回的icon代码
      Image(`https://cdn.jsdelivr.net/npm/qweather-icons@1.8.0/icons/${this.weather.icon}.svg`)
        .width(96)
        .height(96)
        .fillColor(Color.White)
        .margin({ top: 20 })
      Text(this.weather.temp + '°')
        .fontColor(Color.White)
        .fontSize(80)
        .fontWeight(FontWeight.Bold)
      Text(this.weather.text)
        .fontColor(Color.White)
        .fontSize(18)
      Text('体感' + this.weather.feelsLike + '°')
        .fontColor(Color.White)
        .fontSize(16)
    }
  }
}