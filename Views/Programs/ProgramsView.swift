//
//  ProgramsView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/30/22.
//

import SwiftUI
import CongregationServiceKit

struct ProgramsView: View {
    @StateObject var viewModel = ProgramsViewModel()
    @EnvironmentObject var appState: AssembleeAppState
    var body: some View {
        List {
           ForEach(viewModel.scheduleByMonths, id: \.self) { month in
               Section(header: Text("\(Calendar.current.monthSymbols[month-1])")) {
                   ForEach(viewModel.weeks.filter { $0.formattedDate.month == month }, id: \.id) { programCell(vm: ProgramDetailViewModel(week: $0) )}
                   }
               }
        }
        .navigationTitle("Programs")
        .addScheduleSheet(isPresented: $viewModel.showAddScheduleSheet)
        .toastAlert(logManager: appState.logManager)
        .navigationDestination(for: ProgramDetailViewModel.self) { ProgramDetailView(viewModel: $0) }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    viewModel.showAddScheduleSheet.toggle()
                } label: {
                    Label("Schedule", systemImage: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .bold()
                        .labelStyle(.titleAndIcon)
                }
            }
        }
    }
    
    
    @ViewBuilder func programCell(vm: ProgramDetailViewModel) -> some View {
        NavigationLink(value: vm) {
            HStack {
                Image(systemName: "chart.bar.doc.horizontal")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.accentColor.gradient, in: Circle())

                VStack(alignment: .leading) {
                    Text("Week")
                        .font(.caption)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(Color(.systemGray))
                    Text(vm.week?.range ?? "")
                        .font(.body)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.label))
                        .lineLimit(2)
                }
                Spacer()
                if let week = vm.week, week.isSent {
                    Image(systemName: "pin.circle")
                        .foregroundStyle(Color.accentColor)
                        
                        .padding(.trailing, 5)
                }
            }
            .padding(.vertical, 7)
        }
        .swipeActions {
            if let week = vm.week, let currentUser = appState.currentUser, let permissions = currentUser.permissions, permissions.contains(ABPermission.admin.rawValue) {
                Button {
                    Task {
                        await viewModel.togglePin(week:week)
                    }
                } label: {
                    Label(week.isSent ? "Unpin" : "Pin", systemImage: week.isSent ? "pin.slash" : "pin")
                }
                .tint(week.isSent ? .yellow : .green)
            }
        }
    }
}
