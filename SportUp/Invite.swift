//
//  Invite.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import ObjectMapper

class InviteResponse: Mappable {
  var invite: Invite? = nil
  var user: User? = nil
  var event: Event? = nil

  required init(map: Map) { }

  init() { }

  func mapping(map: Map) {
    invite <- map["invite"]
    user <- map["user"]
    event <- map["event"]
  }
}


class Invite: Mappable {
  var id: Int = 0
  var userId: Int = 0
  var eventId: Int = 0
  var accepted: Bool = false

  required init(map: Map) { }

  init() { }

  func mapping(map: Map) {
    id <- map["id"]
    accepted <- map["accepted"]
    userId <- map["user_id"]
    eventId <- map["event_id"]
  }
}
