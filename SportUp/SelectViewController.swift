//
//  SelectViewController.swift
//  SportUp
//
//  Created by Алексей on 31.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class SelectSportTypeViewController: UITableViewController, DefaultBarStyleViewController {
  var didFinishEditingHandler: ((SportType) -> ())? = nil

  var sportTypes: [SportType] = []
  var value: SportType? = nil

  var titleText: String

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let tableViewCell = UITableViewCell()
    let sportType = sportTypes[indexPath.row]
    tableViewCell.textLabel?.text = sportType.name
    tableViewCell.accessoryType = value?.id == sportType.id ? .checkmark : .none
    return tableViewCell
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sportTypes.count
  }

  override func viewDidLoad() {
    navigationItem.title = titleText
  }

  init(title: String) {
    self.titleText = title
    super.init(style: .grouped)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    value = sportTypes[indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
    tableView.reloadData()
  }

  override func viewWillDisappear(_ animated: Bool) {
    guard let value = value else { return }
    didFinishEditingHandler?(value)
  }
}
