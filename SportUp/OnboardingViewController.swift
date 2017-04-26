//
//  OnBoardingViewController.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController, DefaultBarStyleViewController {
  @IBOutlet weak var beginButton: GoButton!
  let animationDuration = 0.3

  @IBAction func beginButtonDidTap(_ sender: Any) {
    let addressViewController = AddressSelectViewController.storyboardInstance()!
    addressViewController.title = "Выбор адреса"
    addressViewController.shouldMarkUserAddress = true
    addressViewController.selectAddressHandler = { _ in
      ProfileManager.instance.currentCoordinate = addressViewController.coordinate
      RootViewController.instance?.prepareTabBarController()
    }
    navigationController?.pushViewController(addressViewController, animated: true)
  }

  override func viewDidLoad() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    beginButton.alpha = 0
    beginButton.isHidden = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard beginButton.isHidden else { return }
    beginButton.isHidden = false
    UIView.animate(withDuration: animationDuration) { [weak self] in
      self?.beginButton.alpha = 1
    }
  }

}
