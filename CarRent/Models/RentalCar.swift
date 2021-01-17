//
//  RentalCar.swift
//  CarRent
//
//  Created by Henrikas J on 16/01/2021.
//

import Foundation
import CoreLocation

struct RentalCar: Codable, Hashable {
  let id: Int
  let plateNumber: String
  var location: Location
  let model: Model
  let batteryPercentage: Int

  struct Location: Codable, Hashable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let address: String
    var distance: CLLocationDistance?
    var computedLocation: CLLocation {
      get {
        return CLLocation(latitude: latitude, longitude: longitude)
      }
    }
  }

  struct Model: Codable, Hashable {
    let id: Int
    let title: String
    let photoUrl: String
  }
}
