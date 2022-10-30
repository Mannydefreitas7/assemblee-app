//
//  CongregationRepository.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/29/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class CongregationRepository: ObservableObject {
    
    private var firestore = Firestore.firestore()
    private var encoder = Firestore.Encoder()
    private var decoder = Firestore.Decoder()
    
    @Published var congregation: ABCongregation?
    
    func fetch(_ user: ABUser) async throws {
        if let id = user.congregationId {
            let data = try await firestore.document("congregations/\(id)").getDocument()
            
            self.congregation = try data.data(as: ABCongregation.self)
        }
    }
    
    func add(_ congregation: ABCongregation) async throws -> String {
        let data = try encoder.encode(congregation)
        let document = try await firestore.collection("congregations").addDocument(data: data)
        self.congregation = congregation
        return document.documentID
    }
    
}
