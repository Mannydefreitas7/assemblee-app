//
//  ABEnums.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import Foundation
import RealmSwift
import CongregationServiceKit

enum ABGender: String {
    case brother = "brother"
    case sister = "sister"
}

let genders : [ABGender] = [.brother, .sister]

enum ABParent: String {
    case talk = "talk"
    case wt = "watchtower"
    case treasures = "treasures"
    case apply = "apply"
    case living = "life"
    case prayer = "prayer"
    case chairman = "chairman"
    //case secondary = "secondary"
}


enum ABScheduleType: String {
    case midweek = "midweek"
    case weekend = "weekend"
    case secondary = "secondary"
    case tertiary = "tertiary"
}

enum RMParent: String, PersistableEnum {
    case talk
    case wt
    case treasures
    case apply
    case living
    case prayer
    case chairman
    case secondary
}

enum ABPublisherKeys: String {
    case firstName = "firstName"
    case lastName = "lastName"
    case email = "email"
    case phone = "phone"
    case privilege = "privilege"
    case gender = "gender"
    case lastGivenPartDate = "lastGivenPartDate"
}

enum ABPrivilege: String {
    case elder = "elder"
    case assistant = "ms"
    case publisher = "publisher"
}

let privileges : [ABPrivilege] = [.elder, .assistant, .publisher]


enum ABPartPublisherType: Int, Identifiable {
    case assignee
    case assistant
    var id: Int {
        hashValue
    }
}

enum ABAssignmentType {
    case all
    case confirmed
    case unconfirmed
}

let permissions : [ABPermission] = [.programs, .speakers, .admin, .publishers, .superAdmin, .editor]

enum ABActiveAlert: Identifiable {
    case invite, remove
    var id: Int {
        hashValue
    }
}

enum ABActiveSheet: Identifiable {
    case assignee, assistant, pdf
    
    var id: Int {
        hashValue
    }
}

enum ABPublishersViewType {
    case list
    case select
}
