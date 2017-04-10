//
//  SportTypesViewController.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "SportTypeTableViewCell"

class SportTypesViewController: UITableViewController, DefaultBarStyleViewController {
  var sportTypes: [SportType] = DataManager.instance.sportTypes

  override func viewDidLoad() {
    tabBarItem.title = "Поиск игр"
    tabBarItem.image = #imageLiteral(resourceName: "iconTabSearchgames")

    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    tableView.tableFooterView = UIView()
    self.refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(SportTypesViewController.refresh), for: .valueChanged)
    refresh()
  }

  func refresh() {
    _ = DataManager.instance.fetchSportTypes().then { [weak self] sportTypes -> Void in
      self?.sportTypes = sportTypes
      self?.tableView.reloadData()
      self?.refreshControl?.endRefreshing()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    guard let indexPath = tableView.indexPathForSelectedRow else { return }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  // MARK: - Table View
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sportTypes.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SportTypeTableViewCell
    cell.configure(sportType: sportTypes[indexPath.row])
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let gamesFeedViewController = GamesFeedViewController.storyboardInstance()!
    gamesFeedViewController.sportType = sportTypes[indexPath.row]
    navigationController?.pushViewController(gamesFeedViewController, animated: true)
  }
}

extension SportTypesViewController {
  // MARK: - Table View Header
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 16
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor.sportUpPaleGrey
    return view
  }
}
