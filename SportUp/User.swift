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
  var phoneNumber: String = ""

  var eventMemberships: [Membership] = []

  func mapping(map: Map) {
    id <- map["id"]
    firstName <- map["first_name"]
    lastName <- map["last_name"]
    phoneNumber <- map["phone_number"]
  }

  required init(map: Map) { }

}
