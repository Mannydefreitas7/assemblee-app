//
//  SignInView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    
    @StateObject var viewModel: SignInViewModel = SignInViewModel()
    @EnvironmentObject var appState: AssembleeAppState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            VStack {
                
                Image("onboarding")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .padding(.bottom, 10)
                
                HStack {
                    Text("Sign In")
                        .font(.largeTitle)
                        .bold()
                }
      
                Form {
                    LabelTextField(label: "Email", hint: "", prompt: "jose@publisher.com", isError: false, isSecure: false, text: $viewModel.email, systemImage: "envelope", keyboardType: .emailAddress)
                    LabelTextField(label: "Password", prompt: "", isError: false, isSecure: true, text: $viewModel.password, systemImage: "lock")
                    
                        Button {
                            Task {
                                await appState.signInWithEmailAndPassword(email: viewModel.email, password: viewModel.password)
                            }
                        } label: {
                            Text("Login")
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                        .disabled(!viewModel.isValid)

                }
                .formStyle(.columns)
                .onSubmit {
                    //
                }
                
                HStack {
                  VStack { Divider() }
                  Text("or")
                  VStack { Divider() }
                }
                
                appleSignInButton()
            
               
            }
            .padding(.horizontal, 40)
            .frame(maxHeight: .infinity)

            VStack {
                Divider()
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("Don't have an account?")
                    Button {
                        viewModel.showSetup.toggle()
                        } label: {
                            Text("Setup a Congregation Account")
                        }
                }
                .padding()
                .padding(.bottom, getSafeArea().bottom)
            }
            .background(Color(.secondarySystemBackground), in: Rectangle())
            .sheet(isPresented: $viewModel.showSetup) {
                SetupView()
            }
           
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    @ViewBuilder func appleSignInButton() -> some View {
        SignInWithAppleButton(.signIn) { request in
            viewModel.handleSignInWithAppleRequest(request)
          } onCompletion: { result in
            viewModel.handleSignInWithAppleCompletion(result)
          }
          .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
          .frame(maxWidth: .infinity, maxHeight: 50)
          .cornerRadius(8)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
