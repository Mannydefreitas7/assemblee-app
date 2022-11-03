//
//  ProgramsViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/30/22.
//

import Foundation
import Combine
import CongregationServiceKit

@MainActor
class ProgramsViewModel: ObservableObject {
    @Published var scheduleByMonths = [Int]()
    @Published var weekRepository = WeekRepository()
    @Published var weeks: [ABWeek] = [ABWeek]()
    @Published var appState: AssembleeAppState?
    @Published var logManager = LogManager()
    @Published var congregation: ABCongregation?
    @Published var showAddScheduleSheet: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func getAllMonths(weeks: [ABWeek]) -> [Int] {
        
        let array = Dictionary(grouping: weeks) {(week) -> Int in
               return week.date?.dateValue().month ?? 0
           }.keys
           
        return Array(array)
       }
    
    init(appState: AssembleeAppState) {
        
        self.appState = appState
        
        UserDefaults.standard.data(forKey: "congregation").publisher
            .map { self.fetchCongregation(from: $0) }
            .compactMap { $0 }
            .assign(to: \.congregation, on: self)
            .store(in: &cancellables)
        
        $congregation
            .compactMap { $0 }
            .sink { congregation in
                Task {
                    await self.fetchWeeks(congregation)
                }
            }
            .store(in: &cancellables)
        
        
        weekRepository.$weeks
            .map { self.getAllMonths(weeks: $0).sorted { $0 < $1 } }
            .assign(to: \.scheduleByMonths, on: self)
            .store(in: &cancellables)
        
        weekRepository.$weeks
            .map { weeks in
                weeks.sorted { $0.formattedDate.compare($1.formattedDate) == .orderedAscending }
            }
             .assign(to: \.weeks, on: self)
             .store(in: &cancellables)
    }
    
    func fetchWeeks(_ congregation: ABCongregation) async {
        do {
            try weekRepository.listen(for: congregation)
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
        }
    }
    
    func togglePin(week: ABWeek) async {
        if let congregation {
            do {
                try await weekRepository.togglePin(week, congregation: congregation)
            } catch {
                print(error.localizedDescription)
            }
        }
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
    
   
}
