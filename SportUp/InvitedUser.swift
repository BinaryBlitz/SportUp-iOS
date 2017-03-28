//
//  EventMember.swift
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
