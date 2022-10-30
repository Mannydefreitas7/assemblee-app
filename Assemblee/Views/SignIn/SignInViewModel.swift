//
//  SignInViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    @Published var showSetup: Bool = false
    

    
    
}
