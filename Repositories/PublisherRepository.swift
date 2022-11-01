//
//  PublisherRepository.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import CongregationServiceKit

@MainActor
class PublisherRepository: ObservableObject {
    
    private var firestore = Firestore.firestore()
    private var encoder = Firestore.Encoder()
    private var decoder = Firestore.Decoder()
    var listener: ListenerRegistration?
    
    @Published var publishers: [ABPublisher] = [ABPublisher]()
    
    init() {
        self.listen()
    }
    
    deinit {
        if let listener {
            listener.remove()
        }
    }
    
    func fetch() async {
        do {
            if let congregationData = UserDefaults.standard.data(forKey: "congregation"), let congregation = self.fetchCongregation(from: congregationData) {
               
                let querySnapshot = try await firestore.collection("congregations/\(congregation.id)/publishers").getDocuments()
                self.publishers = try querySnapshot.documents.map { try $0.data(as: ABPublisher.self) }
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func listen() {
        if let congregationData = UserDefaults.standard.data(forKey: "congregation"), let congregation = self.fetchCongregation(from: congregationData) {
               
            self.listener = firestore.collection("congregations/\(congregation.id)/publishers")
                .addSnapshotListener { querySnapshot, _ in
                    do {
                        if let querySnapshot {
                            self.publishers = try querySnapshot.documents.map { try $0.data(as: ABPublisher.self) }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    func fetchCongregation(from data: Data) -> ABCongregation? {
        do {
            let _congregation = try ABCongregation().decodedData(data)
            return _congregation
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func add(_ publisher: ABPublisher, congregationID: String) async throws {
        let data = try encoder.encode(publisher)
            try await firestore.document("congregations/\(congregationID)/publishers/\(publisher.id)").setData(data, merge: true)
    }
}
