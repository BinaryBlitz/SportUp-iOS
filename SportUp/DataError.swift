//
//  DataError.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import Alamofire

enum DataError: Error, CustomStringConvertible {
  case unknown
  case serverUnavaliable
  case unexpectedResponseFormat
  case unprocessableData
  case validationFailed(message: String)

  var description: String {
    switch self {
    case .validationFailed(let message):
      return message
    default:
      return "Ошибка"
    }
  }
}
