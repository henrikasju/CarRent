//
//  RentalCarAPI.swift
//  CarRent
//
//  Created by Henrikas J on 17/01/2021.
//

import Foundation
import Alamofire

class RentalCarAPI {

  private static let apiUrl = URL(string: "https://development.espark.lt/api/mobile/public/availablecars")!

  static func fetchAllRentalCars(completionHandler: @escaping ([RentalCar]?, Error?) -> ()) {

    AF.request(apiUrl)
      .validate()
      .validate(contentType: ["application/json"])
      .responseDecodable(of: [RentalCar].self ) { response in

        switch response.result {
        case let .failure(error):
          completionHandler(nil, error)
        case.success:
          completionHandler(response.value, nil)
        }
      }
  }
}
