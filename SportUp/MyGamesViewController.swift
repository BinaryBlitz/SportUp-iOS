//
//  MyGamesViewController.swift
//  SportUp
//
//  Created by Алексей on 25.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "MyGamesTableViewCell"

class MyGamesViewController: UITableViewController, DefaultBarStyleViewController {
  var myEvents: [Event] = DataManager.instance.myEvents {
    didSet {
      tableView.reloadData()
    }
  }
  var invites: [InviteResponse] = []

  enum Sections: Int {
    case invites = 0
    case createdGames
    case currentGames
    case finishedGames

    static let count = 4

    var name: String {
      switch self {
      case .invites:
        return "Приглашения на игры"
      case .createdGames:
        return "Созданные игры"
      case .currentGames:
        return "Текущие игры"
      case .finishedGames:
        return "Завершенные игры"
      }
    }
  }

  var currentInvites: [InviteResponse] {
    return invites.filter { inviteResponse in
      let isAccepted = inviteResponse.invite?.accepted ?? false
      return !isAccepted && inviteResponse.event?.membership == nil
    }
  }

  var createdGames: [Event] {
    return myEvents.filter { event in
      return event.isMine && !event.finished
    }
  }

  var currentEvents: [Event] {
    return myEvents.filter { event in
      return !event.isMine && !event.finished
    }
  }

  var finishedEvents: [Event] {
    return myEvents.filter { event in
      return event.finished
    }
  }

  override func viewDidLoad() {
    tabBarItem.title = "Мои игры"
    tabBarItem.image = #imageLiteral(resourceName: "iconTabMygames")
    refresh()

    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonDidTap))
  }

  func addButtonDidTap() {
    let viewControlelr = EventManageViewController.storyboardInstance()!
    let navigationController = SportUpNavigationController(rootViewController: viewControlelr)
    present(navigationController, animated: true, completion: nil)
  }

  func refresh() {
    myEvents = DataManager.instance.myEvents
    _ = DataManager.instance.fetchMemberships().then { [weak self] events -> Void in
      self?.myEvents = events
    }

    _ = DataManager.instance.fetchInvites().then { [weak self] invites -> Void in
      self?.invites = invites
      self?.tableView.reloadData()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = false
    refresh()
    guard !ProfileManager.instance.isAuthorized else { return }
    let registrationNavigationViewController = SportUpNavigationController(rootViewController: RegistrationPhoneInputViewController.storyboardInstance()!)
    present(registrationNavigationViewController, animated: true, completion: { [weak self] _ in
      self?.tabBarController?.selectedIndex = 0
    })
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case Sections.invites.rawValue:
      return currentInvites.count
    case Sections.createdGames.rawValue:
      return createdGames.count
    case Sections.currentGames.rawValue:
      return currentEvents.count
    case Sections.finishedGames.rawValue:
      return finishedEvents.count
    default:
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case Sections.invites.rawValue where !currentInvites.isEmpty:
      break
    case Sections.createdGames.rawValue where !createdGames.isEmpty:
      break
    case Sections.currentGames.rawValue where !currentEvents.isEmpty:
      break
    case Sections.finishedGames.rawValue where !finishedEvents.isEmpty:
      break
    default:
      return 0
    }
    return 46
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UITableViewHeaderFooterView()
    let currentSection = Sections(rawValue: section)
    view.textLabel?.textColor = UIColor.sportUpDarkGrey
    view.textLabel?.text = currentSection?.name
    return view
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyGamesTableViewCell
    cell.delegate = self
    switch indexPath.section {
    case Sections.invites.rawValue:
      cell.cellType = .invite(currentInvites[indexPath.row])
    case Sections.createdGames.rawValue:
      cell.cellType = .myGame(createdGames[indexPath.row])
    case Sections.currentGames.rawValue:
      cell.cellType = .currentGame(currentEvents[indexPath.row])
    case Sections.finishedGames.rawValue:
      cell.cellType = .finishedGame(finishedEvents[indexPath.row])
    default:
      break
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let event: Event
    switch indexPath.section {
    case Sections.invites.rawValue:
      guard let currentEvent = currentInvites[indexPath.row].event else { return }
      event = currentEvent
    case Sections.createdGames.rawValue:
      event = createdGames[indexPath.row]
      let viewController = EventManageViewController.storyboardInstance()!
      viewController.screenType = .edit(event: event)
      navigationController?.pushViewController(viewController, animated: true)
      return
    case Sections.currentGames.rawValue:
      event = currentEvents[indexPath.row]
    case Sections.finishedGames.rawValue:
      event = finishedEvents[indexPath.row]
    default:
      return
    }
    let viewController = EventInfoViewController.storyboardInstance()!
    viewController.event = event
    viewController.sportType = event.sportType
    navigationController?.pushViewController(viewController, animated: true)
  }

}

extension MyGamesViewController: MyGamesTableViewCellDelegate {
  func accept(invite: Invite) {
    _ = DataManager.instance.acceptInvite(inviteId: invite.id).then { [weak self] _ -> Void in
      self?.refresh()
    }
  }

  func decline(invite: Invite) {
    _ = DataManager.instance.declineInvite(inviteId: invite.id).then { [weak self] _ -> Void in
      guard let index = self?.invites.index(where: { $0.invite?.id == invite.id }) else { return }
      self?.invites.remove(at: index)
      self?.tableView.reloadSections(IndexSet(integer: Sections.invites.rawValue), with: .automatic)
    }
  }

  func leave(membership: Membership) {
    _ = DataManager.instance.deleteMembership(membershipId: membership.id).then { [weak self] _ -> Void in
      guard let index = self?.myEvents.index(where: { $0.membership?.id == membership.id }) else { return }
      self?.myEvents.remove(at: index)
      self?.tableView.reloadSections(IndexSet(integer: Sections.currentGames.rawValue), with: .automatic)
    }
  }
}
