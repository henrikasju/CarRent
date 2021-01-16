//
//  ViewController.swift
//  CarRent
//
//  Created by Henrikas J on 16/01/2021.
//

import UIKit
import Stevia
import Alamofire
import AlamofireImage

class CarRentViewController: UIViewController {

  private let v = CarRentView()
  var rentalCars: [RentalCar] = []

  // TODO: Delete later!
  var firstLaunch = true

  override func loadView() {
    view = v
  }

  override func viewWillAppear(_ animated: Bool) {
    fetchData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    print("VC cnt: ",rentalCars.count)

    navigationItem.title = "Rental Cars"
//    navigationController?.navigationBar.prefersLargeTitles = true

    v.collectionView.collectionViewLayout = createCompositionalLayout()
    v.collectionView.dataSource = self
    v.collectionView.register(CarRentCollectionViewCell.self, forCellWithReuseIdentifier: CarRentCollectionViewCell.identifier)
  }

  func fetchData() {
    if let url = URL(string: "https://development.espark.lt/api/mobile/public/availablecars") {

      AF.request(url)
        .validate()
        .validate(contentType: ["application/json"])
        .responseDecodable(of: [RentalCar].self ) { response in

          switch response.result {
          case let .failure(error):
            print("Network error: ", error)
          case.success:

            if let decodedData = response.value {

              self.rentalCars = decodedData
              self.v.collectionView.reloadData()
            }else {

              print("Failed to unwrap data!")
            }
          }
        }

    }
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
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return rentalCars.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if indexPath.section == 0, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarRentCollectionViewCell.identifier, for: indexPath) as? CarRentCollectionViewCell {

      // temp image
      let cellData = rentalCars[indexPath.row]

      let placeholder = UIImage(systemName: "car")
      let url = URL(string: cellData.model.photoUrl)!


      cell.carImageView.af.setImage(withURL: url, cacheKey: cellData.model.photoUrl, placeholderImage: placeholder, filter: AspectScaledToFitSizeFilter(size: CGSize(width: cell.frame.width, height: cell.imageViewHeightContraint!.constant)))

      cell.carNameLabel.text("Car name - [\(cellData.model.title)]")
      cell.carDistanceLabel.text("Distance: [\("Need to calc")]km")
      cell.carPlaneNumberLabel.text("Number Plates - [\(cellData.plateNumber)]")
      cell.carRemainingBattery.text("Battery [\(cellData.batteryPercentage)]%")

      return cell
    }


    let cell = UICollectionViewCell()
    return cell
  }

  // TODO: Delete later
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {


    if firstLaunch {
      firstLaunch = false
      collectionView.frame.origin.y += collectionView.frame.height
      UIView.animate(withDuration: 0.3) {
        collectionView.frame.origin.y -= collectionView.frame.height
      }
    }
  }
}
