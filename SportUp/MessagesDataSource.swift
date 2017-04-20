//
//  MessagesDataSource.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import Chatto

class MessagesDataSource: ChatDataSourceProtocol {
  var hasMoreNext: Bool {
    return false
  }

  var hasMorePrevious: Bool {
    return false
  }

  var chatItems: [ChatItemProtocol] {
    return []
  }

  var delegate: ChatDataSourceDelegateProtocol? = nil

  func loadNext() {
    self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
  }

  func loadPrevious() {
    self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
  }

  func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion: ((Bool)) -> Void) {
  }
  
}
