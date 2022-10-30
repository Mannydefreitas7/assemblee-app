//
//  ABUser.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import Foundation
import FirebaseFirestoreSwift
import RealmSwift

struct ABUser: Codable, Hashable {
    @DocumentID var id: String?
    var uid: String?
    var firstName: String?
    var userId: String?
    var congregation: String?
    var congregationId: String?
    var email: String?
    var isEmailVerified: Bool?
    var isOnline: Bool?
    var lastName: String?
    var loginProvider: String?
    var permissions: [String]?
    var provider: String?
}

extension ABUser {
    
    func encodedData() throws -> Data {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return data
    }
    
    func decodedData(_ data: Data) throws -> Self {
        let decoder = JSONDecoder()
        let data = try decoder.decode(Self.self, from: data)
        return data
    }
    
}


class RMUser: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var uid: String = ""
    @Persisted var firstName: String = ""
    @Persisted var userId: String = ""
    @Persisted var congregation: String = ""
    @Persisted var email: String = ""
    @Persisted var isEmailVerified: Bool = false
    @Persisted var isOnline: Bool = false
    @Persisted var lastName: String = ""
}
