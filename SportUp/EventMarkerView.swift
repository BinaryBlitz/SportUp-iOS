//
//  EventMarkerView.swift
//  SportUp
//
//  Created by Алексей on 27.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import UIKit
import Kingfisher

class EventMarkerView: UIView {
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var gameIconView: UIImageView!

  func configure(iconURL: URL?, backgroundColor: UIColor, imageColor: UIColor = .white) {
    let backgroundImage = #imageLiteral(resourceName: "markerIcon").withRenderingMode(.alwaysTemplate)
    backgroundImageView.image = backgroundImage
    backgroundImageView.tintColor = backgroundColor

    gameIconView.tintColor = UIColor.white
    gameIconView.kf.setImage(with: iconURL) { [weak self] image, _, _, _ in
      guard let image = image?.withRenderingMode(.alwaysTemplate) else { return }
      self?.gameIconView.image = image
      self?.gameIconView.tintColor = UIColor.white
    }
  }

}
