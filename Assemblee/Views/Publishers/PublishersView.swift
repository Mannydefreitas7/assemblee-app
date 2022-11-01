//
//  PublishersView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import SwiftUI

struct PublishersView: View {
    
    @StateObject var viewModel: PublishersViewModel = PublishersViewModel()
    var title: String
    var displayMode: NavigationBarItem.TitleDisplayMode = .large
    var body: some View {
        List {
            ForEach($viewModel.publishers, id: \.id) { publisher in
                PublisherRowView(publisher: publisher)
            }
        }
        .searchable(text:$viewModel.searchText) {
            Section(viewModel.searchText.isEmpty ? "" : "Results for \(viewModel.searchText)") {
                ForEach($viewModel.publisherSuggestions, id: \.id) { publisher in
                    PublisherRowView(publisher: publisher)
                }
            }
        }
        .searchSuggestions(.visible, for: .menu)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(displayMode)
    }
}

