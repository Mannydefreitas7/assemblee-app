//
//  PartViewModel.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import Foundation
import SwiftUI
import CongregationServiceKit

@MainActor
class PartViewModel: ObservableObject {
    @Published var part: ABPart?
    
    
    init(part: ABPart) {
        self.part = part
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
