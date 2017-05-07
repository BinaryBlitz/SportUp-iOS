//
//  ProfileBuyTicketsTableViewCell.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class ProfileBuyTicketsTableViewCell: UITableViewCell {
  @IBOutlet weak var ticketsCountLabel: UILabel!
  @IBOutlet weak var priceButton: GoButton!

  func configure(ticketsCount: Int, price: Double) {
    ticketsCountLabel.text = "\(ticketsCount)"
    priceButton.setTitle(price.currencyString, for: .normal)
  }
}
