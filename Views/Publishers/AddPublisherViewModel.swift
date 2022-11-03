//
//  AddPublisherViewModel.swift
//  Assemblee
//
//  Created by De Freitas, Manuel on 11/3/22.
//

import Foundation
import Combine
import CongregationServiceKit
import PhoneNumberKit

@MainActor
class AddPublisherViewModel: ObservableObject {
    @Published var newPublisher: ABPublisher = ABPublisher.newPublisher()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var congregation: ABCongregation?
    private var publisherRepository = PublisherRepository()

    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var gender: ABGender = .brother
    @Published var privilege: ABPrivilege = .publisher
    @Published var isDirty: Bool = false
    @Published var isLoading: Bool = false
    @Published var message: String = ""
    @Published var code: String = ""
    let phoneNumberKit = PhoneNumberKit()
    @Published var logManager = LogManager()
    
 
    
    init() {

        
        UserDefaults.standard.data(forKey: "congregation").publisher
            .map { self.fetchCongregation(from: $0) }
            .compactMap { $0 }
            .assign(to: \.congregation, on: self)
            .store(in: &cancellables)
        
        $newPublisher
            .compactMap { $0 }
            .map { $0.phone }
            .compactMap { $0 }
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { self.formatPhone($0) }
            .store(in: &cancellables)
        
            
    }
    
    func isValidated() -> Bool {
        if let email = newPublisher.email, email.isValidEmail(), let firstName = newPublisher.firstName, firstName.count > 3, let lastName = newPublisher.lastName, lastName.count > 2 {
            return true
        }
        return false
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
    
    func formatPhone(_ number: String) {
        do {
            if !number.isEmpty && number.count > 9 {
                if phoneNumberKit.isValidPhoneNumber(number) {
                    let phoneNumber = try phoneNumberKit.parse(number)
                    self.newPublisher.phone = phoneNumberKit.format(phoneNumber, toType: .international)
                    message = ""
                } else {
                    message = "Not a valid number"
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    

    func submit(completion: @escaping () -> Void) async {
        isLoading = true
        do {
            if let congregation {
                // Adding publisher
                self.newPublisher.gender = gender.rawValue
                try await publisherRepository.add(self.newPublisher, congregationID: congregation.id)
                self.logManager.display(.success, title: "Added")
                completion()
                isLoading = false
            }
        } catch {
            logManager.display(.error, title: "Error", message: error.localizedDescription)
            print(error.localizedDescription)
        }
    }
}
