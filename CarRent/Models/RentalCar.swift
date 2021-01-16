//
//  RentalCar.swift
//  CarRent
//
//  Created by Henrikas J on 16/01/2021.
//

import Foundation

struct RentalCar: Codable {
  let id: Int
  let plateNumber: String
  let location: Location
  let model: Model
  let batteryPercentage: Int

  struct Location: Codable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let address: String
  }

  struct Model: Codable {
    let id: Int
    let title: String
    let photoUrl: String
  }
}
