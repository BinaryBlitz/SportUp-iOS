//
//  ReportAlertViewController.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

protocol ReportAlertViewControllerDelegate: class {
  func didCreateReport(player: User, reportContent: String)
}

class ReportAlertViewController: UIViewController {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingField: UITextField!
  @IBOutlet weak var sendButton: GoButton!

  let animationDuration = 0.2

  var player: User!
  var delegate: ReportAlertViewControllerDelegate? = nil

  override func viewDidLoad() {
    nameLabel.text = player.firstName + player.lastName
    ratingField.inputAccessoryView = UIView()
    hideKeyboardOnTapOutside()
    view.backgroundColor = UIColor(white: 0, alpha: 0.5)
  }

  override func viewWillAppear(_ animated: Bool) {
    UIView.animate(withDuration: animationDuration) { [weak self] in
      self?.view.alpha = 0
      self?.view.alpha = 1
    }
  }

  @IBAction func sendButtonDidTap(_ sender: GoButton) {
    let content = ratingField.text ?? ""
    delegate?.didCreateReport(player: player, reportContent: content)
    dismiss(animated: true, completion: nil)
  }

}
