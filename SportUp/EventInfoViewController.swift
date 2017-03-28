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

  var tableViewController: EventInfoTableViewController!

  @IBOutlet weak var backgroundHeaderView: UIView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var coutdownLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!

  override func viewDidLoad() {
    refresh()
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCommentWhite"), style: .plain, target: self, action: #selector(self.chatButtonDidTap))
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    updateData()
  }

  func updateData() {
    _ = DataManager.instance.fetchEvent(eventId: event.id).then { [weak self] event -> Void in
      self?.event = event
      self?.refresh()
    }
  }

  func refresh() {
    timeLabel.text = "\(event.startsAt.time) - \(event.endsAt.time)"
    let interval = event.startsAt.timeIntervalSinceNow.formattedInterval ?? ""
    coutdownLabel.text = "До начала: " + interval
    priceLabel.text = event.price == 0 ? "Бесплатно" : event.price.currencyString
    backgroundHeaderView.backgroundColor = sportType.color

    let label = NavigationSubtitleLabel(height: navigationController?.navigationBar.frame.size.height, title: sportType.name, subtitle: "# \(event.id)")
    navigationItem.titleView = label

    tableViewController.refresh()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = sportType.color
  }

  func chatButtonDidTap() {

  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "containerViewSegue" else { return }
    guard let viewController = segue.destination as? EventInfoTableViewController else { return }
    tableViewController = viewController
    viewController.event = event
    viewController.sportType = sportType
    viewController.delegate = self
  }

}

extension EventInfoViewController: EventInfoViewControllerDelegate {
  func membershipButtonDidTap() {
    _ = DataManager.instance.createMembership(eventId: event.id).then { [weak self] eventMember -> Void in
      self?.updateData()
    }
  }

  func pushPlayersListController() {
    let viewController = PlayersListViewController.storyboardInstance()!
    viewController.event = event
    viewController.sportType = sportType
    navigationController?.pushViewController(viewController, animated: true)
  }
}
