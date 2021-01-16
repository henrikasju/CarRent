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

    v.collectionView.collectionViewLayout = createCompositionalLayout()
    v.collectionView.dataSource = self
    v.collectionView.delegate = self
    v.collectionView.register(CarRentCollectionViewCell.self, forCellWithReuseIdentifier: CarRentCollectionViewCell.identifier)
  }

  private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      return self.singleRowVerticalLayoutSection()
    }
  }

  private func singleRowVerticalLayoutSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 20
    section.contentInsets.bottom = 30

    return section
  }
}

extension CarRentViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarRentCollectionViewCell.identifier, for: indexPath) as? CarRentCollectionViewCell {

      cell.backgroundColor = .red
      // temp image
      cell.carImageView.image = UIImage(named: "btc")
      cell.carNameLabel.text("Car name - #[\(indexPath.section)@\(indexPath.row)]")
      cell.carDistanceLabel.text("Distance: []km")
      cell.carPlaneNumberLabel.text("Number Plates - XXX 000")
      cell.carRemainingBattery.text("Battery %")

      return cell
    }


    let cell = UICollectionViewCell()
    return cell
  }
}

extension CarRentViewController: UICollectionViewDelegateFlowLayout {
  
}
