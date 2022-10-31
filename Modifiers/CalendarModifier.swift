//
//  CalendarModifier.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/30/22.
//

import Foundation
import SwiftUI
import AlertToast

struct CalendarModifier: ViewModifier {
    @StateObject var viewModel: CalendarViewModel = CalendarViewModel()
    @Binding var isPresented: Bool
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    CalendarView(viewModel: viewModel)
                        .navigationTitle("Add Schedule")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button {
                                    isPresented.toggle()
                                } label: {
                                    Text("Done")
                                }
                            }
                        }
                        .toastAlert(logManager: viewModel.logManager)
                }
            }
    }
}
