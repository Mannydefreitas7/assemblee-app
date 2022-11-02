//
//  TodayViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/11/22.
//

import Foundation
import Combine
import FirebaseFirestore
import SwiftDate
import CongregationServiceKit

@MainActor
class TodayViewModel: ObservableObject {
    
    @Published var weekRepository = WeekRepository()
    @Published var showUserView: Bool = false
    @Published var weeks = [ABWeek]()
    @Published var pinnedWeeks = [ABWeek]()
    private var userRepository = UserRepository()
    @Published var appState = AssembleeAppState()
    @Published var currentUser: ABUser?
    @Published var currentWeek: ABWeek?
    @Published var hasCurrentWeek: Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var logManager = LogManager()
    
    init() {
        
        appState.$currentUser
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellables)
        
        appState.$congregation
            .compactMap { $0 }
            .sink { self.fetchWeeks($0) }
            .store(in: &cancellables)
        
        weekRepository.$weeks
            .assign(to: \.weeks, on: self)
            .store(in: &cancellables)
        
        weekRepository.$weeks
            .map { weeks in weeks.filter { $0.isSent } }
            .assign(to: \.pinnedWeeks, on: self)
            .store(in: &cancellables)
        
        weekRepository.$weeks
            .map { weeks in weeks.filter { $0.isSent } }
            .map { self.getCurrentWeek($0) }
            .assign(to: \.currentWeek, on: self)
            .store(in: &cancellables)
        
        $currentWeek
            .map { $0 != nil }
            .assign(to: \.hasCurrentWeek, on: self)
            .store(in: &cancellables)
        

    }
    
    
    func fetchWeeks(_ congregation: ABCongregation) {
        do {
            try weekRepository.listen(for: congregation)
        } catch {
            logManager.displayError(title: error.localizedDescription)
        }
    }
    
    func getCurrentWeek(_ weeks: [ABWeek]) -> ABWeek? {
        let today = Date()
        let filteredWeek = weeks.first { week in
            
            if let date = week.date {
                let startWeek = today.dateAt(.startOfWeek).dateByAdding(1, .day).date
                let endWeek = today.dateAt(.endOfWeek).dateByAdding(1, .day).date
                return date.dateValue().isInRange(date: startWeek, and: endWeek)
            }
            return true
        }
        return filteredWeek
    }
}
