//
//  CalendarHeaderView.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import UIKit

class CalendarHeaderView: UIView {
  var selectDateHandler: ((Date) -> Void)? = nil
  var selectedDayTextColor: UIColor? = nil {
    didSet {
      guard let selectedDayTextColor = selectedDayTextColor else { return }
      selectedDayView?.button.setTitleColor(selectedDayTextColor, for: .normal)
    }
  }

  var currentSelectedDate = Date()
  var panGestureStartLocation: CGFloat!
  var weekViews: [CalendarWeekView] = []
  var selectedDayView: CalendarDayView? = nil

  var previousView: CalendarWeekView {
    return self.weekViews[0]
  }
  var currentView: CalendarWeekView {
    return self.weekViews[1]
  }
  var nextView: CalendarWeekView {
    return self.weekViews[2]
  }

  var headerView = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.resetLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }

  func configure() {
    addHeaderView()
    addWeekViews()
  }

  func addHeaderView() {
    self.headerView = UIStackView()
    self.headerView.axis = .horizontal
    self.headerView.distribution = .fillEqually

    let firstWeekday = Calendar.current.firstWeekday -  1

    let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols.enumerated()

    weekdaySymbols.filter { $0.offset >= firstWeekday }.forEach { addWeekdayLabel($0.element) }
    weekdaySymbols.filter { $0.offset < firstWeekday }.forEach { addWeekdayLabel($0.element) }

    headerView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(self.headerView)
    addHeaderViewConstraints()
  }

  func refresh() {
    headerView.removeFromSuperview()
    addHeaderView()
    weekViews.forEach({ $0.removeFromSuperview() })
    weekViews.removeAll()
    addWeekViews()
  }

  func addWeekdayLabel(_ weekdaySymbol: String) {
    let weekdayLabel = UILabel()
    weekdayLabel.text = weekdaySymbol
    weekdayLabel.textAlignment = .center
    weekdayLabel.font = UIFont.systemFont(ofSize: 14)
    weekdayLabel.textColor = UIColor.white
    self.headerView.addArrangedSubview(weekdayLabel)
  }

  func addHeaderViewConstraints() {
    headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    headerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    headerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    headerView.heightAnchor.constraint(equalToConstant: 15).isActive = true
  }

  func addWeekViews() {
    let currentWeekDates = currentSelectedDate.currentWeekDates
    let previousWeekDates = Date.previousWeekDates(currentWeekDates: currentWeekDates)
    let nextWeekDates = Date.nextWeekDates(currentWeekDates: currentWeekDates)

    for dates in [previousWeekDates, currentWeekDates, nextWeekDates] {
      let weekView = CalendarWeekView()
      weekView.delegate = self

      weekView.dates = dates
      weekView.translatesAutoresizingMaskIntoConstraints = false

      weekView.addPanGestureRecognizer(target: self, action: #selector(self.toggleCurrentView(_:)))

      addSubview(weekView)
      weekViews.append(weekView)

      weekView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
      weekView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
      weekView.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    resetLayout()
  }

  func toggleCurrentView(_ pan: UIPanGestureRecognizer) {

    switch pan.state {

    case .began:
      panGestureStartLocation = pan.location(in: self).x

    case .changed:
      let changeInX = pan.location(in: self).x - panGestureStartLocation

      previousView.center.x += changeInX
      currentView.center.x += changeInX
      nextView.center.x += changeInX
      panGestureStartLocation = pan.location(in: self).x
    case .ended:
      if currentView.center.x < (bounds.size.width * 0.5) - 25 {
        UIView.animate(withDuration: 0.25, animations: showNextView, completion: nextViewDidShow)
      }
      else if self.currentView.center.x > (bounds.size.width * 0.5) + 25 {
        UIView.animate(withDuration: 0.25, animations: showPreviousView, completion: previousViewDidShow)
      }
      else {
        UIView.animate(withDuration: 0.15, animations: { self.resetLayout() })
      }

    default:
      break
    }
  }

  func showPreviousView() {
    previousView.center.x = bounds.size.width * 0.5
    currentView.center.x = bounds.size.width * 1.5
  }

  func previousViewDidShow(_ finished: Bool) {
    if finished {
      let newDates = Date.previousWeekDates(currentWeekDates: previousView.dates)
      reuseNextWeekView(newDates: newDates)
      weekViewDidShow()
    }
  }

  func weekViewDidShow() {
    resetLayout()
    currentView.setSelectedDate(currentSelectedDate: currentSelectedDate)
  }

  func showNextView() {
    currentView.center.x = -bounds.size.width * 0.5
    nextView.center.x = bounds.size.width * 0.5
  }

  func nextViewDidShow(_ finished: Bool) {

    if finished {
      let newDates = Date.nextWeekDates(currentWeekDates: nextView.dates)
      reusePreviousWeekView(newDates: newDates)
      weekViewDidShow()
    }
  }

  func reuseNextWeekView(newDates: [Date?]) {
    nextView.dates = newDates
    weekViews.insert(nextView, at: 0)
    weekViews.removeLast()
  }

  func reusePreviousWeekView(newDates: [Date?]) {
    previousView.dates = newDates
    weekViews.append(previousView)
    weekViews.removeFirst()
  }

  func resetLayout() {
    previousView.center.x = -bounds.size.width * 0.5
    currentView.center.x = bounds.size.width * 0.5
    nextView.center.x = bounds.size.width * 1.5
  }

}

extension CalendarHeaderView: CalendarDayDelegate {
  func dayViewSelected(_ dayView: CalendarDayView) {
    selectedDayView?.unhighlight()
    currentSelectedDate = dayView.date!
    selectedDayView = dayView
    selectDateHandler?(currentSelectedDate)
  }

  func selectedDate() -> Date {
    return currentSelectedDate
  }
  
  func selectedTextColor() -> UIColor? {
    return selectedDayTextColor
  }
}
