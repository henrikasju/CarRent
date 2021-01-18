//
//  CarRentCellModelView.swift
//  CarRent
//
//  Created by Henrikas J on 17/01/2021.
//

import Foundation

struct CarRentCellViewModel {
  
  let modelName: String
  let plateNumber: String
  let batteryPercentage: String
  let address: String
  let distance: String?

  init(model: RentalCar) {
    self.modelName = model.model.title
    self.plateNumber = model.plateNumber
    self.batteryPercentage = String(format: "Battery %d%%", model.batteryPercentage)
    self.address = model.location.address
    self.distance = model.location.distance != nil ?
      String(format: "Away %.1f km", (model.location.distance!/1000) ) : nil
  }
}
