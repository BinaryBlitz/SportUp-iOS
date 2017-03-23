//
//  NetworkManager.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class NetworkManager {
  static let baseUrl = "sportup-staging.herokuapp.com"
  static let apiPrefix = "/api/"

  static func doRequest(method: HTTPMethod, _ path: APIPath, _ params: Parameters = [:], _ headers: HTTPHeaders = [:]) -> Promise<Any> {
    return Promise() { fullfill, reject in
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      let url = URL(string: self.baseUrl + self.apiPrefix + path.rawPath)!

      var headers = headers
      headers["accept"] = "application/json"

      Alamofire.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          debugPrint(response)
          switch response.result {
          case .success:
            if let result = response.result.value {
              fullfill(result)
            } else {
              if let error = response.result.error {
                reject(error)
              } else {
                reject(DataError.unexpectedResponseFormat)
              }

            }
          case .failure:
            reject(getError(response.response?.statusCode))
          }
      }
    }
  }

  static func getError(_ statusCode: Int?) -> DataError {
    guard let statusCode = statusCode else { return .unknown }

    switch statusCode {
    case 422: return .unprocessableData
    case 503, 500: return .serverUnavaliable
    default: return .unknown
    }
  }
}
