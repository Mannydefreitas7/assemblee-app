//
//  AssembleeAppState.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import Foundation
import Combine
import FirebaseAuth
import AuthenticationServices

@MainActor
class AssembleeAppState: ObservableObject {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    private var cancellables = Set<AnyCancellable>()
    @Published var authenticationService = AuthenticationService()
    @Published var userRepository = UserRepository()
    @Published var congregationRepository = CongregationRepository()
    @Published var currentUser: ABUser?
    @Published var congregation: ABCongregation?
    @Published var user: RMUser?
    @Published var userId: String?
    @Published var isAuthenticated: Bool = false
    @Published var showAddSchedule: Bool = false
    @Published var showSetup: Bool = false
    var observer: NSKeyValueObservation?
    
    init() {
        
        userRepository.$currentUser
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellables)
        
        userRepository.$currentUser
            .compactMap { $0 }
            .sink { user in
                Task {
                    await self.fetchCongregation(from: user)
                }
             }
            .store(in: &cancellables)
        
        congregationRepository.$congregation
            .assign(to: \.congregation, on: self)
            .store(in: &cancellables)
        
        authenticationService.$user
            .sink { user in
                if let user {
                    self.userRepository.fetch(user: user)
                }
            }
            .store(in: &cancellables)
        
        authenticationService.$isAuthenticated
            .assign(to: \.isAuthenticated, on: self)
            .store(in: &cancellables)
       
        UserDefaults.standard
            .publisher(for: \.user)
            .compactMap { $0 }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
    }
    
    deinit {
        
    }
    
    func signInAnonymously() async {
        do {
            let result = try await authenticationService.signInAnonymously()
            if let result = result {
                // TODO: add congregationId from verified code pin...
                let newUser = ABUser(uid: result.user.uid, userId: result.user.uid, email: nil, provider: result.user.providerID)
                try await userRepository.createUserFrom(loggedInUser: result.user, newUser: newUser)
            }
        } catch {
            print("PRINT: \(error.localizedDescription)")
        }
    }
    
    func createUserFrom(_ user: User, newUser: ABUser) async {
        do {
            try await userRepository.createUserFrom(loggedInUser: user, newUser: newUser)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchCongregation(from user: ABUser) async {
        do {
            try await congregationRepository.fetch(user)
        } catch {
            print(error.localizedDescription)
        }
    }

    
    func signInWithEmailAndPassword(email: String, password: String) async {
        do {
           try await authenticationService.signInWithEmail(email: email, password: password)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signOut() {
        authenticationService.signOut()
        currentUser = nil
    }
    
}
