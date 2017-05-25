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

  @IBOutlet weak var timeStartHoursLabel: UILabel!

  @IBOutlet weak var timeStartMinuteLabel: UILabel!
  @IBOutlet weak var timeFinishesHoursLabel: UILabel!
  @IBOutlet weak var timeFinishesMinutesLabel: UILabel!
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
    configureTimeLabels()
    priceLabel.text = event.price == 0 ? "Бесплатно" : event.price.currencyString
    backgroundHeaderView.backgroundColor = sportType.color

    let label = NavigationSubtitleLabel(height: navigationController?.navigationBar.frame.size.height, title: event.name, subtitle: "# \(event.id)")
    navigationItem.titleView = label

    tableViewController.event = event
    tableViewController.sportType = sportType
    tableViewController.refresh()
  }

  func configureTimeLabels() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H"
    timeStartHoursLabel.text = dateFormatter.string(from: event.startsAt)
    timeFinishesHoursLabel.text = dateFormatter.string(from: event.endsAt)
    dateFormatter.dateFormat = "mm"
    timeStartMinuteLabel.text = dateFormatter.string(from: event.startsAt)
    timeFinishesMinutesLabel.text = dateFormatter.string(from: event.endsAt)
    let interval = event.startsAt.timeIntervalSinceNow.formattedInterval ?? ""
    coutdownLabel.text = "До начала: " + interval

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = sportType.color
  }

  func chatButtonDidTap() {
    let viewController = MessagesViewController()
    navigationController?.pushViewController(viewController, animated: true)
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
  func membershipButtonDidTap(_ button: UIButton) {
    button.isEnabled = true
    if let membership = event.membership {
      _ = DataManager.instance.deleteMembership(membershipId: membership.id).then { [weak self] _ -> Void in
        self?.updateData()
        button.isEnabled = false
      }

    } else {
      let priceController = EventPriceAlertViewController.storyboardInstance()!
      priceController.modalPresentationStyle = .overCurrentContext
      priceController.nextButtonDidTapHandler = { [weak self] in
        guard let event = self?.event else { return }
        _ = DataManager.instance.createMembership(eventId: event.id).then { [weak self] eventMember -> Void in
          self?.updateData()
        }
      }
      tabBarController?.present(priceController, animated: false, completion: nil)
      button.isEnabled = true
    }

  }

  func pushPlayersListController() {
    let viewController = PlayersListViewController.storyboardInstance()!
    viewController.event = event
    viewController.sportType = sportType
    navigationController?.pushViewController(viewController, animated: true)
  }
}
