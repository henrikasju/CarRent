//
//  CarFilterTopBar.swift
//  CarRent
//
//  Created by Henrikas J on 16/01/2021.
//

import UIKit
import Stevia

enum ButtonSortType: Int {
  case distance = 1
  case numberPlates = 2
  case battery = 3
}

class CarFilterTopBar: UIView {

  let titleFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
  let buttonFont = UIFont.systemFont(ofSize: 16, weight: .medium)
  let buttonColor = UIColor(named: "BackgroundColor")

  let titleLabel = UILabel()
  let distanceButton = UIButton()
  let numberPlatesButton = UIButton()
  let batteryButton = UIButton()

  var bottomViewBorder: UIView = {
    let view = UIView()
    view.height(1)
    view.backgroundColor = UIColor(named: "BackgroundColor")
    return view
  }()

  let horizontalStackView = UIStackView()

  convenience init() {
    self.init(frame: .zero)

    horizontalStackView.addArrangedSubview(distanceButton)
    horizontalStackView.addArrangedSubview(numberPlatesButton)
    horizontalStackView.addArrangedSubview(batteryButton)


    subviews{
      titleLabel
      horizontalStackView
      bottomViewBorder
    }

    bottomViewBorder.left(0).right(0).bottom(0)

    titleLabel.text("Sort by")
    titleLabel.font = titleFont
    titleLabel.textColor = .black
    titleLabel.Left == horizontalStackView.Left
    titleLabel.Top == Top + 4

    horizontalStackView.axis = .horizontal
    horizontalStackView.alignment = .center
    horizontalStackView.distribution = .equalSpacing

    horizontalStackView.Top == titleLabel.Bottom
    horizontalStackView.left(12).right(12).bottom(0).centerHorizontally()

    let buttonsEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    let buttonHeight: CGFloat = 35.0
    let buttonCornerRadius: CGFloat = buttonHeight / 2.0

    distanceButton.text("Distance")
    distanceButton.titleLabel?.font = buttonFont
    distanceButton.semanticContentAttribute = .forceRightToLeft
    distanceButton.tag = ButtonSortType.distance.rawValue
    distanceButton.backgroundColor = buttonColor
    distanceButton.layer.cornerRadius = buttonCornerRadius
    distanceButton.height(buttonHeight)
    distanceButton.contentEdgeInsets = buttonsEdgeInsets

    numberPlatesButton.text("Number Plates")
    numberPlatesButton.titleLabel?.font = buttonFont
    numberPlatesButton.tag = ButtonSortType.numberPlates.rawValue
    numberPlatesButton.backgroundColor = buttonColor
    numberPlatesButton.semanticContentAttribute = .forceRightToLeft
    numberPlatesButton.layer.cornerRadius = buttonCornerRadius
    numberPlatesButton.height(buttonHeight)
    numberPlatesButton.contentEdgeInsets = buttonsEdgeInsets

    batteryButton.text("Battery")
    batteryButton.titleLabel?.font = buttonFont
    batteryButton.tag = ButtonSortType.battery.rawValue
    batteryButton.backgroundColor = buttonColor
    batteryButton.layer.cornerRadius = buttonCornerRadius
    batteryButton.height(buttonHeight)
    batteryButton.contentEdgeInsets = buttonsEdgeInsets

    horizontalStackView.backgroundColor = .clear
    backgroundColor = .white
  }
}
