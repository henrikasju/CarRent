//
//  CarRentView.swift
//  CarRent
//
//  Created by Henrikas J on 16/01/2021.
//

import UIKit
import Stevia

class CarRentView: UIView {

  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
  var collectionViewBottomConstraint: NSLayoutConstraint?

  convenience init() {
    self.init(frame: .zero)

    backgroundColor = .white

    subviews {
      collectionView
    }

    collectionView.Top == safeAreaLayoutGuide.Top
    collectionView.Left == safeAreaLayoutGuide.Left
    collectionView.Right == safeAreaLayoutGuide.Right
    collectionViewBottomConstraint = collectionView.Bottom == safeAreaLayoutGuide.Bottom

    collectionView.backgroundColor = .clear
    collectionView.showsVerticalScrollIndicator = false

    print(bounds.width,bounds.height)
  }
}
