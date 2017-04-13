//
//  PromoCodeAlertVIewController.swift
//  SportUp
//
//  Created by Алексей on 10.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class PromoCodeAlertViewController: UIViewController, DefaultBarStyleViewController {
  @IBOutlet weak var promoCodeField: UITextField!
  @IBOutlet weak var sendButton: GoButton!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

  var observers: [Any] = []

  override func viewDidLoad() {
    hideKeyboardOnTapOutside()

    navigationItem.backBarButtonItem = UIBarButtonItem(
      title: "",
      style: .plain,
      target: nil, action: nil
    )

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: #imageLiteral(resourceName: "iconNavCanselBlack"),
      style: .plain,
      target: self, action: #selector(self.leftNavigationButtonDidTap)
    )
    navigationController?.navigationBar.tintColor = .black
  }

  func leftNavigationButtonDidTap() {
    dismiss(animated: true, completion: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    promoCodeField.becomeFirstResponder()
    self.observers = bottomLayoutConstraint.addObserversUpdateWithKeyboard()
  }

  override func viewWillDisappear(_ animated: Bool) {
    observers.forEach { NotificationCenter.default.removeObserver($0) }
    observers = []
  }

  @IBAction func sendButtonDidTap(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
