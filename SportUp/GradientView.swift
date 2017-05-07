//
//  UIView+addGradient.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GradientView: UIView {
  private let gradient : CAGradientLayer = CAGradientLayer()

  @IBInspectable var reverse: Bool = false
  @IBInspectable var topColor: UIColor = UIColor.clear
  @IBInspectable var bottomColor: UIColor = UIColor.white

  override func awakeFromNib() {
    gradient.frame.size = self.frame.size
    gradient.colors = [topColor.cgColor, bottomColor.cgColor]
    if reverse { gradient.colors?.reverse() }
    self.layer.insertSublayer(gradient, at: 0)
  }

  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    gradient.frame = self.bounds
  }
}
