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
                    VStack(alignment: .leading) {
                        Text(part.shortTitle)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(Color(.label))
                        
                        VStack(alignment: .leading) {
            
                                if let assignee = part.assignee {
                                    Text("\(assignee.firstName?.first?.uppercased() ?? "C"). \(assignee.lastName ?? "Russel")")
                                        .font(.body)
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(.label))
                                        .lineLimit(1)
                                        .padding(.top, 2)
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
                        
                        
                    }
                    Spacer()
                    if let isConfirmed = part.isConfirmed, isConfirmed {
                     
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(Color(primaryColor))
                                .symbolRenderingMode(.hierarchical)
                                .padding(.trailing, 5)
                    }

                }
                .padding(.vertical, 5)
            }
            
        }
//        .swipeActions {
//            if let part = partVM.part, let isConfirmed = part.isConfirmed {
//                Button {
//                   // partVM.toggleConfirm(isConfirmed: isConfirmed)
//                } label: {
//                    Label(isConfirmed ? "Unconfirm" : "Confirm", systemImage: isConfirmed ? "xmark" : "checkmark")
//                }
//                .tint(isConfirmed ? .red : .green)
//            }
//        }
    }

}
#endif

