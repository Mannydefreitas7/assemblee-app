//
//  TodayView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import SwiftUI
import RealmSwift

struct TodayView: View {
    
    @EnvironmentObject var appState: AssembleeAppState
    @StateObject var viewModel = TodayViewModel()
    @ObservedResults(RMWeek.self) var weeks
    
    var body: some View {
        
        ZStack {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            HeaderScrollView(image: "today", height: getRect().height / 2) {
                if weeks.isEmpty {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Cette Semaine")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                            Text(viewModel.currentWeek?.range ?? "No schedules")
                                .font(.title3)
                                .foregroundColor(.white)
                                .bold()
                        }
                        Spacer()
                        NavigationLink("View", value: viewModel.currentWeek.self)
                            .bold()
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                    }
                }
                
            } content: {
                LazyVStack(alignment: .leading) {
                    
                    if weeks.isEmpty {
                        
                        emptyState()

                    } else {
                        VStack(alignment: .leading) {
                            Text(appState.currentUser?.uid ?? "")
                            
                            Text("Schedules")
                                .bold()
                                .font(.system(.title3, design: .rounded))
                                .padding(.leading)
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
                                    if let user = appState.currentUser, let congregation = user.congregation {
                                        ScheduleView(viewModel: ScheduleViewModel(week: week, congregation: congregation))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
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
    
    @ViewBuilder func emptyState() -> some View {
        VStack {
            Image(systemName: "doc.on.doc")
                .padding(7)
                .background(Color.secondary, in: Circle())
                .scaleEffect(2)
                .padding()
                .opacity(0.3)
            Text("You have no schedules.")
                .font(.title3)
                .foregroundColor(.secondary)
                .bold()
            Button {
                appState.showAddSchedule.toggle()
            } label: {
                Label("Schedule", systemImage: "calendar.badge.plus")
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.top, 50)
        
    }

}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
