//
//  PartRowCell.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import SwiftUI
import CongregationServiceKit

#if os(iOS)
struct PartRowCell: View {
    
    @ObservedObject var partVM: PartViewModel
    
    var body: some View {
        
        NavigationLink(value: partVM) {
            if let part = partVM.part {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(part.shortTitle)
                            .font(.system(.callout, design: .rounded))
                            .foregroundColor(Color(.label))
                        
                        VStack(alignment: .leading) {
            
                                if let assignee = part.assignee {
                                    Text("\(assignee.firstName?.first?.uppercased() ?? "C"). \(assignee.lastName ?? "Russel")")
                                        .font(.title3)
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(.label))
                                        .lineLimit(1)
                                }
                            
                                if let assistant = part.assistant {
                                    Text("\(assistant.firstName?.first?.uppercased() ?? "C"). \(assistant.lastName ?? "Russel")")
                                        .font(.body)
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(.secondaryLabel))
                                        .lineLimit(1)
                                }
                         
                        }
                        .padding(.top, 5)

                    }
                    Spacer()
                    
                    if let isConfirmed = part.isConfirmed, isConfirmed {
                     
                            Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color.accentColor)
                                .symbolRenderingMode(.hierarchical)
                                .padding(.trailing, 5)
                    }

                }
                .padding(.vertical, 5)
            }
            
        }
        .swipeActions(allowsFullSwipe: false) {
            if let part = partVM.part, let isConfirmed = part.isConfirmed {
                Button {
                    Task {
                        await partVM.toggleConfirm(isConfirmed)
                    }
                } label: {
                    VStack {
                        Image(systemName: isConfirmed ? "person.crop.circle.badge.questionmark.fill" : "person.crop.circle.badge.checkmark")
                            .imageScale(.small)
                            .bold()
                        Text(isConfirmed ? "Unconfirm" : "Confirm")
                            .bold()
                            .font(.caption)
                    }
                }
                .tint(isConfirmed ? Color(.systemGray) : .accentColor)
            }
        }
    }

}
#endif

