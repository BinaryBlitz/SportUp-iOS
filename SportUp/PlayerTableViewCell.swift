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
  @IBOutlet weak var yellowCardIconView: UIImageView!
  @IBOutlet weak var yellowCardCountLabel: UILabel!
  @IBOutlet weak var leaveButton: UIButton!
  @IBOutlet weak var avatarView: AvatarImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var playerTypeLabel: UILabel!

  var leaveButtonDidTapHandler: (() -> Void)? = nil

  func configure(player: User) {
    leaveButton.isEnabled = true
    self.player = player
    nameLabel.text = "\(player.firstName) \(player.lastName)"
    avatarView.dataSource = self
  }

  
  @IBAction func leaveButtonDidTap(_ sender: Any) {
    leaveButton.isEnabled = false
  }

}

extension PlayerTableViewCell: AvatarImageViewDataSource {
  var name: String {
    return player.firstName
  }
}
