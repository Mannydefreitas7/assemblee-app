//
//  PublishersViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import Foundation
import Combine
import CongregationServiceKit

@MainActor
class PublishersViewModel: ObservableObject {
    @Published var scheduleByMonths = [Int]()
    @Published var publisherRepository = PublisherRepository()
    @Published var publishers: [ABPublisher] = [ABPublisher]()
    @Published var publisherSuggestions: [ABPublisher] = [ABPublisher]()
    @Published var appState = AssembleeAppState()
    @Published var logManager = LogManager()
    @Published var congregation: ABCongregation?
    @Published var showAddPublisherSheet: Bool = false
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        
        
        UserDefaults.standard.data(forKey: "congregation").publisher
            .map { self.fetchCongregation(from: $0) }
            .compactMap { $0 }
            .assign(to: \.congregation, on: self)
            .store(in: &cancellables)
            
        
        publisherRepository.$publishers
            .assign(to: \.publishers, on: self)
            .store(in: &cancellables)
        
        $searchText
            .removeDuplicates()
            .map { search in
                if search.isEmpty {
                    return []
                }
                return self.publishers.filter({ $0.firstName?.lowercased().contains(search.lowercased()) ?? true || $0.lastName?.lowercased().contains(search.lowercased()) ?? true })
            }
            .assign(to: \.publisherSuggestions, on: self)
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
