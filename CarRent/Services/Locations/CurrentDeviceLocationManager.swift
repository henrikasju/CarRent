//
//  CurrentDeviceLocation.swift
//  CarRent
//
//  Created by Henrikas J on 18/01/2021.
//

import Foundation
import CoreLocation

enum LocationErrors: Error {
  case locationDenied
}

protocol CurrentDeviceLocationManagerDelegate {
  func locationPermissionsDidChange(_ manager: CurrentDeviceLocationManager, authorizationStatus: CLAuthorizationStatus)
}

class CurrentDeviceLocationManager: NSObject {
  private let manager = CLLocationManager()
  var delegate: CurrentDeviceLocationManagerDelegate?

  init(delegate: CurrentDeviceLocationManagerDelegate) {
    super.init()
    manager.delegate = self
    self.delegate = delegate
  }

  func getCurrentLocation(completionHandler: (LocationErrors?, CLLocation?) -> ()) {
    manager.requestAlwaysAuthorization()

    if manager.authorizationStatus == .denied {
      completionHandler(.locationDenied, nil)
    }else {
      let location = manager.location
      completionHandler(nil, location)
    }
  }


  func getAuthorizationStatus() -> CLAuthorizationStatus {
    return manager.authorizationStatus
  }

  func requestAuthorization() {
    manager.requestAlwaysAuthorization()
  }
}

extension CurrentDeviceLocationManager: CLLocationManagerDelegate {

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    delegate?.locationPermissionsDidChange(self, authorizationStatus: manager.authorizationStatus)
  }

}
