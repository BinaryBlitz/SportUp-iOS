//
//  GamesFeedViewController.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

class GamesFeedViewController: UIViewController {
  var sportType: SportType!

  override func viewDidLoad() {
    navigationItem.title = sportType.name
  }

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.barTintColor = sportType.color
  }
}
