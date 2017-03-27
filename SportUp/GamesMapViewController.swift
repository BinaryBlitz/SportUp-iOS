//
//  GamesMapViewController.swift
//  SportUp
//
//  Created by Алексей on 26.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class GamesMapViewController: UIViewController {
  let animationDuration = 0.3
  var panGestureStartLocation: CGFloat = 0
  let markerZoom: Float = 15
  var events: [Event] = []
  var date: Date = Date()
  var sportType: SportType!

  @IBOutlet weak var lockIconView: UIImageView!
  @IBOutlet weak var promoIconView: UIImageView!
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var eventNameLabel: UILabel!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var playersCountLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var adressLabel: UILabel!
  @IBOutlet weak var bottomCardConstraint: NSLayoutConstraint!
  @IBOutlet weak var cardHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var eventCardView: UIView!

  override func viewDidLoad() {
    configureMap()
  }

  func configureMap() {
    let latitude = events.first?.latitude ?? ProfileManager.instance.currentCity?.latitude
    let longitude = events.first?.longitude ?? ProfileManager.instance.currentCity?.longitude
    mapView.delegate = self
    mapView.camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: markerZoom)

    let markerView = EventMarkerView.nibInstance()
    markerView?.configure(iconURL: sportType.iconUrl, backgroundColor: sportType.color)
    events.enumerated().forEach { index, event in
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
      marker.iconView = markerView

      marker.isDraggable = false
      marker.map = mapView
      marker.userData = index
    }
    
  }

  func prepareCardView(event: Event) {
    for view in stackView.arrangedSubviews {
      stackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
    eventNameLabel.text = event.name
    playersCountLabel.text = "\(event.userCount) / \(event.userLimit)"
    timeLabel.text = event.startsAt.time
    priceLabel.text = event.price == 0 ? event.price.currencyString : "Бесплатно"
    adressLabel.text = event.address
    if !event.isPublic {
      stackView.addArrangedSubview(lockIconView)
    }
    UIView.animate(withDuration: animationDuration) { [weak self] in
      guard let `self` = self else { return }
      self.bottomCardConstraint.constant = 0
      self.view.setNeedsLayout()
      self.view.layoutIfNeeded()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    bottomCardConstraint.constant = -cardHeightConstraint.constant
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = sportType.color
    self.tabBarController?.tabBar.isHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
    super.viewWillDisappear(animated)
  }

  @IBAction func hideCardButtonDidTap(_ sender: Any) {

    UIView.animate(withDuration: animationDuration) { [weak self] in
      guard let `self` = self else { return }
      self.bottomCardConstraint.constant = -self.cardHeightConstraint.constant
      self.view.setNeedsLayout()
      self.view.layoutIfNeeded()
    }
  }

  @IBAction func cardViewDidDrag(_ pan: UIPanGestureRecognizer) {
    let panLocation = pan.translation(in: view).y

    switch pan.state {
    case .changed:
      bottomCardConstraint.constant = min(-panLocation, 0)
      view.setNeedsLayout()
      view.layoutIfNeeded()
    case .ended:
      if panLocation > cardHeightConstraint.constant || pan.velocity(in: view).y > 200 {
        UIView.animate(withDuration: 0.25) { [weak self] in
          guard let `self` = self else { return }
          self.bottomCardConstraint.constant = 0
          self.view.setNeedsLayout()
          self.view.layoutIfNeeded()
        }
      } else {
        UIView.animate(withDuration: 0.25) {
          UIView.animate(withDuration: 0.25) { [weak self] in
            guard let `self` = self else { return }
            self.bottomCardConstraint.constant = -self.cardHeightConstraint.constant
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
          }
        }
      }

    default:
      break
    }
  }

  @IBAction func navigationButtonDidTap(_ sender: Any) {
    mapView.isMyLocationEnabled = true
  }

}

extension GamesMapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    guard let index = marker.userData as? Int else { return false }
    prepareCardView(event: events[index])
    return true
  }
}
