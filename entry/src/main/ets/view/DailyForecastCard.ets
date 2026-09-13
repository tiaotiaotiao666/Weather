import { Daily } from '../model/WeatherModel'

function formatDate(d: Date): string {
  let year = d.getFullYear()          // 取件
  let month = d.getMonth() + 1        // 取件 + 永远记得 +1
  let day = d.getDate()
  let m = month < 10 ? `0${month}` : `${month}`   // 补零：9 → "09"
  let dd = day < 10 ? `0${day}` : `${day}`
  return `${year}-${m}-${dd}`         // 模板字符串拼接
}

function getDayLabel(fxDate: string): string{
  const now = new Date()
  let todayStr = formatDate(now)
  let tomorrowStr = formatDate(new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1))
  if(fxDate === todayStr) {
    return '今天'
  }
  else if(fxDate === tomorrowStr) {
    return '明天'
  }
  else{
    let weekdays: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
    return weekdays[new Date(fxDate).getDay()]
  }
}

@ComponentV2
export struct DailyForecastCard{
  @Require @Param dailyList: Daily[]

  build() {
    Column({ space: 8 }) {
      Text('未来7天')
        .fontColor(Color.White)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
      ForEach(this.dailyList, (item: Daily) => {
        Row() {
          Text(getDayLabel(item.fxDate))
            .fontColor(Color.White)
            .fontSize(14)
            .width(60) // 固定宽度，日期对齐成一列
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
    .width('90%')
  }
}