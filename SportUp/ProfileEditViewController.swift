//
//  ProfileEditViewController.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit
import RSKImageCropper

class ProfileEditViewController: UIViewController, DefaultBarStyleViewController {
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var avatarOuterView: UIView!

  let avatarView = AvatarView.nibInstance()!

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
    avatarOuterView.addSubview(avatarView)
    hideKeyboardOnTapOutside()
    updateData()
    navigationItem.title = screenType.navigationTitle
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCheckedBlack"), style: .plain, target: self, action: #selector(self.rightBarButtonDidTap))
    guard screenType == .registration else { return }
    refresh()
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCanselBlack"), style: .plain, target: self, action: #selector(self.cancelButtonDidTap))
  }

  func refresh() {
    firstNameField.isEnabled = false
    lastNameField.isEnabled = false
    _ = DataManager.instance.fetchUser().then { [weak self] user -> Void in
      self?.user = user
      self?.updateData()
      }.catch { [weak self] _ in
        let viewController = BonusRegistrationAlertViewController.storyboardInstance()!
        viewController.modalPresentationStyle = .overCurrentContext
        self?.navigationController?.pushViewController(viewController, animated: false)

      }.always { [weak self] _ -> Void in
        self?.firstNameField.isEnabled = true
        self?.lastNameField.isEnabled = true
    }
  }

  func updateData() {
    firstNameField.text = user?.firstName
    lastNameField.text = user?.lastName
    avatarView.configure(user: user, cameraIconIsHidden: false)
  }

  @IBAction func avatarViewDidTap(_ sender: UITapGestureRecognizer) {
    let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { (action) in
      self.presentImagePickerWithImagesFrom(.photoLibrary)
    }))
    alert.addAction(UIAlertAction(title: "Сделать фотографию", style: .default, handler: { (action) in
      self.presentImagePickerWithImagesFrom(.camera)
    }))
    alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }

  func presentImagePickerWithImagesFrom(_ sourceType: UIImagePickerControllerSourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = sourceType
    present(imagePicker, animated: true, completion: nil)
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

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
    picker.dismiss(animated: true, completion: nil)

    let imageCropViewController = RSKImageCropViewController(image: image)
    imageCropViewController.delegate = self
    present(imageCropViewController, animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}

extension ProfileEditViewController: RSKImageCropViewControllerDelegate {
  func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
    controller.dismiss(animated: true, completion: nil)
    ProfileManager.instance.updateAvatar(croppedImage).then { [weak self] _ -> Void in
      self?.presentAlertWithMessage("Профиль успешно обновлен")
      self?.refresh()
    }.catch { [weak self] _ -> Void in
      self?.presentAlertWithMessage("Ошибка")
    }
  }

  func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
    controller.dismiss(animated: true, completion: nil)
    }
}

