//
//  TodayView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import SwiftUI
import CongregationServiceKit
import FirebaseFirestoreSwift

struct TodayView: View {
    
    @EnvironmentObject var appState: AssembleeAppState
    @StateObject var viewModel = TodayViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            HeaderScrollView(image: "today", height: getRect().height / (viewModel.hasCurrentWeek ? 2 : 3)) {
                
                if let currentWeek = viewModel.currentWeek, !viewModel.weeks.isEmpty {
                    currentWeekRow(currentWeek)
                }
                
            } content: {
                LazyVStack(alignment: .leading) {
                    
                    Text("Schedules")
                        .bold()
                        .font(.system(.title3, design: .rounded))
                        .padding(.leading)
                        .padding(.top)
                    
                    if viewModel.pinnedWeeks.isEmpty {
                        
                        emptyState()

                    } else {
                        pinnedWeeks()
                    }
                }
            }
            
        }
        .navigationTitle("Today")
        .sheet(isPresented: $viewModel.showUserView) {
            UserView(appState: appState)
        }
        .toolbar {
            ToolbarItem {
                if let currentUser = appState.currentUser, let firstName = currentUser.firstName, let lastName = currentUser.lastName {
                    Button {
                        viewModel.showUserView.toggle()
                    } label: {
                        Avatar(firstName: firstName, lastName: lastName)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    // MARK: Pinned Weeks
    @ViewBuilder func pinnedWeeks() -> some View {
        VStack(alignment: .leading) {

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.pinnedWeeks) { week in
                        NavigationLink(value: week) {
                            ScheduleCard(week: week)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .navigationDestination(for: ABWeek.self) { week in
                    if let congregation = appState.congregation {
                        ScheduleView(viewModel: ScheduleViewModel(week: week, congregation: congregation))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    // MARK: Current Week
    @ViewBuilder func currentWeekRow(_ currentWeek: ABWeek) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Cette Semaine")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                Text(currentWeek.range ?? "")
                    .font(.title3)
                    .foregroundColor(.white)
                    .bold()
            }
            Spacer()
            NavigationLink("View", value: currentWeek.self)
                .bold()
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
        }
    }
    // MARK: Empty weeks state
    @ViewBuilder func emptyState() -> some View {
        VStack {
            Image(systemName: "doc.on.doc")
                .padding(7)
                .background(Color.secondary, in: Circle())
                .scaleEffect(1.5)
                .padding()
                .opacity(0.3)
            Text("There are no schedules on the board yet.")
                .foregroundColor(.secondary)
                .bold()
                .multilineTextAlignment(.center)
                .frame(width: getRect().width / 2)
//            Button {
//                appState.showAddSchedule.toggle()
//            } label: {
//                Label("Schedule", systemImage: "calendar.badge.plus")
//            }
//            .buttonStyle(.borderedProminent)
//            .buttonBorderShape(.roundedRectangle)
//            .controlSize(.large)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

}
