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
import RxCoreLocation
import RxCocoa
import RxSwift

fileprivate typealias RentalCarDataSource = UICollectionViewDiffableDataSource<CarRentViewController.Section, RentalCar>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<CarRentViewController.Section, RentalCar>

class CarRentViewController: UIViewController {

  let manager = CLLocationManager()
  let bag = DisposeBag()

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

    // Setuping location manager
    manager.requestAlwaysAuthorization()

//    manager.rx
//      .didChangeAuthorization
//      .subscribe { _, status in
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways :
//          print("OK")
//          self.currentLocation = self.getCurrentLocation()
//        default:
//          break
//        }
//      }.disposed(by: bag)

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
        print("Network error: ", validError)
      }else if let validResults = result {
        self.rentalCars = validResults
        self.reloadData()
      }
    }
  }

  func getCurrentLocation() -> CLLocation? {

    manager.requestAlwaysAuthorization()
    var currentLocation: CLLocation? = nil

    if manager.authorizationStatus == .denied {
      print("Denied auth, show alert to enable in settings!")
    }else{
      manager.startUpdatingLocation()

      manager.rx
        .location
        .subscribe { location in
//          print(location.)
          print("Loc: [\(String(describing: location?.coordinate))]")
          if let loc = location {
            currentLocation = loc
            self.manager.stopUpdatingLocation()
            self.setRentalCarDistances(toLocation: loc)
            self.reloadData()
          }
        } onError: { error in
          print("Show alert! Error found: ", error.localizedDescription)
        }.disposed(by: bag)

    }

    return currentLocation
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
    print("Sort selection button Pressed")
    var validActionRequest = false

    switch sender.tag {
    case ButtonSortType.distance.rawValue:
      print("Distance!")
      validActionRequest = true

      if currentLocation == nil {
        currentLocation = getCurrentLocation()
      }

      if currentLocation != nil {
//        print("lat : long - [\(location.coordinate.latitude) : \(location.coordinate.longitude)]")

        rentalCars.sort { (a: RentalCar, b: RentalCar) -> Bool in
          a.location.distance ?? 0 < b.location.distance ?? 0
        }
      }else{
        print("No location found! and alert with error enum!")
      }

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
