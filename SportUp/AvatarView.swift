//
//  AvatarImageView.swift
//  SportUp
//
//  Created by Алексей on 12.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

private let avatarColors: [UIColor] = [
  UIColor(red: 50.0 / 255.0, green: 204.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0),
  UIColor(red: 186.0 / 255.0, green: 184.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0),
  UIColor(red: 76.0 / 255.0, green: 184.0 / 255.0, blue: 198.0 / 255.0, alpha: 1.0),
  UIColor(red: 233.0 / 255.0, green: 150.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0),
  UIColor(red: 102.0 / 255.0, green: 205.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0),
  UIColor(red: 81.0 / 255.0, green: 157.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0),
  UIColor(red: 114.0 / 255.0, green: 198.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0),
  UIColor(red: 199.0 / 255.0, green: 101.0 / 255.0, blue: 116.0 / 255.0, alpha: 1.0),
  UIColor(red: 246.0 / 255.0, green: 118.0 / 255.0, blue: 142.0 / 255.0, alpha: 1.0),
  UIColor(red: 223.0 / 255.0, green: 203.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0)
]

class AvatarView: UIView {
  @IBOutlet weak var userIconView: UIImageView!
  @IBOutlet weak var cameraIconView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var circleView: UIView!

  func setBgColor(character: Character) {
    let number = Int(character.asciiValue ?? 0)
    let index = number % avatarColors.count
    circleView.backgroundColor = avatarColors[index]
  }

  func setDefaultAvatar() {
    nameLabel.isHidden = true
    userIconView.isHidden = true
    userIconView.contentMode = .center
    userIconView.image = #imageLiteral(resourceName: "iconUserWhite")
  }

  func configure(user: User?, cameraIconIsHidden: Bool = true) {
    cameraIconView.isHidden = cameraIconIsHidden
    guard let user = user else {
      return setDefaultAvatar()
    }
    userIconView.contentMode = .scaleAspectFit
    if let url = user.avatarUrl {
      nameLabel.isHidden = true
      userIconView.isHidden = false
      userIconView.contentMode = .scaleAspectFill
      userIconView.kf.setImage(with: url)
      circleView.backgroundColor = UIColor.clear
    } else {
      guard let firstNameChar = user.firstName.characters.first ?? user.lastName.characters.first else { return setDefaultAvatar() }
      setBgColor(character: firstNameChar)
      userIconView.isHidden = true
      nameLabel.isHidden = false
      nameLabel.text = "\(firstNameChar)".uppercased()
    }
    layoutIfNeeded()
  }

  override func didMoveToSuperview() {
    guard let superview = superview else { return }
    topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
    leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
    rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
    bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    superview.updateConstraintsIfNeeded()
    superview.layoutIfNeeded()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    circleView.cornerRadius = self.frame.width / 2
    layoutIfNeeded()
  }

  @IBAction func avatarViewDidTap(_ sender: Any) {
  }
  
}
