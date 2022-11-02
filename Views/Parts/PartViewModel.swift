//
//  PartViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import Foundation
import SwiftUI
import Combine
import CongregationServiceKit

@MainActor
class PartViewModel: ObservableObject {
    @Published var part: ABPart?
    @Published var title: String = ""
    @Published var week: ABWeek?
    @Published var assignee: ABPublisher = ABPublisher.newPublisher()
    @Published var assistant: ABPublisher = ABPublisher.newPublisher()
    @Published var showSelectPublisherSheet: ABPartPublisherType?
    @Published var congregation: ABCongregation?
    private var partRepository: PartRepository = PartRepository()
    private var cancellables = Set<AnyCancellable>()
    
    init(part: ABPart, week: ABWeek) {
        self.part = part
        self.week = week
        
        UserDefaults.standard.data(forKey: "congregation").publisher
            .map { self.fetchCongregation(from: $0) }
            .compactMap { $0 }
            .assign(to: \.congregation, on: self)
            .store(in: &cancellables)
        
        self.$part
            .compactMap { $0 }
            .map { $0.title }
            .compactMap { $0 }
            .assign(to: \.title, on: self)
            .store(in: &cancellables)
        
        self.$part
            .compactMap { $0 }
            .map { $0.assignee }
            .compactMap { $0 }
            .assign(to: \.assignee, on: self)
            .store(in: &cancellables)
        
        self.$part
            .compactMap { $0 }
            .map { $0.assistant }
            .compactMap { $0 }
            .assign(to: \.assistant, on: self)
            .store(in: &cancellables)
    }
    
    func selectParticipant() async {
        do {
            if let part, let week, let congregation {
                try await partRepository.selectParticipant(part, for: week, in: congregation.id)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func toggleConfirm(_ confirmed: Bool) async {
        do {
            if let part, let week, let congregation {
                try await partRepository.toggle(part, for: week, in: congregation.id, key: "isConfirmed", value: !confirmed)
            }
        } catch {
            print(error.localizedDescription)
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

extension PartViewModel: Hashable {
 
        var identifier: String {
            return UUID().uuidString
        }
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(identifier)
        }
        
        public static func == (lhs: PartViewModel, rhs: PartViewModel) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    
}
