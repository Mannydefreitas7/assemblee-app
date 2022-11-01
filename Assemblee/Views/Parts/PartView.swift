//
//  PartView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import SwiftUI

struct PartView: View {
    
    @ObservedObject var viewModel: PartViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                partTitle()
                Divider()
                List {
                        
                    if let part = viewModel.part, (part.parent == ABParent.treasures.rawValue && part.index == 2) || part.parent == ABParent.apply.rawValue {
                        gridOptions()
                    }
                   
   
                   
                    Section {
                        assigneeRow()
                        if let part = viewModel.part, part.hasAssistant {
                            assistantRow()
                        }
                    } header: {
                       Text("Participants").bold()
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            //
                        } label: {
                            HStack {
                                Text("Delete")
                                Spacer()
                                Image(systemName: "trash")
                            }

                        }
                    }
                }
            }
       
        
        .background(Color(.secondarySystemGroupedBackground))
        .navigationTitle(viewModel.week?.range ?? "")
    }
    
    @ViewBuilder func partTitle() -> some View {
        LazyVStack(alignment: .leading) {
            HStack {
                Text("Name")
                    .bold()
                Spacer()
                Button {
                    //
                } label: {
                    Text("Edit")
                        .bold()
                }
            }
            Divider()
            Text(viewModel.part?.title ?? "")
                .font(.body)
                .padding(.horizontal)
                .padding(.vertical, 5)
            
            PillView(text: viewModel.part?.parent ?? "", color: Color(viewModel.part?.parent ?? ""))
                .padding(.leading)
        }
        .padding()
    }
    
    // MARK: Assignee Row
    @ViewBuilder func assigneeRow() -> some View {
        if let part = viewModel.part {
            if let _ = part.assignee {
                PublisherRowView(publisher: $viewModel.assignee)
            } else {
                Button {
                    //
                } label: {
                    HStack {
                        Text("Select Assignee")
                        Spacer()
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .symbolRenderingMode(.hierarchical)
                            .imageScale(.large)
                    }
                    .padding(.vertical, 10)
                }
            }
        }
    }
    
    // MARK: Assistant Row
    @ViewBuilder func assistantRow() -> some View {
        if let part = viewModel.part {
            if let _ = part.assistant {
                PublisherRowView(publisher: $viewModel.assistant)
            } else {
                Button {
                    //
                } label: {
                    HStack {
                        Text("Select Assistant")
                        Spacer()
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .symbolRenderingMode(.hierarchical)
                            .imageScale(.large)
                    }
                    .padding(.vertical, 10)
                }
            }
        }
    }
    
    // MARK: Grid options
    @ViewBuilder func gridOptions() -> some View {
        Section {
            
            LazyVGrid(columns: columns) {
                
                
                gridButton(label: "Share", systemImage: "square.and.arrow.up") {
                    //
                }
                .disabled(true)
                
                gridButton(label: "Email", systemImage: "envelope") {
                    //
                }
                
                gridButton(label: "WhatsApp", systemImage: "message") {
                    //
                }
                
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
    
    @ViewBuilder func gridButton(label: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            LazyVStack(spacing: 5) {
                Image(systemName: systemImage)
                    .frame(minHeight: 24, alignment: .center)
                Text(label)
            }
            .frame(minHeight: 80)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
