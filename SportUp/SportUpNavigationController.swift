//
//  SportUpNavigationController.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit


class SportUpNavigationController: UINavigationController, UINavigationControllerDelegate {

  let defaultBarTintColor = UIColor.white

  override func loadView() {
    super.loadView()
    delegate = self
    navigationBar.isTranslucent = false
    view.backgroundColor = UIColor.white
    navigationBar.barStyle = .black
    navigationBar.tintColor = .white
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.backgroundColor = defaultBarTintColor
    navigationBar.barTintColor = defaultBarTintColor
  }
  
}
