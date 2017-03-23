//
//  NetworkManager.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
  static let baseUrl = "http://dev.silver.travel:8080"
  static let apiPrefix = "/api/v1/"

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
                reject(DataError.responseConvertFailed)
              }

            }
          case .failure:
            reject(getError(statusCode: response.response?.statusCode))
          }
      }
    }
  }
}
