//
//  DataManager.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import PromiseKit
import ObjectMapper

class DataManager {
  static let instance = DataManager()
  var verificationToken: String? = nil
  var phoneNumber: String? = ProfileManager.instance.currentProfile?.phoneNumber

  var sportTypes: [SportType] = [] {
    didSet {
      try? StorageHelper.save(sportTypes.toJSONString(), forKey: .sportTypes)
    }
  }

  var myEvents: [Event] = [] {
    didSet {
      try? StorageHelper.save(myEvents.toJSONString(), forKey: .myEvents)
    }
  }

  private init() {
    if let sportTypesJSON: String = StorageHelper.loadObjectForKey(.sportTypes) {
      sportTypes = Mapper<SportType>().mapArray(JSONString: sportTypesJSON) ?? []
    }
    if let eventsJSON: String = StorageHelper.loadObjectForKey(.myEvents) {
      myEvents = Mapper<Event>().mapArray(JSONString: eventsJSON) ?? []
    }
  }

  func fetchCities() -> Promise<[City]> {
    return NetworkManager.doRequest(.getCities).then { result in
      guard let cities = Mapper<City>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: cities)
    }
  }

  func fetchEvents(sportType: SportType, date: Date) -> Promise<[Event]> {
    guard let coordinate = ProfileManager.instance.currentCoordinate else { return Promise(error: DataError.unknown) }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-YYYY"
    let params: [String: Any] = [
      "latitude": coordinate.latitude,
      "longitude": coordinate.longitude,
      "date": dateFormatter.string(from: date)
    ]
    return NetworkManager.doRequest(.getEvents(sportTypeId: sportType.id), params).then { result in
      guard let events = Mapper<Event>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: events)
    }
  }

  func fetchEvent(eventId: Int) -> Promise<Event> {
    return NetworkManager.doRequest(.getEvent(eventId: eventId)).then { result in
      guard let event = Mapper<Event>().map(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: event)
    }
  }

  func fetchSportTypes() -> Promise<[SportType]> {
    guard let coordinate = ProfileManager.instance.currentCoordinate else { return Promise(error: DataError.unknown) }
    let params: [String: Any] = [
      "latitude": coordinate.latitude,
      "longitude": coordinate.longitude,
    ]
    return NetworkManager.doRequest(.getSportTypes, params).then { result in
      guard let sportTypes = Mapper<SportType>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      self.sportTypes = sportTypes
      return Promise(value: sportTypes)
    }
  }

  func createMembership(eventId: Int, password: String? = nil) -> Promise<Membership> {
    var params: [String: Any] = [:]
    if let password = password {
      params["password"] = password
    }
    return NetworkManager.doRequest(.createMembership(eventId: eventId), params).then { result in
      guard let eventMember = Mapper<Membership>().map(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: eventMember)
    }
  }

  func fetchMemberships(eventId: Int) -> Promise<[Membership]> {
    return NetworkManager.doRequest(.getEventMemberships(eventId: eventId)).then { result in
      guard let invitedUsers = Mapper<Membership>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: invitedUsers)
    }
  }

  func deleteMembership(membershipId: Int) -> Promise<Void> {
    return NetworkManager.doRequest(.deleteMembership(membershipId: membershipId)).asVoid()
  }

  func joinTeam(eventId: Int, teamIndex: Int) -> Promise<Void> {
    return NetworkManager.doRequest(.joinTeam(eventId: eventId), ["team_number": teamIndex]).asVoid()
  }

  func leaveTeam(eventId: Int, membershipId: Int) -> Promise<Void> {
    return NetworkManager.doRequest(.leaveTeam(eventId: eventId, membershipId: membershipId)).asVoid()
  }

  func vote(eventId: Int, userId: Int) -> Promise<Void> {
    let json: [String: Any] = ["voted_user_id": userId as Any]
    return NetworkManager.doRequest(.vote(eventId: eventId), json).asVoid()
  }

  func createReport(eventId: Int, reports: [Report]) -> Promise<Void> {
    let json = Mapper<Report>().toJSONArray(reports)
    return NetworkManager.doRequest(.vote(eventId: eventId), json.asParameters()).asVoid()
  }

  func fetchInvites() -> Promise<[InviteResponse]> {
    return NetworkManager.doRequest(.getInvites).then { result in
      guard let invites = Mapper<InviteResponse>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: invites)
    }
  }

  func fetchMemberships() -> Promise<[Event]> {
    return NetworkManager.doRequest(.getMemberships).then { result in
      guard let eventMemberships = Mapper<EventMembership>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      self.myEvents = eventMemberships.map { $0.event }.sorted { $0.startsAt > $1.startsAt }
      return Promise(value: self.myEvents)
    }
  }

  func acceptInvite(inviteId: Int) -> Promise<Void> {
    let json: [String: Any] = ["accepted": true as Any]
    return NetworkManager.doRequest(.acceptInvite(inviteId: inviteId), json).asVoid()
  }

  func declineInvite(inviteId: Int) -> Promise<Void> {
    return NetworkManager.doRequest(.deleteInvite(inviteId: inviteId)).asVoid()
  }

  func createEvent(event: Event) -> Promise<Void> {
    return NetworkManager.doRequest(.createEvent, ["event": event.toJSON()]).then { result in
      guard let event = Mapper<Event>().map(JSONObject: result) else { return Promise(error: DataError.unexpectedResponseFormat) }
      self.myEvents.insert(event, at: 0)
      return Promise(value: ())
    }
  }

  func editEvent(event: Event) -> Promise<Void> {
    return NetworkManager.doRequest(.editEvent(eventId: event.id), ["event": event.toJSON()]).asVoid()
  }

  func createVerificationToken(phoneNumber: String) -> Promise<Void> {
    return NetworkManager.doRequest(.createVerificationToken, ["phone_number": phoneNumber]).then { result in
      let json = JSON(result)
      self.verificationToken = json["token"].string
      self.phoneNumber = phoneNumber
      return Promise(value: ())
    }
  }

  func verifyToken(code: String) -> Promise<Void> {
    guard let verificationToken = self.verificationToken else { return Promise(error: DataError.unknown) }
    return NetworkManager.doRequest(.verifyToken(verificationToken: verificationToken), ["code": code as Any, "token": verificationToken as Any]).then { result in
      let json = JSON(result)
      try? StorageHelper.save(json["api_token"].string, forKey: .apiToken)
      return Promise(value: ())
    }
  }

  func updateUser(profile: User) -> Promise<Void> {
    return NetworkManager.doRequest(.updateUser, ["user": profile.toJSON()]).asVoid()
  }

  func updateAvatar(imageString: String, profile: User) -> Promise<Void> {
    var userJSON = profile.toJSON()
    userJSON["avatar"] = imageString as Any
    return NetworkManager.doRequest(.updateUser, ["user": userJSON]).asVoid()
  }

  func addPromoCode(_ code: String) -> Promise<Void> {
    return NetworkManager.doRequest(.addPromoCode, ["code": code as Any]).then { result in

      return Promise(value: ())
    }
  }

  func createUser(profile: User) -> Promise<Void> {
    profile.phoneNumber = phoneNumber ?? ""
    return NetworkManager.doRequest(.createUser, ["user": profile.toJSON()]).then { result in
      guard let token = JSON(result)["api_token"].string else { return Promise(error: DataError.unknown) }
      try? StorageHelper.save(token, forKey: .apiToken)
      return Promise(value: ())
    }
  }

  func fetchUser() -> Promise<User> {
    guard let apiToken: String = StorageHelper.loadObjectForKey(.apiToken) else { return Promise(error: DataError.unknown) }
    return NetworkManager.doRequest(.getUser).then { result in
      guard let user = Mapper<User>().map(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      ProfileManager.instance.currentProfile = user
      return Promise(value: user)
    }
  }
}

