//
//  ABPublisher.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import RealmSwift
let dateFormatter = DateFormatter()

struct ABPublisher: Codable, Identifiable, Hashable {
    static func == (lhs: ABPublisher, rhs: ABPublisher) -> Bool {
        return lhs.uid == rhs.uid
    }
    @DocumentID var id: String?
    var uid: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var gender: String?
    var isInvited: Bool?
    var isWTConductor: Bool?
    var photoUrl: String?
    var privilege: String?
    var lastGivenDate: String?
    var phone: String?
    var part: [ABPart]?
    
    var userId: String?
    var congregation: String?
    var isEmailVerified: Bool?
    var isOnline: Bool?
    var loginProvider: String?
    var permissions: [String]?
    
    var localPhone: String {
        self.phone ?? ""
    }
    
    var localEmail: String {
        self.email ?? ""
    }
    
    var fullName: String {
        return "\(self.firstName ?? "") \(self.lastName ?? "")"
    }

}

enum RMGender: String, PersistableEnum {
    case brother
    case sister
}

enum RMPrivilege: String, PersistableEnum {
    case publisher
    case assistant
    case elder
}

class RMPublisher: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var uid: String = ""
    @Persisted var email: String = ""
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var gender: RMGender = .brother
    @Persisted var isInvited: Bool = false
    @Persisted var isWTConductor: Bool = false
    @Persisted var privilege: RMPrivilege = .publisher
    @Persisted var lastGivenDate: Date = .now
    @Persisted var phone: String = ""
    @Persisted var parts: List<RMPart>
    @Persisted var congregation: RMCongregation?
}
