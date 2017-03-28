//
//  APIPath.swift
//  SportUp
//
//  Created by Алексей on 23.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import Alamofire

enum APIPath {
  case getCities
  case getSportTypes
  case getEvents(sportTypeId: Int)
  case getEvent(eventId: Int)
  case getEventMemberships(eventId: Int)
  case sendMembership(eventId: Int)
  case deleteMembership(membershipId: Int)
  case joinTeam(eventId: Int)
  case fetchTeams(eventId: Int)

  var rawPath: String {
    switch self {
    case .getCities:
      return "cities"
    case .getSportTypes:
      return "sport_types"
    case .getEvents(let sportTypeId):
      return "sport_types/\(sportTypeId)/events"
    case .getEvent(let eventId):
      return "events\(eventId)"
    case .getEventMemberships(let eventId):
      return "events/\(eventId)/memberships"
    case .sendMembership(let eventId):
      return "events/\(eventId)/membershibs"
    case .deleteMembership(let membershipId):
      return "memberships/\(membershipId)"
    case .joinTeam(let eventId), .fetchTeams(let eventId):
      return "events/\(eventId)/teams"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .deleteMembership(_):
      return .delete
    case .sendMembership(_):
      return .post
    default:
      return .get
    }
  }

  var encoding: ParameterEncoding {
    switch method {
    case .get, .delete:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }
}
