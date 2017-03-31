//
//  TextInputViewController.swift
//  SportUp
//
//  Created by Алексей on 31.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "TextInputTableViewCell"

class TextInputViewController: UITableViewController, DefaultBarStyleViewController {

  var textInputTableViewCell = TextInputTableViewCell.nibInstance()!

  var keyboardType: UIKeyboardType {
    get {
      return textInputTableViewCell.textField.keyboardType
    }
    set {
      textInputTableViewCell.textField.keyboardType = newValue
    }
  }

  var didFinishEditingHandler: ((String) -> ())? = nil

  var value: String {
    get {
      return textInputTableViewCell.textField.text ?? ""
    }
    set {
      textInputTableViewCell.textField.text = newValue
    }
  }

  init() {
    super.init(style: .grouped)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    tableView.register(TextInputTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return textInputTableViewCell
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  override func viewWillDisappear(_ animated: Bool) {
    didFinishEditingHandler?(value)
  }
}