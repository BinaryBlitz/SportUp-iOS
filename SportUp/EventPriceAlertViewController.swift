//
//  EventPriceAlertViewController.swift
//  SportUp
//
//  Created by Алексей on 18.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

private let animationDuration = 0.3

class EventPriceAlertViewController: UIViewController {
  @IBOutlet weak var ticketsCountLabel: UILabel!
  @IBOutlet weak var nextButton: GoButton!
  @IBOutlet weak var contentView: UIView!
  
  var nextButtonDidTapHandler: (() -> Void)? = nil

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
      self.dismiss(animated: true, completion: { [weak self] in
        self?.nextButtonDidTapHandler?()
      })
    })
  }

  @IBAction func backgroundViewDidTap(_ sender: Any) {
    UIView.animate(withDuration: animationDuration, animations: {
      self.view.alpha = 0
    }, completion: { _ in
      self.dismiss(animated: true, completion: nil)
    })
  }

}

extension EventPriceAlertViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view == gestureRecognizer.view && touch.view != contentView
  }
}
