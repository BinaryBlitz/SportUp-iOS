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

  @IBAction func sendButtonDidTap(_ sender: Any) {
  }

  var observers: [NSObjectProtocol] = []

  override func viewDidLoad() {
    hideOnTapOutside()

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
  }

  func leftNavigationButtonDidTap() {
    dismiss(animated: true, completion: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    promoCodeField.becomeFirstResponder()
    bottomLayoutConstraint.addObserverUpdateWithKeyboard()
  }

  override func viewWillDisappear(_ animated: Bool) {
    observers.forEach { NotificationCenter.default.removeObserver($0) }
    observers = []
  }
}
