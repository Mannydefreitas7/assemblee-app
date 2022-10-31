//
//  ABTabView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import SwiftUI

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
            
            NavigationStack {
                ProgramsView()
            }
            .tabItem {
                Label("Programs", systemImage: "chart.bar.doc.horizontal")
            }
        }
        .environmentObject(appState)
        
    }
}


