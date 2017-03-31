//
//  UIViewController+addToolbar.swift
//  SportUp
//
//  Created by Алексей on 31.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: UITextFieldDelegate, UITextViewDelegate {
  var textToolbar: UIToolbar {
    let toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor.sportUpGunmetal
    let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(self.donePressed))
    toolBar.setItems([doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    toolBar.sizeToFit()
    return toolBar
  }
  
  func addToolbar(textField: UITextField){
    textField.delegate = self
    textField.inputAccessoryView = textToolbar
  }

  func addToolbar(textView: UITextView){
    textView.inputAccessoryView = textToolbar
  }

    func donePressed() {
      view.endEditing(true)
    }

}
