//
//  MessagesDecorator.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class MessagesDecorator: ChatItemsDecoratorProtocol {
  struct Constants {
    static let shortSeparation: CGFloat = 3
    static let normalSeparation: CGFloat = 10
    static let timeIntervalThresholdToIncreaseSeparation: TimeInterval = 120
  }
  
  func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
    var decoratedChatItems = [DecoratedChatItem]()
    let calendar = Calendar.current

    for (index, chatItem) in chatItems.enumerated() {
      let next: ChatItemProtocol? = (index + 1 < chatItems.count) ? chatItems[index + 1] : nil
      let prev: ChatItemProtocol? = (index > 0) ? chatItems[index - 1] : nil

      let bottomMargin = self.separationAfterItem(chatItem, next: next)
      var showsTail = false
      let additionalItems =  [DecoratedChatItem]()

      var addTimeSeparator = false
      if let currentMessage = chatItem as? MessageModelProtocol {
        if let nextMessage = next as? MessageModelProtocol {
          showsTail = currentMessage.senderId != nextMessage.senderId
        } else {
          showsTail = true
        }

        if let previousMessage = prev as? MessageModelProtocol {
          addTimeSeparator = !calendar.isDate(currentMessage.date, inSameDayAs: previousMessage.date)
        } else {
          addTimeSeparator = true
        }
      }

      decoratedChatItems.append(DecoratedChatItem(
        chatItem: chatItem,
        decorationAttributes: ChatItemDecorationAttributes(bottomMargin: bottomMargin, showsTail: showsTail, canShowAvatar: showsTail))
      )
      decoratedChatItems.append(contentsOf: additionalItems)
    }

    return decoratedChatItems
  }

  func separationAfterItem(_ current: ChatItemProtocol?, next: ChatItemProtocol?) -> CGFloat {
    guard let nexItem = next else { return 0 }
    guard let currentMessage = current as? MessageModelProtocol else { return Constants.normalSeparation }
    guard let nextMessage = nexItem as? MessageModelProtocol else { return Constants.normalSeparation }

    if self.showsStatusForMessage(currentMessage) {
      return 0
    } else if currentMessage.senderId != nextMessage.senderId {
      return Constants.normalSeparation
    } else if nextMessage.date.timeIntervalSince(currentMessage.date) > Constants.timeIntervalThresholdToIncreaseSeparation {
      return Constants.normalSeparation
    } else {
      return Constants.shortSeparation
    }
  }

  func showsStatusForMessage(_ message: MessageModelProtocol) -> Bool {
    return message.status == .failed || message.status == .sending
  }
}
