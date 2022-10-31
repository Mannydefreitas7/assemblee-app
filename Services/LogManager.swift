//
//  LogManager.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/29/22.
//

import Foundation

final class LogManager: ObservableObject {
    
    @Published var isPresented: Bool = false
    @Published var showError: Bool = false
    
    @Published var showInfo: Bool = false
    @Published var showWarning: Bool = false
    @Published var showSuccess: Bool = false
    @Published var toastItem: ToastItem = ToastItem(id: UUID().uuidString, type: .info)
    
    func displayError(title: String?, message: String? = "") {
        toastItem.title = title ?? "Error"
        toastItem.message = message
        toastItem.type = .error
    }
    
    func displaySuccess(title: String?, message: String? = "") {
        toastItem.title = title ?? "Success"
        toastItem.message = message
        toastItem.type = .success
    }
    
    func displayWarning(title: String?, message: String? = "") {
        toastItem.title = title ?? "Warning"
        toastItem.message = message
        toastItem.type = .warning

    }
    
    func displayInfo(title: String?, message: String? = "") {
        toastItem.title = title ?? "Info"
        toastItem.message = message
        toastItem.type = .info
    }
    
    func display(_ type: ToastItem.ToastType, title: String?, message: String? = "") {
        switch type {
        case .success: displaySuccess(title: title, message: message)
        case .info: displayInfo(title: title, message: message)
        case .error: displayError(title: title, message: message)
        case .warning: displayWarning(title: title, message: message)
        }
        isPresented.toggle()
    }
    
}
