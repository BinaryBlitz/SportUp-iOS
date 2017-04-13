//
//  Message.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import ObjectMapper

enum MessageItemType: String {
  case text = "text"
  case image = "image"
}

public class MessageItem {
  var id: Int = UUID().hashValue
  var sender: User? = nil
  public var date: Date = Date()

}
