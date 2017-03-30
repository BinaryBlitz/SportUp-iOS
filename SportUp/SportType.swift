//
//  SportType.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import ObjectMapper

class SportType: Mappable {
  var id: Int = 0
  var color: UIColor = UIColor.sportUpAquaMarine
  var name: String = ""
  var eventsCount: Int = 0
  var iconUrl: URL? = nil

  func mapping(map: Map) {
    id <- map["id"]
    color <- (map["color"], HexColorTransform())
    name <- map["name"]
    eventsCount <- map["events_count"]
    iconUrl <- (map["icon_url"], URLTransform())
  }

  required init(map: Map) { }
  
}
