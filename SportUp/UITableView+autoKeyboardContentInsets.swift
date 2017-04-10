//
//  UIScrollView+autoKeyboardContentInsets.swift
//  SportUp
//
//  Created by Алексей on 09.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  func autoUpdateInsetsWithKeyboard() -> [Any] {
    let willShowObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { [weak self] notification in
      guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect)?.size else { return }
      let rate = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

      let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
      UIView.animate(withDuration: rate) {
        self?.contentInset = contentInsets
        self?.scrollIndicatorInsets = contentInsets;
      }
    }

    let willHideObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { [weak self] notification in
      let rate = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

      UIView.animate(withDuration: rate) {
        self?.contentInset = UIEdgeInsets.zero
        self?.scrollIndicatorInsets = UIEdgeInsets.zero
      }
    }

    return [willShowObserver, willHideObserver]
  }
}
