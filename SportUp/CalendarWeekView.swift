//
//  CalendarWeekView.swift
//  SportUp
//
//  Created by Алексей on 27.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

class CalendarWeekView: UIStackView {
  // MARK: Properties
  var panGestureRecognizer: UIPanGestureRecognizer!
  var delegate: CalendarDayDelegate? = nil
  var dayViews: [CalendarDayView] {
    return self.arrangedSubviews as! [CalendarDayView]
  }

  internal var dates: [Date?] = [] {
    didSet {
      dayViews.isEmpty ? addDayViews() : updateDayViews()
    }
  }

  internal var containsToday: Bool {
    return dates.contains(where: { possibleDate in
      guard let date = possibleDate else { return false }
      return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    })
  }

  // MARK: Initializers

  required init(coder: NSCoder) {

    super.init(coder: coder)
  }

  init() {

    super.init(frame: CGRect.zero)
    self.axis = .horizontal
    self.distribution = .fillEqually
  }
}

// MARK: - Day Views

extension CalendarWeekView {

  func addDayViews() {
    for date in self.dates {
      let dayView = CalendarDayView()
      dayView.date = date
      dayView.delegate = delegate
      addArrangedSubview(dayView)
    }
  }

  fileprivate func updateDayViews() {
    for (index, date) in dates.enumerated() {
      dayViews[index].date = date
    }
  }
}

// MARK: - Pan Gesture Recognizer

extension CalendarWeekView {

  internal func addPanGestureRecognizer(target: Any?, action: Selector?) {
    panGestureRecognizer = UIPanGestureRecognizer(target: target, action: action)
    addGestureRecognizer(panGestureRecognizer)
  }
}

// MARK: - Selected Date

extension CalendarWeekView {

  func setSelectedDate(currentSelectedDate: Date  ) {
    let calendar = Calendar.current
    let dateComponents: DateComponents
    if containsToday {
      dateComponents = calendar.dateComponents([.weekday], from: Date())
      highlight(index: getDayIndex(dateComponents.weekday!))
    }
    else {
      highlight(index: getDayIndex())
    }

  }

  func getDayIndex(_ weekday: Int! = Calendar.current.firstWeekday) -> Int {
    let calendar = Calendar.current
    let numberOfWeekdays = calendar.maximumRange(of: .weekday)!.count
    let firstWeekday = calendar.firstWeekday

    if weekday - firstWeekday < 0 {
      return numberOfWeekdays - weekday
    } else {
      return weekday - firstWeekday
    }
  }

  internal func highlight(index: Int) {
    self.dayViews[index].highlight()
  }
}

