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
  var invitedUsers: [EventMember] = []
  var teams: [Team] = []

  var delegate: PlayersListTableViewControllerDelegate? = nil

  override func viewDidLoad() {

  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    let teamsCount = event?.teamLimit ?? 0
    return teamsCount
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let event = event else { return nil }
    let view = TeamSectionHeaderView.nibInstance()
    if section > event.teamLimit {
      view?.configure(headerType: .otherPlayers)
    } else {
      view?.configure(headerType: .team(teamCount: section, teamPlayers: event.teamLimit, playersCount: event.userCount))
    }
    return view
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: playerCellReuseIdentifier, for: indexPath) as! PlayerTableViewCell
    cell.leaveButtonDidTapHandler = { _ in
    }
    return cell
  }

}
