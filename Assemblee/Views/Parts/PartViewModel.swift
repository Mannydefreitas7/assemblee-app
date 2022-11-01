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
    private var cancellables = Set<AnyCancellable>()
    
    init(part: ABPart, week: ABWeek) {
        self.part = part
        self.week = week
        
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
