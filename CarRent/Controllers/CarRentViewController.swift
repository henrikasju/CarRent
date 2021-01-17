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

fileprivate typealias RentalCarDataSource = UICollectionViewDiffableDataSource<CarRentViewController.Section, RentalCar>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<CarRentViewController.Section, RentalCar>

class CarRentViewController: UIViewController {

  private let v = CarRentView()
  var rentalCars = [RentalCar]()
  private var dataSource: RentalCarDataSource!

  var showingSortView: Bool = false
  let carFilterTopBar = CarFilterTopBar()

  override func loadView() {
    view = v
  }

  override func viewWillAppear(_ animated: Bool) {
    fetchData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Rental Cars"

    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(sortButtonPressed(sender:)))

    v.collectionView.collectionViewLayout = createCompositionalLayout()
    v.collectionView.delegate = self
    v.collectionView.register(CarRentCollectionViewCell.self, forCellWithReuseIdentifier: CarRentCollectionViewCell.identifier)

    configureDataSource()

    let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(filterTopBarSwipedUp(sender:)))
    swipeGesture.direction = .up

    carFilterTopBar.addGestureRecognizer(swipeGesture)

    carFilterTopBar.distanceButton.addTarget(self, action: #selector(sortSelectionButtonPressed(sender:)), for: .touchUpInside)
    carFilterTopBar.numberPlatesButton.addTarget(self, action: #selector(sortSelectionButtonPressed(sender:)), for: .touchUpInside)
    carFilterTopBar.batteryButton.addTarget(self, action: #selector(sortSelectionButtonPressed(sender:)), for: .touchUpInside)
  }

  private func configureDataSource() {

    dataSource = RentalCarDataSource(collectionView: v.collectionView, cellProvider: {
      (collectionView, indexPath, rentalCar) -> UICollectionViewCell? in

      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarRentCollectionViewCell.identifier, for: indexPath) as! CarRentCollectionViewCell

      let cellData = rentalCar

      let placeholder = UIImage(systemName: "car")

      // TODO: Fix aspect ratio!
      if let url = URL(string: cellData.model.photoUrl) {
        cell.carImageView.af.setImage(withURL: url, cacheKey: cellData.model.photoUrl, placeholderImage: placeholder, filter: AspectScaledToFitSizeFilter(size: CGSize(width: 175, height: cell.imageViewHeightContraint!.constant)))
      }

      cell.carNameLabel.text("Car name - [\(cellData.model.title)]")
      cell.carDistanceLabel.text("Distance: [\("Need to calc")]km")
      cell.carPlaneNumberLabel.text("Number Plates - [\(cellData.plateNumber)]")
      cell.carRemainingBattery.text("Battery [\(cellData.batteryPercentage)]%")

      return cell
    })

    var snapshot = DataSourceSnapshot()
    snapshot.appendSections([Section.main])
    snapshot.appendItems(self.rentalCars)
    dataSource.apply(snapshot, animatingDifferences: true)
  }

  func reloadData() {
    var snapshot = DataSourceSnapshot()
    snapshot.appendSections([Section.main])
    snapshot.appendItems(rentalCars)
    dataSource.apply(snapshot, animatingDifferences: true)
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
              self.reloadData()
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

extension CarRentViewController: UICollectionViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == v.collectionView && showingSortView {
      sortButtonPressed()
    }
  }

  fileprivate enum Section {
    case main
  }
}

//MARK: - Button actions

extension CarRentViewController {

  @objc func sortButtonPressed(sender: UIBarButtonItem? = nil){

    showingSortView = showingSortView ? false : true
    navigationItem.rightBarButtonItem?.isEnabled = false

    print("Sort button pressed: ", showingSortView ? "showing view" : "closing view")

    let animationDuration = 0.5

    if showingSortView {
      v.collectionView.setContentOffset(v.collectionView.contentOffset, animated: false)

      view.subviews{
        carFilterTopBar
      }

      carFilterTopBar.Bottom == self.view.safeAreaLayoutGuide.Top
      carFilterTopBar.Left == self.view.safeAreaLayoutGuide.Left
      carFilterTopBar.Right == self.view.safeAreaLayoutGuide.Right
      carFilterTopBar.Height == 100

      self.view.layoutIfNeeded()

      UIView.animate(withDuration: animationDuration) {
        self.carFilterTopBar.bottomConstraint?.isActive = false
        self.carFilterTopBar.Top == self.view.safeAreaLayoutGuide.Top

        self.view.layoutIfNeeded()
      } completion: { _ in
        self.navigationItem.rightBarButtonItem?.isEnabled = true
      }


    }else{

      UIView.animate(withDuration: animationDuration/2) {
        self.carFilterTopBar.topConstraint?.isActive = false
        self.carFilterTopBar.Bottom == self.view.safeAreaLayoutGuide.Top

        self.view.layoutIfNeeded()
      } completion: { _ in
        self.carFilterTopBar.removeFromSuperview()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
      }
    }
  }

  @objc func sortSelectionButtonPressed(sender: UIButton){
    print("Sort selection button Pressed")
    var validActionRequest = false

    switch sender.tag {
    case ButtonSortType.distance.rawValue:
      print("Distance!")
      validActionRequest = true

      // TODO: implment!
//      rentalCars.sort { (a: RentalCar, b: RentalCar) -> Bool in
//        a.plateNumber.lowercased() < b.plateNumber.lowercased()
//      }

    case ButtonSortType.numberPlates.rawValue:
      print("NumberPlates!")
      validActionRequest = true

      sender.isSelected = true

      rentalCars.sort { (a: RentalCar, b: RentalCar) -> Bool in
        a.plateNumber.lowercased() < b.plateNumber.lowercased()
      }

    case ButtonSortType.battery.rawValue:
      print("Battery!")
      validActionRequest = true

      rentalCars.sort { (a: RentalCar, b: RentalCar) -> Bool in
        a.batteryPercentage > b.batteryPercentage
      }

    default:
      print("Unkown")
    }

    if validActionRequest {

      // TODO: weird reload behaviour!
      sortButtonPressed()
      reloadData()
      v.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

  @objc func filterTopBarSwipedUp(sender: UITapGestureRecognizer){
    print("Gesture Found!")
    sortButtonPressed()
  }

}
