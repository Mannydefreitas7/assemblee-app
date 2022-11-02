//
//  SetupView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import SwiftUI
import CoreLocationUI
import AuthenticationServices
import CongregationServiceKit
import MapKit

struct SetupView: View {
    @EnvironmentObject var appState: AssembleeAppState
    @StateObject var viewModel = SetupViewModel()
    @FocusState private var focusedField: String?
    @AppStorage("user") var user: String?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            
            Group {
                containedView()
                    .toastAlert(logManager: viewModel.logManager)
            }
            .navigationTitle("Account Setup")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                if viewModel.page != .welcome {
                    VStack(spacing: 0) {
                        Divider()
                        controls()
                            .padding(.bottom, getSafeArea().bottom)
                            .background(.ultraThinMaterial, in: Rectangle())
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .interactiveDismissDisabled(viewModel.isLoading)
        
    }
    
    // MARK: Contained Pages
    func containedView() -> AnyView {
        switch viewModel.page {
        case .welcome: return AnyView(welcomePage())
        case .user: return AnyView(userInfoPage())
        case .language: return AnyView(languagesPage())
        case .congregation: return AnyView(congregationLocationsPage())
        case .done: return AnyView(reviewPage())
        }
    }
    
    
    // MARK: Pages
    // Page 1: Welcome
    @ViewBuilder func welcomePage() -> some View {
            VStack {
                
                Image("onboarding")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                
                VStack {
                    Text("Welcome!")
                        .font(.largeTitle.bold())
                    Text("Start your Assemblee Congregation setup now.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 50)
                .padding(.bottom)
                Button {
                    viewModel.page = .user
                } label: {
                    HStack {
                        Text("Start")
                        Image(systemName: "chevron.right")
                    }.bold()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top)
              
            }
    }
    
    // Page 2: User Info
    @ViewBuilder func userInfoPage() -> some View {
        ScrollView {
            VStack {
                VStack(spacing: 0) {
                    Text("1")
                        .font(.largeTitle)
                        .bold()
                        .padding(20)
                        .background(Color(.secondarySystemBackground), in: Circle())
                    Text("About you.")
                        .bold()
                        .font(.title)
                }
                .padding(.bottom)
                
                Form {
                    
                    LabelTextField(label: "First Name (required)", prompt: "Joe", text: $viewModel.newUser.firstName ?? "")
                        .focused($focusedField, equals: "first_name")
                        .onSubmit {
                            focusedField = "last_name"
                        }
                        .submitLabel(.next)
                    
                    LabelTextField(label: "Last Name (required)", prompt: "Publisher", text: $viewModel.newUser.lastName ?? "")
                        .focused($focusedField, equals: "last_name")
                        .onSubmit {
                            focusedField = "email"
                        }
                        .submitLabel(.next)
                    
                        HStack {
                          VStack { Divider() }
                          Text("and")
                          VStack { Divider() }
                        }
                        .padding(.vertical)
 
                    
                    LabelTextField(label: "Email", prompt: "joe@publisher.com", text: $viewModel.newUser.email ?? "", keyboardType: .emailAddress)
                        .textContentType(.emailAddress)
                        .focused($focusedField, equals: "email")
                        .onSubmit {
                            focusedField = "confirm_email"
                        }
                        .submitLabel(.next)
                    LabelTextField(label: "Confirm Email", prompt: "joe@publisher.com", text: $viewModel.confirmEmail, keyboardType: .emailAddress)
                        .textContentType(.emailAddress)
                        .focused($focusedField, equals: "confirm_email")
                        .onSubmit {
                            if viewModel.validate() {
                                focusedField = nil
                                viewModel.page = .language
                            }
                        }
                        .submitLabel(.continue)
                    
                }
                .formStyle(.columns)
                .padding(.horizontal)
                
                VStack {
                    HStack {
                      VStack { Divider() }
                      Text("or")
                      VStack { Divider() }
                    }
                    appleSignInButton()
                }
                .padding(.horizontal)
                .padding(.bottom)
                
            }
            
        }
        .padding(.horizontal)
        
        
    }
    
    // Page 3: Language Selection
    @ViewBuilder func languagesPage() -> some View {
        
        VStack {
            
            VStack(spacing: 0) {
                Text("2")
                    .font(.largeTitle)
                    .bold()
                    .padding(20)
                    .background(Color(.secondarySystemBackground), in: Circle())
                Text("Language")
                    .bold()
                    .font(.title)
                Text("Your Congregation language")
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            
            LazyVStack(spacing: 0) {
                
                if let language = viewModel.language {
                    languageCard(language: language)
                }
                
                LabelTextField(label: "", prompt: "Search languages...", text: $viewModel.queryLanguage, systemImage: "magnifyingglass")
                    .focused($focusedField, equals: "language")
                    .onSubmit {
                        focusedField = nil
                    }
                    .submitLabel(.search)
                
                
                if !viewModel.filteredLanguages.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            
                            ForEach(viewModel.filteredLanguages, id: \.locale) { language in
                                Button {
                                    viewModel.language =  language
                                    viewModel.filteredLanguages.removeAll()
                                    viewModel.queryLanguage = ""
                                } label: {
                                    languageCard(language: language)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.top)
                        .padding(.horizontal, 5)
                        
                    }
                }
                else if viewModel.queryLanguage.count > 3 {
                    LazyVStack {
                        
                        ProgressView {
                            Text("Searching...")
                        }
                        .padding()
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
    
    
    // Page 4: Congregation locations
    @ViewBuilder func congregationLocationsPage() -> some View {
        
        VStack(spacing: 0) {
            
            VStack(spacing: 0) {
                Text("3")
                    .font(.largeTitle)
                    .bold()
                    .padding(20)
                    .background(Color(.secondarySystemBackground), in: Circle())
                Text("Congregation")
                    .bold()
                    .font(.title)
                Text("Pick your congregation")
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            
            VStack(spacing: 0) {
                Form {
                    LabelTextField(label: "", prompt: "Enter location...", text: $viewModel.queryLocation, systemImage: "magnifyingglass")
                        .focused($focusedField, equals: "congregation")
                        .padding(.horizontal)
                        .keyboardType(.webSearch)
                        .onSubmit {
                            Task {
                                await viewModel.searchLocation(viewModel.queryLocation)
                            }
                        }
                }
                .formStyle(.columns)
                
                
                ScrollView(showsIndicators: false) {
                    if !viewModel.isSearching {
                        VStack {
                            ForEach(viewModel.congregations, id: \.geoID) { congregation in
                                Button {
                                    viewModel.selectCongregation(from: congregation)
                                } label: {
                                    congregationCard(congregation: congregation)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal)
                        .padding(.horizontal)
                    } else {
                        LazyVStack {
                            Spacer()
                            ProgressView {
                                Text("Searching...")
                            }
                            .padding()
                            Spacer()
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            
        }
        .onAppear {
            Task {
                await viewModel.requestCurrentLocation()
            }
        }
    }
    
    // Page 5: Review.
    @ViewBuilder func reviewPage() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    Text("4")
                        .font(.largeTitle)
                        .bold()
                        .padding(20)
                        .background(Color(.secondarySystemBackground), in: Circle())
                    Text("Review")
                        .bold()
                        .font(.title)
                    Text("Review below to complete setup.")
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
                
                GroupBox {
                    LazyVStack(alignment: .leading) {
                        HStack {
                            Text("First Name")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(viewModel.newUser.firstName ?? "")
                                .bold()
                        }
                        .padding(.vertical, 3)
                        
                        HStack {
                            Text("Last Name")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(viewModel.newUser.lastName ?? "")
                                .bold()
                        }
                        .padding(.vertical, 3)
                        
                        HStack {
                            Text("Email")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(viewModel.newUser.email ?? "")
                                .bold()
                        }
                        .padding(.vertical, 3)
                    }
                } label: {
                    HStack {
                        Text("About You")
                        Spacer()
                        Button("Edit") {
                            viewModel.page = .user
                        }
                    }
                  
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                if let language = viewModel.language {
                    GroupBox {
                        selectedLanguageCard(language: language)
                            .padding(.vertical)
                    } label: {
                        HStack {
                            Text("Target Language")
                            Spacer()
                            Button("Edit") {
                                viewModel.page = .language
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                if let congregation = viewModel.congregation {
                    GroupBox {
                        selectedCongregation(congregation: congregation)
                            .padding(.vertical)
                    } label: {
                        HStack {
                            Text("Your Congregation")
                            Spacer()
                            Button("Edit") {
                                viewModel.page = .congregation
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, getSafeArea().bottom * 2)
            .frame(maxHeight: .infinity)
        }
        .toolbar {
            if viewModel.isLoading {
                ToolbarItem(placement: .confirmationAction) {
                    ProgressView()
                }
            }
        }
    }
    
    // Page 6: Complete.
    @ViewBuilder func completePage() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    
                    Image(systemName: "envelope.circle.fill")
                        .padding(10)
                        .background(Color(.secondarySystemBackground), in: Circle())
                    Text("Check your inbox.")
                        .bold()
                        .font(.title)
                    Text("We sent a link to your \(viewModel.newUser.email ?? "")")
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
                
                
            }
            .padding(.bottom, getSafeArea().bottom * 2)
            .frame(maxHeight: .infinity)
        }
       
    }
    
    
    // Mark: Bottom controls
    @ViewBuilder func controls() -> some View {
        HStack {
            
            Button {
                viewModel.prev()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .bold()
            }
            
            Spacer()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button {
                    viewModel.next(appState: appState)
                } label: {
                    HStack {
                        Text(viewModel.page == .done ? "Done" : "Next")
                        Image(systemName:viewModel.page == .done ? "checkmark" : "chevron.right")
                    }.bold()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!viewModel.validate())
            }
        }
       
        .padding()
        .padding(.horizontal)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // MARK: Language card
    @ViewBuilder func languageCard(language: WOLLanguage) -> some View {
      
            HStack {
                Image(systemName: "quote.bubble")
                    .padding()
                    .background(Color.accentColor.gradient, in: Circle())
                    .foregroundColor(.white)
                VStack(alignment: .leading) {
                    Text(language.languageTitle ?? "")
                        .bold()
                        .lineLimit(1)
                    Text(language.englishName ?? "")
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if let _language = viewModel.language, let locale = language.locale, let _locale = _language.locale, locale == _locale {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .bold()
                }
                
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            .ignoresSafeArea(.keyboard)
    }
    
    // MARK: Congregation card
    @ViewBuilder func congregationCard(congregation: GeoLocationList) -> some View {
      
        HStack(alignment: .center) {
                Image(systemName: "building.2")
                    .padding()
                    .background(Color.accentColor.gradient, in: Circle())
                    .foregroundColor(.white)
                VStack(alignment: .leading) {
                    Text(congregation.properties?.orgName ?? "")
                        .bold()
                        .lineLimit(1)
                    Text(congregation.properties?.address ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                if let _congregation = viewModel.congregation, let geoID = congregation.properties?.orgGUID, let _geoID = _congregation.properties?.orgGUID, geoID == _geoID {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .bold()
                }
                
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            .ignoresSafeArea(.keyboard)
    }
    
    // MARK: Selected Congregation Card
    @ViewBuilder func selectedCongregation(congregation: ABCongregation) -> some View {
      
        HStack(alignment: .center) {
                Image(systemName: "building.2")
                    .padding()
                    .background(Color.accentColor.gradient, in: Circle())
                    .foregroundColor(.white)
                VStack(alignment: .leading) {
                    Text(congregation.properties?.orgName ?? "")
                        .bold()
                        .lineLimit(1)
                    Text(congregation.properties?.address ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
    }
    
    // MARK: Selected Language card
    @ViewBuilder func selectedLanguageCard(language: WOLLanguage) -> some View {
      
            HStack {
                Image(systemName: "quote.bubble")
                    .padding()
                    .background(Color.accentColor.gradient, in: Circle())
                    .foregroundColor(.white)
                VStack(alignment: .leading) {
                    Text(language.languageTitle ?? "")
                        .bold()
                        .lineLimit(1)
                    Text(language.englishName ?? "")
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
    }
    
    @ViewBuilder func appleSignInButton() -> some View {
        SignInWithAppleButton(.continue) { request in
            print(request)
            viewModel.handleSignInWithAppleRequest(request)
          } onCompletion: { result in
            viewModel.handleSignInWithAppleCompletion(result)
          }
          .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
          .frame(maxWidth: .infinity, minHeight: 50)
          .cornerRadius(8)
    }
}
