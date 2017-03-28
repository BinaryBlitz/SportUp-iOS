//
//  Membership.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import ObjectMapper

class Membership: Mappable {
  var id: Int = 0
  var eventId: Int = 0
  var createdAt: Date = Date()

  func mapping(map: Map) {
    id <- map["id"]
    eventId <- map["event_id"]
    createdAt <- (map["name"], DateTransform())
  }

  required init(map: Map) { }

}
