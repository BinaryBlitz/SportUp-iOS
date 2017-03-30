//
//  Date+formatted.swift
//  SportUp
//
//  Created by Алексей on 26.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation

extension DateFormatter {

  convenience init(dateStyle: DateFormatter.Style) {
    self.init()
    self.dateStyle = dateStyle
  }
  
}

extension Date {

  struct Formatter {
    static let shortDate = DateFormatter(dateStyle: .short)
    static let longDate = DateFormatter(dateStyle: .full)
    static let mediumDate = DateFormatter(dateStyle: .medium)

  }

  var shortDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.YYYY"
    return formatter.string(from: self)
  }

  var longDate: String {
    return Formatter.longDate.string(from: self)
  }

  var mediumDate: String {
    return Formatter.mediumDate.string(from: self)
  }

  var shortDateWithoutYear: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM"
    return formatter.string(from: self)
  }

  var time: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: self)
  }
}
