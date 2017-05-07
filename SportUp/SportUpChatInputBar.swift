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

class SportUpChatInputBar: UIView {
  @IBOutlet weak var imageButton: UIButton!
  @IBOutlet weak var textView: ExpandableTextView!
  @IBOutlet weak var sendButton: UIButton!  

  @IBAction func imageButtonDidTap(_ sender: Any) {
  }

  @IBAction func sendButtonDidTap(_ sender: UIButton) {
  }

  open override func layoutSubviews() {
    self.updateConstraints()
    super.layoutSubviews()
  }


  class func loadNib() -> SportUpChatInputBar {
    let view = SportUpChatInputBar.nibInstance()!
    view.translatesAutoresizingMaskIntoConstraints = false
    view.frame = CGRect.zero
    return view
  }
}
