//
//  EventInfoViewController.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class EventInfoViewController: UIViewController {
  // MARK: - Data
  var event: Event!
  var sportType: SportType!

  @IBOutlet weak var backgroundHeaderView: UIView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var coutdownLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!

  override func viewDidLoad() {
    configureHeader()
    configureNavigation()
  }

  func configureHeader() {
    timeLabel.text = "\(event.startsAt.time) - \(event.endsAt.time)"
    let interval = event.startsAt.timeIntervalSinceNow.formattedInterval ?? ""
    coutdownLabel.text = "До начала: " + interval
    priceLabel.text = event.price == 0 ? "Бесплатно" : event.price.currencyString
    backgroundHeaderView.backgroundColor = sportType.color
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = sportType.color
  }

  func configureNavigation() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCommentWhite"), style: .plain, target: self, action: #selector(self.chatButtonDidTap))

    let label = NavigationSubtitleLabel(height: navigationController?.navigationBar.frame.size.height, title: sportType.name, subtitle: "# \(event.id)")
    navigationItem.titleView = label
  }

  func chatButtonDidTap() {

  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "containerViewSegue" else { return }
    guard let viewController = segue.destination as? EventInfoTableViewController else { return }
    viewController.event = event
    viewController.sportType = sportType
  }

}
