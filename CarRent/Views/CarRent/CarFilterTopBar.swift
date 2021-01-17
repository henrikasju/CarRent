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

  let titleLabel = UILabel()
  let distanceButton = UIButton()
  let numberPlatesButton = UIButton()
  let batteryButton = UIButton()

  // TODO: Should be horizontal collectinon view!
  let horizontalStackView = UIStackView()

  let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(viewWasSwipedUp))

  convenience init() {
    self.init(frame: .zero)

    addGestureRecognizer(swipeUpGestureRecognizer)


    subviews{
      titleLabel
      horizontalStackView
    }

    titleLabel.text("Sort by")
    titleLabel.left(0).top(0)

    horizontalStackView.addArrangedSubview(distanceButton)
    horizontalStackView.addArrangedSubview(numberPlatesButton)
    horizontalStackView.addArrangedSubview(batteryButton)

    horizontalStackView.axis = .horizontal
    horizontalStackView.alignment = .center
    horizontalStackView.distribution = .fillProportionally
    horizontalStackView.spacing = 24

    horizontalStackView.Top == titleLabel.Bottom
    horizontalStackView.left(0).right(0).bottom(0)

    distanceButton.text("Distance")
    distanceButton.setImage(UIImage(systemName: "car"), for: .normal)
    distanceButton.semanticContentAttribute = .forceRightToLeft
    distanceButton.tag = ButtonSortType.distance.rawValue
    distanceButton.backgroundColor = .systemRed
    distanceButton.layer.cornerRadius = 35/2
    distanceButton.height(35)
    distanceButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    numberPlatesButton.text("Number Plates")
    numberPlatesButton.tag = ButtonSortType.numberPlates.rawValue
    numberPlatesButton.backgroundColor = .systemRed
    numberPlatesButton.setImage(UIImage(systemName: "car"), for: .normal)
    numberPlatesButton.semanticContentAttribute = .forceRightToLeft
    numberPlatesButton.layer.cornerRadius = 35/2
    numberPlatesButton.height(35)
    numberPlatesButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    batteryButton.text("Battery")
    batteryButton.tag = ButtonSortType.battery.rawValue
    batteryButton.backgroundColor = .systemRed
    batteryButton.setImage(UIImage(systemName: "car"), for: .normal)
    batteryButton.semanticContentAttribute = .forceRightToLeft
    batteryButton.layer.cornerRadius = 35/2
    batteryButton.height(35)
    batteryButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    backgroundColor = .systemPink
    horizontalStackView.backgroundColor = .cyan
  }

  @objc func viewWasSwipedUp(){
    print("Swiped up view!")
  }

}
