//
//  ProfileViewController.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, DefaultBarStyleViewController {
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!

  var user: User? = ProfileManager.instance.currentProfile
  
  enum ScreenType {
    case registration
    case profileTab

    var navigationTitle: String {
      switch self {
      case .registration:
        return "Регистрация"
      case .profileTab:
        return "Профиль"
      }
    }
  }

  var screenType: ScreenType = .profileTab

  override func viewDidLoad() {
    tabBarItem.title = "Профиль"
    tabBarItem.image = #imageLiteral(resourceName: "iconTabProfile")
    hideOnTapOutside()
    updateData()
    navigationItem.title = screenType.navigationTitle
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCheckedBlack"), style: .plain, target: self, action: #selector(self.rightBarButtonDidTap))
    firstNameField.isEnabled = false
    lastNameField.isEnabled = false
    _ = DataManager.instance.fetchUser().then { [weak self] user -> Void in
      self?.user = user
      self?.updateData()
      }.always { [weak self] _ -> Void in
        self?.firstNameField.isEnabled = true
        self?.lastNameField.isEnabled = true
    }
    guard screenType == .registration else { return }
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCanselBlack"), style: .plain, target: self, action: #selector(self.cancelButtonDidTap))
  }


  func updateData() {
    firstNameField.text = user?.firstName
    lastNameField.text = user?.lastName
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let apiToken: String? = StorageHelper.loadObjectForKey(.apiToken)
    guard screenType != .registration && apiToken == nil else { return }
    let registrationNavigationViewController = SportUpNavigationController(rootViewController: RegistrationPhoneInputViewController.storyboardInstance()!)
    present(registrationNavigationViewController, animated: true, completion: { [weak self] _ in
      self?.tabBarController?.selectedIndex = 0
    })
  }

  @IBAction func avatarViewDidTap(_ sender: UITapGestureRecognizer) {
  }


  func cancelButtonDidTap() {
    dismiss(animated: true, completion: nil)
  }

  func rightBarButtonDidTap() {
    view.endEditing(true)
    navigationItem.rightBarButtonItem?.isEnabled = false
    ProfileManager.instance.updateProfile { [weak self] user in
      user.firstName = self?.firstNameField.text ?? ""
      user.lastName = self?.lastNameField.text ?? ""
    }.then { [weak self] _ -> Void in
      guard let `self` = self else { return }
      switch self.screenType {
      case .registration:
        self.presentAlertWithMessage("Профиль создан") { _ in
          self.dismiss(animated: true, completion: nil)
        }
      case .profileTab:
        self.presentAlertWithMessage("Профиль успешно обновлен")  
      }
    }.catch { [weak self] _ in
      self?.presentAlertWithMessage("Ошибка при обновлении профиля")
    }
  }

  @IBAction func firstNameEditingDidChange(_ sender: Any) {
    navigationItem.rightBarButtonItem?.isEnabled = true
  }

  @IBAction func lastNameEditingDidChange(_ sender: Any) {
    navigationItem.rightBarButtonItem?.isEnabled = true
  }
  
}
