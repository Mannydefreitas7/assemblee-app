//
//  UserView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import SwiftUI

struct UserView: View {
    
    @ObservedObject var appState: AssembleeAppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            LazyVStack {
                if let user = appState.currentUser, let firstName = user.firstName, let lastName = user.lastName, let email = user.email {
                    Avatar(firstName: firstName, lastName: lastName)
                        .scaleEffect(2.5)
                        .padding()
                        .padding(.vertical)
                    VStack {
                        Text("\(lastName), \(firstName)")
                            .bold()
                            .font(.title3)
                        Text(email)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom)
                }
                
            }
            .padding()
            Divider()
           
            Form {
                
                Section("Info") {
                    Text("Congregation")
                        .badge(Text(appState.congregation?.properties?.orgName ?? ""))
                    Text("Permission")
                        .badge(Text(appState.currentUser?.permissions?.first ?? ""))
                }
                
                
//                Section("Profile") {
//                    TextField("First Name", text: $appState.currentUser.firstName ?? "", axis: .vertical)
//                    TextField("Last Name", text: $appState.currentUser.lastName ?? "", axis: .vertical)
//                    TextField("Email", text: $appState.currentUser.email ?? ""), axis: .vertical)
//                }
                
                Button {
                    appState.signOut()
                    self.dismiss()
                } label: {
                    HStack {
                        Text("Sign Out")
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}
