//
//  CitySelectViewController.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

private let reuseIdentifier = "CitySelectTableViewCell"

class CitySelectViewController: UIViewController, DefaultBarStyleViewController {
  // Search
  var searchController = UISearchController(searchResultsController: nil)

  // Data
  var cities: [City] = []
  var filteredCities: [City] = []
  var currentLocation: CLLocationCoordinate2D? = nil

  // UI
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var didNotFindCityButton: GoButton!

  // Location Manager
  let locationManager = CLLocationManager()

  @IBAction func didNotFindCityButtonDidTap(_ sender: Any) {
    
  }

  override func viewDidLoad() {
    tableView.delegate = self
    tableView.dataSource = self

    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconLocationpointBlack"), style: .plain, target: self, action: #selector(self.locationButtonDidTap))

    configureLocationManager()
    configureSearch()

    _ = DataManager.instance.fetchCities().then { [weak self] cities -> Void in
      self?.cities = cities
      self?.refresh()
    }
  }

  func locationButtonDidTap() {
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }

  func configureLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    locationManager.startUpdatingLocation()
  }

  func configureSearch() {
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
    searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    let searchBar = searchController.searchBar

    searchBar.barTintColor = UIColor.sportupBlueyGrey
    searchBar.layer.borderWidth = 1
    searchBar.layer.borderColor = UIColor.white.cgColor
    searchBar.tintColor = UIColor.black
    searchBar.backgroundColor = UIColor.white
    searchBar.backgroundImage = UIImage()
    searchBar.setSearchFieldBackgroundImage(#imageLiteral(resourceName: "searchBar"), for: .normal)
    searchBar.setImage(#imageLiteral(resourceName: "iconSearchsmollGray"), for: .search, state: .normal)
    searchBar.setTextColor(color: UIColor.sportupBlueyGrey)
    searchBar.searchTextPositionAdjustment = UIOffsetMake(5.0, 0.0)
  }

  func refresh(searchText: String? = nil) {
    var filteredCities = self.cities
    if let searchString = searchText, searchString.characters.count > 0 {
      filteredCities = filteredCities
        .filter { $0.name.lowercased().range(of: searchString.lowercased()) != nil }
    }
    filteredCities.sort { $0.distanceTo(currentLocation) < $1.distanceTo(currentLocation) }
    self.filteredCities = filteredCities
    tableView.reloadData()
  }

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(false, animated: true)
    guard let indexPath = tableView.indexPathForSelectedRow else { return }
    tableView.deselectRow(at: indexPath, animated: true)
  }

}

extension CitySelectViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    ProfileManager.instance.currentCity = filteredCities[indexPath.row]
    RootViewController.instance?.prepareTabBarController()
  }
}

extension CitySelectViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredCities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    cell.textLabel?.text = filteredCities[indexPath.row].name
    if currentLocation != nil && indexPath.row == 0 {
      cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "iconLocationsmollGray"))
    } else {
      cell.accessoryView = nil
    }
    return cell
  }
}

extension CitySelectViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    currentLocation = locations.first?.coordinate
    locationManager.stopUpdatingLocation()
    refresh()
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      locationManager.startUpdatingLocation()
    }
  }
}

extension CitySelectViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    refresh(searchText: searchController.searchBar.text)
  }


}
