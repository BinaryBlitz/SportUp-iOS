//
//  User.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class User: Mappable {
  var id: Int = 0
  var firstName: String = ""
  var lastName: String = ""
  var avatarUrl: URL? = nil
  var phoneNumber: String = ""
  var votesCount: Int = 0
  var violationsCount: Int = 0
  var eventMemberships: [Membership] = []

  var fullName: String {
    return firstName + " " + lastName
  }

  init() { }

  func mapping(map: Map) {
    id <- map["id"]
    firstName <- map["first_name"]
    lastName <- map["last_name"]
    phoneNumber <- map["phone_number"]
    avatarUrl <- (map["avatar_url"], URLTransform())
    votesCount <- map["votes_count"]
  }

  required init(map: Map) { }

}
