//
//  MyGamesTableViewCell.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

protocol MyGamesTableViewCellDelegate: class {
  func accept(invite: Invite)
  func decline(invite: Invite)
  func leave(membership: Membership)
}

class MyGamesTableViewCell: UITableViewCell {
  @IBOutlet var sportTypeIconView: UIImageView!
  @IBOutlet var eventNameLabel: UILabel!
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var timeLabel: UILabel!

  @IBOutlet var acceptButton: UIButton!
  @IBOutlet var declineButton: UIButton!
  @IBOutlet var nextIconView: UIImageView!

  var delegate: MyGamesTableViewCellDelegate? = nil

  enum CellType {
    case invite(InviteResponse)
    case myGame(EventMembership)
    case currentGame(EventMembership)
    case finishedGame(EventMembership)
  }

  var cellType: CellType? = nil {
    didSet {
      guard let cellType = cellType else { return }
      switch cellType {
      case .invite(let inviteResponse):
        guard let event = inviteResponse.event else { return }
        configure(event: event)
        stackView.addArrangedSubview(acceptButton)
        stackView.addArrangedSubview(declineButton)
      case .myGame(let eventMembership):
        configure(event: eventMembership.event)
        stackView.addArrangedSubview(nextIconView)
      case .currentGame(let eventMembership):
        configure(event: eventMembership.event)
        stackView.addArrangedSubview(declineButton)
      case .finishedGame(let eventMembership):
        configure(event: eventMembership.event)
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    prepareStackView()
  }

  private func configure(event: Event) {
    sportTypeIconView.kf.setImage(with: event.sportType?.iconUrl) { [weak self] image, _, _, _ in
      guard let image = image?.withRenderingMode(.alwaysTemplate) else { return }
      self?.sportTypeIconView.image = image
      self?.sportTypeIconView.tintColor = event.sportType?.color
    }
    eventNameLabel.text = event.name
    dateLabel.text = event.startsAt.shortDate
    timeLabel.text = event.startsAt.time
    acceptButton.isEnabled = true
    declineButton.isEnabled = true
  }

  override func prepareForReuse() {
    prepareStackView()
  }

  func prepareStackView() {
    for view in stackView.arrangedSubviews {
      view.removeFromSuperview()
      stackView.removeArrangedSubview(view)
    }
  }

  @IBAction func acceptButtonDidTap(_ sender: Any) {
    acceptButton.isEnabled = false
    declineButton.isEnabled = false
    guard let cellType = cellType else { return }
    switch cellType {
    case .invite(let inviteResponse):
      guard let invite = inviteResponse.invite else { return }
      delegate?.accept(invite: invite)
    default:
      break
    }
  }

  @IBAction func declineButtonDidTap(_ sender: UIButton) {
    acceptButton.isEnabled = false
    declineButton.isEnabled = false
    guard let cellType = cellType else { return }
    switch cellType {
    case .invite(let inviteResponse):
      guard let invite = inviteResponse.invite else { return }
      delegate?.decline(invite: invite)
    case .currentGame(let eventMembership):
      delegate?.leave(membership: eventMembership.membership)
    default:
      break
    }
  }
}
