//
//  BestPlayersResultsHeaderView.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

class BestPlayersResultsHeaderView: UIView {
  
  @IBOutlet weak var sportTypeLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!

  func configure(sportType: SportType, event: Event) {
    sportTypeLabel.text = sportType.name
    backgroundColor = sportType.color
    dateLabel.text = event.startsAt.mediumDate
  }
}
