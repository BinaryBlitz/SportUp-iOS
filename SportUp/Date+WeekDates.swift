//
//  Date+WeekDates.swift
//  SportUp
//
//  Created by Алексей on 27.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
extension Date {

  static func previousWeekDates(currentWeekDates: [Date?]) -> [Date?] {
    let startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeekDates[0]!)
    return weekDates(startDate: startDate!)
  }

  var currentWeekDates: [Date?] {
    return Date.currentWeekDates(date: self)
  }

  static func currentWeekDates(date: Date) -> [Date?] {
    var components = Calendar.current.dateComponents([.weekday, .weekOfYear, .year], from: date)

    components.weekday = Calendar.current.firstWeekday

    let startDate = Calendar.current.date(from: components)

    return self.weekDates(startDate: startDate!)
  }

  static func nextWeekDates(currentWeekDates: [Date?]) -> [Date?] {
    let startDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeekDates[0]!)
    return self.weekDates(startDate: startDate!)
  }

  static func weekDates(startDate: Date) -> [Date?] {
    let numberOfWeekdays = Calendar.current.maximumRange(of: .weekday)!.count
    var dates = [Date?](repeating: nil, count: numberOfWeekdays)
    var date = startDate

    for index in 0...numberOfWeekdays - 1 {
      dates[index] = date
      date = Calendar.current.date(byAdding: .weekday, value: 1, to: date)!
    }
    return dates
  }

}
