//
//  RegistrationCodeInputViewController.swift
//  SportUp
//
//  Created by Алексей on 31.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

private let termsOfServiceUrl = URL(string: "")

class RegistrationCodeInputViewController: UIViewController, DefaultBarStyleViewController {
  var phoneNumberString: String = ""
  let maskedCodeInput = MaskedInput(formattingType: .pattern("* ∙ * ∙ * ∙ * ∙ *"))

  @IBOutlet weak var codeField: UITextField!
  @IBOutlet weak var repeatButton: UIButton!
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var licenseAgreementLabel: UILabel!

  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

  var observers: [NSObjectProtocol] = []

  override func viewDidLoad() {
    hideKeyboardOnTapOutside()
    configureLicenseAgreementLabel()
    codeField.inputAccessoryView = UIView()
    codeField.tintColor = UIColor.sportUpAquaMarine
    subTitleLabel.text = "На номер \(phoneNumberString) был отправлен код"
    maskedCodeInput.configure(textField: codeField)

    maskedCodeInput.isValidHandler = { [weak self] isValid in
      guard isValid else { return }
      self?.codeField.isEnabled = false
      _ = DataManager.instance.verifyToken(code: self?.codeField.text?.onlyDigits ?? "").then { [weak self] _ -> Void in
        let viewController = ProfileEditViewController.storyboardInstance()!
        viewController.screenType = .registration
        self?.navigationController?.setViewControllers([viewController], animated: true)
      }.catch { _ in
        self?.codeField.isEnabled = true
      }
    }

  }

  func configureLicenseAgreementLabel() {
    let licenseAgreementString = NSMutableAttributedString()
    licenseAgreementString.append(NSAttributedString(string: "Регистрируясь в приложении, вы принимаете условия "))
    licenseAgreementString.append(NSAttributedString(string: "Пользовательского соглашения", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]))
    licenseAgreementLabel.attributedText = licenseAgreementString
  }

  override func viewWillAppear(_ animated: Bool) {
    codeField.becomeFirstResponder()
    addObserverUpdateWithKeyboard()
  }

  override func viewWillDisappear(_ animated: Bool) {
    observers.forEach { NotificationCenter.default.removeObserver($0) }
    observers = []
  }

  func addObserverUpdateWithKeyboard() {
    let currentConstant = bottomLayoutConstraint.constant

    let didShowObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil, using: { [weak self] notification in
      if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        let keyboardHeight = keyboardSize.height
        UIView.animate(withDuration: 0.4, animations: {
          self?.bottomLayoutConstraint.constant = currentConstant + keyboardHeight
          self?.view.layoutIfNeeded()
        })
      }
    })

    observers.append(didShowObserver)

    let willHideObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: { [weak self] notification in
      UIView.animate(withDuration: 0.4, animations: {
        self?.bottomLayoutConstraint.constant = currentConstant
        self?.view.layoutIfNeeded()
      })
    })

    observers.append(willHideObserver)
  }

  @IBAction func licenseAgreementDidTap(_ sender: Any) {
    guard let url = termsOfServiceUrl else { return }
    let safariViewController = SFSafariViewController(url: url)
    present(safariViewController, animated: true, completion: nil)
    
  }

}
