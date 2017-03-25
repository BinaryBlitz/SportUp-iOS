//
//  StorageHelper.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import KeychainAccess

class StorageHelper {

  enum StorageError: Error {
    case keychainOnlyStringSupported
  }

  enum StorageType {
    case keychain
    case userDefaults
  }

  enum StorageKey: String {
    case currentProfile
    case currentCity
    case apiToken

    var storageType: StorageType {
      switch self {
      case .apiToken:
        return .keychain
      default:
        return .userDefaults
      }
    }
  }

  static func save(_ object: Any?, forKey key: StorageKey) throws {
    switch key.storageType {
    case .keychain:
      guard let objectString = object as? String else { throw StorageError.keychainOnlyStringSupported }
      let keychain = Keychain()
      keychain[key.rawValue] = objectString
    case .userDefaults:
      let userDefaults = UserDefaults.standard
      userDefaults.set(object, forKey: key.rawValue)
    }
  }

  static func loadObjectForKey<T>(_ key: StorageKey) -> T? {
    switch key.storageType {
    case .keychain:
      let keychain = Keychain()
      let object = keychain[key.rawValue]
      return object as? T
    case .userDefaults:
      let userDefaults = UserDefaults.standard
      let object = userDefaults.object(forKey: key.rawValue)
      return object as? T
    }
  }
}
