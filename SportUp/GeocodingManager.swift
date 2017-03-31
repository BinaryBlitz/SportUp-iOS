//
//  GeocodingManager.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation
import Alamofire
import PromiseKit

class Address {
  let json: JSON
  let adressComponents: [JSON]?

  func getComponent(type: String) -> JSON? {
    return adressComponents?.first { (jsonComponent) -> Bool in
      return jsonComponent["types"]
        .arrayValue
        .map { $0.stringValue }
        .contains(type)
    }
  }

  var streetNumber: String? {
    guard let component = getComponent(type: "street_number") else { return nil }

    return component["long_name"].string
  }

  var streetName: String? {
    guard let component = getComponent(type: "route") else { return nil }

    return component["long_name"].string
  }

  var cityName: String? {
    guard let component = getComponent(type: "locality") else { return nil }

    return component["long_name"].string
  }

  init(json: JSON) {
    self.json = json
    self.adressComponents = json["results"].array?[0]["address_components"].array
  }
}

class ReverseGeocoder {

  static let apiKey = "AIzaSyB0YorJGoVc8pdcnUKbxvwhxLRMzdgKhCs"

  static func getAdress(coordinate: CLLocationCoordinate2D) -> Promise<Address?> {
    let params = [
      "latlng": "\(String(coordinate.latitude)),\(String(coordinate.longitude))",
      "language": "ru",
      "key": apiKey
    ]

    return Promise { resolve, reject in
      let url = "https://maps.googleapis.com/maps/api/geocode/json"

      let request = Alamofire.request(url, parameters: params, encoding: URLEncoding.default)
        .responseJSON { response in
          debugPrint(response)
          guard let result = response.result.value else {
            reject(DataError.unexpectedResponseFormat)
            return
          }
          let json = JSON(result)
          resolve(Address(json: json))
      }
    }
  }
  
}
