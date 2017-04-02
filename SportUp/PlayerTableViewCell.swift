//
//  PlayerTableViewCell.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import AvatarImageView

class PlayerTableViewCell: UITableViewCell {
  var player: User!
  @IBOutlet var yellowCardIconView: UIImageView!
  @IBOutlet var yellowCardCountLabel: UILabel!
  @IBOutlet var leaveButton: UIButton!
  @IBOutlet var avatarView: AvatarImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var playerTypeLabel: UILabel!
  @IBOutlet var labelsStackView: UIStackView!
  
  var leaveButtonDidTapHandler: (() -> Void)? = nil

  func configure(player: User, isFreePlayersSection: Bool = false) {
    for view in labelsStackView.arrangedSubviews {
      labelsStackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
    leaveButton.isEnabled = true
    self.player = player
    nameLabel.text = "\(player.firstName) \(player.lastName)"
    avatarView.dataSource = self
    if player.violationsCount > 0 {
      labelsStackView.addArrangedSubview(yellowCardIconView)
      yellowCardCountLabel.text = "\(player.violationsCount)"
      labelsStackView.addArrangedSubview(yellowCardCountLabel)
    }
    if ProfileManager.instance.currentProfile?.id == player.id && !isFreePlayersSection {
      labelsStackView.addArrangedSubview(leaveButton)
    }
  }

  @IBAction func leaveButtonDidTap(_ sender: Any) {
    leaveButton.isEnabled = false
  }

  override func prepareForReuse() {

  }

}

extension PlayerTableViewCell: AvatarImageViewDataSource {
  var name: String {
    return player.firstName
  }
}
