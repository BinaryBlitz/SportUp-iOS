//
//  Membership.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import ObjectMapper

struct EventMember: Mappable {
  var user: User!
  var membership: Membership!

  init(map: Map) {
  }

  mutating func mapping(map: Map) {
    user <- map["user"]
    membership <- map["membership"]
  }
}

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
  var eventId: Int = 0
  var userId: Int = 0
  var event: Event? = nil

  func mapping(map: Map) {
    id <- map["id"]
    eventId <- map["event_id"]
    userId <- map["user_id"]
  }

  required init(map: Map) { }

}
