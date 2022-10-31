//
//  ToastItem.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/29/22.
//

import Foundation

struct ToastItem: Hashable {
    
    enum ToastType {
        case success
        case info
        case warning
        case error
    }
    
    var id: String
    var title: String?
    var message: String?
    var type: ToastType
    
}
