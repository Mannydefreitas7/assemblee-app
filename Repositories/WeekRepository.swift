//
//  WeekRepository.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/11/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftDate
import CongregationServiceKit

@MainActor
class WeekRepository: ObservableObject {
    
    private var firestore = Firestore.firestore()
    private var encoder = Firestore.Encoder()
    private var decoder = Firestore.Decoder()
    var listener: ListenerRegistration?
    
    @Published var weeks : [ABWeek] = [ABWeek]()
    
    
    func listen(for congregation: ABCongregation) throws {
        self.listener = firestore.collection("congregations/\(congregation.id)/weeks")
            .addSnapshotListener { querySnapshot, error in
                do {
                    if let querySnapshot {
                        self.weeks = try querySnapshot.documents.map { try $0.data(as: ABWeek.self) }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
    func fetch(for congregation: ABCongregation) async throws {
    
        let querySnapshot = try await firestore.collection("congregations/\(congregation.id)/weeks").getDocuments()
        self.weeks = try querySnapshot.documents.map { try $0.data(as: ABWeek.self) }
        
    }
    
    deinit {
        if let listener {
             listener.remove()
        }
    }
    
    func add(for congregation: ABCongregation, week: ABWeek) async throws {
        if let date = week.date {
            let weekDate = date.dateValue().get(direction: .previous, dayName: .monday, considerToday: true).toFormat("YYYYMMd")
            let data = try encoder.encode(week)
            try await firestore.document("congregations/\(congregation.id)/weeks/\(weekDate)").setData(data, merge: true)
           // try await self.fetch(for: congregation)
        }
    }
    
    func alreadyExists(congregation: ABCongregation, date: Date) async throws -> (Bool, ABWeek?) {
            let weekDate = date.get(direction: .previous, dayName: .monday, considerToday: true).toFormat("YYYYMMd")
        let document = try await firestore.document("congregations/\(congregation.id)/weeks/\(weekDate)").getDocument()
            if document.exists {
                let week = try document.data(as: ABWeek.self)
                return (document.exists, week)
            }
        return (false, nil)
    }
    
}
