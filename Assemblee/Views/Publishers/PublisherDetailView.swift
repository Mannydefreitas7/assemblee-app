//
//  PublisherDetailView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 11/1/22.
//

import SwiftUI

struct PublisherDetailView: View {
    
    @ObservedObject var viewModel: PublisherDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            LazyVStack {
                if let publisher = viewModel.publisher, let firstName = publisher.firstName, let lastName = publisher.lastName, let email = publisher.email {
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
        }
    }
}
