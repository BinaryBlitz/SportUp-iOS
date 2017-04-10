//
//  UIView+addUpdateConstraintWithKeyboard.swift
//  SportUp
//
//  Created by Алексей on 10.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {

  func addObserverUpdateWithKeyboard() {
    let currentConstant = self.constant

    var observers: [Any] = []

    let didShowObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil, using: { [weak self] notification in
      if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        let keyboardHeight = keyboardSize.height
        UIView.animate(withDuration: 0.4, animations: {
          self?.constant = currentConstant + keyboardHeight
        })
      }
    })

    observers.append(didShowObserver)

    let willHideObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: { [weak self] notification in
      UIView.animate(withDuration: 0.4, animations: {
        self?.constant = currentConstant
      })
    })

    observers.append(willHideObserver)
  }
}
