//
//  ContentView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @StateObject var appState = AssembleeAppState()
    @AppStorage("email") var email: String?
    
    var body: some View {
        Group {
            contentFlow()
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
                    .sheet(isPresented: $appState.showAddSchedule) {
                        VStack {
                            CalendarView()
                        }
                        .presentationDetents([.medium])
                    }
            } else {
                CongregationSignInView()
                    .environmentObject(appState)
            }
    }
    
    private func passwordlessSignIn(email: String, link: String) async -> AuthDataResult? {
        do {
            return try await Auth.auth().signIn(withEmail: email, link: link)
        } catch {
            print("ⓧ Authentication error: \(error.localizedDescription).")
            return nil
        }
      }
}


/// Model object for an `Alert` view.
struct AlertItem: Identifiable {    // *
  var id = UUID()
  var title: String
  var message: String
}

