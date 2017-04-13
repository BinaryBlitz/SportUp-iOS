//
//  UserProfileViewController.swift
//  SportUp
//
//  Created by Алексей on 01.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

private let balanceCellIdentifier = "ProfileBalanceTableViewCell"
private let buyTicketsCellIdentifier = "ProfileBuyTicketsTableViewCell"
private let earnTicketsCellIdentifier = "ProfileEarnTicketsTableViewCell"
private let headerReuseIdentifier = String(describing: UserProfileTableHeaderView.self)

enum TestActions: Int {
  case rating = 0
  case invite
  case share

  static let count = 3

  var icon: UIImage {
    switch self {
    case .rating:
      return #imageLiteral(resourceName: "iconFeedback")
    case .invite:
      return #imageLiteral(resourceName: "iconInvitefriend")
    case .share:
      return #imageLiteral(resourceName: "iconShare")
    }
  }

  var ticketsCount: Int {
    switch self {
    case .rating:
      return 1
    case .invite:
      return 2
    case .share:
      return 3
    }
  }

  var name: String {
    switch self {
    case .rating:
      return "Оставить отзыв"
    case .invite:
      return "Пригласить друга"
    case .share:
      return "Поделиться"
    }
  }
}

class UserProfileViewController: UIViewController, DefaultBarStyleViewController {
  @IBOutlet weak var avatarOuterView: UIView!
  @IBOutlet weak var bestPlayerCountLabel: UILabel!
  @IBOutlet weak var gamesPlayedCountLabel: UILabel!
  @IBOutlet weak var yellowCardsCountLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!

  let avatarView = AvatarView.nibInstance()!

  enum Sections: Int {
    case balance = 0
    case buyTickets
    case earnTickets

    static let count = 3

    var name: String? {
      switch self {
      case .balance:
        return nil
      case .buyTickets:
        return "Купить билеты"
      case .earnTickets:
        return "Заработать билеты"
      }
    }
  }

  var testProducts: [(ticketsCount: Int, price: Double)] = []

  func configureTestProducts() {
    testProducts.append((ticketsCount: 2, price: 30))
    testProducts.append((ticketsCount: 5, price: 100))
    testProducts.append((ticketsCount: 10, price: 150))
    reloadData()
  }

  override func viewDidLoad() {
    configureTestProducts()
    avatarOuterView.addSubview(avatarView)
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "edit"), style: .plain, target: self, action: #selector(UserProfileViewController.rightBarButtonDidTap))
    let nib = UINib(nibName: headerReuseIdentifier, bundle: nil)
    tableView.register(nib, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)

    _ = DataManager.instance.fetchUser().always { [weak self] in
      self?.reloadData()
    }
  }

  func reloadData() {
    guard let profile = ProfileManager.instance.currentProfile else { return }
    navigationItem.title = profile.fullName
    avatarView.configure(user: profile)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadData()
    guard !ProfileManager.instance.isAuthorized else { return }
    let registrationNavigationViewController = SportUpNavigationController(rootViewController: RegistrationPhoneInputViewController.storyboardInstance()!)
    present(registrationNavigationViewController, animated: true, completion: { [weak self] _ in
      self?.tabBarController?.selectedIndex = 0
    })

  }

  func rightBarButtonDidTap() {
    navigationController?.pushViewController(ProfileEditViewController.storyboardInstance()!, animated: true)
  }

  @IBAction func signOutButtonDidTap(_ sender: Any) {
    ProfileManager.instance.signOut()
  }

  @IBAction func promoCodeButtonDidTap(_ sender: UIButton) {
    let viewController = UINavigationController(rootViewController: PromoCodeAlertViewController.storyboardInstance()!)
    present(viewController, animated: true, completion: nil)
  }

}

extension UserProfileViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case Sections.balance.rawValue:
      return 1
    case Sections.buyTickets.rawValue:
      return testProducts.count
    case Sections.earnTickets.rawValue:
      return TestActions.count
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch indexPath.section {
    case Sections.balance.rawValue:
      let balanceCell = tableView.dequeueReusableCell(withIdentifier: balanceCellIdentifier) as! ProfileBalanceTableViewCell
      cell = balanceCell
    case Sections.buyTickets.rawValue:
      let buyCell = tableView.dequeueReusableCell(withIdentifier: buyTicketsCellIdentifier) as! ProfileBuyTicketsTableViewCell
      let product = testProducts[indexPath.row]
      buyCell.configure(ticketsCount: product.ticketsCount, price: product.price)
      cell = buyCell
    case Sections.earnTickets.rawValue:
      let earnCell = tableView.dequeueReusableCell(withIdentifier: earnTicketsCellIdentifier) as! ProfileEarnTicketsTableViewCell
      guard let action = TestActions(rawValue: indexPath.row) else { return UITableViewCell() }
      earnCell.configure(action: action)
      cell = earnCell
    default:
      cell = UITableViewCell()
    }

    return cell
  }
}

extension UserProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as! UserProfileTableHeaderView
    header.nameLabel?.text = Sections(rawValue: section)?.name
    return header
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 17
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == Sections.balance.rawValue ? 72 : 60
  }
}
