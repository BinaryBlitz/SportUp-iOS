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

  override func viewDidAppear(_ animated: Bool) {
    //guard profileManager.userProfile.value.city == nil else { return }

    //present(OnBoardingNavigationController.storyboardInstance()!, animated: true)
  }

  override func loadView() {
    RootViewController.instance = self
    super.loadView()
  }
    
}
