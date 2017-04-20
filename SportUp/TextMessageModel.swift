//
//  TextMessageModel.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public class SportUpTextMessageModel: TextMessageModel<MessageItem> {
  override init(messageModel: MessageItem, text: String) {
    super.init(messageModel: messageModel, text: text)
  }

  var status: MessageStatus {
    return self._messageModel.status
  }
}
