//
//  RegistrationPhoneInputViewController.swift
//  SportUp
//
//  Created by Алексей on 31.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import PhoneNumberKit

private let termsOfServiceUrl = URL(string: "")

class RegistrationPhoneInputViewController: UIViewController, DefaultBarStyleViewController {
  @IBOutlet weak var phoneInputField: UITextField!
  @IBOutlet weak var sendButton: GoButton!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var licenseAgreementLabel: UILabel!

  var observers: [Any] = []

  override func viewDidLoad() {
    hideKeyboardOnTapOutside()
    configureLicenseAgreementLabel()

    phoneInputField.inputAccessoryView = UIView()
    phoneInputField.tintColor = UIColor.sportUpAquaMarine

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

  func configureLicenseAgreementLabel() {
    let licenseAgreementString = NSMutableAttributedString()
    licenseAgreementString.append(NSAttributedString(string: "Регистрируясь в приложении, вы принимаете условия "))
    licenseAgreementString.append(NSAttributedString(string: "Пользовательского соглашения", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]))
    licenseAgreementLabel.attributedText = licenseAgreementString
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    phoneInputField.becomeFirstResponder()
    addObserverUpdateWithKeyboard()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    observers.forEach { NotificationCenter.default.removeObserver($0) }
    observers = []
  }

  func addObserverUpdateWithKeyboard() {

    let didShowObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil, using: { [weak self] notification in
      if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        let keyboardHeight = keyboardSize.height
        UIView.animate(withDuration: 0.4, animations: {
          self?.bottomLayoutConstraint.constant = keyboardHeight
          self?.view.layoutIfNeeded()
        })
      }
    })

    observers.append(didShowObserver)

    let willHideObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: { [weak self] notification in
      UIView.animate(withDuration: 0.4, animations: {
        UIView.animate(withDuration: 0.4, animations: {
          self?.bottomLayoutConstraint.constant = 0
          self?.view.layoutIfNeeded()
        })
      })
    })

    observers.append(willHideObserver)
  }

  @IBAction func licenseAgreementDidTap(_ sender: Any) {
    guard let url = termsOfServiceUrl else { return }
    let safariViewController = SFSafariViewController(url: url)

    present(safariViewController, animated: true, completion: nil)
  }

  @IBAction func sendButtonDidTap(_ sender: Any) {
    guard let phoneText = phoneInputField.text else { return presentAlertWithMessage("Неправильный формат номера телефона") }
    let phoneNumberKit = PhoneNumberKit()
    guard let phoneNumber = try? phoneNumberKit.parse(phoneText) else { return presentAlertWithMessage("Неправильный формат номера телефона") }
    _ = DataManager.instance
      .createVerificationToken(phoneNumber: phoneNumberKit.format(phoneNumber, toType: .e164)).then { [weak self] _ -> Void in
      let viewController = RegistrationCodeInputViewController.storyboardInstance()!
      viewController.phoneNumberString = phoneText
      self?.navigationController?.pushViewController(viewController, animated: true)
    }.catch { [weak self ] _ -> Void in
        self?.presentAlertWithMessage("Номер телефона имеет неправильный формат или уже используется")
    }

  }

}
