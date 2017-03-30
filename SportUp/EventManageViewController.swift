//
//  EventManageViewController.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class EventManageViewController: UITableViewController, DefaultBarStyleViewController {
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var addressField: UITextField!
  @IBOutlet weak var startDateTimeLabel: UILabel!
  @IBOutlet weak var startDatePicker: UIDatePicker!
  @IBOutlet weak var endDatePicker: UIDatePicker!
  @IBOutlet weak var endTimeLabel: UILabel!
  @IBOutlet weak var sportTypeLabel: UILabel!
  @IBOutlet weak var playersCountField: UITextField!
  @IBOutlet weak var teamsCountField: UITextField!
  @IBOutlet weak var priceField: UITextField!
  @IBOutlet weak var privacySwitch: UISwitch!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var cancelButton: GoButton!
  @IBOutlet weak var descriptionTextView: UITextView!

  @IBOutlet weak var privacyIconView: UIImageView!
  @IBOutlet weak var privacyLabel: UILabel!

  var sportTypes: [SportType] = DataManager.instance.sportTypes

  var address: String? = nil {
    didSet {
      addressField.text = address
    }
  }
  var name: String? = nil {
    didSet {
      nameField.text = name
    }
  }
  var descriptionText: String? = nil {
    didSet {
      descriptionTextView.text = description
    }
  }
  var sportType: SportType? = nil {
    didSet {
      sportTypeLabel.text = sportType?.name
    }
  }
  var playersCount: Int = 0 {
    didSet {
      playersCountField.text = "\(playersCount)"
    }
  }
  var teamsCount: Int = 0 {
    didSet {
      teamsCountField.text = "\(playersCount)"
    }
  }
  var price: Int = 0 {
    didSet {
      priceField.text = Double(price).currencyString
    }
  }
  var startsAt: Date = Date() {
    didSet {
      startDateTimeLabel.text = "\(startsAt.mediumDate)  \(startsAt.time)"
    }
  }
  var endsAt: Date = Date() {
    didSet {
      endTimeLabel.text = endsAt.time
    }
  }
  var isPublic: Bool = true {
    didSet {
      privacyLabel.text = isPublic ? "Публичное" : "Приватное"
      privacyIconView.isHighlighted = isPublic
      privacySwitch.isOn = !isPublic
      tableView.reloadData()
      if isPublic { password = "" }
    }
  }
  var password: String? = nil {
    didSet {
      passwordField.text = password
    }
  }

  enum ScreenType {
    case edit(event: Event)
    case create
  }

  var screenType: ScreenType = .create

  enum Sections: Int {
    case mainInfo = 0
    case dateTime
    case sportType
    case playersCount
    case price
    case privacy
    case description

    static let count = 7
  }

  enum MainInfoRows: Int {
    case nameRow
    case locationRow
  }

  enum DateTimeSectionRows: Int {
    case startsAtLabels = 0
    case startAtDatePicker
    case endsAtLabels
    case endsAtDatePicker
  }

  enum GameLimitsSectionRows: Int {
    case playersCount = 0
    case teamsCount
  }

  enum PrivacyRows: Int {
    case privacySwitch = 0
    case password
  }

  override func viewDidLoad() {
    configureView()
    navigationController?.navigationBar.tintColor = UIColor.black
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }

  func configureView() {
    nameField.delegate = self
    addToolbar(textField: nameField)
    passwordField.delegate = self
    addToolbar(textField: passwordField)
    addToolbar(textView: descriptionTextView)
    addressField.isEnabled = false
    playersCountField.isEnabled = false
    teamsCountField.isEnabled = false
    priceField.isEnabled = false
    startDatePicker.isHidden = true
    endDatePicker.isHidden = true
    switch screenType {
    case .create:
      tableView.tableFooterView = nil
      navigationItem.title = "Создание события"
    case .edit(let event):
      address = event.address
      name = event.name
      startsAt = event.startsAt
      endsAt = event.endsAt
      isPublic = event.isPublic
      password = event.password
      playersCount = event.userLimit
      teamsCount = event.teamLimit
      descriptionText = event.description
      navigationItem.title = "Редактирование события"
    }
  }

  @IBAction func startDatePickerDidChange(_ sender: UIDatePicker) {
    startsAt = sender.date
  }

  @IBAction func endDatePickerDidChange(_ sender: UIDatePicker) {
    endsAt = sender.date
  }

  @IBAction func privacySwitchDidChange(_ sender: UISwitch) {
    isPublic = sender.isOn
  }

  @IBAction func cancelButtonDidTap(_ sender: GoButton) {
    
  }
  
}

