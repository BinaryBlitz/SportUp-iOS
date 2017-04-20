//
//  AddressSelectViewController.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

private let markerZoom: Float = 17
private let cityZoom: Float = 10

class AddressSelectViewController: UIViewController {
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var searchView: UIView!

  let resultsViewController = GMSAutocompleteResultsViewController()
  let locationManager = CLLocationManager()

  let marker = GMSMarker()
  var coordinate: CLLocationCoordinate2D? = nil {
    didSet {
      guard let coordinate = coordinate else { return }
      searchController?.isActive = false
      marker.position = coordinate
      let cameraUpdate = GMSCameraUpdate.setTarget(coordinate, zoom: markerZoom)
      mapView.animate(with: cameraUpdate)

      _ = ReverseGeocoder.getAdress(coordinate: coordinate).then { [weak self] address -> Void in
        guard let number = address?.streetNumber else { return }
        guard let streetName = address?.streetName else { return }

        self?.addressString = "\(streetName), \(number)"
      }
    }
  }

  var addressString: String = "" {
    didSet {
      searchController?.searchBar.text = addressString
    }
  }
  
  let sportType: SportType? = nil
  var selectAddressHandler: ((String) -> ())? = nil

  let defaultColor = UIColor.sportUpAquaMarine

  var searchController: UISearchController? = nil

  override func viewDidLoad() {
    view.backgroundColor = sportType?.color ?? defaultColor
    configureMap()
    configureSearch()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = sportType?.color ?? defaultColor
  }

  func configureMap() {
    mapView.delegate = self
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
    mapView.isMyLocationEnabled = true

    guard let city = ProfileManager.instance.currentCity else { return }
    mapView.camera = GMSCameraPosition.camera(withLatitude: city.latitude, longitude: city.longitude, zoom: cityZoom)

    let markerView = EventMarkerView.nibInstance()!
    markerView.configure(iconURL: sportType?.iconUrl, backgroundColor: sportType?.color ?? defaultColor)
    marker.iconView = markerView
    marker.isDraggable = true
    marker.map = mapView

  }

  func configureSearch() {
    definesPresentationContext = true
    resultsViewController.delegate = self
    searchController = UISearchController(searchResultsController: resultsViewController)
    searchController?.searchResultsUpdater = resultsViewController

    resultsViewController.extendedLayoutIncludesOpaqueBars = true
    searchController?.dimsBackgroundDuringPresentation = false
    resultsViewController.edgesForExtendedLayout = UIRectEdge([])

    guard let searchBar = searchController?.searchBar else { return }

    searchBar.barTintColor = sportType?.color ?? defaultColor
    searchBar.layer.borderColor = sportType?.color.cgColor ?? defaultColor.cgColor
    searchBar.barStyle = .black
    searchBar.tintColor = UIColor.white
    searchBar.backgroundColor = sportType?.color ?? UIColor.sportUpAquaMarine
    searchBar.backgroundImage = UIImage()
    searchBar.setSearchFieldBackgroundImage(#imageLiteral(resourceName: "whiteSearchBarBackground"), for: .normal)
    searchBar.setImage(#imageLiteral(resourceName: "iconSearchsmollWhite"), for: .search, state: .normal)
    searchBar.setTextColor(color: UIColor.white)
    searchBar.searchTextPositionAdjustment = UIOffsetMake(5.0, 0.0)

    searchBar.sizeToFit()
    searchView.addSubview(searchBar)
  }

  @IBAction func saveButtonDidTap(_ sender: Any) {
    selectAddressHandler?(addressString)
    _ = navigationController?.popViewController(animated: true)
  }

  @IBAction func myLocationButtonDidTap(_ sender: UIButton) {
    let status = CLLocationManager.authorizationStatus()
    if status == .denied {
      UIApplication.shared.open(URL(string: "prefs:root=LOCATION_SERVICES")!, options: [:], completionHandler: nil)
    } else {
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
      mapView.isMyLocationEnabled = true
    }
  }

}

extension AddressSelectViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    self.coordinate = place.coordinate
  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error) {
    let alertController = UIAlertController(title: NSLocalizedString("error", comment: "Error alert"), message: error.localizedDescription, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Error alert"), style: .default, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }


}

extension AddressSelectViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate

  }
}

extension AddressSelectViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let coordinate = locations.first?.coordinate else { return }
    mapView.animate(to: GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: markerZoom))
    locationManager.stopUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
    locationManager.startUpdatingLocation()
  }
}
