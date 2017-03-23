//
//  APIPath.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import Alamofire

enum APIPath {
  case getCities

  var rawPath: String {
    switch self {
    case .getCities:
      return "cities"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .getCities:
      return .get
    }
  }
}
