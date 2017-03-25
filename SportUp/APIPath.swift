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
  case getSportTypes

  var rawPath: String {
    switch self {
    case .getCities:
      return "cities"
    case .getSportTypes:
      return "sport_types"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .getCities, .getSportTypes:
      return .get
    }
  }

  var encoding: ParameterEncoding {
    switch method {
    case .get, .delete:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }
}
