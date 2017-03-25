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
    setNeedsStatusBarAppearanceUpdate()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    guard let visibleViewController = self.visibleViewController else { return .default }
    if visibleViewController is DefaultBarStyleViewController {
      return .default
    }
    return .lightContent
  }
  
}
