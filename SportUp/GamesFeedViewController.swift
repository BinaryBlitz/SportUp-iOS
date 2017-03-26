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
  @IBOutlet weak var calendarHeaderView: CalendarHeaderView!
  @IBOutlet weak var headerView: UIView!
  
  override func viewDidLoad() {
    navigationItem.title = sportType.name
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    calendarHeaderView.refresh()
    headerView.backgroundColor = sportType.color
    calendarHeaderView.selectedDayTextColor = sportType.color
    calendarHeaderView.selectDateHandler = { self.updateNavigationTitle($0) }
    updateNavigationTitle()
  }

  func updateNavigationTitle(_ date: Date = Date()) {
    let label = UILabel()
    label.numberOfLines = 2
    label.textColor = UIColor.white.lighter(percentage: 0.8)
    label.textAlignment = .center
    let attributedString = NSMutableAttributedString()
    attributedString.append(NSAttributedString(string: sportType.name + "\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor.white]))
    if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day) {
      attributedString.append(NSAttributedString(string: "Сегодня, ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]))
    }
    attributedString.append(NSAttributedString(string: date.shortDateWithoutYear, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]))
  }

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.barTintColor = sportType.color
  }
}
