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
import PhoneNumberKit

@MainActor
class PublisherDetailViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
 
    @Published var publisher: ABPublisher = ABPublisher.newPublisher()
    @Published var congregation: ABCongregation?
    @Published var editMode: EditMode = .inactive
    private var publisherRepository = PublisherRepository()

    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var gender: ABGender?
    @Published var privilege: ABPrivilege?
    @Published var isDirty: Bool = false
    @Published var message: String = ""
    @Published var code: String = ""
    let phoneNumberKit = PhoneNumberKit()
    @Published var logManager = LogManager()
    
 
    
    init(publisher: ABPublisher) {
        self.publisher = publisher

        
        UserDefaults.standard.data(forKey: "congregation").publisher
            .map { self.fetchCongregation(from: $0) }
            .compactMap { $0 }
            .assign(to: \.congregation, on: self)
            .store(in: &cancellables)
        
        $publisher
            .compactMap { $0 }
            .map { $0.firstName }
            .compactMap { $0 }
            .assign(to: \.firstName, on: self)
            .store(in: &cancellables)
        
        $publisher
            .compactMap { $0 }
            .map { $0.lastName }
            .compactMap { $0 }
            .assign(to: \.lastName, on: self)
            .store(in: &cancellables)
        
        $publisher
            .compactMap { $0 }
            .map { $0.phone }
            .compactMap { $0 }
            .assign(to: \.phone, on: self)
            .store(in: &cancellables)
        
        $publisher
            .compactMap { $0 }
            .map { $0.email }
            .compactMap { $0 }
            .assign(to: \.email, on: self)
            .store(in: &cancellables)
        
        $publisher
            .compactMap { $0 }
            .map { $0.gender }
            .compactMap { $0 }
            .map {  ABGender(rawValue: $0) }
            .assign(to: \.gender, on: self)
            .store(in: &cancellables)
        
        $publisher
            .compactMap { $0 }
            .map { $0.privilege }
            .compactMap { $0 }
            .map {  ABPrivilege(rawValue: $0) }
            .assign(to: \.privilege, on: self)
            .store(in: &cancellables)
        
        $publisher
            .compactMap { $0 }
            .map { $0.code }
            .assign(to: \.code, on: self)
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
    
    func formatPhone(_ number: String) -> String {
        do {
            if !number.isEmpty && number.count > 9 {
                if phoneNumberKit.isValidPhoneNumber(number) {
                    let phoneNumber = try phoneNumberKit.parse(number)
                    return phoneNumberKit.format(phoneNumber, toType: .international)
                } else {
                    message = "Not a valid number"
                    return ""
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return number
    }
    
    func udapte() async {
        do {
            if let congregation {
                // Saving data to publisher
                try await publisherRepository.update(self.publisher, congregationID: congregation.id)
                self.logManager.display(.success, title: "Updated")
            }
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
            print(error.localizedDescription)
        }
    }
    
    func toggleEdit(completion: @escaping (_ editMode: EditMode) -> Void) {
        if editMode == .inactive {
            editMode = .active
            completion(.active)
        } else {
            editMode = .inactive
            Task {
                await self.udapte()
            }
            completion(.inactive)
        }
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
