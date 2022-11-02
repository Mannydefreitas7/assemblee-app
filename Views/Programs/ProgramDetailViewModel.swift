//
//  ProgramDetailViewModel.swift
//  Assemblee (iOS)
//
//  Created by Manuel De Freitas on 1/17/22.
//

import Foundation
import Combine
import SwiftUI
import CongregationServiceKit

@MainActor
class ProgramDetailViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
 
    @Published var week: ABWeek?
    @Published var range: String = ""
    @Published var view: ABScheduleType = .midweek
    @Published var congregation: ABCongregation?
    @Published var partRepository = PartRepository()
    
    @Published var chairmansViewModel = [PartViewModel]()
    @Published var treasuresViewModel = [PartViewModel]()
    @Published var secondaryViewModel = [PartViewModel]()
    @Published var lifeViewModel = [PartViewModel]()
    @Published var applyViewModel = [PartViewModel]()
    @Published var prayersViewModel = [PartViewModel]()
    @Published var talkViewModel: PartViewModel?
    @Published var watchtowerViewModel: PartViewModel?
    
    init(week: ABWeek) {
        self.week = week
        
        
        
        UserDefaults.standard.data(forKey: "congregation").publisher
            .map { self.fetchCongregation(from: $0) }
            .compactMap { $0 }
            .assign(to: \.congregation, on: self)
            .store(in: &cancellables)
        
        Task {
            await self.fetch()
        }
        
        $week
            .compactMap { $0 }
            .map { $0.range }
            .compactMap { $0 }
            .assign(to: \.range, on: self)
            .store(in: &cancellables)
        
        
        // MARK: Prayers
        partRepository.$prayers
            .map { parts in
                parts
                    .map { PartViewModel(part: $0, week: week) }
            }
            .assign(to: \.prayersViewModel, on: self)
            .store(in: &cancellables)
        
        // MARK: Chairmans
        partRepository.$chairmans
          .map { parts in
              parts.map { PartViewModel(part: $0, week: week) }
          }
          .assign(to: \.chairmansViewModel, on: self)
          .store(in: &cancellables)
        
        // MARK: Treasures
        partRepository.$treasures
            .map { parts in
                parts.map { PartViewModel(part: $0, week: week) }
            }
            .assign(to: \.treasuresViewModel, on: self)
            .store(in: &cancellables)
        
        // MARK: Apply
        partRepository.$apply
            .map { parts in
                parts.map { PartViewModel(part: $0, week: week) }
            }
            .assign(to: \.applyViewModel, on: self)
            .store(in: &cancellables)

        // MARK: Living
        partRepository.$life
            .map { parts in
                parts.map { PartViewModel(part: $0, week: week) }
            }
            .assign(to: \.lifeViewModel, on: self)
            .store(in: &cancellables)

        // MARK: Secondary
        partRepository.$secondary
            .map { parts in
                parts.map { PartViewModel(part: $0, week: week) }
            }
            .assign(to: \.secondaryViewModel, on: self)
            .store(in: &cancellables)
        
        // MARK: Public talk
        partRepository.$talk
            .compactMap { $0.first }
            .map { PartViewModel(part: $0, week: week) }
            .assign(to: \.talkViewModel, on: self)
            .store(in: &cancellables)
        
        // MARK: Watchtower
        partRepository.$watchtower
            .compactMap { $0.first }
            .map { PartViewModel(part: $0, week: week) }
            .assign(to: \.watchtowerViewModel, on: self)
            .store(in: &cancellables)

    }
    
    
    
    func fetchCongregation(from data: Data) -> ABCongregation? {
        do {
            let _congregation = try ABCongregation().decodedData(data)
            return _congregation
        } catch {
            print(error.localizedDescription)
        }
       return nil
    }
    
    func fetch() async {
        if let congregation, let week, let weekID = week.id {
            do {
                try await partRepository.fetchParts(weekID, congregation: congregation.id)
              //  partRepository.listen(weekID, congregationID: congregation.id)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    
}


extension ProgramDetailViewModel: Hashable {
 
        var identifier: String {
            return UUID().uuidString
        }
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(identifier)
        }
        
        public static func == (lhs: ProgramDetailViewModel, rhs: ProgramDetailViewModel) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    
}
