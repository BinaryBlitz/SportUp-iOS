//
//  BestPlayersPollTableViewCell.swift
//  SportUp
//
//  Created by Алексей on 29.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import AvatarImageView

class BestPlayersPollTableViewCell: UITableViewCell {
  @IBOutlet weak var avatarView: AvatarImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var checkmarkButton: UIButton!

  var user: User? = nil

  func configure(user: User) {
    self.user = user
    nameLabel.text = user.firstName + " " + user.lastName
  }

  override func awakeFromNib() {
    avatarView.dataSource = self
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: true)
    checkmarkButton.isSelected = selected
    nameLabel.textColor = selected ? UIColor.sportupGunmetal : UIColor.sportupBlueyGreyTwo
  }

}

extension BestPlayersPollTableViewCell: AvatarImageViewDataSource {
  var name: String {
    return user?.firstName ?? ""
  }
}
