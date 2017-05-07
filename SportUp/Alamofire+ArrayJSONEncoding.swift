//
//  Alamofire+ArrayJSONEncoding.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import Alamofire

private let arrayParametersKey = "arrayParametersKey"

/// Extenstion that allows an array be sent as a request parameters
extension Array {
  func asParameters() -> Parameters {
    return [arrayParametersKey: self]
  }
}

public struct ArrayEncoding: ParameterEncoding {

  public let options: JSONSerialization.WritingOptions

  public init(options: JSONSerialization.WritingOptions = []) {
    self.options = options
  }

  public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
    var urlRequest = try urlRequest.asURLRequest()

    guard let parameters = parameters,
      let array = parameters[arrayParametersKey] else {
        return urlRequest
    }

    do {
      let data = try JSONSerialization.data(withJSONObject: array, options: options)

      if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }

      urlRequest.httpBody = data

    } catch {
      throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
    }

    return urlRequest
  }
}
