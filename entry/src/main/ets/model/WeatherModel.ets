@Observed export  class CityInfo{
  public name: string = ''  // 城市名（直辖市时可能为空，用 province 兜底）
  public adcode: string = ''  // 行政区划代码
  public province: string = ''  // 省份
  public district: string = ''  // 区县
  public formattedAddress: string = ''  // 完整格式化地址
}

export class CityEntry{  // 城市条目：城市列表里的一枚棋子
  name: string          // 显示名（"我的位置"或城市名，如"西安市"）
  lon: string           // 经度——"我的位置"恒为空串（活动靶，切换时 GPS 现取）
  lat: string           // 纬度——同上
  adcode: string        // 身份证号：添加时查重用
  isMyLocation: boolean // 旗子：true=活动靶走GPS，false=死靶用存的坐标

  constructor(name: string, lon: string, lat: string, adcode: string, isMyLocation: boolean) {
    this.name = name
    this.lon = lon
    this.lat = lat
    this.adcode = adcode
    this.isMyLocation = isMyLocation
  }
}

@Observed export class WeatherNow{
  obsTime: string = ''  // 观测时间
  temp: string = ''  // 当前气温（℃）
  feelsLike: string = ''  // 体感温度（℃）
  text: string = ''  // 天气现象文字（晴/多云/小雨…）
  icon: string = ''  // 天气图标代码（配图标CDN用）
  windDir: string = ''  // 风向（如"东北风"）
  windScale: string = ''  // 风力等级（如"3"）
  windSpeed: string = ''  // 风速（km/h）
  humidity: string = ''  // 相对湿度（%）
  precip: string = ''  // 降水量（mm）
  pressure: string = ''  // 大气压强（hPa）
  vis: string = ''  // 能见度（km）
  cloud: string = ''  // 云量（%）
}

export class Refer{
  source: string[] = []  // 数据来源名称列表
  license: string[] = []  // 数据许可协议列表
}

export class WeatherNowResponse{
  code: string = ''  // 状态码，'200' 为成功
  updateTime: string = ''  // 本次数据更新时间
  fxLink: string = ''  // 和风官网该城市天气页链接
  now: Record<string, string> = {}  // 实况数据原始键值对
  refer: Refer = new Refer()  // 参考信息（来源与许可）
}

export class AmapRegeoResponse{
  status: string = ''  // 状态值，'1' 为成功
  info: string = ''  // 状态说明
  regeocode: AmapRegeo = new AmapRegeo()  // 逆地理编码结果
}

export class AmapRegeo{
  formattedAddress: string = ''  // 格式化完整地址
  addressComponent: AmapAddressComponent = new AmapAddressComponent()  // 省市区的分解组件
}

export class AmapAddressComponent{
  province: string = ''  // 省份
  district: string = ''  // 区县
  adcode: string = ''  // 区划编码
  city: string = ''  // 城市（直辖市可能返回空值，取值要判型）
  citycode: string = ''  // 城市区号
}

export class Daily{
  fxDate: string = ''  // 预报日期（如 2026-09-08）
  tempMax: string = ''  // 最高气温（℃）
  tempMin: string = ''  // 最低气温（℃）
  iconDay: string = ''  // 白天天气图标代码
  textDay: string = ''  // 白天天气现象文字
}

export class DailyResponse{
  code: string = ''  // 状态码，'200' 为成功
  updateTime: string = ''  // 本次数据更新时间
  fxLink: string = ''  // 和风官网该城市天气页链接
  daily: Record<string, string>[] = []  // 逐日预报原始数组
}

export class AmapDistrict{
  name: string = ''  // 行政区名称：是市名还是区名看 level（city=市名"西安市"，district=区名"西安区"）
  adcode: string = ''  // 行政区划代码，每个行政区唯一（西安市 610100）
  citycode: string = ''  // 城市区号（西安 029；同城多条目时相同，可当"同一座城"的判据）
  center: string = ''  // 中心点坐标，"经度,纬度"格式——左边经度（>90 必是经度）
  level: string = ''  // 行政级别：province省 / city市 / district区（直辖市挂在 province 上）
}

export class AmapDistrictResponse{
  status: string = ''  // 状态值，'1' 为成功
  info: string = ''  // 状态说明
  districts: Record<string, string>[] = []  // 匹配到的行政区原始数组（每条还带个嵌套空 districts，不搬它）
}