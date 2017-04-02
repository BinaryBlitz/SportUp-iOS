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

  var sportTypes: [SportType] = [] {
    didSet {
      try? StorageHelper.save(sportTypes.toJSONString(), forKey: .sportTypes)
    }
  }

  private init() {
    if let sportTypesJSON: String = StorageHelper.loadObjectForKey(.sportTypes) {
      sportTypes = Mapper<SportType>().mapArray(JSONString: sportTypesJSON) ?? []
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
    guard let city = ProfileManager.instance.currentCity else { return Promise(error: DataError.unknown) }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-YYYY"
    return NetworkManager.doRequest(.getEvents(cityId: city.id, sportTypeId: sportType.id), ["date": dateFormatter.string(from: date)]).then { result in
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
    guard let city = ProfileManager.instance.currentCity else { return Promise(error: DataError.unknown) }
    return NetworkManager.doRequest(.getSportTypes(cityId: city.id)).then { result in
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

  func leaveTeam(eventId: Int) -> Promise<Void> {
    return NetworkManager.doRequest(.leaveTeam(eventId: eventId)).asVoid()
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

  func fetchMemberships() -> Promise<[EventMembership]> {
    return NetworkManager.doRequest(.getMemberships).then { result in
      guard let eventMemberships = Mapper<EventMembership>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: eventMemberships)
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
    return NetworkManager.doRequest(.createEvent, ["event": event.toJSON()]).asVoid()
  }

  func editEvent(event: Event) -> Promise<Void> {
    return NetworkManager.doRequest(.editEvent(eventId: event.id), ["event": event.toJSON()]).asVoid()
  }

  func createVerificationToken(phoneNumber: String) -> Promise<Void> {
    return NetworkManager.doRequest(.createVerificationToken, ["phone_number": phoneNumber]).then { result in
      let json = JSON(result)
      self.verificationToken = json["token"].string
      return Promise(value: ())
    }
  }

  func verifyToken(code: String) -> Promise<Void> {
    guard let verificationToken = self.verificationToken else { return Promise(error: DataError.unknown) }
    return NetworkManager.doRequest(.verifyToken(verificationToken: verificationToken), ["code": code as Any, "token": verificationToken as Any]).then { result in
      let json = JSON(result)
      let token = "foobar" //json["api_token"].string ?? 

      try? StorageHelper.save(token, forKey: .apiToken)
      return Promise(value: ())
    }
  }

  func updateUser(profile: User) -> Promise<Void> {
    return NetworkManager.doRequest(.updateUser, ["user": profile.toJSON()]).asVoid()
  }

  func createUser(profile: User) -> Promise<Void> {
    return NetworkManager.doRequest(.createUser, ["user": profile.toJSON()]).asVoid()
  }

  func fetchUser() -> Promise<User> {
    return NetworkManager.doRequest(.getUser).then { result in
      guard let user = Mapper<User>().map(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      ProfileManager.instance.currentProfile = user
      return Promise(value: user)
    }
  }
}

