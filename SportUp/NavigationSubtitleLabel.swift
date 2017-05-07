//
//  MultiLineLabel.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit


class NavigationSubtitleLabel: UILabel {
  
  init?(height: CGFloat? = 0, title: String, subtitle: String) {
    let attributedString = NSMutableAttributedString()
    attributedString.append(NSAttributedString(string: title + "\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor.white]))

    attributedString.append(NSAttributedString(string: subtitle, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11)]))

    let size = attributedString.size()

    let width = size.width
    guard let height = height else { return nil }

    super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
    numberOfLines = 0
    textColor = UIColor.sportUpLightWhite
    textAlignment = .center
    attributedText = attributedString

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
