//
//  CalendarView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/25/22.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var viewModel: CalendarViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            DatePicker(selection: $viewModel.date, in: Date()..., displayedComponents: .date) {
                           Text("Select Week")
            }
            .datePickerStyle(.graphical)
            
            LazyVStack(alignment: .leading) {
                Text("Selected Week")
                    .foregroundColor(.secondary)
                Text(viewModel.label)
                    .font(.title3)
                    .bold()
            }
            .padding(.bottom)
            
            HStack {
                Image(systemName: "calendar")
                    .imageScale(.medium)
                    .padding()
                    .background(Color(.systemBackground), in: Circle())
                

               
                VStack(alignment: .leading) {
                    Text("Schedule")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Midweek")
                        .bold()
                }
                
                Spacer()
                
                if viewModel.isLoading || viewModel.isMidweekLoading {
                    ProgressView()
                } else if viewModel.midweekExists {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .bold()
                } else {
                    Button {
                        Task {
                            await viewModel.addMidweek()
                        }
                    } label: {
                        Text(viewModel.isMidWeekAvailable ? "Download" : "Not Available")
                            .bold()
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .disabled(!viewModel.isMidWeekAvailable)
                }
        
            }
            .padding()
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
            
            HStack {
                Image(systemName: "calendar")
                    .imageScale(.medium)
                    .padding()
                    .background(Color(.systemBackground), in: Circle())
            
               
                VStack(alignment: .leading) {
                    Text("Schedule")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Weekend")
                        .bold()
                }
                
                Spacer()
                
                if viewModel.isLoading || viewModel.isWeekEndLoading {
                    
                    ProgressView()
                    
                } else if viewModel.weekendExists {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .bold()
                } else {
                    
                    Button {
                        Task {
                            await viewModel.addWeekEnd()
                        }
                    } label: {
                       Text("Download")
                            .bold()
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                
                }
            
            }
            .padding()
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
         
            Spacer()

        }
        .padding()
    }
}
