//
//  TimeInterval+toString.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation

extension TimeInterval {
  var formattedInterval: String? {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.month, .day, .hour, .minute, .weekday]
    formatter.unitsStyle = .abbreviated

    return formatter.string(from: self)
  }
}
