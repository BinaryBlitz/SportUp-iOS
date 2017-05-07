//
//  ProfileEarnTicketsTableViewCell.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class ProfileEarnTicketsTableViewCell: UITableViewCell {
  @IBOutlet weak var ticketsCountLabel: UILabel!
  @IBOutlet weak var actionTypeImageView: UIImageView!
  @IBOutlet weak var actionTypeLabel: UILabel!

  func configure(action: TestActions) {
    ticketsCountLabel.text = "\(action.ticketsCount)"
    actionTypeImageView.image = action.icon
    actionTypeLabel.text = action.name
  }
}
