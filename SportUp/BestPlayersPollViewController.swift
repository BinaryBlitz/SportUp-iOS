//
//  BestPlayersPollViewController.swift
//  SportUp
//
//  Created by Алексей on 29.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "BestPlayersPollTableViewCell"

class BestPlayersPollViewController: UIViewController {
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBAction func sendRatingButtonDidTap(_ sender: GoButton) {
    sender.isEnabled = false
    _ = DataManager.instance.createReport(eventId: event.id, reports: reports.map { $0.value }).then { [weak self] _ in
      self?.dismiss(animated: true, completion: nil)
    }
  }

  lazy var pollHeaderView = BestPlayersPollHeaderView.nibInstance()!
  lazy var resultsHeaderView = BestPlayersResultsHeaderView.nibInstance()!
  lazy var reportsHeaderVIew = ReportsHeaderView.nibInstance()!

  enum ScreenType {
    case poll
    case results
    case reports
  }

  var screenType: ScreenType = .poll

  var currentBestPlayer: User? = nil
  var event: Event!
  var sportType: SportType!
  var eventMembers: [Membership] = []
  var reports: [Int: Report] = [:]

  var users: [User] {
    var users: [User] = []
    eventMembers.forEach { member in
      guard let user = member.user else { return }
      users.append(user)
    }
    return users.sorted { $0.votesCount > $1.votesCount }
  }

  override func viewDidLoad() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCanselWhite"), style: .plain, target: self, action: #selector(self.cancelButtonDidTap))
    configureHeaderView()
    configureFooterView()

    _ = DataManager.instance.fetchMemberships(eventId: event.id).then { [weak self] response -> Void in
      self?.eventMembers = response
      self?.tableView.reloadData()
    }
  }

  func configureHeaderView() {
    var headerContentView: UIView

    switch screenType {
    case .poll:
      pollHeaderView.configureTimeLabels(event: event)
      headerContentView = pollHeaderView
    case .results:
      resultsHeaderView.configure(sportType: sportType, event: event)
      headerContentView = resultsHeaderView
    case .reports:
      headerContentView = reportsHeaderVIew
    }
    headerView.addSubview(headerContentView)
    headerContentView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
    headerContentView.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
    headerContentView.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
    headerContentView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
  }

  func configureFooterView() {
    guard screenType != .reports else { return }
    tableView.tableFooterView = nil
  }

  func cancelButtonDidTap() {
    guard let currentBestPlayer = self.currentBestPlayer, screenType == .poll else {
      dismiss(animated: true, completion: nil)
      return
    }
    _ = DataManager.instance.vote(eventId: event.id, userId: currentBestPlayer.id).always { [weak self] in
      self?.dismiss(animated: true, completion: nil)
    }
  }
}

extension BestPlayersPollViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user = users[indexPath.row]
    let isBestPlayer = users.sorted { $0.votesCount > $1.votesCount }.first?.id == user.id
    let isReported = reports[user.id]?.violation == true
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BestPlayersPollTableViewCell
    cell.delegate = self
    cell.configure(user: user, screenType: screenType, isBestPlayer: isBestPlayer, isReportedViolation: isReported)
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
}

extension BestPlayersPollViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 46
  }

  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return screenType == .poll
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch screenType {
    case .poll:
      currentBestPlayer = users[indexPath.row]
    case .reports:
      let viewController = ReportAlertViewController.storyboardInstance()!
      viewController.modalPresentationStyle = .overCurrentContext
      viewController.player = users[indexPath.row]
      viewController.delegate = self
      present(viewController, animated: true, completion: nil)
    default:
      break
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UITableViewHeaderFooterView()
    view.textLabel?.textColor = UIColor.sportUpDarkGrey
    view.backgroundColor = UIColor.clear
    switch screenType {
    case .poll:
      view.textLabel?.text = "Выбрать лучшего игрока"
    case .results:
      view.textLabel?.text = "Рейтинг игроков"
    case .reports:
      view.textLabel?.text = "Список игроков"
    }

    return view
  }


  
}

extension BestPlayersPollViewController: ReportAlertViewControllerDelegate {
  func didCreateReport(player: User, reportContent: String) {
    let report = reports[player.id] ?? Report()
    report.reportedUserId = player.id
    report.content = reportContent
    reports[player.id] = report
    tableView.reloadData()
  }
}

extension BestPlayersPollViewController: BestPlayersPollTableViewCellDelegate {
  func didTapViolationButton(user: User) {
    let report = reports[user.id] ?? Report()
    report.reportedUserId = user.id
    report.violation = !report.violation
    reports[user.id] = report
    tableView.reloadData()
  }
}
