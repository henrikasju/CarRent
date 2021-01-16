//
//  CollectionViewCell.swift
//  CarRent
//
//  Created by Henrikas J on 16/01/2021.
//

import UIKit
import Stevia

class CarRentCollectionViewCell: UICollectionViewCell {

  class var identifier: String{
      return "CarRentCollectionViewCell"
  }

  let carImageView = UIImageView()
  let carNameLabel = UILabel()
  let carDistanceLabel = UILabel()
  let carPlaneNumberLabel = UILabel()
  let carRemainingBattery = UILabel()

  let verticalStackView = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    subviews {
      verticalStackView
    }

    verticalStackView.fillContainer()

    verticalStackView.addArrangedSubview(carImageView)
    verticalStackView.addArrangedSubview(carNameLabel)
    verticalStackView.addArrangedSubview(carDistanceLabel)
    verticalStackView.addArrangedSubview(carPlaneNumberLabel)
    verticalStackView.addArrangedSubview(carRemainingBattery)

    verticalStackView.axis = .vertical
    verticalStackView.alignment = .center
    verticalStackView.distribution = .fill
    verticalStackView.spacing = 1

    carImageView.height(200).heightEqualsWidth()
    carNameLabel.backgroundColor = .red
    carPlaneNumberLabel.backgroundColor = .cyan


    self.backgroundColor = .red
    verticalStackView.backgroundColor = .green
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
