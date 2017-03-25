//
//  DataManager.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import ObjectMapper

class DataManager {
  static let instance = DataManager()
  var sportTypes: [SportType] = [] {
    didSet {
      try? StorageHelper.save(sportTypes.toJSONString(), forKey: .sportTypes)
    }
  }

  private init() {
    if let sportTypesJSON: String = StorageHelper.loadObjectForKey(.sportTypes) {
      sportTypes = Mapper<SportType>().mapArray(JSONString: sportTypesJSON) ?? []
    }
  }

  func fetchCities() -> Promise<[City]> {
    return NetworkManager.doRequest(.getCities).then { result in
      guard let cities = Mapper<City>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: cities)
    }
  }

  func fetchSportTypes() -> Promise<[SportType]> {
    return NetworkManager.doRequest(.getSportTypes).then { result in
      guard let sportTypes = Mapper<SportType>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      self.sportTypes = sportTypes
      return Promise(value: sportTypes)
    }
  }
}
