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

struct ABPublisherAlt: Codable, Identifiable, Hashable {
    static func == (lhs: ABPublisherAlt, rhs: ABPublisherAlt) -> Bool {
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
    var part: [ABPartAlt]?
    
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

