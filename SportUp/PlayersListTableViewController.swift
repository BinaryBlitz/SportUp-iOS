//
//  PlayersListTableViewController.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

private let playerCellReuseIdentifier = "PlayerTableViewCell"
private let joinTeamCellReuseIdentifier = "JoinTeamTableViewCell"
private let headerReuseIdentifier = "TeamSectionHeaderView"

protocol PlayersListTableViewControllerDelegate: class {
  func didTapLeaveButton(teamIndex: Int)
  func didJoin(teamIndex: Int)
}

class PlayersListTableViewController: UITableViewController {
  var sportType: SportType? = nil
  var event: Event? = nil {
    didSet {
      guard let event = event else { return }
      _ = DataManager.instance.fetchMemberships(eventId: event.id).then { [weak self] members in
        self?.eventMembers = members
      }
    }
  }
  var eventMembers: [Membership] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  var freeMembers: [Membership] {
    return eventMembers.filter { $0.teamNumber == nil }
  }

  func membersOfTeam(_ teamNumber: Int) -> [Membership] {
    return eventMembers.filter { $0.teamNumber == teamNumber }
  }

  var teamsCount: Int {
    return event?.teamLimit ?? 0
  }

  var delegate: PlayersListTableViewControllerDelegate? = nil

  override func viewDidLoad() {

  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    var sectionsCount = teamsCount
    if !freeMembers.isEmpty { sectionsCount += 1 }
    return sectionsCount
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case teamsCount where !freeMembers.isEmpty:
      return freeMembers.count
    default:
      return membersOfTeam(section).count + 1
    }
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let event = event else { return nil }
    let view = TeamSectionHeaderView.nibInstance()
    if section == teamsCount {
      view?.configure(headerType: .otherPlayers)
    } else {
      view?.configure(headerType: .team(teamCount: section + 1, teamPlayers: event.teamLimit, playersCount: event.userCount))
    }
    return view
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch indexPath.section {
    case teamsCount where !freeMembers.isEmpty:
      guard let user = freeMembers[indexPath.row].user else { return UITableViewCell() }
      let playerCell = tableView.dequeueReusableCell(withIdentifier: playerCellReuseIdentifier, for: indexPath) as! PlayerTableViewCell
      playerCell.configure(player: user)
      cell = playerCell
    default:
      let users = membersOfTeam(indexPath.section)
      if indexPath.row == users.count {
        let joinTeamCell = tableView.dequeueReusableCell(withIdentifier: joinTeamCellReuseIdentifier, for: indexPath)
        joinTeamCell.textLabel?.text = "Занять место в команде \(indexPath.section + 1)"
        cell = joinTeamCell
      } else {
        guard let player = users[indexPath.row].user else { return UITableViewCell() }
        let playerCell = tableView.dequeueReusableCell(withIdentifier: playerCellReuseIdentifier, for: indexPath) as! PlayerTableViewCell
        playerCell.configure(player: player)
        playerCell.leaveButtonDidTapHandler = { _ in
          self.delegate?.didTapLeaveButton(teamIndex: indexPath.section)
        }
        cell = playerCell
      }
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard indexPath.section < teamsCount else { return }
    let players = membersOfTeam(indexPath.section)
    guard indexPath.row == players.count else { return }
    delegate?.didJoin(teamIndex: indexPath.section)
  }

}
