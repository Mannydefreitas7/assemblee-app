//
//  ABEnums.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import Foundation
import RealmSwift

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
    case secondary = "secondary"
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


enum ABPartPublisherType {
    case assignee
    case assistant
}

enum ABAssignmentType {
    case all
    case confirmed
    case unconfirmed
}

enum ABPermission: String {
    case programs = "programs"
    case speakers = "speakers"
    case admin = "admin"
    case publishers = "publishers"
    case superAdmin = "superAdmin"
    case editor = "editor"
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
