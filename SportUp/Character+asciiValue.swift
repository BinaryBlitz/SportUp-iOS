//
//  Character+asciiValue.swift
//  SportUp
//
//  Created by Алексей on 13.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation

extension Character {
  var asciiValue: UInt32? {
    return String(self).unicodeScalars.first?.value
  }
}
