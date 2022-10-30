//
//  ABPart.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import RealmSwift

struct ABPart: Codable, Identifiable, Hashable {
    var id: String?
    var assignee: ABPublisher?
    var assistant: ABPublisher?
    var date: Timestamp?
    var gender: [ABGender.RawValue]?
    var hasAssistant: Bool?
    var hasDiscussion: Bool?
    var index: Int?
    var isConfirmed: Bool?
    var isEmailed: Bool?
    var isCalendarAdded: Bool?
    var length: String?
    var lengthTime: TimeInterval?
    var parent: ABParent.RawValue?
    var path: String?
    var privilege: [String]?
    var subTitle: String?
    var title: String?
    var week: String?
    var schedule: ABWeek?
    
    var shortTitle: String {
        self.title?.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines) ?? ""
    }
    
    var formattedDate: Date? {
        self.date?.dateValue()
    }
    
    var includeAssistant: Bool {
        self.hasAssistant ?? false
    }
}

class RMPart: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var assignee: RMPublisher?
    @Persisted var assistant: RMPublisher?
    @Persisted var date: Date?
    @Persisted var gender: List<RMGender>
    @Persisted var hasAssistant: Bool?
    @Persisted var hasDiscussion: Bool?
    @Persisted var index: Int?
    @Persisted var isConfirmed: Bool?
    @Persisted var isEmailed: Bool?
    @Persisted var isCalendarAdded: Bool?
    @Persisted var length: String?
    @Persisted var lengthTime: Double?
    @Persisted var parent: RMParent = .chairman
    @Persisted var path: String?
    @Persisted var privilege: List<RMPrivilege>
    @Persisted var subTitle: String?
    @Persisted var title: String?
    @Persisted var week: String?
    @Persisted var schedule: RMWeek?
    @Persisted var createdAt: Date = .now
    
}


