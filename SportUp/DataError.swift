//
//  DataError.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import Alamofire

enum DataError: Error {
  case unknown
  case serverUnavaliable
  case unexpectedResponseFormat
  case unprocessableData
}
