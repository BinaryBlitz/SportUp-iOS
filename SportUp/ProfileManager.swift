//
//  ProfileManager.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileManager {
  static let instance = ProfileManager()

  var currentProfile: Profile? = nil
  var currentCity: City? = nil {
    didSet {
      let cityJSON = currentCity?.toJSONString()
      try? StorageHelper.save(cityJSON, forKey: .currentCity)
    }
  }

  private init() {
    if let profileJSON: String = StorageHelper.loadObjectForKey(.currentProfile) {
      currentProfile =  Mapper<Profile>().map(JSONString: profileJSON)
    }
    if let cityJSON: String = StorageHelper.loadObjectForKey(.currentCity) {
      currentCity = Mapper<City>().map(JSONString: cityJSON)
    }
  }
}
