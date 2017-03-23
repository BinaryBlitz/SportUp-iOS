//
//  UIView+cornerRadius.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    return layer.cornerRadius
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
      return UIColor(cgColor: layer.borderColor!)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }

}

@IBDesignable class RotatingUIView: UIView {

  @IBInspectable var angle: Double = M_PI_4

  override func awakeFromNib() {
    super.awakeFromNib()
    self.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
  }
}