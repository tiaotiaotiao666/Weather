import { http } from '@kit.NetworkKit';
import { CityInfo, AmapRegeoResponse, AmapDistrict, AmapDistrictResponse } from '../model/WeatherModel'
import { Config } from '../config/Config'

export class AmapService {
  static reverseGeocode(latitude: number, longitude: number): Promise<CityInfo> {
    return new Promise<CityInfo>((resolve, reject) => {
      let url =
        `https://restapi.amap.com/v3/geocode/regeo?location=${longitude},${latitude}&key=${Config.AMAP_KEY}&extensions=base`
      let httpRequest = http.createHttp()
      httpRequest.request(url, { method: http.RequestMethod.GET }, (err, data) => {
        if (!err) {
          let resultStr = typeof data.result === 'string' ? data.result as string : JSON.stringify(data.result)
          let jsonObj = JSON.parse(resultStr) as Record<string, Object>
          let response = new AmapRegeoResponse()
          response.status = jsonObj['status'] as string
          response.info = jsonObj['info'] as string
          if (response.status === '1') {
            let regeocodeObj = jsonObj['regeocode'] as Record<string, Object>
            response.regeocode.formattedAddress = regeocodeObj['formattedAddress'] as string
            let addrObj = regeocodeObj['addressComponent'] as Record<string, Object>
            response.regeocode.addressComponent.province = addrObj['province'] as string
            response.regeocode.addressComponent.district = addrObj['district'] as string
            response.regeocode.addressComponent.adcode = addrObj['adcode'] as string
            let cityValue = addrObj['city']
            response.regeocode.addressComponent.city = typeof cityValue === 'string' ? cityValue : ''
            let cityInfo = new CityInfo()
            let addr = response.regeocode.addressComponent
            cityInfo.adcode = addr.adcode
            cityInfo.province = addr.province
            cityInfo.district = addr.district
            cityInfo.name = typeof addr.city === 'string' ? addr.city : addr.province
            cityInfo.formattedAddress = response.regeocode.formattedAddress
            resolve(cityInfo)
          } else {
            reject(`API错误: status=${response.status}`)
          }
        } else {
          reject(err)
        }
        httpRequest.destroy()
      })
    })
  }

  static searchCity(keyword: string): Promise<AmapDistrict[]> {
    return new Promise<AmapDistrict[]>((resolve, reject) => {
      let url = `https://restapi.amap.com/v3/config/district?keywords=${encodeURIComponent(keyword)}&subdistrict=0&key=${Config.AMAP_KEY}`
      let httpRequest = http.createHttp()
      httpRequest.request(url, { method: http.RequestMethod.GET }, (err, data) => {
        if (!err) {
          let resultStr = typeof data.result === 'string' ? data.result as string : JSON.stringify(data.result)
          let jsonObj = JSON.parse(resultStr) as Record<string, Object>
          let response = new AmapDistrictResponse()
          response.status = jsonObj['status'] as string
          response.info = jsonObj['info'] as string
          response.districts = jsonObj['districts'] as Record<string, string>[]
          if (response.status === '1') {
            let result: AmapDistrict[] = []
            for (let item of response.districts) {
              let district = new AmapDistrict()
              district.name = item['name']
              district.adcode = item['adcode']
              district.citycode = item['citycode']
              district.center = item['center']
              district.level = item['level']
              result.push(district)
            }
            resolve(result)
          } else {
            reject(`API错误: status=${response.status}`)
          }
        } else {
          reject(err)
        }
        httpRequest.destroy()
      })
    })
  }
}

