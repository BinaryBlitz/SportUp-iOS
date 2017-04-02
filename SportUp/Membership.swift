//
//  Membership.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import ObjectMapper

struct EventMembership: Mappable {
  var event: Event!
  var membership: Membership!

  init(map: Map) { }

  mutating func mapping(map: Map) {
    event <- map["event"]
    membership <- map["membership"]
  }
}

class Membership: Mappable {
  var id: Int = 0
  var user: User? = nil
  var eventId: Int = 0
  var userId: Int = 0
  var teamNumber: Int? = nil
  var event: Event? = nil

  func mapping(map: Map) {
    id <- map["id"]
    user <- map["user"]
    eventId <- map["event_id"]
    userId <- map["user_id"]
    teamNumber <- map["team_number"]
  }

  required init(map: Map) { }

}
