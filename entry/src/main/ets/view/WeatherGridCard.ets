import { WeatherNow } from '../model/WeatherModel'

@ComponentV2
export struct WeatherGridCard{
  @Require @Param weather: WeatherNow

  build() {
    Column() {
      Row() {
        Column() {
          Text('湿度')
            .fontColor('#E6F0FA')
            .fontSize(14)
          Text(this.weather.humidity + '%')
            .fontColor(Color.White)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
        }
        .layoutWeight(1)

        Column() {
          Text('风速')
            .fontColor('#E6F0FA')
            .fontSize(14)
          Text(this.weather.windSpeed + 'km/h')
            .fontColor(Color.White)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
        }
        .layoutWeight(1)

        Column() {
          Text('气压')
            .fontColor('#E6F0FA')
            .fontSize(14)
          Text(this.weather.pressure + 'hPa')
            .fontColor(Color.White)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
        }
        .layoutWeight(1)
      }

      Row() {
        Column() {
          Text('能见度')
            .fontColor('#E6F0FA')
            .fontSize(14)
          Text(this.weather.vis + 'km')
            .fontColor(Color.White)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
        }
        .layoutWeight(1)

        Column() {
          Text('降水量')
            .fontColor('#E6F0FA')
            .fontSize(14)
          Text(this.weather.precip + 'mm')
            .fontColor(Color.White)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
        }
        .layoutWeight(1)

        Column() {
          Text('云量')
            .fontColor('#E6F0FA')
            .fontSize(14)
          Text(this.weather.cloud + '%')
            .fontColor(Color.White)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
        }
        .layoutWeight(1)
      }
    }
    .backgroundColor('rgba(20,40,80,0.55)') // 深色玻璃：自己提供对比度，不依赖背后渐变
    .borderRadius(16) // 圆角
    .padding(16) // 内边距，文字不贴边
    .width('90%')
  }
}