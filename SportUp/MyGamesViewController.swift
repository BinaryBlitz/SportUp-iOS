//
//  MyGamesViewController.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

class MyGamesViewController: UITableViewController, DefaultBarStyleViewController {
  override func viewDidLoad() {
    tabBarItem.title = "Мои игры"
    tabBarItem.image = #imageLiteral(resourceName: "iconTabMygames")
  }
}
