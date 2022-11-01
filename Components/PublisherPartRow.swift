//
//  PublisherPartRow.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import SwiftUI
import CongregationServiceKit

struct PublisherRowView: View {
    @Binding var publisher: ABPublisher
    var body: some View {
        HStack {
            if let firstName = publisher.firstName, let lastName = publisher.lastName, let gender = publisher.gender {
                Text("\(lastName.first?.uppercased() ?? "")\(firstName.first?.uppercased() ?? "")")
                    .fontWeight(.bold)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(Color.white)
                    .padding(9)
                    .background(Color(gender == ABGender.brother.rawValue ? .systemBlue : .systemPurple).gradient, in: Circle())
                
                
                VStack(alignment: .leading) {
                    Text("\(lastName), \(firstName)")
                        .fontWeight(.medium)
                    Text(publisher.privilege?.uppercased() ?? "")
                        .foregroundColor(Color(.systemGray))
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 7)
    }
}

