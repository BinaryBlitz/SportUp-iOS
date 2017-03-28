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
  var description: String = ""
  var endsAt: Date = Date()
  var address: String = ""
  var userLimit: Int = 0
  var teamLimit: Int = 0
  var isPublic: Bool = true
  var price: Double = 0
  var userCount: Int = 0
  var latitude: Double = 0
  var longitude: Double = 0
  var membership: Membership? = nil


  func mapping(map: Map) {
    id <- map["id"]
    startsAt <- (map["starts_at"], DateTransform())
    description <- map["description"]
    endsAt <- (map["ends_at"], DateTransform())
    address <- map["adress"]
    userLimit <- map["user_limit"]
    teamLimit <- map["team_limit"]
    name <- map["name"]
    price <- map["price"]
    isPublic <- map["public"]
    userCount <- map["user_count"]
    latitude <- map["latitude"]
    longitude <- map["longitude"]
    membership <- map["membership"]
  }

  required init(map: Map) { }

}
