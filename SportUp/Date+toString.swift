//
//  Date+formatted.swift
//  SportUp
//
//  Created by Алексей on 26.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation

extension Date {

  var shortDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.YYYY"
    return formatter.string(from: self)
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
