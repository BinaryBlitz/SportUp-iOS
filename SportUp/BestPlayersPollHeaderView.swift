//
//  BestPlayersPollHeaderView.swift
//  SportUp
//
//  Created by Алексей on 29.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class BestPlayersPollHeaderView: UIView {
  @IBOutlet weak var timeStartHoursLabel: UILabel!
  @IBOutlet weak var timeStartMinuteLabel: UILabel!
  @IBOutlet weak var timeFinishesHoursLabel: UILabel!
  @IBOutlet weak var timeFinishesMinutesLabel: UILabel!
  @IBOutlet weak var coutdownLabel: UILabel!

  func configureTimeLabels(event: Event) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H"
    timeStartHoursLabel.text = dateFormatter.string(from: event.startsAt)
    timeFinishesHoursLabel.text = dateFormatter.string(from: event.endsAt)
    dateFormatter.dateFormat = "mm"
    timeStartMinuteLabel.text = dateFormatter.string(from: event.startsAt)
    timeFinishesMinutesLabel.text = dateFormatter.string(from: event.endsAt)
    let interval = event.startsAt.timeIntervalSinceNow.formattedInterval ?? ""
    coutdownLabel.text = "До завершения голосования " + interval

  }
  
}
