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
import CoreLocation

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
  
  var currentCoordinate: CLLocationCoordinate2D? = nil {
    didSet {
      try? StorageHelper.save(currentCoordinate?.latitude, forKey: .currentLatitude)
      try? StorageHelper.save(currentCoordinate?.latitude, forKey: .currentLongitude)
    }
  }

  func updateProfile(_ closure: (User) -> Void) -> Promise<Void> {
    if let profile = currentProfile {
      closure(profile)
      return DataManager.instance.updateUser(profile: profile).then {
        try? StorageHelper.save(profile.toJSONString(), forKey: .currentProfile)
      }
    } else {
      let profile = User()
      closure(profile)
      return DataManager.instance.createUser(profile: profile).then {
        try? StorageHelper.save(profile.toJSONString(), forKey: .currentProfile)
      }
    }
  }

  func updateAvatar(_ image: UIImage) -> Promise<Void> {
    guard let profile = currentProfile else { return Promise.init(error: DataError.unknown) }
    return DataManager.instance.updateAvatar(imageString: image.base64String ?? "", profile: profile).asVoid()
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
    if let latitude: Double = StorageHelper.loadObjectForKey(.currentLatitude),
      let longitude: Double = StorageHelper.loadObjectForKey(.currentLongitude) {
      currentCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
  }
}
