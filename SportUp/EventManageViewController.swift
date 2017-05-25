//
//  EventManageViewController.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

// MARK:- TODO: refactor
import Foundation
import UIKit
import CoreLocation

private enum Sections: Int {
  case mainInfo = 0
  case dateTime
  case sportType
  case playersCount
  case price
  case privacy
  case description

  static let count = 7
}

private enum MainInfoRows: Int {
  case nameRow
  case locationRow
}

private enum DateTimeSectionRows: Int {
  case startsAtLabels = 0
  case startAtDatePicker
  case endsAtLabels
  case endsAtDatePicker
}

private enum GameLimitsSectionRows: Int {
  case playersCount = 0
  case teamsCount
}

private enum PrivacyRows: Int {
  case privacySwitch = 0
  case password
}


private let datePickerCellHeight: CGFloat = 220
private let passwordPickerCellHeight: CGFloat = 81

class EventManageViewController: UITableViewController, SelfControlledBarStyleViewController {
  // MARK: - Outlets
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
  @IBOutlet weak var saveButton: UIButton!

  var sportTypes: [SportType] = DataManager.instance.sportTypes

  // MARK: - Properties

  var address: String? = nil {
    didSet {
      addressField.text = address
    }
  }
  var name: String? {
    set {
      nameField.text = newValue
    }
    get {
      return nameField.text
    }
  }
  var coordinate: CLLocationCoordinate2D?

  var descriptionText: String? {
    set {
      descriptionTextView.text = descriptionText ?? ""
    }
    get {
      return descriptionTextView.text
    }
  }
  var sportType: SportType? = nil {
    didSet {
      sportTypeLabel.text = sportType?.name
      configureNavigationBar()
      tableView.reloadData()
    }
  }
  var playersCount: Int = 0 {
    didSet {
      playersCountField.text = "\(playersCount)"
    }
  }
  var teamsCount: Int = 0 {
    didSet {
      teamsCountField.text = "\(teamsCount)"
    }
  }
  var price: Int = 0 {
    didSet {
      priceField.text = price == 0 ? "Бесплатно" : Double(price).currencyString
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
      privacyIconView.isHighlighted = !isPublic
      privacySwitch.isOn = !isPublic
      tableView.reloadData()
      if isPublic { password = "" }
    }
  }
  var password: String? {
    set {
      passwordField.text = newValue
    }
    get {
      return passwordField.text
    }
  }

  enum ScreenType {
    case edit(event: Event)
    case create
  }

  var screenType: ScreenType = .create

  override func viewDidLoad() {
    configureView()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    switch screenType {
    case .create:
      navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCanselWhite"), style: .plain, target: self, action: #selector(self.navCancelButtonDidTap))
    default:
      break
    }
  }

  func navCancelButtonDidTap() {
    dismiss(animated: true, completion: nil)
  }

