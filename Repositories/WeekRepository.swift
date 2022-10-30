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

@MainActor
class WeekRepository: ObservableObject {
    
    private var firestore = Firestore.firestore()
    private var encoder = Firestore.Encoder()
    private var decoder = Firestore.Decoder()
    
    @Published var weeks : [ABWeek] = [ABWeek]()
    
    func fetch(user: ABUser?) async throws {
        if let user, let congregationID = user.congregation {
            let snapshot = try await firestore.collection("congregations/\(congregationID)/weeks").order(by: "date").getDocuments()
                self.weeks = try snapshot.documents.map { try $0.data(as: ABWeek.self) }
        }
    }
    
    
    
}
