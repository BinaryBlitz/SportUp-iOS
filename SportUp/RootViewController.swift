//
//  RootViewController.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: SportUpNavigationController {
  private(set) static var instance: RootViewController? = nil

  override func loadView() {
    RootViewController.instance = self
    let viewController = OnboardingViewController.storyboardInstance()!
    viewControllers = [viewController]
    super.loadView()
  }
    
}
