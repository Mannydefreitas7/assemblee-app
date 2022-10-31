//
//  ABPart.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ABPartAlt: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var assignee: ABPublisherAlt?
    var assistant: ABPublisherAlt?
    var inPerson: Bool = true
    var date: Timestamp?
    var gender: [ABGender.RawValue] = [ABGender.brother.rawValue]
    var hasAssistant: Bool = false
    var hasDiscussion: Bool = false
    var index: Int?
    var isConfirmed: Bool = false
    var isEmailed: Bool = false
    var isCalendarAdded: Bool = false
    var length: String?
    var lengthTime: TimeInterval?
    var parent: ABParent.RawValue?
    var path: String?
    var privilege: [ABPrivilege.RawValue] = [ABPrivilege.publisher.rawValue]
    var subTitle: String?
    var title: String?
    var week: String?
    var schedule: ABWeekAlt?
    var type: ABScheduleType.RawValue = ABScheduleType.weekend.rawValue
    
    var shortTitle: String {
        self.title?.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines) ?? ""
    }
    
    var formattedDate: Date? {
        self.date?.dateValue()
    }
    
    var genders: [ABGender] {
        self.gender.map { ABGender(rawValue: $0) ?? ABGender.brother }
    }
    
    var privileges: [ABPrivilege] {
        self.privilege.map { ABPrivilege(rawValue: $0) ?? ABPrivilege.publisher }
    }
}


extension ABPartAlt {
    static func weekEndParts(week: ABWeekAlt, date: Date) -> [ABPartAlt] {
        let parts: [ABPartAlt] = [
            .init(date: Timestamp(date: date), gender: [ABGender.brother.rawValue], hasAssistant: false, hasDiscussion: false, index: 2, isConfirmed: false, isEmailed: false, isCalendarAdded: false, parent: ABParent.prayer.rawValue, privilege: [ABPrivilege.publisher.rawValue, ABPrivilege.assistant.rawValue, ABPrivilege.elder.rawValue], title: "Prayer", schedule: week),
            .init(date: Timestamp(date: date), gender: [ABGender.brother.rawValue], hasAssistant: false, hasDiscussion: false, index: 3, isConfirmed: false, isEmailed: false, isCalendarAdded: false, parent: ABParent.prayer.rawValue, privilege: [ABPrivilege.publisher.rawValue, ABPrivilege.assistant.rawValue, ABPrivilege.elder.rawValue], title: "Prayer", schedule: week),
            .init(date: Timestamp(date: date), gender: [ABGender.brother.rawValue], hasAssistant: false, hasDiscussion: false, index: 1, isConfirmed: false, isEmailed: false, isCalendarAdded: false, parent: ABParent.chairman.rawValue, privilege: [ABPrivilege.elder.rawValue], title: "Chairman", schedule: week),
            .init(date: Timestamp(date: date), gender: [ABGender.brother.rawValue], hasAssistant: false, hasDiscussion: false, index: 0, isConfirmed: false, isEmailed: false, isCalendarAdded: false, parent: ABParent.talk.rawValue, privilege: [ABPrivilege.elder.rawValue, ABPrivilege.assistant.rawValue], title: "Speaker", schedule: week),
            .init(date: Timestamp(date: date), gender: [ABGender.brother.rawValue], hasAssistant: false, hasDiscussion: false, index: 0, isConfirmed: false, isEmailed: false, isCalendarAdded: false, parent: ABParent.wt.rawValue, privilege: [ABPrivilege.elder.rawValue], title: "Watchtower Conductor", schedule: week)
        ]
        return parts
    }
    
    static func midWeekParts(week: ABWeekAlt, date: Date) -> [ABPartAlt] {
        let parts: [ABPartAlt] = [
            .init(date: Timestamp(date: date), gender: [ABGender.brother.rawValue], hasAssistant: false, hasDiscussion: false, index: 0, isConfirmed: false, isEmailed: false, isCalendarAdded: false, parent: ABParent.prayer.rawValue, privilege: [ABPrivilege.publisher.rawValue, ABPrivilege.assistant.rawValue, ABPrivilege.elder.rawValue], title: "Prayer", schedule: week, type: ABScheduleType.midweek.rawValue),
            .init(date: Timestamp(date: date), gender: [ABGender.brother.rawValue], hasAssistant: false, hasDiscussion: false, index: 1, isConfirmed: false, isEmailed: false, isCalendarAdded: false, parent: ABParent.prayer.rawValue, privilege: [ABPrivilege.publisher.rawValue, ABPrivilege.assistant.rawValue, ABPrivilege.elder.rawValue], title: "Prayer", schedule: week, type: ABScheduleType.midweek.rawValue),
            .init(date: Timestamp(date: date), gender: [ABGender.brother.rawValue], hasAssistant: false, hasDiscussion: false, index: 0, isConfirmed: false, isEmailed: false, isCalendarAdded: false, parent: ABParent.chairman.rawValue, privilege: [ABPrivilege.elder.rawValue], title: "Chairman", schedule: week, type: ABScheduleType.midweek.rawValue),
        ]
        return parts
    }
}


