//
//  PublisherDetailViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 11/1/22.
//

import Foundation
import Combine
import SwiftUI
import CongregationServiceKit

@MainActor
class PublisherDetailViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
 
    @Published var publisher: ABPublisher?
    @Published var congregation: ABCongregation?
    @Published var publisherRepository = PublisherRepository()
    
    
    init(publisher: ABPublisher) {
        self.publisher = publisher
        
        
        UserDefaults.standard.data(forKey: "congregation").publisher
            .map { self.fetchCongregation(from: $0) }
            .compactMap { $0 }
            .assign(to: \.congregation, on: self)
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
    
}


extension PublisherDetailViewModel: Hashable {
 
        var identifier: String {
            return UUID().uuidString
        }
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(identifier)
        }
        
        public static func == (lhs: PublisherDetailViewModel, rhs: PublisherDetailViewModel) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    
}
