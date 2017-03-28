//
//  EventInfoTableViewController.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

private let markerZoom: Float = 18

class EventInfoTableViewController: UITableViewController {
  // MARK: - Data
  var event: Event!
  var sportType: SportType!

  // MARK: - Sections
  enum Sections: Int {
    case mainInfo = 0
    case decription
    case share
  }

  enum MainInfoRow: Int {
    case map = 0
    case playersCount
  }

  // MARK: - UI
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var adressLabel: UILabel!
  @IBOutlet weak var playersCountLabel: UILabel!
  @IBOutlet weak var teamsCountLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  override func viewDidLoad() {
    configureLabels()
    configureMap()
  }

  func configureLabels() {
    adressLabel.text = event.address
    playersCountLabel.text = "\(event.userCount) / \(event.teamLimit)"
    let teamLimitText = event.teamLimit.getRussianNumEnding(endings: ["команда", "команды", "команд"])
    teamsCountLabel.text = "(\(teamLimitText))"
    descriptionLabel.text = event.description
  }

  func configureMap() {
    mapView.delegate = self
    mapView.camera = GMSCameraPosition.camera(withLatitude: event.latitude, longitude: event.longitude, zoom: markerZoom)

    let markerView = EventMarkerView.nibInstance()
    markerView?.configure(iconURL: sportType.iconUrl, backgroundColor: sportType.color)
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
    marker.iconView = markerView
    marker.map = mapView
  }

  // MARK: - Table view

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case Sections.decription.rawValue:
      return UITableViewAutomaticDimension
    default:
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case Sections.decription.rawValue:
      return 223
    default:
      return 50
    }
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard section != Sections.mainInfo.rawValue else { return 0 }
    return 16
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case Sections.mainInfo.rawValue:
      guard indexPath.row == MainInfoRow.playersCount.rawValue else { return }
      return
    case Sections.share.rawValue:
      return
    default:
      break
    }
  }

  @IBAction func requestInviteButtonDidTap(_ sender: GoButton) {
  }

}

extension EventInfoTableViewController: GMSMapViewDelegate {

}