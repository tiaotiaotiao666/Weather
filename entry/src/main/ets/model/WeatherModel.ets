@Observed export  class CityInfo{
  public name: string = ''
  public adcode: string = ''
  public province: string = ''
  public district: string = ''
  public formattedAddress: string = ''
}

@Observed export class WeatherNow{
  obsTime: string = ''
  temp: string = ''
  feelsLike: string = ''
  text: string = ''
  icon: string = ''
  windDir: string = ''
  windScale: string = ''
  windSpeed: string = ''
  humidity: string = ''
  precip: string = ''
  pressure: string = ''
  vis: string = ''
  cloud: string = ''
}

export class Refer{
  source: string[] = []
  license: string[] = []
}

export class WeatherNowResponse{
  code: string = ''
  updateTime: string = ''
  fxLink: string = ''
  now: Record<string, string> = {}
  refer: Refer = new Refer()
}

export class AmapRegeoResponse{
  status: string = ''
  info: string = ''
  regeocode: AmapRegeo = new AmapRegeo()
}

export class AmapRegeo{
  formattedAddress: string = ''
  addressComponent: AmapAddressComponent = new AmapAddressComponent()
}

export class AmapAddressComponent{
  province: string = ''
  district: string = ''
  adcode: string = ''
  city: string = ''
  citycode: string = ''
}

export class Daily{
  fxDate: string = ''
  tempMax: string = ''
  tempMin: string = ''
  iconDay: string = ''
  textDay: string = ''
}

export class DailyResponse{
  code: string = ''
  updateTime: string = ''
  fxLink: string = ''
  daily: Record<string, string>[] = []
}