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
    get {
      return self.layer.cornerRadius
    }
    set {
      self.layer.cornerRadius = newValue
    }
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

  @IBInspectable var shadow: Bool {
    get {
      return layer.shadowOpacity > 0.0
    }
    set {
      if newValue {
        addShadow()
      }
    }
  }

  func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                 shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                 shadowOpacity: Float = 0.2,
                 shadowRadius: CGFloat = 3.0) {
    layer.shadowColor = shadowColor
    layer.shadowOffset = shadowOffset
    layer.shadowOpacity = shadowOpacity
    layer.shadowRadius = shadowRadius
  }

}

@IBDesignable class RotatingUIView: UIView {

  @IBInspectable var angle: Double = M_PI_4

  override func awakeFromNib() {
    super.awakeFromNib()
    self.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
  }
}
