//
//  SportTypeTableViewCell.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class SportTypeTableViewCell: UITableViewCell {
  @IBOutlet weak var categoryIconView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  func configure(sportType: SportType) {
    categoryIconView.kf.setImage(with: sportType.iconUrl) { [weak self] image, _, _, _ in
      guard let image = image?.withRenderingMode(.alwaysTemplate) else { return }
      self?.categoryIconView.image = image
      self?.categoryIconView.tintColor = sportType.color
    }
    titleLabel.text = sportType.name
    descriptionLabel.text = sportType.eventsCount.getRussianNumEnding(endings: ["игра", "игры", "игр"])
  }

  override func prepareForReuse() {
    categoryIconView.kf.cancelDownloadTask()
  }
}
