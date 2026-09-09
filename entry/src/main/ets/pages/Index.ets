import { Daily } from '../model/WeatherModel'
import { common } from '@kit.AbilityKit'
import {WeatherViewModel} from '../viewmodel/WeatherViewModel'


@Entry
@ComponentV2
struct Index {
  @Local vm: WeatherViewModel = new WeatherViewModel()
  @Local isRefreshing: boolean = false

  aboutToAppear(): void {
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext
    this.vm.loadWeather(context)
  }

  build() {
    Refresh({refreshing: $$this.isRefreshing }){
    Column() {
      if (this.vm.loading) {
        Text('正在定位...')
          .fontColor(Color.White)
          .fontSize(18)
      } else if (this.vm.errorMsg) {
        Text(this.vm.errorMsg)
          .fontColor(Color.White)
          .fontSize(16)
      } else {
        Column() {
          Text(this.vm.currentCity.name + '·' + this.vm.currentCity.district)
            .fontColor(Color.White)
            .fontSize(20)
            .margin({ top: 60 })
        }

        Column() {
          // 天气图标：和风图标库CDN，文件名就是API返回的icon代码
          Image(`https://cdn.jsdelivr.net/npm/qweather-icons@1.8.0/icons/${this.vm.currentWeather.icon}.svg`)
            .width(96)
            .height(96)
            .fillColor(Color.White)
            .margin({ top: 20 })
          Text(this.vm.currentWeather.temp + '°')
            .fontColor(Color.White)
            .fontSize(80)
            .fontWeight(FontWeight.Bold)
          Text(this.vm.currentWeather.text)
            .fontColor(Color.White)
            .fontSize(18)
          Text('体感' + this.vm.currentWeather.feelsLike + '°')
            .fontColor(Color.White)
            .fontSize(16)
        }

        Column() {
          Row() {
            Column() {
              Text('湿度')
                .fontColor('#E6F0FA')
                .fontSize(14)
              Text(this.vm.currentWeather.humidity + '%')
                .fontColor(Color.White)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
            }
            .layoutWeight(1)

            Column() {
              Text('风速')
                .fontColor('#E6F0FA')
                .fontSize(14)
              Text(this.vm.currentWeather.windSpeed + 'km/h')
                .fontColor(Color.White)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
            }
            .layoutWeight(1)

            Column() {
              Text('气压')
                .fontColor('#E6F0FA')
                .fontSize(14)
              Text(this.vm.currentWeather.pressure + 'hPa')
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
              Text(this.vm.currentWeather.vis + 'km')
                .fontColor(Color.White)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
            }
            .layoutWeight(1)

            Column() {
              Text('降水量')
                .fontColor('#E6F0FA')
                .fontSize(14)
              Text(this.vm.currentWeather.precip + 'mm')
                .fontColor(Color.White)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
            }
            .layoutWeight(1)

            Column() {
              Text('云量')
                .fontColor('#E6F0FA')
                .fontSize(14)
              Text(this.vm.currentWeather.cloud + '%')
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

        Column({ space: 8 }) {
          Text('未来7天')
            .fontColor(Color.White)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
          ForEach(this.vm.dailyList, (item: Daily) => {
            Row() {
              Text(item.fxDate)
                .fontColor(Color.White)
                .fontSize(14)
                .width(95) // 固定宽度，日期对齐成一列
              Image(`https://cdn.jsdelivr.net/npm/qweather-icons@1.8.0/icons/${item.iconDay}.svg`)
                .width(24).height(24)
                .fillColor(Color.White)
                .margin({ left: 8 })
              Text(item.textDay)
                .fontColor(Color.White)
                .fontSize(14)
                .layoutWeight(1)               // 撑满中间，温度被推到最右
                .margin({ left: 8 })
              Text(item.tempMin + '° ~ ' + item.tempMax + '°')
                .fontColor(Color.White)
                .fontSize(14)
            }
            .width('100%')
          })
        }
        .backgroundColor('rgba(20,40,80,0.55)') // 深色玻璃：自己提供对比度，不依赖背后渐变
        .borderRadius(16) // 圆角
        .padding(16) // 内边距，文字不贴边
        .margin({ top: 16 }) // 和上方卡片拉开距离
        .width('90%')
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .linearGradient({
      angle: 180,
      colors: [['#4A90D9', 0], ['#87CEEB', 0.5], ['#E8F4FD', 1]]
    })
  }
  .onRefreshing(() => {this.handleRefresh()})
  .width('100%')
  .height('100%')
}
  async handleRefresh(): Promise<void> {
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext
    await this.vm.refreshWeather(context)
    this.isRefreshing = false
  }
}
