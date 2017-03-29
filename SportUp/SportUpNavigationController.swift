//
//  SportUpNavigationController.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

protocol DefaultBarStyleViewController { }

class SportUpNavigationController: UINavigationController, UINavigationControllerDelegate {

  let defaultBarTintColor = UIColor.white

  override func loadView() {
    super.loadView()
    delegate = self
    navigationBar.isTranslucent = false
    view.backgroundColor = UIColor.white
    navigationBar.barStyle = .default
    navigationBar.tintColor = .black
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.backgroundColor = defaultBarTintColor
    navigationBar.barTintColor = defaultBarTintColor
    navigationBar.titleTextAttributes =
      [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
  }

  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController, animated: Bool) {
    if viewController is DefaultBarStyleViewController {
      navigationBar.barTintColor = defaultBarTintColor
      navigationBar.tintColor = .black
      navigationBar.isTranslucent = false
    } else {
      navigationBar.tintColor = defaultBarTintColor
    }
    updateStatusbar()
  }

  func updateStatusbar() {
    let statusbarStyle: UIStatusBarStyle
    if let visibleViewController = self.visibleViewController {
      if visibleViewController is DefaultBarStyleViewController {
        statusbarStyle = .default
      } else {
        statusbarStyle = .lightContent
      }
    } else {
      statusbarStyle = .default
    }
    UIApplication.shared.statusBarStyle = statusbarStyle
  }
  
}
