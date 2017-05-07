//
//  Message.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import ObjectMapper

import Foundation
import ObjectMapper
import Chatto
import ChattoAdditions

enum MessageItemType: String {
  case text = "text"
  case image = "image"
}

public class MessageItem {
  var id: Int = UUID().hashValue
  var sender: User? = nil
  public var date: Date = Date()

}

extension MessageItem: MessageModelProtocol {
  public var uid: String {
    return "\(id)"
  }

  public var senderId: String {
    return "\(sender?.id ?? 0)"
  }

  public var type: ChatItemType {
    return MessageItemType.text.rawValue
  }

  public var isIncoming: Bool {
    return sender?.id == ProfileManager.instance.currentProfile?.id
  }

  public var status: MessageStatus {
    return .success
  }
  
}
