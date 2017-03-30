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
  func didTapLeaveButton(team: Team)
  func didJoin(team: Team)
}

class PlayersListTableViewController: UITableViewController {
  var event: Event? = nil
  var sportType: SportType? = nil
  var teams: [TeamResponse] = []
  var eventMembers: [EventMember] = []

  var teamUsers: [User] {
    return teams.map { $0.users }.reduce([], +)
  }

  var freeMembers: [EventMember] {
    let teamMembers = self.teamUsers
    return eventMembers.filter { eventMember in
      return teamMembers.first(where: { $0.id == eventMember.user.id} ) == nil
    }
  }

  var delegate: PlayersListTableViewControllerDelegate? = nil

  override func viewDidLoad() {

  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    var teamsCount = teams.count
    if freeMembers.isEmpty { teamsCount += 1 }
    return teamsCount
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case teams.count where !freeMembers.isEmpty:
      return freeMembers.count
    default:
      guard !teams.isEmpty else { return 0 }
      return teams[section].users.count + 1
    }
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let event = event else { return nil }
    let view = TeamSectionHeaderView.nibInstance()
    if section == teamUsers.count {
      view?.configure(headerType: .otherPlayers)
    } else {
      view?.configure(headerType: .team(teamCount: section + 1, teamPlayers: event.teamLimit, playersCount: event.userCount))
    }
    return view
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch indexPath.section {
    case teams.count where !freeMembers.isEmpty:
      let playerCell = tableView.dequeueReusableCell(withIdentifier: playerCellReuseIdentifier, for: indexPath) as! PlayerTableViewCell
      playerCell.configure(player: freeMembers[indexPath.row].user)
      cell = playerCell
    default:
      let teamResponse = teams[indexPath.section]
      let users = teamResponse.users
      if indexPath.row == users.count {
        let joinTeamCell = tableView.dequeueReusableCell(withIdentifier: joinTeamCellReuseIdentifier, for: indexPath)
        joinTeamCell.textLabel?.text = "Занять место в команде \(indexPath.section + 1)"
        cell = joinTeamCell
      } else {
        let player = users[indexPath.row]
        let playerCell = tableView.dequeueReusableCell(withIdentifier: playerCellReuseIdentifier, for: indexPath) as! PlayerTableViewCell
        playerCell.configure(player: player)
        playerCell.leaveButtonDidTapHandler = { _ in
          self.delegate?.didTapLeaveButton(team: teamResponse.team)
        }
        cell = playerCell
      }
    }
    return cell
  }

}
