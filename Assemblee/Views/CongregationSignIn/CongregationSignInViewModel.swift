//
//  CongregationSignInViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/15/22.
//

import Foundation
import Combine
import AuthenticationServices

@MainActor
class CongregationSignInViewModel: ObservableObject {
    
    @Published var code: String = ""
    private var cancellables = Set<AnyCancellable>()
    private var authenticationService = AuthenticationService()
    
}


// Sign in with Apple
extension CongregationSignInViewModel {
    
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        authenticationService.handleSignInWithAppleRequest(request)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        authenticationService.handleSignInWithAppleCompletion(result) { _ in }
    }
    
}
