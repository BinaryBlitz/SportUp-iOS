//
//  CalendarDayView.swift
//  SportUp
//
//  Created by Алексей on 27.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

protocol CalendarDayDelegate: class {
  func dayViewSelected(_ dayView: CalendarDayView)
  func selectedDate() -> Date
}

class CalendarDayView: UIView {

  var delegate: CalendarDayDelegate? = nil {
    didSet {
      formatButton()
    }
  }

  // MARK: Views
  let button = UIButton()
  let buttonDimension: CGFloat = 35

  let tapGestureRecognizer = UITapGestureRecognizer()

  var title: String? {
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current

    dateFormatter.calendar = calendar
    dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d", options: 0, locale: calendar.locale)

    return dateFormatter.string(from: date!)
  }

  var font = UIFont.systemFont(ofSize: 20)

  var textColor: UIColor = .white

  var selectedBackgroundColor: UIColor? = UIColor.white

  var date: Date? = nil {
    didSet {
      guard date != nil else { return }
      formatButton()
    }
  }

  required init?(coder aDecoder: NSCoder) {

    return nil
  }

  init() {
    super.init(frame: CGRect.zero)

    addTapGestureRecognizer()
    addButton()
    addConstraints()
  }
}

// MARK: - Tap Gesture Recognizer

extension CalendarDayView {

  func addTapGestureRecognizer() {
    tapGestureRecognizer.addTarget(self, action: #selector(self.highlight))
    addGestureRecognizer(tapGestureRecognizer)
  }
}

// MARK: - Button

extension CalendarDayView {

  fileprivate func addButton() {

    button.layer.cornerRadius = buttonDimension / 2
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(highlight), for: .touchUpInside)
    button.setTitleColor(textColor, for: .normal)
    addSubview(button)
  }

  func formatButton() {

    button.setTitle(title, for: .normal)
    button.titleLabel!.font = font

    guard let delegate = delegate else { return }

    if Calendar.current.isDate(date!, inSameDayAs: delegate.selectedDate()) {
      highlight()
    }
    else {
      unhighlight()
    }
  }
}

// MARK: - Constraints

fileprivate extension CalendarDayView {

  fileprivate func addConstraints() {

    button.widthAnchor.constraint(equalToConstant: buttonDimension).isActive = true
    button.heightAnchor.constraint(equalToConstant: buttonDimension).isActive = true
    button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
}

// MARK: - Selection

extension CalendarDayView {

  func highlight() {
    isUserInteractionEnabled = false
    button.borderWidth = 1
    button.borderColor = UIColor.white
    delegate?.dayViewSelected(self)
    animateSelection()
  }

  internal func unhighlight() {
    button.titleLabel!.font = font
    button.borderColor = UIColor.clear
    button.borderWidth = 0
    isUserInteractionEnabled = true
  }
}

// MARK: - Animations

fileprivate extension CalendarDayView {
  fileprivate func animateSelection() {
    self.animate(toScale: 0.9) { [weak self] finished in
      if finished {
        self?.animate(toScale: 1.1) { finished in
          if finished {
            self?.animate(toScale: 1.0)
          }
        }
      }
    }
  }

  fileprivate func animate(toScale scale: CGFloat, completion: ((Bool) -> Void)? = nil) {

    UIView.animate(withDuration: 0.1, animations: { [weak self] in
      self?.button.transform = CGAffineTransform(scaleX: scale, y: scale)
    }, completion: completion)
  }
}
