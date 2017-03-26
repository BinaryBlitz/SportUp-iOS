//
//  Event.swift
//  SportUp
//
//  Created by Алексей on 26.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import ObjectMapper

class Event: Mappable {
  var id: Int = 0
  var name: String = ""
  var startsAt: Date = Date()
  var endsAt: String = ""
  var address: String = ""
  var userLimit: Int = 0
  var teamLimit: Int = 0
  var isPublic: Bool = true
  var price: Double = 0
  
  func mapping(map: Map) {
    id <- map["id"]
    startsAt <- (map["starts_at"], DateTransform())
    endsAt <- map["ends_at"]
    address <- map["adress"]
    userLimit <- map["user_limit"]
    teamLimit <- map["team_limit"]
    name <- map["name"]
    price <- map["price"]
    isPublic <- map["public"]
  }

  required init(map: Map) { }

}
