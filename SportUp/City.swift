//
//  City.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class City: Mappable {
  var id: Int = 0
  var name: String = ""
  var latitude: Double = 0.0
  var longitude: Double = 0.0

  func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    latitude <- map["latitude"]
    longitude <- map["latitude"]
  }

  required init(map: Map) { }

  func distanceTo(_ point: CLLocationCoordinate2D?) -> Double {
    guard let point = point else { return 0 }
    return pow(latitude - point.latitude, 2) + pow(longitude - point.longitude, 2)
  }
  
}
