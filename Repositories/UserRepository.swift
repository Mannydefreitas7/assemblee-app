//
//  UserRepository.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import AuthenticationServices

@MainActor
class UserRepository: ObservableObject {
    private var firestore = Firestore.firestore()
    private var encoder = Firestore.Encoder()
    private var decoder = Firestore.Decoder()
    @Published var currentUser: ABUser?
    private var listener: ListenerRegistration?
    
    deinit {
        if let listener {
            listener.remove()
        }
    }

    func fetch(user: User) {
        
        self.listener = firestore.collection("users").document(user.uid).addSnapshotListener({ snapshot, error in
            
            if let error {
                print(error.localizedDescription)
                self.currentUser = nil
                return
            }
            if let snapshot {
                do {
                    self.currentUser = try snapshot.data(as: ABUser.self)
                } catch {
                    self.currentUser = nil
                    print(error.localizedDescription)
                }
            }
        })
      
    }
    
    func createUserFrom(loggedInUser user: User, newUser: ABUser) async throws {
        var _user: ABUser = newUser
        _user.userId = user.uid
        _user.id = user.uid
        let data = try encoder.encode(newUser)
        try await firestore.document("users/\(user.uid)").setData(data)
    }
    
    func add(_ user: ABUser) async throws {
        let data = try encoder.encode(user)
        let _user = try await firestore.collection("users").addDocument(data: data)
        var updatedUser : ABUser = try await _user.getDocument().data(as: ABUser.self)
        updatedUser.userId = _user.documentID
        try await self.update(updatedUser)
    }
    
    
    func update(_ user: ABUser) async throws {
        
            let data = try encoder.encode(user)
            try await firestore.document("users/\(user.id)").setData(data, merge: true)
        
    }
}
