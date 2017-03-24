//
//  UISearchBar+serTextColor.swift
//  SportUp
//
//  Created by Алексей on 24.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit


extension UISearchBar {

  func setTextColor(color: UIColor) {
    for subview in self.subviews {
      for secondLevelSubview in subview.subviews {
        guard secondLevelSubview.isKind(of: UITextField.self) else { continue }
        guard let searchBarTextField = secondLevelSubview as? UITextField else { continue }

        let placeholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSForegroundColorAttributeName: color])

        searchBarTextField.attributedPlaceholder = placeholder
        searchBarTextField.textColor = color

        break
      }
    }
  }
  
}
