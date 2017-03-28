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


  var tableViewController: PlayersListTableViewController!
  
  @IBOutlet weak var gameStatusLabel: UILabel!
  @IBOutlet weak var bestPlayerNameLabel: UILabel!
  @IBOutlet weak var headerView: UIView!

  override func viewDidLoad() {
    configureNavigationTitle()

  }

  func configureNavigationTitle() {
    let title = sportType.name
    let subtitle = "\(event.userCount)/\(event.userLimit)"
    let label = NavigationSubtitleLabel(height: navigationController?.navigationBar.frame.size.height, title: title, subtitle: subtitle)
    navigationItem.titleView = label
    headerView.backgroundColor = sportType.color
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

  }
  
  func didJoin(team: Team) {
    
  }
}
