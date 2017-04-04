//
//  ProfileManager.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper

class ProfileManager {
  static let instance = ProfileManager()

  var currentProfile: User? = nil {
    didSet {
      let currentProfileJSON = currentProfile?.toJSONString()
      try? StorageHelper.save(currentProfileJSON, forKey: .currentProfile)
    }
  }

  var isAuthorized: Bool {
    let apiToken: String? = StorageHelper.loadObjectForKey(.apiToken)
    return apiToken != nil
  }
  
  var currentCity: City? = nil {
    didSet {
      let cityJSON = currentCity?.toJSONString()
      try? StorageHelper.save(cityJSON, forKey: .currentCity)
    }
  }

  func updateProfile(_ closure: (User) -> Void) -> Promise<Void> {
    let profile = currentProfile ?? User()
    closure(profile)
    return DataManager.instance.updateUser(profile: profile).then {
      try? StorageHelper.save(profile.toJSONString(), forKey: .currentProfile)
    }
  }

  func signOut() {
    try? StorageHelper.save(nil, forKey: .apiToken)
    currentProfile = nil
    RootViewController.instance?.prepareOnboarding()
  }

  private init() {
    if let profileJSON: String = StorageHelper.loadObjectForKey(.currentProfile) {
      currentProfile =  Mapper<User>().map(JSONString: profileJSON)
    }
    if let cityJSON: String = StorageHelper.loadObjectForKey(.currentCity) {
      currentCity = Mapper<City>().map(JSONString: cityJSON)
    }
  }
}
