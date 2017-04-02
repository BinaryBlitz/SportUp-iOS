//
//  SportUpChatInputBar.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import Chatto
import ChattoAdditions

class SportUpChatInputBar: ChatInputBar {
  override class open func loadNib() -> ChatInputBar {
    let view = nibInstance()! as ChatInputBar
    view.translatesAutoresizingMaskIntoConstraints = false
    view.frame = CGRect.zero
    return view
  }
}

class SportUpExpandableTextView: ExpandableTextView{}
class SportUpHorizontalStackScrollView: HorizontalStackScrollView {}
