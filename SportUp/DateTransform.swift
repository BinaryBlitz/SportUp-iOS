//
//  DateTransform.swift
//  SportUp
//
//  Created by Алексей on 26.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftDate

struct DateTransform: TransformType {

  typealias Object = Date
  typealias JSON = String

  public func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? String else { return nil }
    let date = value.date(format: .iso8601(options: .withInternetDateTimeExtended), fromRegion: Region.Local())?.absoluteDate
    return date
  }

  init() { }

  public func transformToJSON(_ value: Object?) -> JSON? {
    guard let date = value else { return "" }
    return date.string(format: .iso8601(options: [.withInternetDateTimeExtended]), in: Region.Local())
  }
  
}