  func configureNavigationBar() {
    navigationController?.navigationBar.tintColor = sportType == nil ? UIColor.black : UIColor.white
    navigationController?.navigationBar.barTintColor = sportType?.color ?? UIColor.white
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: sportType == nil ? UIColor.black : UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 17)]

    UIApplication.shared.statusBarStyle = sportType == nil ? .default : .lightContent

  }
  
  @IBAction func saveButtonDidTap(_ sender: Any?) {
    view.endEditing(true)
    navigationItem.rightBarButtonItem?.isEnabled = false
    switch screenType {
    case .create:
      let event = Event()
      do {
        try updateEvent(event: event)
      } catch {
        navigationItem.rightBarButtonItem?.isEnabled = true
        guard let error = error as? DataError else { return }
        presentAlertWithTitle("Ошибка", andMessage: error.description)
        return
      }
      DataManager.instance.createEvent(event: event).then { [weak self] in
        self?.dismiss(animated: true, completion: nil)
      }.catch { [weak self] error in
        self?.navigationItem.rightBarButtonItem?.isEnabled = true
        self?.presentAlertWithMessage("Ошибка")
      }
    case .edit(let event):
      do {
        try updateEvent(event: event)
      } catch {
        navigationItem.rightBarButtonItem?.isEnabled = true
        guard let error = error as? DataError else { return }
        presentAlertWithTitle("Ошибка", andMessage: error.description)
        return
      }
      DataManager.instance.editEvent(event: event).then { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      }.catch { [weak self] error in
        self?.navigationItem.rightBarButtonItem?.isEnabled = true
        self?.presentAlertWithMessage("Ошибка")
      }
    }
  }

  func updateEvent(event: Event) throws {
    var alertMessage = ""
    let name = self.name ?? ""
    if name.trimmingCharacters(in: .whitespaces).isEmpty {
      alertMessage += "Укажите название игры"
    }
    event.name = name
    let address = self.address ?? ""
    event.address = address
    event.description = self.descriptionText ?? ""
    event.endsAt = endsAt
    event.startsAt = startsAt
    if startsAt.time > endsAt.time {
      alertMessage += "\nВермя начала игры не может быть позже времени окончания"
    }
    event.isPublic = isPublic
    if !event.isPublic {
      if let password = password {
        event.password = password
      } else {
        alertMessage += "\n Укажите пароль приватной игры"
      }
    }
    
    if let sportType = sportType {
      event.sportType = sportType
    } else {
      alertMessage += "\nВыберите вид спорта"
    }
    event.price = Double(price)
    if playersCount == 0 {
      alertMessage += "\nВыберите количество участников"
    }
    event.userLimit = playersCount
    if teamsCount == 0 {
      alertMessage += "\nУкажите количество команд"
    }
    event.teamLimit = teamsCount
    if let latitude = coordinate?.latitude, let longitude = coordinate?.longitude, !address.trimmingCharacters(in: .whitespaces).isEmpty {
      event.latitude = latitude
      event.longitude = longitude
    } else {
      alertMessage += "\nВыберите адрес"
    }
    if !alertMessage.isEmpty {
      throw DataError.validationFailed(message: alertMessage)
    }
  }

  func configureView() {
    nameField.delegate = self
    descriptionTextView.delegate = self
    passwordField.delegate = self
    addToolbar(textView: descriptionTextView)
    addressField.isEnabled = false
    playersCountField.isEnabled = false
    teamsCountField.isEnabled = false
    priceField.isEnabled = false
    startDatePicker.isHidden = true
    endDatePicker.isHidden = true
    switch screenType {
    case .create:
      cancelButton.isHidden = true
      navigationItem.title = "Создание события"
      startsAt = Date()
      endsAt = Date()
    case .edit(let event):
      cancelButton.isHidden = false
      address = event.address
      name = event.name
      startsAt = event.startsAt
      endsAt = event.endsAt
      isPublic = event.isPublic
      password = event.password
      playersCount = event.userLimit
      price = Int(event.price)
      teamsCount = event.teamLimit
      sportType = event.sportType
      descriptionTextView.text = event.description
      coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
      saveButton.setTitle("Сохранить изменения", for: .normal)
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
    isPublic = !sender.isOn
  }

  @IBAction func cancelButtonDidTap(_ sender: GoButton) {
    
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
    configureNavigationBar()
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
}

// MARK: - Table view
extension EventManageViewController {

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard section != Sections.mainInfo.rawValue else { return 0 }
    return 8
  }

  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 8
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    if section == Sections.mainInfo.rawValue {
      view.backgroundColor = sportType?.color ?? UIColor.sportUpAquaMarine
    } else {
      view.backgroundColor = UIColor.sportUpPaleGrey
    }
    return view
  }

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
      return datePicker.isHidden ? 0 : datePickerCellHeight
    case Sections.privacy.rawValue where indexPath.row == PrivacyRows.password.rawValue:
      return isPublic ? 0 : passwordPickerCellHeight
    default:
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    view.endEditing(true)
    switch indexPath.section {
    case Sections.dateTime.rawValue:
      return didSelectDateTimeCell(indexPath: indexPath)
    case Sections.playersCount.rawValue:
      return didSelectGameLimitsCell(indexPath: indexPath)
    case Sections.mainInfo.rawValue:
      guard indexPath.row == MainInfoRows.locationRow.rawValue else { return }
      let viewController = AddressSelectViewController.storyboardInstance()!
      viewController.selectAddressHandler = { [weak self] in
        self?.address = $0
        self?.coordinate = viewController.coordinate
      }
      navigationController?.pushViewController(viewController, animated: true)
    case Sections.price.rawValue:
      let viewController = TextInputViewController(title: "Цена")
      viewController.value = price > 0 ? "\(price)" : ""
      viewController.keyboardType = .numberPad
      viewController.didFinishEditingHandler =  { [weak self] in
        self?.price = Int($0) ?? 0
      }
      navigationController?.pushViewController(viewController, animated: true)
    case Sections.sportType.rawValue:
      let viewController = SelectSportTypeViewController(title: "Вид спорта")
      viewController.sportTypes = sportTypes
      viewController.didFinishEditingHandler = { [weak self] in
        self?.sportType = $0
      }
      navigationController?.pushViewController(viewController, animated: true)
    case Sections.description.rawValue:
      tableView.deselectRow(at: indexPath, animated: true)
      descriptionTextView.becomeFirstResponder()
    default:
      tableView.deselectRow(at: indexPath, animated: true)
    }
    hidePickers()
  }

  func hidePickers() {
    endDatePicker.isHidden = true
    startDatePicker.isHidden = true
    tableView.beginUpdates()
    tableView.endUpdates()
  }

  func didSelectGameLimitsCell(indexPath: IndexPath) {
    switch indexPath.row {
    case GameLimitsSectionRows.playersCount.rawValue:
      let viewController = TextInputViewController(title: "Количество участников")
      viewController.value = playersCount > 0 ? "\(playersCount)" : ""
      viewController.keyboardType = .numberPad
      viewController.didFinishEditingHandler =  { [weak self] in
        self?.playersCount = Int($0) ?? 0
      }
      navigationController?.pushViewController(viewController, animated: true)
    case GameLimitsSectionRows.teamsCount.rawValue:
      let viewController = TextInputViewController(title: "Количество команд")
      viewController.value = teamsCount > 0 ? "\(teamsCount)" : ""
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
      endDatePicker.isHidden = true
    case DateTimeSectionRows.endsAtLabels.rawValue:
      startDatePicker.isHidden = true
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
  func textViewDidBeginEditing(_ textView: UITextView) {
    hidePickers()
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    hidePickers()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
}
