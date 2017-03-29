//
//  PlayersListViewController.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class PlayersListViewController: UIViewController {
  var event: Event!
  var sportType: SportType!
  var eventMembers: [EventMember] = [] {
    didSet {
      tableViewController.eventMembers = eventMembers
    }
  }

  var teams: [TeamResponse] = [] {
    didSet {
      tableViewController.teams = teams
    }
  }

  var tableViewController: PlayersListTableViewController!
  
  @IBOutlet weak var gameStatusLabel: UILabel!
  @IBOutlet weak var bestPlayerNameLabel: UILabel!
  @IBOutlet weak var headerView: UIView!

  override func viewDidLoad() {
    headerView.backgroundColor = sportType.color
    configureNavigationTitle()
  }

  func updateData() {
    _ = DataManager.instance.fetchTeams(eventId: event.id).then { [weak self] teamResponse -> Void in
      self?.teams = teamResponse
    }

    _ = DataManager.instance.fetchMemberships(eventId: event.id).then { [weak self] members in
      self?.eventMembers = members

    }

    _ = DataManager.instance.fetchEvent(eventId: event.id).then { [weak self] event -> Void in
      self?.event = event
      self?.configureNavigationTitle()
    }


  }

  func configureNavigationTitle() {
    let title = sportType.name
    let subtitle = "\(event.userCount)/\(event.userLimit)"
    let label = NavigationSubtitleLabel(height: navigationController?.navigationBar.frame.size.height, title: title, subtitle: subtitle)
    navigationItem.titleView = label
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "containerViewSegue" else { return }
    guard let viewController = segue.destination as? PlayersListTableViewController else { return }
    tableViewController = viewController
    tableViewController.delegate = self
    viewController.event = event
    viewController.sportType = sportType
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = sportType.color
  }
}

extension PlayersListViewController: PlayersListTableViewControllerDelegate {
  
  func didTapLeaveButton(team: Team) {
    _ = DataManager.instance.leaveTeam(teamId: team.id).then { [weak self] in
      self?.updateData()
    }

  }
  
  func didJoin(team: Team) {
    _ = DataManager.instance.joinTeam(teamId: team.id).then { [weak self] in
      self?.updateData()
    }
  }
}
