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
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-YYYY"
    return NetworkManager.doRequest(.getEvents(sportTypeId: sportType.id), ["date": dateFormatter.string(from: date)]).then { result in
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
    return NetworkManager.doRequest(.getSportTypes).then { result in
      guard let sportTypes = Mapper<SportType>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      self.sportTypes = sportTypes
      return Promise(value: sportTypes)
    }
  }

  func createMembership(eventId: Int) -> Promise<EventMember> {
    return NetworkManager.doRequest(.getEventMemberships(eventId: eventId)).then { result in
      guard let eventMember = Mapper<EventMember>().map(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: eventMember)
    }
  }

  func fetchMemberships(eventId: Int) -> Promise<[EventMember]> {
    return NetworkManager.doRequest(.getEventMemberships(eventId: eventId)).then { result in
      guard let invitedUsers = Mapper<EventMember>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: invitedUsers)
    }
  }

  func deleteMembership(membershipId: Int) -> Promise<Void> {
    return NetworkManager.doRequest(.deleteMembership(membershipId: membershipId)).asVoid()
  }

  func fetchTeams(eventId: Int) -> Promise<[TeamResponse]> {
    return NetworkManager.doRequest(.getTeams(eventId: eventId)).then { result in
      guard let teams = Mapper<TeamResponse>().mapArray(JSONObject: result) else {
        return Promise(error: DataError.unprocessableData)
      }
      return Promise(value: teams)
    }
  }

  func joinTeam(teamId: Int) -> Promise<Void> {
    return NetworkManager.doRequest(.joinTeam(teamId: teamId)).asVoid()
  }

  func leaveTeam(teamId: Int) -> Promise<Void> {
    return NetworkManager.doRequest(.leaveTeam(teamId: teamId)).asVoid()
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
}

