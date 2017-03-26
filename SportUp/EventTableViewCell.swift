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
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var lockIconView: UIImageView!
  @IBOutlet weak var promoIconView: UIImageView!
  @IBOutlet weak var playersCountLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var adressLabel: UILabel!

  override func awakeFromNib() {
    for view in stackView.arrangedSubviews {
      stackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
  }

  func configure(event: Event) {
    nameLabel.text = event.name
    playersCountLabel.text = "\(event.userCount) / \(event.userLimit)"
    timeLabel.text = event.startsAt.time
    priceLabel.text = event.price == 0 ? event.price.currencyString : "Бесплатно"
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
