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
  case getSportTypes(cityId: Int)
  case getEvents(cityId: Int, sportTypeId: Int)
  case getEvent(eventId: Int)
  case getEventMemberships(eventId: Int)
  case createMembership(eventId: Int)
  case deleteMembership(membershipId: Int)
  case joinTeam(eventId: Int)
  case leaveTeam(eventId: Int, membershipId: Int)
  case vote(eventId: Int)
  case createReport(eventId: Int)
  case getMemberships
  case getInvites
  case acceptInvite(inviteId: Int)
  case deleteInvite(inviteId: Int)
  case createEvent
  case editEvent(eventId: Int)
  case createVerificationToken
  case verifyToken(verificationToken: String)
  case createUser
  case updateUser
  case getUser

  var rawPath: String {
    switch self {
    case .getCities:
      return "cities"
    case .getSportTypes(let cityId):
      return "cities/\(cityId)/sport_types"
    case .getEvents(let cityId, let sportTypeId):
      return "cities/\(cityId)/sport_types/\(sportTypeId)/events"
    case .getEvent(let eventId):
      return "events/\(eventId)"
    case .getEventMemberships(let eventId):
      return "events/\(eventId)/memberships"
    case .createMembership(let eventId):
      return "events/\(eventId)/memberships"
    case .deleteMembership(let membershipId):
      return "memberships/\(membershipId)"
    case .joinTeam(let eventId):
      return "events/\(eventId)/teams"
    case .leaveTeam(let eventId, let membershipId):
      return "/api/events/\(eventId)/teams/\(membershipId)"
    case .vote(let eventId):
      return "api/events/\(eventId)/votes"
    case .createReport(let eventId):
      return "api/events/\(eventId)/reports"
    case .getMemberships:
      return "memberships"
    case .getInvites:
      return "invites"
    case .acceptInvite(let inviteId):
      return "invites/\(inviteId)"
    case .deleteInvite(let inviteId):
      return "invites/\(inviteId)"
    case .createEvent:
      return "events"
    case .editEvent(let eventId):
      return "events/\(eventId)"
    case .createVerificationToken:
      return "verification_tokens"
    case .verifyToken(let verificationToken):
      return "verification_tokens/\(verificationToken)"
    case .updateUser, .createUser, .getUser:
      return "user"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .deleteMembership(_), .deleteInvite(_):
      return .delete
    case .createMembership(_), .vote(_), .createReport(_),
         .createEvent, .createVerificationToken, .createUser, .joinTeam(_):
      return .post
    case .acceptInvite(_), .editEvent(_), .verifyToken(_), .updateUser, .leaveTeam(_):
      return .put
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
