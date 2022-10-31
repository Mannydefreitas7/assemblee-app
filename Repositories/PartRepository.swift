//
//  PartRepository.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/11/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import SwiftDate
import CongregationServiceKit

@MainActor
final class PartRepository: ObservableObject {
    private var firestore = Firestore.firestore()
    private var congregationKit = CongregationServiceKit()
    private var encoder = Firestore.Encoder()
    private var decoder = Firestore.Decoder()
    @Published var chairmans = [ABPart]()
    @Published var treasures = [ABPart]()
    @Published var life = [ABPart]()
    @Published var apply = [ABPart]()
    @Published var prayers = [ABPart]()
    @Published var talk = [ABPart]()
    @Published var watchtower = [ABPart]()
    @Published var secondary = [ABPart]()
    @Published var updateError: String?
    @Published var midweekExists: Bool = false
    @Published var weekendExists: Bool = false
    
    var listener: ListenerRegistration?
    
    deinit {
        if let listener {
            listener.remove()
        }
    }
    
    func midWeekAlreadyExists(_ date: Date, for week: ABWeek, in congregation: ABCongregation) async throws {
        if let weekDate = week.id {
            let documents = try await firestore.collection("congregations/\(congregation.id)/weeks/\(weekDate)/parts").whereField("type", isEqualTo: ABScheduleType.midweek.rawValue).getDocuments()
            self.midweekExists = !documents.isEmpty
        }
    }
    
    func weekendAlreadyExists(_ date: Date, for week: ABWeek, in congregation: ABCongregation) async throws {
        let weekDate = date.get(direction: .previous, dayName: .monday, considerToday: true).toFormat("YYYYMMd")
        let documents = try await firestore.collection("congregations/\(congregation.id )/weeks/\(weekDate)/parts").whereField("type", isEqualTo: ABScheduleType.weekend.rawValue).getDocuments()
        self.weekendExists = !documents.isEmpty
    }
    
    func partsAlreadyExists(_ type: ABScheduleType, for date: Date, in congregation: ABCongregation) async throws -> Bool {

        let weekDate = date.get(direction: .previous, dayName: .monday, considerToday: true).toFormat("YYYYMMd")
        let documents = try await firestore.collection("congregations/\(congregation.id)/weeks/\(weekDate)/parts").whereField("type", isEqualTo: type.rawValue).getDocuments()
        return !documents.documents.isEmpty
    }
    
    func fetchParts(_ week: String, congregation: String) async throws {
       let documents = try await firestore.collection("congregations/\(congregation)/weeks/\(week)/parts").getDocuments()
        let parts = try documents.documents.map { try $0.data(as: ABPart.self) }
        if !parts.isEmpty {
            let (prayers, chairmans, treasures, apply, living, watchtower, talk, secondary) =  self.parseParts(parts)
                self.prayers = prayers
                self.chairmans = chairmans
                self.treasures = treasures
                self.apply = apply
                self.life = living
                self.watchtower = watchtower
                self.talk = talk
                self.secondary = secondary
        }
    }
    
    func listen(_ weekID: String, congregationID: String) {
        self.listener = firestore.collection("congregations/\(congregationID)/weeks/\(weekID)/parts")
            .addSnapshotListener { querySnapshot, error in

                if let querySnapshot {
                    do {
                        let parts: [ABPart] = try querySnapshot.documents.map { try $0.data(as: ABPart.self) }
                        let (prayers, chairmans, treasures, apply, living, watchtower, talk, secondary) =  self.parseParts(parts)
                            self.prayers = prayers
                            self.chairmans = chairmans
                            self.treasures = treasures
                            self.apply = apply
                            self.life = living
                            self.watchtower = watchtower
                            self.talk = talk
                            self.secondary = secondary
                    } catch {
                        print(error.localizedDescription)
                    }
            }
        }
    }
    
    func addWeekEndParts(date: Date, week: ABWeek, congregationID: String) async throws {
        let parts: [ABPart] = ABPart.weekEndParts(week: week, date: date)
        let weekDate = date.get(direction: .previous, dayName: .monday, considerToday: true).toFormat("YYYYMMd")
        try await parts.asyncForEach { part in
            let data = try encoder.encode(part)
            _ = try await firestore.collection("congregations/\(congregationID)/weeks/\(weekDate)/parts").addDocument(data: data)
        }
    }
    

    func addMidweekParts(date: Date, week: ABWeek, congregation: ABCongregation) async throws {
        var parts: [ABPart] = ABPart.midWeekParts(week: week, date: date)
        if  let language = congregation.language, let libs = language.libs, let lib = libs.first, let research = lib.researchConfigurationID, let symbol = lib.symbol {
            let (treasures, apply, life, secondary) = try await congregationKit.getParts(for: date, symbol: symbol, research: research)
            treasures.forEach { parts.append($0) }
            apply.forEach { parts.append($0) }
            life.forEach { parts.append($0) }
            
            if let secondaryClass = congregation.secondaryClass {
                for _ in 1...secondaryClass {
                    secondary.forEach { parts.append($0) }
                }
            }
            
            // Add treasures parts
            let weekDate = date.get(direction: .previous, dayName: .monday, considerToday: true).toFormat("YYYYMMd")
            try await parts.asyncForEach { part in
                let data = try encoder.encode(part)
                _ = try await firestore.collection("congregations/\(congregation.id)/weeks/\(weekDate)/parts").addDocument(data: data)
            }
        }
        
    }
    
    
    
    func parseParts(_ weekParts: [ABPart]) -> (prayers: [ABPart], chairmans: [ABPart], treasures: [ABPart], apply: [ABPart], living: [ABPart], watchtower: [ABPart], talk: [ABPart], secondary: [ABPart]) {

        let _prayers: [ABPart] = weekParts
               .filter { $0.parent == ABParent.prayer.rawValue }
               .sorted { $0.index < $1.index }
           
           
        let _chairmans: [ABPart] = weekParts
            .filter { $0.parent == ABParent.chairman.rawValue }
            .sorted { $0.index < $1.index }
        
        let _secondary: [ABPart] = weekParts
                .filter { $0.type == ABScheduleType.secondary.rawValue }
                .sorted { $0.index < $1.index }
           
           
        let _talk: [ABPart] = weekParts
            .filter { $0.parent == ABParent.talk.rawValue }
            .sorted { $0.index < $1.index }


        let _watchtower: [ABPart] = weekParts
            .filter { $0.parent == ABParent.wt.rawValue }
            .sorted { $0.index < $1.index }
           
        let _treasures : [ABPart] = weekParts
            .filter { $0.parent == ABParent.treasures.rawValue }
            .sorted { $0.index < $1.index }
    
           
        let _apply : [ABPart] = weekParts
                .filter { $0.parent == ABParent.apply.rawValue }
                .sorted { $0.index < $1.index }
           
        let _living : [ABPart] = weekParts
            .filter { $0.parent == ABParent.living.rawValue }
            .sorted { $0.index < $1.index }
        return (_prayers, _chairmans, _treasures, _apply, _living, _watchtower, _talk, _secondary)
       }
    
 
    
  
}
