//
//  ViewController.swift
//  CarRent
//
//  Created by Henrikas J on 16/01/2021.
//

import UIKit

class CarRentViewController: UIViewController {

  private let v = CarRentView()

  override func loadView() {
    view = v
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Rental Cars"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
}
