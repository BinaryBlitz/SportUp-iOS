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
  var dateRequestNumber = 0
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
    headerView.isHidden = true
    tableView.dataSource = self
    updateData()
    configureCalendar()
    updateNavigationTitle()
  }

  func updateData() {
    self.dateRequestNumber += 1
    let dateRequestNumber = self.dateRequestNumber
    _ = DataManager.instance.fetchEvents(sportType: sportType, date: currentDate).then { [weak self] events -> Void in
      guard let `self` = self, dateRequestNumber == self.dateRequestNumber else { return }
      self.events = events
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
    let attributedString = NSMutableAttributedString()
    attributedString.append(NSAttributedString(string: sportType.name + "\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor.white]))
    if Calendar.current.isDate(currentDate, equalTo: Date(), toGranularity: .day) {
      attributedString.append(NSAttributedString(string: "Сегодня, ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11)]))
    }
    attributedString.append(NSAttributedString(string: currentDate.shortDateWithoutYear, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11)]))

    let size = attributedString.size()

    let width = size.width
    guard let height = navigationController?.navigationBar.frame.size.height else { return }
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
    titleLabel.numberOfLines = 0
    titleLabel.textColor = UIColor.sportupLightWhite
    titleLabel.textAlignment = .center
    titleLabel.attributedText = attributedString
    navigationItem.titleView = titleLabel
  }

  override func viewWillAppear(_ animated: Bool) {
    headerView.isHidden = false
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = sportType.color
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    headerView.isHidden = true
    super.viewWillDisappear(animated)
  }
}

extension GamesFeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventTableViewCell
    cell.configure(event: events[indexPath.row])
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.count
  }
}
