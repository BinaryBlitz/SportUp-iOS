//
//  ProfileViewController.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, DefaultBarStyleViewController {
  override func viewDidLoad() {
    tabBarItem.title = "Профиль"
    tabBarItem.image = #imageLiteral(resourceName: "iconTabProfile")
  }
}
