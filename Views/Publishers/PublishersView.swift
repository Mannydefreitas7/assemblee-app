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

