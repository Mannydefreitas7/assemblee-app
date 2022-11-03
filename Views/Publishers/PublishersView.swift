//
//  PublishersView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import SwiftUI
import CongregationServiceKit

struct PublishersView: View {
    
    @StateObject var viewModel: PublishersViewModel = PublishersViewModel()
    @Environment(\.dismiss) var dismiss
    // Properties
    var viewType: ABPublishersViewType = .list
    var selectedPublisher: (_ selectedPublisher: ABPublisher) -> Void

    var body: some View {
        List {
            ForEach($viewModel.publishers, id: \.id) { publisher in
                if viewType == .list {
                    publisherRowLink(publisher)
                } else {
                    selectPublisherRow(publisher)
                }
            }
        }
        .searchable(text:$viewModel.searchText) {
            Section(viewModel.searchText.isEmpty ? "" : "Results for \"\(viewModel.searchText)\"") {
                ForEach($viewModel.publisherSuggestions, id: \.id) { publisher in
                    if viewType == .list {
                        publisherRowLink(publisher)
                    } else {
                        selectPublisherRow(publisher)
                    }
                }
            }
        }
        .searchSuggestions(.visible, for: .menu)
        .navigationTitle(viewType == .list ? "Publishers" : "Select Publisher")
        .navigationBarTitleDisplayMode(viewType == .list ? .large : .inline)
        .navigationDestination(for: PublisherDetailViewModel.self) { PublisherDetailView(viewModel: $0) }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    viewModel.showAddPublisherSheet.toggle()
                } label: {
                    Label("Publisher", systemImage: "plus.circle.fill")
                        .labelStyle(.titleAndIcon)
                        .symbolRenderingMode(.hierarchical)
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Menu {
                    Button {
                        viewModel.showFileImporter.toggle()
                    } label: {
                        Label("Import from Hourglass", systemImage: "square.and.arrow.down")
                    }
                } label: {
                    Label("More", systemImage: "ellipsis.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                }

                
            }
        }
        .sheet(isPresented: $viewModel.showAddPublisherSheet) {
            NavigationStack {
                AddPublisherView()
                    .navigationTitle("New Publisher")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .fileImporter(isPresented: $viewModel.showFileImporter, allowedContentTypes: [.commaSeparatedText]) { result in
            switch result {
            case .success(let url): print(url)
            case .failure(let error): print(error)
            }
        }
    }
    
    @ViewBuilder func selectPublisherRow(_ publisher: Binding<ABPublisher>) -> some View {
        Button {
            selectedPublisher(publisher.wrappedValue)
            dismiss()
        } label: {
            PublisherRowView(publisher: publisher)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder func publisherRowLink(_ publisher: Binding<ABPublisher>) -> some View {
        NavigationLink(value: PublisherDetailViewModel(publisher: publisher.wrappedValue)) {
            PublisherRowView(publisher: publisher)
        }
    }
}

