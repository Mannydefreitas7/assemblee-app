//
//  ABTabView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import SwiftUI
import CongregationServiceKit

struct ABTabView: View {

    @EnvironmentObject var appState: AssembleeAppState
    
    var body: some View {
        TabView {
            NavigationStack {
                TodayView()
            }
            .tabItem {
                Label("Today", systemImage: "calendar")
            }
            if let currentUser = appState.currentUser, let permissions = currentUser.permissions, permissions.contains(ABPermission.editor.rawValue) || permissions.contains(ABPermission.admin.rawValue) {
                
                NavigationStack {
                    ProgramsView()
                }
                .tabItem {
                    Label("Programs", systemImage: "chart.bar.doc.horizontal")
                }
                
                NavigationStack {
                    PublishersView { _ in }
                }
                .tabItem {
                    Label("Publishers", systemImage: "person.2.fill")
                }
                
            }

        }
        .environmentObject(appState)
        
    }
}


