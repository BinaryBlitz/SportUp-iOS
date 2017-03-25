//
//  RootViewController.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
  private(set) static var instance: RootViewController? = nil

  let mainTabBarController = MainTabBarController.storyboardInstance()!
  let onboardingviewController = OnboardingViewController.storyboardInstance()!
  let onboardingNavigationController = SportUpNavigationController()

  var currentViewController: UIViewController? = nil {
    didSet {
      oldValue?.removeFromParentViewController()
      oldValue?.view.removeFromSuperview()

      guard let currentViewController = currentViewController else { return }
      self.addChildViewController(currentViewController)
      currentViewController.view.frame = self.view.frame
      self.view.addSubview(currentViewController.view)
      currentViewController.didMove(toParentViewController: self)
    }
  }

  override func viewDidLoad() {
    onboardingNavigationController.viewControllers = [onboardingviewController]

    if ProfileManager.instance.currentCity == nil {
      prepareOnboarding()
    } else {
      prepareTabBarController()
    }
  }

  func prepareOnboarding() {
    currentViewController = onboardingNavigationController
  }

  func prepareTabBarController() {
    currentViewController = mainTabBarController
  }

  override func loadView() {
    RootViewController.instance = self
    super.loadView()
  }
    
}