extension EventManageViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case Sections.dateTime.rawValue:
      let datePicker: UIDatePicker
      switch indexPath.row {
      case DateTimeSectionRows.startAtDatePicker.rawValue:
        datePicker = startDatePicker
      case DateTimeSectionRows.endsAtDatePicker.rawValue:
        datePicker = endDatePicker
      default:
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
      return datePicker.isHidden ? 0 : 220
    case Sections.privacy.rawValue where indexPath.row == PrivacyRows.password.rawValue:
      return isPublic ? 0 : 71
    default:
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case Sections.dateTime.rawValue:
      return didSelectDateTimeCell(indexPath: indexPath)
    case Sections.playersCount.rawValue:
      return didSelectGameLimitsCell(indexPath: indexPath)
    case Sections.mainInfo.rawValue:
      guard indexPath.row == MainInfoRows.locationRow.rawValue else { return }
      let viewController = AddressSelectViewController.storyboardInstance()!
      navigationController?.pushViewController(viewController, animated: true)
    case Sections.price.rawValue:
      let viewController = TextInputViewController()
      viewController.value = "\(price)"
      viewController.keyboardType = .numberPad
      viewController.didFinishEditingHandler =  { [weak self] in
        self?.price = Int($0) ?? 0
      }
      navigationController?.pushViewController(viewController, animated: true)
    case Sections.sportType.rawValue:
      let viewController = SelectSportTypeViewController()
      viewController.sportTypes = sportTypes
      viewController.didFinishEditingHandler = { [weak self] in
        self?.sportType = $0
      }
      navigationController?.pushViewController(viewController, animated: true)
    default:
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }

  func didSelectGameLimitsCell(indexPath: IndexPath) {
    switch indexPath.row {
    case GameLimitsSectionRows.playersCount.rawValue:
      let viewController = TextInputViewController()
      viewController.value = "\(playersCount)"
      viewController.keyboardType = .numberPad
      viewController.didFinishEditingHandler =  { [weak self] in
        self?.playersCount = Int($0) ?? 0
      }
      navigationController?.pushViewController(viewController, animated: true)
    case GameLimitsSectionRows.teamsCount.rawValue:
      let viewController = TextInputViewController()
      viewController.value = "\(teamsCount)"
      viewController.keyboardType = .numberPad
      viewController.didFinishEditingHandler =  { [weak self] in
        self?.teamsCount = Int($0) ?? 0
      }
      navigationController?.pushViewController(viewController, animated: true)
    default:
      return tableView.deselectRow(at: indexPath, animated: true)
    }

  }

  func didSelectDateTimeCell(indexPath: IndexPath) {
    let datePicker: UIDatePicker
    switch indexPath.row {
    case DateTimeSectionRows.startsAtLabels.rawValue:
      datePicker = startDatePicker
    case DateTimeSectionRows.endsAtLabels.rawValue:
      datePicker = endDatePicker
    default:
      return tableView.deselectRow(at: indexPath, animated: true)
    }
    datePicker.isHidden = !datePicker.isHidden
    tableView.beginUpdates()
    tableView.deselectRow(at: indexPath, animated: true)
    tableView.endUpdates()
  }
}

extension EventManageViewController {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
}
