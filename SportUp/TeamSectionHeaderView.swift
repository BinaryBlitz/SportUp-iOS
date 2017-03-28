//
//  TeamSectionHeaderView.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class TeamSectionHeaderView: UITableViewHeaderFooterView {
  enum HeaderType {
    case team(teamCount: Int, teamPlayers: Int, playersCount: Int)
    case otherPlayers
  }

  @IBOutlet weak var teamCountLabel: UILabel!
  @IBOutlet weak var teamPlayersLabel: UILabel!

  func configure(headerType: HeaderType) {
    switch headerType {
    case .team(let teamCount, let teamPlayers, let playersCount):
      teamCountLabel.text = "Команда \(teamCount)"
      teamPlayersLabel.text = "\(playersCount)/\(teamPlayers) (\(teamPlayers - playersCount) из \(teamCount)"
    case .otherPlayers:
      teamCountLabel.text = "Неопределившиеся игроки"
      teamPlayersLabel.text = nil
    }
  }
}
