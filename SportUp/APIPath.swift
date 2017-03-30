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
  case joinTeam(teamId: Int)
  case getTeams(eventId: Int)
  case leaveTeam(teamId: Int)
  case vote(eventId: Int)
  case createReport(eventId: Int)

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
    case .getTeams(let eventId):
      return "events/\(eventId)/teams"
    case .joinTeam(let teamId):
      return "teams/\(teamId)/joins"
    case .leaveTeam(let teamId):
      return "teams/\(teamId)/joins"
    case .vote(let eventId):
      return "api/events/\(eventId)/votes"
    case .createReport(let eventId):
      return "api/events/\(eventId)/reports"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .deleteMembership(_), .leaveTeam(_):
      return .delete
    case .sendMembership(_), .joinTeam(_), .vote(_), .createReport(_):
      return .post
    default:
      return .get
    }
  }

  var encoding: ParameterEncoding {
    switch self {
    case .createReport(_):
      return ArrayEncoding()
    default:
      switch method {
      case .get, .delete:
        return URLEncoding.default
      default:
        return JSONEncoding.default
      }
    }
  }
}
