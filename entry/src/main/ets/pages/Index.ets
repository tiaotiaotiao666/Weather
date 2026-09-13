import { common } from '@kit.AbilityKit'
import { WeatherViewModel } from '../viewmodel/WeatherViewModel'
import { WeatherNowCard } from '../view/WeatherNowCard'
import { WeatherGridCard } from '../view/WeatherGridCard'
import { DailyForecastCard } from '../view/DailyForecastCard'
import { CitySearchSheet } from '../view/CitySearchSheet'
import { CityItem } from '../view/CityItem'
import { CityEntry } from '../model/WeatherModel'

@Entry
@ComponentV2
struct Index {
  @Local vm: WeatherViewModel = new WeatherViewModel()
  @Local isRefreshing: boolean = false
  @Local isSheetShow: boolean = false

  aboutToAppear(): void {
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext
    this.vm.loadWeather(context)
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      Scroll() {
        Column() {
          Button('切换城市')
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#66FFFFFF')
            .margin({ top: 12 })
            .onClick(() => {
              this.isSheetShow = true
            })
            .bindSheet($$this.isSheetShow, this.searchSheetBuilder(), {
              detents: [SheetSize.MEDIUM],
              title: { title: '选择城市' }
            })
          Scroll() {
            Row({ space: 8 }) {
              ForEach(this.vm.cityList, (entry: CityEntry) => {
                CityItem({
                  name: entry.name,
                  active: this.vm.currentEntry === entry,
                  onTap: () => {
                    this.vm.switchToCity(entry)
                  }
                })
              }, (entry: CityEntry) => entry.adcode)
            }
            .padding({ left: 16, right: 16 })
          }
          .scrollable(ScrollDirection.Horizontal)
          .width('90%')
          .margin({ top: 8 })
          if (this.vm.loading) {
            Text('正在加载...')
              .fontColor(Color.White)
              .fontSize(18)
          } else if (this.vm.errorMsg) {
            Text(this.vm.errorMsg)
              .fontColor(Color.White)
              .fontSize(16)
          } else {
          WeatherNowCard({ city: this.vm.currentCity, weather: this.vm.currentWeather })
            .margin({ top: 16 })
            WeatherGridCard({ weather: this.vm.currentWeather })
            DailyForecastCard({ dailyList: this.vm.dailyList })
              .margin({ top: 16 })
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .linearGradient({
        angle: 180,
        colors: [['#4A90D9', 0], ['#87CEEB', 0.5], ['#E8F4FD', 1]]
      })
    }
    .onRefreshing(() => {
      this.handleRefresh()
    })
    .width('100%')
    .height('100%')
  }

  async handleRefresh(): Promise<void> {
    await this.vm.refreshWeather()
    this.isRefreshing = false
  }

  @Builder
  searchSheetBuilder() {
    CitySearchSheet({
      vm: this.vm,
      onCityPicked: () => {
        this.isSheetShow = false
      }
    })
  }
}
