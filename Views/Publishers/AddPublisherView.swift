//
//  AddPublisherView.swift
//  Assemblee
//
//  Created by De Freitas, Manuel on 11/3/22.
//

import SwiftUI

struct AddPublisherView: View {
    
    @StateObject var viewModel: AddPublisherViewModel = AddPublisherViewModel()
    @FocusState private var focusedField: String?
    @Environment(\.dismiss) var dismiss
    let genderCols = [GridItem(.flexible()), GridItem(.flexible())]
    let generalCols = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        Form {
            
            genderOptions()
            
            Section("Name") {
                TextField("First Name", text: $viewModel.newPublisher.firstName ?? "")
                    .focused($focusedField, equals: "first_name")
                    .onSubmit {
                        focusedField = "last_name"
                    }
                    .submitLabel(.next)
                    .autocorrectionDisabled()
                TextField("Last Name", text: $viewModel.newPublisher.lastName ?? "")
                    .focused($focusedField, equals: "last_name")
                    .onSubmit {
                        focusedField = "email"
                    }
                    .submitLabel(.next)
                    .autocorrectionDisabled()
            }
         
        
            Section {
              
                TextField("Email", text: $viewModel.newPublisher.email ?? "")
                    .focused($focusedField, equals: "email")
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .padding(.vertical, 7)
                    .onSubmit {
                        focusedField = "phone"
                    }
                    .submitLabel(.next)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
                
                TextField("Phone", text: $viewModel.newPublisher.phone ?? "")
                    .focused($focusedField, equals: "phone")
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
                    .padding(.vertical, 7)
                    .autocorrectionDisabled()
                
               
                
            } header: {
                Text("Contact")
            } footer: {
                if !viewModel.message.isEmpty {
                    Text(viewModel.message)
                        .foregroundColor(Color(.systemRed))
                }
            }
            Section {
                privilegePicker()
            }
            
            Button {
                Task {
                    await viewModel.submit {
                        self.dismiss()
                    }
                }
            } label: {
                HStack {
                    if let firstName = viewModel.newPublisher.firstName, let lastName = viewModel.newPublisher.lastName {
                        Text("Add \(lastName), \(firstName)")
                    } else {
                        Text("Add")
                    }
                Spacer()
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "plus")
                    }
                }
            }
            .disabled(!viewModel.isValidated() || viewModel.isLoading)
        }
        .toolbar {
            if viewModel.isLoading {
                ToolbarItem(placement: .confirmationAction) {
                    ProgressView()
                }
            }
        }
    }
    
    // MARK: Grid options
    @ViewBuilder func genderOptions() -> some View {
        Section("Gender") {
            
            LazyVGrid(columns: genderCols) {
                
                genderButton(label: "Brother", image: "brother") {
                    viewModel.gender = .brother
                }
                
                genderButton(label: "Sister", image: "sister") {
                    viewModel.gender = .sister
                }

            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
    

    @ViewBuilder func genderButton(label: String, image: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            LazyVStack(spacing: 5) {
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 32, height: 32, alignment: .center)
                Text(label)
                    .bold()
            }
            .foregroundColor(viewModel.gender == ABGender(rawValue: image) ? .accentColor : Color(.label))
            .frame(minHeight: 120)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
    

    @ViewBuilder func privilegePicker() -> some View {
        Picker("Privilege", selection: $viewModel.newPublisher.privilege ?? "") {
            Text(ABPrivilege.publisher.rawValue.capitalized)
                .tag(ABPrivilege.publisher.rawValue)
            if viewModel.gender == .brother {
                Text(ABPrivilege.elder.rawValue.capitalized)
                    .tag(ABPrivilege.elder.rawValue)
                Text(ABPrivilege.assistant.rawValue.capitalized)
                    .tag(ABPrivilege.assistant.rawValue)
            }
        }
    }
}
