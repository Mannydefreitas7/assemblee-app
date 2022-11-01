//
//  ProgramDetailView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import SwiftUI

struct ProgramDetailView: View {

    @ObservedObject var viewModel: ProgramDetailViewModel
    @EnvironmentObject var appState: AssembleeAppState
   
    var body: some View {
        VStack(spacing: 0) {
            
            Picker(selection: $viewModel.view) {
                Text("Midweek")
                    .tag(ABScheduleType.midweek)
                Text("Weekend")
                    .tag(ABScheduleType.weekend)
            } label: {
                Text("Schedule")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.bottom)
            
            Divider()
            
            List {
                if viewModel.view == .midweek {
                    
                    chairmanSection(for: 0)
                    prayerSection(for: 0)
                    treasuresSection()
                    applySection()
                    lifeSection()
                    
                    secondarySection()
                    prayerSection(for: 1)
                    
                } else if viewModel.view == .weekend {
                    
                    chairmanSection(for: 1)
                    prayerSection(for: 2)
                    
                    talkSection()
                    watchtowerSection()
                    
                    prayerSection(for: 3)
                    
                }
    
            }
            .background(Color(.secondarySystemGroupedBackground))
            .navigationDestination(for: PartViewModel.self) { partViewModel in
                PartView(viewModel: partViewModel)
            }
        }
            .navigationTitle(viewModel.range)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
                    Menu {
                        
                        Button {
                            //
                        } label: {
                            Label("Add Part", systemImage: "doc.badge.plus")
                        }
                        
                        Button(role:.destructive) {
                            //
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }

                }
            }
          
    }
    
    // MARK: Chairman Section
    @ViewBuilder func chairmanSection(for index: Int) -> some View {
        Section {
            if viewModel.chairmansViewModel.count > index {
                PartRowCell(partVM:viewModel.chairmansViewModel[index])
            }
        }
    }

    // MARK: Prayer Section
    @ViewBuilder func prayerSection(for index: Int) -> some View {
        Section {
            if viewModel.prayersViewModel.count > index {
                PartRowCell(partVM:viewModel.prayersViewModel[index])
            }
        }
    }
    
    // MARK: Treasures Section
    @ViewBuilder func treasuresSection() -> some View {
        Section(header:
            Text(STRING_TREASURES)
            .foregroundColor(Color(treasuresColor))
            .font(.system(size: 18, weight: .bold, design: .rounded))
        ) {
            ForEach(viewModel.treasuresViewModel, id: \.identifier) { PartRowCell(partVM: $0) }
            .onMove { indexSet, offset in
              //  viewModel.treasuresViewModel.move(fromOffsets: indexSet, toOffset: offset)
              //  viewModel.updateOrder(parts: viewModel.treasuresViewModel, set: indexSet, offset: offset)
            }
        }
    }
    
    // MARK: Apply Section
    @ViewBuilder func applySection() -> some View {
        Section(header:
        Text(STRING_APPLY)
            .foregroundColor(Color(applyColor))
            .font(.system(size: 18, weight: .bold, design: .rounded))
        ) {
            ForEach(viewModel.applyViewModel, id: \.identifier) { PartRowCell(partVM: $0) }
            .onMove { indexSet, offset in
              //  viewModel.applyViewModel.move(fromOffsets: indexSet, toOffset: offset)
              //  viewModel.updateOrder(parts: viewModel.applyViewModel, set: indexSet, offset: offset)
            }
        }
    }
    // MARK: Life Section
    @ViewBuilder func lifeSection() -> some View {
        Section(header:
        Text(STRING_LIFE)
        .foregroundColor(Color(lifeColor))
        .font(.system(size: 18, weight: .bold, design: .rounded))
        ) {
            ForEach(viewModel.lifeViewModel, id: \.identifier) { PartRowCell(partVM: $0)
            }
            .onMove { indexSet, offset in
               //viewModel.lifeViewModel.move(fromOffsets: indexSet, toOffset: offset)
                //viewModel.updateOrder(parts: viewModel.lifeViewModel, set: indexSet, offset: offset)
            }
        }
    }
    
    // MARK: Secondary section
    @ViewBuilder func secondarySection() -> some View {
        Section(header: Text(STRING_SECONDARY)
                    .foregroundColor(Color.secondary)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
        ) {
            ForEach(viewModel.secondaryViewModel, id: \.identifier) { PartRowCell(partVM: $0)}
        }
    }
    
    // MARK: Talk
    @ViewBuilder func talkSection() -> some View {
        Section(header: Text("Public Talk")
                    .foregroundColor(Color.secondary)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
        ) {
            if let talkViewModel = viewModel.talkViewModel {
                PartRowCell(partVM: talkViewModel)
            }
        }
    }
    
    // MARK: Watchtower
    @ViewBuilder func watchtowerSection() -> some View {
        Section(header: Text("Watchtower")
                    .foregroundColor(Color.secondary)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
        ) {
            if let watchtowerViewModel = viewModel.watchtowerViewModel {
                PartRowCell(partVM: watchtowerViewModel)
            }
        }
    }
}
