//
//  PublisherDetailView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 11/1/22.
//

import SwiftUI

struct PublisherDetailView: View {
    
    @ObservedObject var viewModel: PublisherDetailViewModel
    @Environment(\.editMode) var editMode
    @FocusState private var focusedField: String?
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 0) {
            LazyVStack {
                Avatar(firstName: viewModel.firstName, lastName: viewModel.lastName)
                    .scaleEffect(2.5)
                    .padding()
                    .padding(.bottom)
                VStack {
                    Text("\(viewModel.lastName), \(viewModel.firstName)")
                        .bold()
                        .font(.title3)
                    Text(viewModel.publisher?.email ?? "")
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
            }
            .padding()
            Divider()
            
            
            List {
                
                
                Section("Name") {
                    if viewModel.editMode == .inactive {
                        Text("First Name")
                            .badge(viewModel.firstName)
                        Text("Last Name")
                            .badge(viewModel.lastName)
                    } else {
                         TextField("First Name", text: $viewModel.firstName)
                            .focused($focusedField, equals: "first_name")
                         TextField("Last Name", text: $viewModel.lastName)
                            .focused($focusedField, equals: "last_name")
                    }

                }
             
            
                Section {
                    if viewModel.editMode == .inactive {
                        HStack {
                            Image(systemName: "envelope.circle.fill")
                            Text("Email")
                                .badge(viewModel.publisher?.email ?? "")
                        }
                        .padding(.vertical, 7)
                        HStack {
                            Image(systemName: "phone.circle.fill")
                            Text("Phone")
                                .badge(viewModel.publisher?.phone ?? "")
                        }
                        .padding(.vertical, 7)
                    } else {
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .padding(.vertical, 7)
                        TextField("Phone", text: $viewModel.phone)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                            .padding(.vertical, 7)
                    }
                } header: {
                    Text("Contact")
                } footer: {
                    if !viewModel.message.isEmpty {
                        Text(viewModel.message)
                            .foregroundColor(Color(.systemRed))
                    }
                }
                
                genderOptions()
            }
        }
        .navigationTitle("\(viewModel.lastName), \(viewModel.firstName)")
        .navigationBarTitleDisplayMode(.inline)
        .toastAlert(logManager: viewModel.logManager)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    viewModel.toggleEdit { editMode in
                        focusedField = editMode == .active ? "first_name" : nil
                    }
                } label: {
                    Text(viewModel.editMode == .inactive ? "Edit": "Done")
                        .bold()
                }
            }
        }
        .environment(\.editMode, $viewModel.editMode)
    }
    
    // MARK: Grid options
    @ViewBuilder func genderOptions() -> some View {
        Section("Gender") {
            
            LazyVGrid(columns: columns) {
                
                
                genderButton(label: "Brother", image: "brother") {
                    //
                }
                .disabled(viewModel.editMode == .inactive)
                
                genderButton(label: "Sister", image: "sister") {
                    //
                }
                .disabled(viewModel.editMode == .inactive)
                
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
}
