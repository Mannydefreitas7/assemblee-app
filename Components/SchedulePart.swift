//
//  SchedulePart.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import SwiftUI
import CongregationServiceKit

struct SchedulePart: View {
    
    var part: ABPart
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            
            if let title = part.title {
                Text(title)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 5)
            }
            
            VStack(alignment: .leading) {
                if let assignee = part.assignee, let firstName = assignee.firstName, let lastName = assignee.lastName {
                    Text("\(firstName) \(lastName)")
                        .font(.title3)
                        .fontWeight(.bold)
                        
                }
                
                if let assistant = part.assistant, let firstName = assistant.firstName, let lastName = assistant.lastName {
                    Text("\(firstName) \(lastName)")
                        .foregroundColor(.secondary)
                        .font(.title3)
                }
            }
            .padding(.leading)
            .padding(.bottom, 5)
        }
    }
}
