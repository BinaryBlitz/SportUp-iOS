//
//  MessagesViewController.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import Chatto
import ChattoAdditions

class MessagesViewController: BaseChatViewController {
  var chatInputPresenter: BasicChatInputBarPresenter!

  override func createChatInputView() -> UIView {
    let chatInputView = SportUpChatInputBar.loadNib()
    var appearance = ChatInputBarAppearance()
    appearance.sendButtonAppearance.title = ""
    appearance.textInputAppearance.placeholderText = ""
    self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
    chatInputView.maxCharactersCount = 1000
    return chatInputView
  }

  func createChatInputItems() -> [ChatInputItemProtocol] {
    var items = [ChatInputItemProtocol]()
    items.append(self.createTextInputItem())
    //items.append(self.createPhotoInputItem())
    return items
  }

  private func createTextInputItem() -> TextChatInputItem {
    let item = TextChatInputItem()
    item.textInputHandler = { [weak self] text in
    }
    return item
  }

  private func createPhotoInputItem() -> PhotosChatInputItem {
    let item = PhotosChatInputItem(presentingController: self)
    item.photoInputHandler = { [weak self] image in
    }
    return item
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.chatDataSource = MessagesDataSource()
  }

  override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
    let textMessagePresenter = TextMessagePresenterBuilder(viewModelBuilder: SportUpTextMessageViewModelBuilder(),
                                                           interactionHandler: SportUpTextMessageHandler())
    //textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()

    return [
      MessageItemType.text.rawValue : [textMessagePresenter]
    ]
  }

}
