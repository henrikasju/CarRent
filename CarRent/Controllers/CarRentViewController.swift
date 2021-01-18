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
import CoreLocation

fileprivate typealias RentalCarDataSource = UICollectionViewDiffableDataSource<CarRentViewController.Section, RentalCar>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<CarRentViewController.Section, RentalCar>

class CarRentViewController: UIViewController {

  var locationManager: CurrentDeviceLocationManager!

  var currentLocation: CLLocation?

  private let v = CarRentView()

  var rentalCars = [RentalCar]()
  private var dataSource: RentalCarDataSource!

  var showingSortView: Bool = false
  let carFilterTopBar = CarFilterTopBar()

  override func loadView() {
    view = v
  }

  override func viewWillAppear(_ animated: Bool) {

  }

  override func viewDidLoad() {
    super.viewDidLoad()

    locationManager = CurrentDeviceLocationManager(delegate: self)

    // Setuping location manager
    locationManager.requestAuthorization()

    fetchRentalCars()
    setupNavigationItems()
    setupViews()
    configureDataSource()
  }

  private func setupNavigationItems(){
    navigationItem.title = "Rental Cars"

    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(sortButtonPressed(sender:)))
  }

  private func setupViews(){
    v.collectionView.collectionViewLayout = createCompositionalLayout()
    v.collectionView.delegate = self
    v.collectionView.register(CarRentCollectionViewCell.self, forCellWithReuseIdentifier: CarRentCollectionViewCell.identifier)

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

      let cellImagePhotoURL = rentalCar.model.photoUrl
      let placeholder = UIImage(systemName: "car")

      if let url = URL(string: cellImagePhotoURL) {
        cell.carImageView.af.setImage(withURL: url, cacheKey: cellImagePhotoURL, placeholderImage: placeholder)
      }

      cell.carRentViewModel = CarRentCellViewModel(model: rentalCar)

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

  func fetchRentalCars() {
    RentalCarAPI.fetchAllRentalCars { (result: [RentalCar]?, error: Error?) in
      if let validError = error {
        Alert.showErrorAlert(on: self, title: "Network error", message: validError.localizedDescription, buttonTitle: "Close", buttonHandler: nil) {

        }
      }else if let validResults = result {
        self.rentalCars = validResults
        if self.locationManager.getAuthorizationStatus() != .denied {
          self.setCurrentLocation()
        }
        if self.currentLocation != nil {
          self.setRentalCarDistances(toLocation: self.currentLocation!)
        }

        self.reloadData()
      }
    }
  }

  func setCurrentLocation() {

    locationManager.getCurrentLocation { (error: LocationErrors?, location: CLLocation?) in
      if let validError = error {

        switch validError {
        case .locationDenied:
          let message = "Please allow app location tracking in settings."
          Alert.showErrorAlert(on: self, title: "Location Permissions", message: message, buttonTitle: "Understood", buttonHandler: nil) {

          }
        }

      }else if let validLocation = location {
        self.currentLocation = validLocation
        setRentalCarDistances(toLocation: validLocation)
      }
    }
  }

  func setRentalCarDistances(toLocation: CLLocation) {
    for index in 0..<rentalCars.count {
      rentalCars[index].location.distance = toLocation.distance(from: rentalCars[index].location.computedLocation)
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
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 10)

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

    let animationDuration = 0.5

    if showingSortView {
      v.collectionView.setContentOffset(v.collectionView.contentOffset, animated: false)

      view.subviews{
        carFilterTopBar
      }

      carFilterTopBar.Bottom == self.view.safeAreaLayoutGuide.Top
      carFilterTopBar.Left == self.view.safeAreaLayoutGuide.Left
      carFilterTopBar.Right == self.view.safeAreaLayoutGuide.Right
      carFilterTopBar.Height == 80

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
    var validActionRequest = false

    switch sender.tag {
    case ButtonSortType.distance.rawValue:
      validActionRequest = true

      // if location premissions were lifted
      if locationManager.getAuthorizationStatus() != .denied {
        setCurrentLocation()
        if currentLocation != nil {
          setRentalCarDistances(toLocation: currentLocation!)

          rentalCars.sort { (a: RentalCar, b: RentalCar) -> Bool in
            a.location.distance ?? 0 < b.location.distance ?? 0
          }
        }
      }else{
        let message = "Could not locate device."
        Alert.showErrorAlert(on: self, title: "Location issues", message: message, buttonTitle: "Close", buttonHandler: nil) {

        }

        validActionRequest = false
      }

    case ButtonSortType.numberPlates.rawValue:
      validActionRequest = true

      sender.isSelected = true

      rentalCars.sort { (a: RentalCar, b: RentalCar) -> Bool in
        a.plateNumber.lowercased() < b.plateNumber.lowercased()
      }

    case ButtonSortType.battery.rawValue:
      validActionRequest = true

      rentalCars.sort { (a: RentalCar, b: RentalCar) -> Bool in
        a.batteryPercentage > b.batteryPercentage
      }

    default:
      print("Unkown")
    }

    if validActionRequest {

      sortButtonPressed()
      reloadData()
      v.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

  @objc func filterTopBarSwipedUp(sender: UITapGestureRecognizer){
    sortButtonPressed()
  }

}

extension CarRentViewController: CurrentDeviceLocationManagerDelegate {
  func locationPermissionsDidChange(_ manager: CurrentDeviceLocationManager, authorizationStatus: CLAuthorizationStatus) {
    if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
      manager.getCurrentLocation { (error: LocationErrors?, location: CLLocation?) in
        if let validError = error {
          print(validError)
        }else if let validLocation = location {
          let firstLocation = currentLocation == nil
          self.currentLocation = validLocation
          setRentalCarDistances(toLocation: validLocation)

          if firstLocation {
            reloadData()
          }
        }
      }
    }
  }
}
