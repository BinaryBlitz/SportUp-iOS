//
//  EventTableViewCell.swift
//  SportUp
//
//  Created by Алексей on 26.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

class EventTableViewCell: UITableViewCell {
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var lockIconView: UIImageView!
  @IBOutlet var promoIconView: UIImageView!
  @IBOutlet var playersCountLabel: UILabel!
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var adressLabel: UILabel!

  override func awakeFromNib() {
    for view in stackView.arrangedSubviews {
      stackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
  }

  func configure(event: Event, sportType: SportType) {
    nameLabel.text = event.name
    playersCountLabel.text = "\(event.userCount) / \(event.userLimit)"
    timeLabel.text = event.startsAt.time
    priceLabel.text = event.price != 0 ? event.price.currencyString : "Бесплатно"
    if event.price == 0 {
      priceLabel.textColor = sportType.color
    }
    adressLabel.text = event.address
    if !event.isPublic {
      stackView.addArrangedSubview(lockIconView)
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    for view in stackView.arrangedSubviews {
      stackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
  }

}
