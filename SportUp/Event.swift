//
//  Event.swift
//  SportUp
//
//  Created by Алексей on 26.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftDate

class Event: Mappable {
  var id: Int = 0
  var name: String = ""
  var description: String = ""
  var creator: User? = nil
  var sportType: SportType? = nil
  var startsAt: Date = Date()
  var endsAt: Date = Date()
  var address: String = ""
  var userLimit: Int = 0
  var teamLimit: Int = 0
  var isPublic: Bool = true
  var price: Double = 0
  var userCount: Int = 0
  var latitude: Double = 0
  var longitude: Double = 0
  var password: String = ""
  var membership: Membership? = nil

  var isMine: Bool {
    return creator?.id == ProfileManager.instance.currentProfile?.id
  }

  var started: Bool {
    return startsAt < Date()
  }

  var finished: Bool {
    return startsAt < Date() && startsAt < Date()
  }

  func mapping(map: Map) {
    id <- map["id"]
    startsAt <- (map["starts_at"], DateTransform())
    description <- map["description"]
    address <- map["address"]
    userLimit <- map["user_limit"]
    teamLimit <- map["team_limit"]
    name <- map["name"]
    price <- map["price"]
    isPublic <- map["public"]
    latitude <- map["latitude"]
    longitude <- map["longitude"]
    password <- map["password"]
    sportType?.id >>> map["sport_type_id"]
    if map.mappingType == .toJSON {
      endsAt.time >>> map["ends_at"]
    } else {
      var date = Date()
      date <- (map["ends_at"], DateTransform())
      let endsAtComponents = Calendar.current.dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: date)
      endsAt = startsAt.atTime(hour: endsAtComponents.hour ?? 0, minute: endsAtComponents.minute ?? 0, second: 0) ?? Date()
      userCount <- map["user_count"]
      membership <- map["membership"]
      membership?.event = self
      creator <- map["creator"]
      sportType <- map["sport_type"]

    }
  }

  init() { }

  required init(map: Map) { }

}
