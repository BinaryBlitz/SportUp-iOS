//
//  PasswordAlertViewController.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

private let animationDuration = 0.3

class PasswordAlertViewController: UIViewController {
  @IBOutlet weak var joinButton: GoButton!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

  var event: Event!

  var didEnterPasswordHandler: (() -> Void)? = nil

  override func viewDidLoad() {
    view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    hideOnTapOutside()
    passwordField.delegate = self
  }

  @IBAction func joinButtonDidTap(_ sender: UIButton) {
    passwordField.isEnabled = false
    joinButton.isEnabled = false
    _ = DataManager.instance.createMembership(eventId: event.id, password: passwordField.text).then { [weak self] _ -> Void in
      guard let `self` = self else { return }
      UIView.animate(withDuration: animationDuration, animations: {
        self.view.alpha = 0
      }, completion: { _ in
        self.dismiss(animated: true, completion: self.didEnterPasswordHandler)
      })
    }.catch { [weak self] error in
      self?.presentAlertWithMessage("Неверный пароль")
      self?.passwordField.isEnabled = true
      self?.joinButton.isEnabled = true
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    UIView.animate(withDuration: animationDuration) { [weak self] in
      self?.view.alpha = 0
      self?.view.alpha = 1
    }
  }

}

extension PasswordAlertViewController {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
}