//
//  BestPlayersPollViewController.swift
//  SportUp
//
//  Created by Алексей on 29.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import AvatarImageView

private let reuseIdentifier = "BestPlayersPollTableViewCell"

class BestPlayersPollViewController: UIViewController {
  @IBOutlet weak var timeStartHoursLabel: UILabel!

  @IBOutlet weak var timeStartMinuteLabel: UILabel!
  @IBOutlet weak var timeFinishesHoursLabel: UILabel!
  @IBOutlet weak var timeFinishesMinutesLabel: UILabel!
  @IBOutlet weak var coutdownLabel: UILabel!

  @IBOutlet weak var tableView: UITableView!

  var currentBestPlayer: User? = nil
  
  var event: Event!
  var teams: [TeamResponse] = []

  var users: [User] {
    return teams.map { $0.users }.reduce([], +)
  }

  override func viewDidLoad() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCanselWhite"), style: .plain, target: self, action: #selector(self.cancelButtonDidTap))
    configureTimeLabels()
    _ = DataManager.instance.fetchTeams(eventId: event.id).then { [weak self] response -> Void in
      self?.teams = response
      self?.tableView.reloadData()
    }
  }

  func cancelButtonDidTap() {
    guard let currentBestPlayer = self.currentBestPlayer else {
      dismiss(animated: true, completion: nil)
      return
    }
    _ = DataManager.instance.vote(eventId: event.id, userId: currentBestPlayer.id).always { [weak self] in
      self?.dismiss(animated: true, completion: nil)
    }
  }

  func configureTimeLabels() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H"
    timeStartHoursLabel.text = dateFormatter.string(from: event.startsAt)
    timeFinishesHoursLabel.text = dateFormatter.string(from: event.endsAt)
    dateFormatter.dateFormat = "mm"
    timeStartMinuteLabel.text = dateFormatter.string(from: event.startsAt)
    timeFinishesMinutesLabel.text = dateFormatter.string(from: event.endsAt)
    let interval = event.startsAt.timeIntervalSinceNow.formattedInterval ?? ""
    coutdownLabel.text = "До завершения голосования " + interval
  }

}

extension BestPlayersPollViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user = users[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BestPlayersPollTableViewCell
    cell.configure(user: user)
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
}

extension BestPlayersPollViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 46
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UITableViewHeaderFooterView()
    view.textLabel?.text = "Выбрать лучшего игрока"
    view.backgroundColor = UIColor.clear
    return view
  }
}
