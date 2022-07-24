//
//  BonusRegistrationAlertViewController.swift
//  SportUp
//
//  Created by Алексей on 12.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

private let animationDuration = 0.3

class BonusRegistrationAlertViewController: UIViewController {
  @IBOutlet weak var ticketsCountLabel: UILabel!
  @IBOutlet weak var nextButton: GoButton!

  override func viewDidLoad() {
    view.backgroundColor = UIColor(white: 0, alpha: 0.5)
  }

  override func viewWillAppear(_ animated: Bool) {
    UIView.animate(withDuration: animationDuration) { [weak self] in
      self?.view.alpha = 0
      self?.view.alpha = 1
    }
  }

  @IBAction func nextButtonDidTap(_ sender: Any) {
    UIView.animate(withDuration: animationDuration, animations: {
      self.view.alpha = 0
    }, completion: { _ in
      self.dismiss(animated: true, completion: nil)
    })
  }
  
}
