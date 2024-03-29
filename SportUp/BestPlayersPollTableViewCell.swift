//
//  BestPlayersPollTableViewCell.swift
//  SportUp
//
//  Created by Алексей on 29.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

protocol BestPlayersPollTableViewCellDelegate: class {
  func didTapViolationButton(user: User)
}

class BestPlayersPollTableViewCell: UITableViewCell {
  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var checkmarkButton: UIButton!
  @IBOutlet weak var stackView: UIStackView!
  let yellowCardButton = UIButton()

  var user: User? = nil

  var delegate: BestPlayersPollTableViewCellDelegate? = nil

  func configure(user: User, screenType: BestPlayersPollViewController.ScreenType, isBestPlayer: Bool, isReportedViolation: Bool = false) {
    self.user = user
    nameLabel.text = user.firstName + " " + user.lastName

    switch screenType {
    case .results:
      let icon = UIImageView(image: #imageLiteral(resourceName: "iconBestplayer"))
      stackView.addArrangedSubview(icon)

      let label = UILabel()
      label.text = "\(user.votesCount)"
      label.font = UIFont.systemFont(ofSize: 22)
      label.textColor = UIColor.sportUpAquaMarine
      stackView.addArrangedSubview(label)
    case .reports:
      configureReportsView(user: user, isReportedViolation: isReportedViolation)
    case .poll:
      stackView.addArrangedSubview(checkmarkButton)
      break
    }
  }

  func configureReportsView(user: User, isReportedViolation: Bool) {
    yellowCardButton.setTitle(nil, for: .normal)
    yellowCardButton.setImage(#imageLiteral(resourceName: "iconYellowcardSmall"), for: .normal)
    yellowCardButton.isSelected = isReportedViolation

    stackView.addArrangedSubview(yellowCardButton)
    stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.reportViolationButtonDidTap)))

    let label = UILabel()
    var violationsCount = user.violationsCount
    if isReportedViolation { violationsCount += 1 }
    label.text = "\(violationsCount)"
    label.font = UIFont.systemFont(ofSize: 22)
    label.alpha = isReportedViolation ? 0.8 : 1.0
    label.textColor = UIColor.sportUpBlueyGrey
    stackView.addArrangedSubview(label)
  }

  func reportViolationButtonDidTap() {
    guard let user = user else { return }
    delegate?.didTapViolationButton(user: user)
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: true)
    checkmarkButton.isSelected = selected
    nameLabel.textColor = selected ? UIColor.sportUpGunmetal : UIColor.sportUpBlueyGreyTwo
  }

  override func prepareForReuse() {
    for view in stackView.arrangedSubviews {
      stackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
  }

}
