//
//  MaskedInput.swift
//  SportUp
//
//  Created by Алексей on 31.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import PhoneNumberKit

extension String {
  var onlyDigits: String {
    return components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
  }
}

class MaskedInput: NSObject {
  var textField: UITextField? = nil

  enum FormattingType {
    case phoneNumber
    case pattern(String)
  }

  var type: FormattingType
  var replacementChar: String = "*"
  let maximumPhoneLength = 15

  var isValidHandler: ((Bool) -> Void)? = nil

  init(formattingType: FormattingType) {
    self.type = formattingType
  }

  func configure(textField: UITextField) {
    textField.delegate = self
    self.textField = textField
    textField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
  }

  func textFieldDidChange() {
    guard let text = textField?.text else { return }
    switch type {
    case .phoneNumber:
      let formattedPhone = PartialFormatter().formatPartial(text)
      textField?.text = formattedPhone
    case .pattern(let formattingPattern):
      if text.characters.count > 0, formattingPattern.characters.count > 0 {
        let formattedText = format(text: text, formattingPattern: formattingPattern)

        textField?.text = formattedText

        isValidHandler?(formattedText.characters.count == formattingPattern.characters.count)
      }
    }

  }

  func shouldContinueEditing(text: String, range: NSRange, replacementStirng string: String) -> Bool {
    switch type {
    case .phoneNumber:
      let newLength = text.onlyDigits.characters.count + string.characters.count - range.length
      return newLength <= maximumPhoneLength
    default:
      return true
    }
  }

  private func format(text: String, formattingPattern: String) -> String {
    let onlyDigitsString = text.onlyDigits

    var finalText = ""

    var formatterIndex = formattingPattern.startIndex
    var tempIndex = onlyDigitsString.startIndex

    while !(formatterIndex >= formattingPattern.endIndex || tempIndex >= onlyDigitsString.endIndex) {
      let formattingPatternRange = formatterIndex ..< formattingPattern.index(formatterIndex, offsetBy: 1)

      if formattingPattern.substring(with: formattingPatternRange) != replacementChar {
        finalText = finalText + formattingPattern.substring(with: formattingPatternRange)
      } else if onlyDigitsString.characters.count > 0 {
        let pureStringRange = tempIndex ..< onlyDigitsString.index(tempIndex, offsetBy: 1)
        finalText = finalText + onlyDigitsString.substring(with: pureStringRange)
        tempIndex = onlyDigitsString.index(after: tempIndex)
      }
      formatterIndex = formattingPattern.index(after: formatterIndex)
    }

    return finalText
  }

}

extension MaskedInput: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    return shouldContinueEditing(text: text, range: range, replacementStirng: string)
  }
}
