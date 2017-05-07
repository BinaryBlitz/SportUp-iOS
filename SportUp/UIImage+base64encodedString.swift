//
//  UIImage+base64encodedString.swift
//  SportUp
//
//  Created by Алексей on 12.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

  var base64String: String? {
    let imageData = UIImagePNGRepresentation(self)
    let base64ImageString = imageData?.base64EncodedString(options: .lineLength64Characters)
    if let base64ImageString = base64ImageString {
      let formattedImage = "data:image/gif;base64,\(base64ImageString))"
      return formattedImage
    } else {
      return nil
    }
  }
}
