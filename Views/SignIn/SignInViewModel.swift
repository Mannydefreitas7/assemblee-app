//
//  SignInViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import Foundation
import Combine
import AuthenticationServices

@MainActor
class SignInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    private var cancellables = Set<AnyCancellable>()
    @Published var isValid: Bool = false
    private var authenticationService = AuthenticationService()
    @Published var showSetup: Bool = false
    
    init() {
        $email
            .combineLatest($password)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { (email, password) in
                if !email.isEmpty && email.isValidEmail() && !password.isEmpty {
                    return true
                }
                return false
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
    }
  
}

// Sign in with Apple
extension SignInViewModel {
    
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        authenticationService.handleSignInWithAppleRequest(request)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        authenticationService.handleSignInWithAppleCompletion(result) { _ in }
    }
    
}
