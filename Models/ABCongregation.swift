//
//  ABCongregation.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CongregationServiceKit
import RealmSwift

struct ABCongregation: Codable, Identifiable {
    static func == (lhs: ABCongregation, rhs: ABCongregation) -> Bool {
        return lhs.id == rhs.id
    }
    @DocumentID var id: String?
    var passcode: String?
    var properties: Properties?
    var language: WOLLanguage?
}

extension ABCongregation {
    
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

class RMCongregation: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var orgName: String = ""
    @Persisted var orgGUID: String = ""
    @Persisted var address: String = ""
    @Persisted var languageCode: String = ""
    @Persisted var midweek: RMMidweek?
    @Persisted var weekend: RMMidweek?
    @Persisted var language: RMLanguage?
    
}

class RMLanguage: EmbeddedObject {
    @Persisted var languageTitle: String = ""
    @Persisted var englishName: String = ""
    @Persisted var vernacularName: String = ""
    @Persisted var mepsSymbol: String = ""
    @Persisted var direction: RMDirection = .ltr
    @Persisted var isSignLanguage: Bool = false
    @Persisted var locale: String = ""
    @Persisted var researchConfigurationID: String = ""
    @Persisted var symbol: String = ""
}



public enum RMDirection: String, PersistableEnum {
    case ltr
    case rtl
}

// MARK: - Schedule
struct ABSchedule: Codable, Hashable {
    var current: ABCurrent?
}


struct Schedule: Codable, Hashable {
    var current: ABCurrent?
}

// MARK: - Current
struct ABCurrent: Codable, Hashable {
    var midweek: ABMidweek?
    var weekend: ABMidweek?
}

// MARK: - Midweek
struct ABMidweek: Codable, Hashable {
    var weekday: Int?
    var time: String?
}

// MARK: - Midweek
class RMMidweek: EmbeddedObject {
    @Persisted var weekday: Int = 1
    @Persisted var time: String = ""
}

struct ABLocation: Codable, Hashable {
    var longitude: Double?
    var latitude: Double?
}
