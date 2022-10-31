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
            if let congregation {
                let encodedData = try congregation.encodedData()
                UserDefaults.standard.set(encodedData, forKey: "congregation")
            }
        }
    }
    
    func fetchLocalCongregation(from data: Data) -> ABCongregation? {
        do {
            let _congregation = try ABCongregation().decodedData(data)
            return _congregation
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func add(_ congregation: ABCongregation) async throws -> String {
        let data = try encoder.encode(congregation)
        try await firestore.document("congregations/\(congregation.id)").setData(data, merge: true)
        self.congregation = congregation
        return congregation.id
    }
    
}
