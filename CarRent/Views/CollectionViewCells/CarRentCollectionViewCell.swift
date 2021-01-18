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

  var carRentViewModel: CarRentCellViewModel! {
    didSet {
      carNameLabel.text(carRentViewModel.modelName)
      carAddressLabel.text(carRentViewModel.address)
      carPlaneNumberLabel.text(carRentViewModel.plateNumber)
      carRemainingBatteryLabel.text(carRentViewModel.batteryPercentage)
      if carRentViewModel.distance != nil {
        carDistanceLabel.text(carRentViewModel.distance!)
      }
    }
  }

  let carNameTitleFont = UIFont.systemFont(ofSize: 22, weight: .medium)
  let carPlateNumberFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
  let carAddressFont = UIFont.systemFont(ofSize: 14, weight: .medium)
  let carDistanceFont = UIFont.systemFont(ofSize: 14, weight: .medium)
  let carBatteryFont = UIFont.systemFont(ofSize: 14, weight: .medium)

  let carImageView = UIImageView()
  let carNameLabel = UILabel()
  let carAddressLabel = UILabel()
  let carDistanceLabel = UILabel()
  let carPlaneNumberLabel = UILabel()
  let carRemainingBatteryLabel = UILabel()

  let verticalStackView = UIStackView()
  let verticalCarDetailsStackView = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    let cornerRadius: CGFloat = 10.0
    layer.cornerRadius = cornerRadius

    subviews {
      carImageView
      verticalCarDetailsStackView
      carAddressLabel
      carDistanceLabel
    }

    carImageView.top(cornerRadius).left(cornerRadius).width(175).height(100)
    carImageView.contentMode = .scaleAspectFit
    carImageView.tintColor = .gray
    carImageView.backgroundColor = .clear

    verticalCarDetailsStackView.backgroundColor = .clear

    verticalCarDetailsStackView.Left == carImageView.Right + 8
    verticalCarDetailsStackView.Top == carImageView.Top
    verticalCarDetailsStackView.Bottom == carDistanceLabel.Top - 12
    verticalCarDetailsStackView.right(cornerRadius)

    verticalCarDetailsStackView.addArrangedSubview(carNameLabel)
    verticalCarDetailsStackView.addArrangedSubview(carPlaneNumberLabel)
    verticalCarDetailsStackView.addArrangedSubview(carRemainingBatteryLabel)

    verticalCarDetailsStackView.axis = .vertical
    verticalCarDetailsStackView.alignment = .leading
    verticalCarDetailsStackView.distribution = .fillProportionally
    verticalCarDetailsStackView.backgroundColor = .clear

    carAddressLabel.left(cornerRadius).bottom(cornerRadius)
    carAddressLabel.Right == carImageView.Right
    carAddressLabel.Top == carImageView.Bottom
    carAddressLabel.height(30)

    carDistanceLabel.right(cornerRadius).height(30).bottom(cornerRadius)
    carDistanceLabel.Top == carAddressLabel.Top
    carDistanceLabel.Left == carAddressLabel.Right + 8

    carNameLabel.backgroundColor = .clear
    carNameLabel.textColor = UIColor(named: "MainFontColor")
    carNameLabel.font = carNameTitleFont

    carPlaneNumberLabel.backgroundColor = .clear
    carPlaneNumberLabel.textColor = UIColor(named: "SecondaryFontColor")
    carPlaneNumberLabel.font = carPlateNumberFont

    carRemainingBatteryLabel.textColor = UIColor(named: "BatteryColor")
    carRemainingBatteryLabel.backgroundColor = .clear
    carRemainingBatteryLabel.textAlignment = .right
    carRemainingBatteryLabel.font = carBatteryFont

    carAddressLabel.backgroundColor = .clear
    carAddressLabel.textColor = UIColor(named: "AddressFontColor")
    carAddressLabel.textAlignment = .left
    carAddressLabel.font = carAddressFont

    carDistanceLabel.textColor = UIColor(named: "BackgroundColor")
    carDistanceLabel.backgroundColor = .clear
    carDistanceLabel.textAlignment = .left
    carDistanceLabel.font = carDistanceFont

    backgroundColor = .white
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
