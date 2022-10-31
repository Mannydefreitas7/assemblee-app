//
//  ABUser.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ABUser: Codable, Hashable {
    var id: String = UUID().uuidString
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
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(self)
        return data
    }
    
    func decodedData(_ data: Data) throws -> Self {
        let decoder = PropertyListDecoder()
        let data = try decoder.decode(Self.self, from: data)
        return data
    }
    
}
