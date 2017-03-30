//
//  Report.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import ObjectMapper

class Report: Mappable {
  var content: String = ""
  var violation: Bool = false
  var reportedUserId: Int = 0

  required init(map: Map) {
  }

  init() { }

  func mapping(map: Map) {
    content <- map["content"]
    violation <- map["violation"]
    reportedUserId <- map["reported_user_id"]
  }
}
