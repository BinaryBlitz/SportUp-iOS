//
//  SelectViewController.swift
//  SportUp
//
//  Created by Алексей on 31.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "SelectTableViewCell"

class SelectSportTypeViewController: UITableViewController, DefaultBarStyleViewController {
  var didFinishEditingHandler: ((SportType) -> ())? = nil

  var sportTypes: [SportType] = []
  var value: SportType? = nil

  var titleText: String

  override func viewDidLoad() {
    navigationItem.title = titleText
    tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)

    navigationItem.rightBarButtonItem?.isEnabled = false
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let sportType = sportTypes[indexPath.row]
    let tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SelectTableViewCell
    tableViewCell.iconView.kf.setImage(with: sportType.iconUrl) { image, _, _, _ in
      guard let image = image?.withRenderingMode(.alwaysTemplate) else { return }
      tableViewCell.iconView?.image = image
      tableViewCell.iconView?.tintColor = sportType.color
    }
    tableViewCell.nameLabel.text = sportType.name
    tableViewCell.accessoryType = value?.id == sportType.id ? .checkmark : .none
    return tableViewCell
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sportTypes.count
  }

  init(title: String) {
    self.titleText = title
    super.init(style: .grouped)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    didFinishEditingHandler?(sportTypes[indexPath.row])
    _ = navigationController?.popViewController(animated: true)
    tableView.reloadData()
  }
}
