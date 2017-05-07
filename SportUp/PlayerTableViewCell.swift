//
//  PlayerTableViewCell.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class PlayerTableViewCell: UITableViewCell {
  var player: User!
  @IBOutlet var yellowCardIconView: UIImageView!
  @IBOutlet var yellowCardCountLabel: UILabel!
  @IBOutlet var leaveButton: UIButton!
  @IBOutlet var avatarOuterView: UIView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var playerTypeLabel: UILabel!
  @IBOutlet var labelsStackView: UIStackView!

  let avatarView = AvatarView.nibInstance()!
  
  var leaveButtonDidTapHandler: (() -> Void)? = nil

  override func awakeFromNib() {
    super.awakeFromNib()
    avatarOuterView.addSubview(avatarView)
  }

  func configure(player: User, isFreePlayersSection: Bool = false) {
    for view in labelsStackView.arrangedSubviews {
      labelsStackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
    leaveButton.isEnabled = true
    self.player = player
    nameLabel.text = "\(player.firstName) \(player.lastName)"
    avatarView.configure(user: player)
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
    leaveButtonDidTapHandler?()
  }

  override func prepareForReuse() {

  }

}
