import { geoLocationManager } from '@kit.LocationKit'
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'

class LocationResult {
  latitude: number = 0
  longitude: number = 0
}

const LOCATION_PERMISSIONS: Permissions[] = [
  'ohos.permission.APPROXIMATELY_LOCATION',
  'ohos.permission.LOCATION'
]

export class LocationService {
  static async requestPermissions(context: common.UIAbilityContext): Promise<boolean> {
    let atManager = abilityAccessCtrl.createAtManager()
    try {
      let result = await atManager.requestPermissionsFromUser(context, LOCATION_PERMISSIONS)
      return result.authResults[0] === 0 && result.authResults[1] === 0
    } catch(err){
      return false
    }
  }

  static async getCurrentLocation(): Promise<LocationResult> {
    let requestInfo: geoLocationManager.LocationRequest = {
      priority: geoLocationManager.LocationRequestPriority.ACCURACY,
      scenario: geoLocationManager.LocationRequestScenario.UNSET,
      timeInterval: 1,
      distanceInterval: 0,
      maxAccuracy: 0
    }
      let location = await geoLocationManager.getCurrentLocation(requestInfo)
      let result = new LocationResult()
      result.latitude = location.latitude
      result.longitude = location.longitude
      return result
  }

}