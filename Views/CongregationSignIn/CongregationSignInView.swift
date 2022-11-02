//
//  CongregationSignInView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/15/22.
//

import SwiftUI
import AuthenticationServices

struct CongregationSignInView: View {
    
    @StateObject var viewModel: CongregationSignInViewModel = CongregationSignInViewModel()
    @EnvironmentObject var appState: AssembleeAppState
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("email") var email: String?
    let randomGenerator = RandomPinGenerator.instance
    
    
    var body: some View {
        VStack {
            VStack {
                
                Image("onboarding")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .padding(.bottom, 10)
                
                HStack {
                    Text("Congregation")
                        .font(.largeTitle)
                        .bold()
                   
                }
                
                Text("Enter the congregation code to see available schedules.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                
                Form {
                   
                    LabelTextField(label: "Code", hint: "Congregation code can be provided by one of your elders.", prompt: "ABC-DEF-1234", isError: false, isSecure: true, text: $viewModel.code, systemImage: "lock")
                    
                        Button {
                           //
                        } label: {
                            Text("Submit")
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(.borderedProminent)

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
                
                if let email {
                    HStack {
                        Image(systemName: "envelope.circle.fill")
                            .imageScale(.large)
                            .scaleEffect(1.5)
                        VStack(alignment: .leading) {
                            Text("Check your email.")
                                .bold()
                            Text("We sent a link to \(email)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button {
                            self.email = nil
                        } label: {
                            Text("Reset")
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                    }
                    .padding()
                    .padding(.bottom, getSafeArea().bottom)
                } else {
                    VStack(alignment: .leading) {
                        Text("Don't have an account?")
                        Button {
                            appState.showSetup.toggle()
                            } label: {
                                Text("Setup a Congregation Account")
                            }
                    }
                    .padding()
                    .padding(.bottom, getSafeArea().bottom)
                }
            
            }
            .background(Color(.secondarySystemBackground), in: Rectangle())
            .sheet(isPresented: $appState.showSetup) {
                SetupView()
                    .environmentObject(appState)
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
