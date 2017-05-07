//
//  URLTransform.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import ObjectMapper

struct StringToDateTransform: TransformType {

  typealias Object = URL
  typealias JSON = String

  public func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? String else { return nil }
    return URL(string: value)

  }

  public func transformToJSON(_ value: Object?) -> JSON? {
    guard let url = value else { return "" }
    return url.absoluteString
  }

}
