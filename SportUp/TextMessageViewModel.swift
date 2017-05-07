//
//  TextMessageViewModel.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import ChattoAdditions

open class SportUpTextMessageViewModel: TextMessageViewModel<SportUpTextMessageModel> {
  override init(textMessage: SportUpTextMessageModel, messageViewModel: MessageViewModelProtocol) {
    super.init(textMessage: textMessage, messageViewModel: messageViewModel)
  }
}

open class SportUpTextMessageViewModelBuilder: ViewModelBuilderProtocol {
  public init() {}

  let messageViewModelBuilder = MessageViewModelDefaultBuilder()

  public func createViewModel(_ textMessage: SportUpTextMessageModel) -> SportUpTextMessageViewModel {
    let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(textMessage)
    let textMessageViewModel = SportUpTextMessageViewModel(textMessage: textMessage, messageViewModel: messageViewModel)
    textMessageViewModel.avatarImage.value = UIImage(named: "userAvatar")
    return textMessageViewModel
  }

  public func canCreateViewModel(fromModel model: Any) -> Bool {
    return model is SportUpTextMessageModel
  }
}
