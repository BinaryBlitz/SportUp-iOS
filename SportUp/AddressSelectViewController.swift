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
  let resultsViewController = GMSAutocompleteResultsViewController()
  let marker = GMSMarker()
  var addressString: String = "" {
    didSet {
      navigationItem.title = addressString
    }
  }
  let sportType: SportType? = nil
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var searchView: UIView!

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
    guard let city = ProfileManager.instance.currentCity else { return }
    mapView.camera = GMSCameraPosition.camera(withLatitude: city.latitude, longitude: city.longitude, zoom: cityZoom)

    let markerView = EventMarkerView()
    markerView.configure(iconURL: sportType?.iconUrl, backgroundColor: sportType?.color ?? defaultColor)
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
    searchBar.setSearchFieldBackgroundImage(#imageLiteral(resourceName: "searchBar"), for: .normal)
    searchBar.setImage(#imageLiteral(resourceName: "iconSearchsmollGray"), for: .search, state: .normal)
    searchBar.setTextColor(color: UIColor.white)
    searchBar.searchTextPositionAdjustment = UIOffsetMake(5.0, 0.0)

    searchBar.sizeToFit()
    searchView.addSubview(searchBar)
  }

  func updateMarker(coordinate: CLLocationCoordinate2D) {
    searchController?.isActive = false
    marker.position = coordinate
    let cameraUpdate = GMSCameraUpdate.setTarget(coordinate, zoom: markerZoom)
    mapView.animate(with: cameraUpdate)

    ReverseGeocoder.getAdress(coordinate: coordinate).then { [weak self] address -> Void in
      guard let number = address?.streetNumber else { return }
      guard let streetName = address?.streetName else { return }

      self?.addressString = "\(streetName), \(number)"
    }
  }
}

extension AddressSelectViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    updateMarker(coordinate: place.coordinate)
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
    updateMarker(coordinate: coordinate)

  }
}
