//
//  ContentView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import SwiftUI
import Firebase
import AlertToast

struct ContentView: View {
    
    @StateObject var appState = AssembleeAppState()
    @AppStorage("email") var email: String?
    
    var body: some View {
        Group {
            contentFlow()
                .toastAlert(logManager: appState.logManager)
        }
        .onOpenURL { url in   // 2
            let link = url.absoluteString
            if Auth.auth().isSignIn(withEmailLink: link), let email {    // 3
                Task {
                    if let result = await passwordlessSignIn(email: email, link: link) {
                        print(result.user)
                    }
                }
            }
        }
 
    }
    
    @ViewBuilder func contentFlow() -> some View {
            if let _ = appState.currentUser {
                ABTabView()
                    .environmentObject(appState)

            } else {
                CongregationSignInView()
                    .environmentObject(appState)
            }
    }
    
    private func passwordlessSignIn(email: String, link: String) async -> AuthDataResult? {
        do {
            return try await Auth.auth().signIn(withEmail: email, link: link)
        } catch {
            appState.logManager.displayError(title: error.localizedDescription)
            return nil
        }
    }
}
