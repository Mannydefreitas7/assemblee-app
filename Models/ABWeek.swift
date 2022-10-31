//
//  ABWeek.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/11/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import RealmSwift

struct ABWeekAlt: Codable, Identifiable, Hashable {
    
    @DocumentID var id: String?
    var date: Timestamp?
    var isCOVisit: Bool
    var isSent: Bool
    var range: String?
    var isDownloaded: Bool?

}

extension ABWeekAlt {
    static let week = ABWeekAlt(date: Timestamp(date: .now), isCOVisit: false, isSent: false, range: "December 1 - 7", isDownloaded: false)
    static let weeks = Array(repeating: week, count: 9)
}

class RMWeek: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date = .now
    @Persisted var isCOVisit: Bool = false
    @Persisted var isSent: Bool = false
    @Persisted var range: String = ""
    @Persisted var isDownloaded: Bool = false
    @Persisted var createdAt: Date = .now
}
