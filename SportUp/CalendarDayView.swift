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
  func selectedTextColor() -> UIColor?
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

    return dateFormatter.string(from: self.date!)
  }

  var font = UIFont.systemFont(ofSize: 20)

  var textColor: UIColor = .white

  var selectedTextColor: UIColor? {
    return delegate?.selectedTextColor() ?? UIColor.sportUpAquaMarine
  }

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

    self.addTapGestureRecognizer()
    self.addButton()
    self.addConstraints()
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
    addSubview(self.button)
  }

  func formatButton() {

    self.button.setTitle(self.title, for: .normal)
    self.button.setTitleColor(UIColor.white, for: .normal)
    self.button.titleLabel!.font = self.font

    guard let delegate = delegate else { return }

    if Calendar.current.isDate(self.date!, inSameDayAs: delegate.selectedDate()) {
      self.highlight()
    }
    else {
      self.unhighlight()
    }
  }
}

// MARK: - Constraints

fileprivate extension CalendarDayView {

  fileprivate func addConstraints() {

    self.button.widthAnchor.constraint(equalToConstant: self.buttonDimension).isActive = true
    self.button.heightAnchor.constraint(equalToConstant: self.buttonDimension).isActive = true
    self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
  }
}

// MARK: - Selection

extension CalendarDayView {

  func highlight() {
    self.isUserInteractionEnabled = false
    self.button.backgroundColor = self.selectedBackgroundColor
    self.button.setTitleColor(self.selectedTextColor, for: .normal)
    self.delegate?.dayViewSelected(self)
    self.animateSelection()
  }

  internal func unhighlight() {
    self.button.backgroundColor = nil
    self.button.titleLabel!.font = self.font
    self.button.setTitleColor(self.textColor, for: .normal)

    self.isUserInteractionEnabled = true
  }
}

// MARK: - Animations

fileprivate extension CalendarDayView {
  fileprivate func animateSelection() {
    self.animate(toScale: 0.9) { finished in
      if finished {
        self.animate(toScale: 1.1) { finished in
          if finished {
            self.animate(toScale: 1.0)
          }
        }
      }
    }
  }

  fileprivate func animate(toScale scale: CGFloat, completion: ((Bool) -> Void)? = nil) {

    UIView.animate(withDuration: 0.1, animations: {

      self.button.transform = CGAffineTransform(scaleX: scale, y: scale)

    }, completion: completion)
  }
}
