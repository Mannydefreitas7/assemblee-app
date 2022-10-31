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
                
                chairmanSection()
                treasuresSection()
                applySection()
                lifeSection()
                secondarySection()
                prayerEndSection()
            }
        }
            
            .navigationTitle(viewModel.range)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.status) {
                }
            }
    }
    
    // MARK: Chairman Section
    @ViewBuilder func chairmanSection() -> some View {
        Section {
            if viewModel.chairmansViewModel.count > 0 {
                PartRowCell(partVM:viewModel.chairmansViewModel.first!)
            }
            if viewModel.prayersViewModel.count > 0 {
                PartRowCell(partVM:viewModel.prayersViewModel.first!)
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
    // MARK: Prayer end section
    @ViewBuilder func prayerEndSection() -> some View {
        if viewModel.prayersViewModel.count > 1 {
            PartRowCell(partVM:viewModel.prayersViewModel[1])
        }
    }
    
    @ViewBuilder func secondarySection() -> some View {
        Section(header: Text(STRING_SECONDARY)
            .foregroundColor(Color.secondary)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
        ) {
            ForEach(viewModel.secondaryViewModel, id: \.identifier) { PartRowCell(partVM: $0) }
        }
    }
}
