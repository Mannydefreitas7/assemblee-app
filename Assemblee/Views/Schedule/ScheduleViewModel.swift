//
//  ScheduleViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import CongregationServiceKit

@MainActor
final class ScheduleViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var partRepository = PartRepository()
    @Published var week: ABWeek?
    var congregation: String?
    @Published var chairmans = [ABPart]()
    @Published var treasures = [ABPart]()
    @Published var secondary = [ABPart]()
    @Published var life = [ABPart]()
    @Published var apply = [ABPart]()
    @Published var prayers = [ABPart]()
    @Published var view: ABScheduleType = .midweek
    
    init(week: ABWeek, congregation: ABCongregation) {
        self.week = week
        
            if let id = week.id {
                Task {
                    do {
                        try await partRepository.fetchParts(id, congregation: congregation.id)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        

            // MARK: Prayers
            partRepository.$prayers
            .assign(to: \.prayers, on: self)
            .store(in: &cancellables)


            // MARK: Chairmans
            partRepository.$chairmans
            .assign(to: \.chairmans, on: self)
            .store(in: &cancellables)


            // MARK: Treasures
            partRepository.$treasures
            .assign(to: \.treasures, on: self)
            .store(in: &cancellables)


            // MARK: Apply
            partRepository.$apply
            .assign(to: \.apply, on: self)
            .store(in: &cancellables)


            // MARK: Living
            partRepository.$life
            .assign(to: \.life, on: self)
            .store(in: &cancellables)


            // MARK: Secondary
            partRepository.$secondary
            .assign(to: \.secondary, on: self)
            .store(in: &cancellables)

    }
    
}
