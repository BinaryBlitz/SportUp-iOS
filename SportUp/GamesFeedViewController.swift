//
//  GamesFeedViewController.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "EventTableViewCell"

class GamesFeedViewController: UIViewController {
  var currentDate: Date = Date() {
    didSet {
      updateNavigationTitle()
      updateData()
    }
  }
  var sportType: SportType!
  var events: [Event] = []
  @IBOutlet weak var calendarHeaderView: CalendarHeaderView!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavMapWhite"), style: .plain, target: self, action: #selector(self.mapButtonDidTap))
    calendarHeaderView.isHidden = true
    tableView.dataSource = self
    tableView.delegate = self
    updateData()
    configureCalendar()
    updateNavigationTitle()
  }

  func updateData() {
    let date = currentDate
    _ = DataManager.instance.fetchEvents(sportType: sportType, date: currentDate).then { [weak self] events -> Void in
      guard let `self` = self, date.isInSameDayOf(date: self.currentDate) else { return }
      self.events = events.sorted { $0.startsAt < $1.startsAt }
      self.tableView.reloadData()
    }
  }

  func mapButtonDidTap() {
    let viewController = GamesMapViewController.storyboardInstance()!
    viewController.events = events
    viewController.sportType = sportType
    viewController.date = currentDate
    navigationController?.pushViewController(viewController, animated: true)
  }

  func configureCalendar() {
    headerView.backgroundColor = sportType.color
    calendarHeaderView.selectedDayTextColor = sportType.color
    calendarHeaderView.selectDateHandler = { [weak self] date in
      self?.currentDate = date
    }
  }

  func updateNavigationTitle() {
    var subtitle = ""
    if Calendar.current.isDate(currentDate, equalTo: Date(), toGranularity: .day) {
      subtitle += "Сегодня, "
    }
    subtitle += currentDate.shortDateWithoutYear
    let label = NavigationSubtitleLabel(height: navigationController?.navigationBar.frame.size.height, title: sportType.name, subtitle: subtitle)
    navigationItem.titleView = label
  }

  override func viewWillAppear(_ animated: Bool) {
    calendarHeaderView.isHidden = false
    super.viewWillAppear(animated)
    updateData()
    navigationController?.navigationBar.barTintColor = sportType.color
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    calendarHeaderView.isHidden = true
    super.viewWillDisappear(animated)
  }
}

extension GamesFeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventTableViewCell
    cell.configure(event: events[indexPath.row], sportType: sportType)
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.count
  }
}

extension GamesFeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard ProfileManager.instance.isAuthorized else {
      let viewController = UINavigationController(rootViewController: RegistrationPhoneInputViewController.storyboardInstance()!)
      return present(viewController, animated: true, completion: nil)
    }
    let event = events[indexPath.row]
    let viewController = EventInfoViewController.storyboardInstance()!
    viewController.event = event
    viewController.sportType = sportType
    if event.isPublic || event.membership != nil {
      navigationController?.pushViewController(viewController, animated: true)
    } else {
      tableView.deselectRow(at: indexPath, animated: true)
      let passwordAlertController = PasswordAlertViewController.storyboardInstance()!
      passwordAlertController.event = event
      passwordAlertController.modalPresentationStyle = .overCurrentContext
      passwordAlertController.didEnterPasswordHandler = { [weak self] in
        self?.navigationController?.pushViewController(viewController, animated: true)
      }
      tabBarController?.present(passwordAlertController, animated: false, completion: nil)
    }
  }
}
