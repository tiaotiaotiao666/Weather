import { WeatherViewModel } from '../viewmodel/WeatherViewModel'
import { AmapDistrict } from '../model/WeatherModel'

@ComponentV2
export struct CitySearchSheet {
  @Require @Param vm: WeatherViewModel
  @Event onCityPicked: () => void = () => {}
  @Local keyword: string = ''
  private searchTimer = -1
  private hotCities: string [] = ['北京', '上海', '天津', '重庆',
    '哈尔滨', '长春', '沈阳', '石家庄', '太原', '济南',
    '郑州', '西安', '兰州', '西宁', '银川', '乌鲁木齐',
    '呼和浩特', '拉萨', '南京', '杭州', '合肥', '福州',
    '南昌', '武汉', '长沙', '广州', '南宁', '海口',
    '贵阳', '昆明', '成都', '深圳', '大连', '青岛', '宁波', '厦门'
  ]

  build() {
    Column() {
      TextInput({ placeholder: '输入城市名，如：西安', text: this.keyword })
        .onChange((value: string) => {
          this.onKeywordChange(value)
        })
        .height(40)
        .width('90%')
        .backgroundColor('#F1F3F5')
        .borderRadius(20)
        .margin({ top: 12 })

      if (this.keyword === '') {
        Grid() {
          ForEach(this.hotCities, (city: string) => {
            GridItem() {
              Text(city)
                .fontSize(14)
                .fontColor('#333333')
                .textAlign(TextAlign.Center)
                .width('100%')
                .padding({ top: 10, bottom: 10 })
                .backgroundColor('#F1F3F5')
                .borderRadius(16)
                .onClick(() => {
                  this.onCityTap(city)
                })
            }
          }, (city: string) => city)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .columnsGap(8)
        .rowsGap(8)
        .padding({ left: 16, right: 16, top: 12 })
        .layoutWeight(1)
        .nestedScroll({
          scrollForward: NestedScrollMode.PARENT_FIRST,
          scrollBackward: NestedScrollMode.SELF_FIRST
        })
      } else {
        List({ space: 8 }) {
          ForEach(this.vm.searchResults, (d: AmapDistrict) => {
            ListItem() {
              Row() {
                Text(d.name)
                  .fontSize(16)
                  .fontColor('#333333')
                  .layoutWeight(1)
                Text(this.levelLabel(d.level))
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')
              .padding(12)
              .borderRadius(12)
              .backgroundColor('#F1F3F5')
              .onClick(() => {
                this.vm.addCity(d)
                this.onCityPicked()
              })
            }
          }, (d: AmapDistrict) => d.adcode)
        }
        .width('90%')
        .layoutWeight(1)
        .margin({ top: 12 })
        .nestedScroll({
          scrollForward: NestedScrollMode.PARENT_FIRST,
          scrollBackward: NestedScrollMode.SELF_FIRST
        })
      }
    }
    .width('100%')
    .height('100%')

  }

  onKeywordChange(value: string): void {
    this.keyword = value
    if (this.searchTimer !== -1) {
      clearTimeout(this.searchTimer)
    }
    if (value === '') {
      this.vm.searchCities('')
      return
    }
    this.searchTimer = setTimeout(() => {
      this.vm.searchCities(value)
    }, 500)
  }

  onCityTap(city: string): void{
    if(this.searchTimer !== -1){
      clearTimeout(this.searchTimer)
    }
    this.keyword = city
    this.vm.searchCities(city)
  }

  levelLabel(level: string): string{
    if(level === 'province'){
      return '省'
    }
    if(level === 'district'){
      return '区'
    }
    return '市'
  }
}
