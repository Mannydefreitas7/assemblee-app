//
//  CalendarViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/30/22.
//

import Foundation
import SwiftDate
import SwiftUI
import Combine
import CongregationServiceKit
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class CalendarViewModel: ObservableObject {
    
    private var encoder = Firestore.Encoder()
    private var decoder = Firestore.Decoder()
    
    @Published var date: Date = .now
    @Published var isMidWeekAvailable: Bool = false
    @Published var isWeekEndAvailable: Bool = false
    @Published var label: String = ""
    @Published var congregation: ABCongregation?
   // @Published var appState: AssembleeAppState?
    @Published var isLoading: Bool = false
    @Published var isMidweekLoading: Bool = false
    @Published var isWeekEndLoading: Bool = false
    @Published var midweekExists: Bool = false
    @Published var weekendExists: Bool = false
    @Published var partRepository = PartRepository()
    private var weekRepository = WeekRepository()
    
    @Published var logManager = LogManager()
    private var congregationKit = CongregationServiceKit()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
//
        UserDefaults.standard.data(forKey: "congregation").publisher
            .map { self.fetchCongregation(from: $0) }
            .compactMap { $0 }
            .assign(to: \.congregation, on: self)
            .store(in: &cancellables)
        
        
        $date
            .sink { date in
                Task {
                    await self.onDateSelection(date: date)
                }
            }
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
    
    func addWeekEnd() async {
        isWeekEndLoading = true
        do {
            if let congregation, let language = congregation.language {
                let items = try await congregationKit.fetchSchedule(date: date, for: language)
                if let items, !items.isEmpty {
                    var week = ABWeek.week
                    week.date = Timestamp(date: date)
                    if let midweek = items.first(where: { $0.classification == 106 }) {
                        week.range = midweek.title
                    } else {
                        week.range = self.label
                    }
                    week.isDownloaded = true
                    
                    try await partRepository.addWeekEndParts(date: date, week: week, congregationID: congregation.id)
              
                    self.weekendExists = try await partRepository.partsAlreadyExists(.weekend, for: date, in: congregation)
                    
                    // Checks if week document already exists
                    let (exists, _) = try await weekRepository.alreadyExists(congregation: congregation, date: date)
                    if !exists {
                        try await weekRepository.add(for: congregation, week: week)
                    }
                    
                    logManager.display(.success, title: "Weekend Added", message: label)
                    isWeekEndLoading = false
                }
            }
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
        }
    }
    
    func addMidweek() async {
        do {
            isMidweekLoading = true
            if let congregation, let language = congregation.language {
                let items = try await congregationKit.fetchSchedule(date: date, for: language)
                
                if let items, !items.isEmpty {
                    var week = ABWeek.week
                    week.date = Timestamp(date: date)
                    if let midweek = items.first(where: { $0.classification == 106 }) {
                        week.range = midweek.title
                    } else {
                        week.range = self.label
                    }
                    week.isDownloaded = true
                    
                
                    try await partRepository.addMidweekParts(date: date, week: week, congregation: congregation)
                    self.midweekExists = try await partRepository.partsAlreadyExists(.midweek, for: date, in: congregation)
                    
                    // Checks if week document already exists
                    let (exists, _) = try await weekRepository.alreadyExists(congregation: congregation, date: date)
                    if !exists {
                        try await weekRepository.add(for: congregation, week: week)
                    }
                    
                    logManager.display(.success, title: "Midweek Added", message: label)
                    isMidweekLoading = false
                }
            }
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
        }
    }
    
    
    
    func onDateSelection(date: Date) async {
        isLoading = true
        let monday = date.get(direction: .previous, dayName: .monday, considerToday: true)
        let sunday = date.get(direction: .next, dayName: .sunday, considerToday: true)
        let title = "\(monday.date.formatted(date: .abbreviated, time: .omitted)) - \(sunday.date.formatted(date: .abbreviated, time: .omitted))"
        self.label = title
        do {
            if let congregation, let language = congregation.language {
                self.isMidWeekAvailable = try await congregationKit.isMidweekAvailable(date: date, for: language)
                self.midweekExists =  try await partRepository.partsAlreadyExists(.midweek, for: date, in: congregation)
                self.weekendExists = try await partRepository.partsAlreadyExists(.weekend, for: date, in: congregation)
                isLoading = false
            }
        } catch {
            print(error.localizedDescription)
            logManager.display(.error, title: "Error", message: error.localizedDescription)
        }
    }
}
