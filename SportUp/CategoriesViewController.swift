//
//  CategoriesViewController.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

class CategoriesViewController: UITableViewController, DefaultBarStyleViewController {
  override func viewDidLoad() {
    tabBarItem.title = "Поиск игр"
    tabBarItem.image = #imageLiteral(resourceName: "iconTabSearchgames")
  }
}
