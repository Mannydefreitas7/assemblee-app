//
//  AuthenticationService.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import Foundation
import Firebase
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import SwiftUI
import Combine

enum LoginOption {
    case signInWithApple
    case emailAndPassword(email: String, password: String)
}

@MainActor
class AuthenticationService: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var handle: AuthStateDidChangeListenerHandle?
    @Published var isLoading: Bool = true
    @Published var user: User?
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage = ""
    @Published var displayName = ""
    @Published var isValid = false
    @Published var currentNonce: String?
    @Published var credential: AuthCredential?
    @Published var logManager: LogManager = LogManager()
    
    private func registerStateListener() {
        
        do {
          try Auth.auth().useUserAccessGroup("FUU334NWUK.com.wolinweb.Assemblee.shared")
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
        }
       
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user {
                self.user = user
                self.isAuthenticated = true
            } else {
                self.isAuthenticated = false
            }
        }
    }
    
    init() {
        registerStateListener()
        verifySignInWithAppleAuthenticationState()
    }
    

    
    func signInAnonymously() async throws -> AuthDataResult? {
        let result: AuthDataResult = try await Auth.auth().signInAnonymously()
        return result
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func sendSignEmailLink(email: String) async throws {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://assemblee.web.app/email")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        UserDefaults.standard.set(email, forKey: "email")
        try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
    }
    
    func signInWithEmailLink(link: String) async throws {
        if Auth.auth().isSignIn(withEmailLink: link) {
            if let email = UserDefaults.standard.string(forKey: "Email") {
                try await Auth.auth().signIn(withEmail: email, link: link)
            }
        }
    }
    
    func updateDisplayName(displayName: String) { // (2)
        if let user = Auth.auth().currentUser {
            let changeRequest = user.createProfileChangeRequest() // (3)
            changeRequest.displayName = displayName
            changeRequest.commitChanges { [weak self] error in // (4)
                if error != nil {
                    self?.logManager.display(.success, title: "Successfully updated")
                }
            }
        }
    }
}


extension AuthenticationService {
    private func wait() async {
      do {
        try await Task.sleep(nanoseconds: 1_000_000_000)
      }
      catch { }
    }
    
    func signOut() {
      do {
        try Auth.auth().signOut()
        logManager.display(.info, title: "Signed Out")
      }
      catch {
          logManager.display(.error, title: "Error", message: error.localizedDescription)
      }
    }
    
    func deleteAccount() async -> Bool {
      do {
        try await user?.delete()
        return true
      }
      catch {
          logManager.display(.error, title: "Error", message: error.localizedDescription)
        return false
      }
    }
    
}


// Apple Sign In
extension AuthenticationService {
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
      request.requestedScopes = [.fullName, .email]
      let nonce = randomNonceString()
      currentNonce = nonce
      request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>, completion: @escaping (User?) -> Void) {
      if case .failure(let failure) = result {
          print(failure.localizedDescription)
          logManager.display(.error, title: "Error", message: failure.localizedDescription)
      }
      else if case .success(let authorization) = result {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
            fatalError("Invalid state: a login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetdch identify token.")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
            return
          }

          let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)
          Task {
            do {
              let result = try await Auth.auth().signIn(with: credential)
              await updateDisplayName(for: result.user, with: appleIDCredential)
              completion(result.user)
            }
            catch {
                print(error.localizedDescription)
            }
          }
        }
      }
    }
    
    func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
        
      if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
        // current user is non-empty, don't overwrite it
      }
      else {
        let changeRequest = user.createProfileChangeRequest()
          changeRequest.displayName = appleIDCredential.displayName()
        do {
          try await changeRequest.commitChanges()
          self.displayName = Auth.auth().currentUser?.displayName ?? ""
        }
        catch {
            print(error.localizedDescription)
            logManager.display(.error, title: error.localizedDescription)
        }
      }
    }
    
    func verifySignInWithAppleAuthenticationState() {
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let providerData = Auth.auth().currentUser?.providerData
      if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
        Task {
          do {
            let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
              
            switch credentialState {
            case .authorized:
                print("AUTHORIZED")
              break // The Apple ID credential is valid.
            case .revoked, .notFound:
                print("notFound")
              // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
              self.signOut()
            default:
              break
            }
          }
          catch {
              print(error.localizedDescription)
              logManager.display(.error, title: error.localizedDescription)
          }
        }
      }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}


extension ASAuthorizationAppleIDCredential {
  func displayName() -> String {
    return [self.fullName?.givenName, self.fullName?.familyName]
      .compactMap( {$0})
      .joined(separator: " ")
  }
}
