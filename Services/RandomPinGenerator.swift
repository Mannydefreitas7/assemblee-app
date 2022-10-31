//
//  RandomPinGenerator.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/15/22.
//

import Foundation

final class RandomPinGenerator {
    
    let characters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    static let instance = RandomPinGenerator()
    

    
    func code(for digits: Int) -> String {
        let partition = String((0..<digits).compactMap { _ in characters.randomElement() })
        return partition
    }
    
}

extension RandomPinGenerator {
    
    enum CodeType {
        case congregation
        case publisher
    }
    
    func generate(for codeType: CodeType) -> String {
        switch codeType {
        case .congregation: return self.code(for: 4)
        case .publisher: return "\(self.code(for: 3))-\(self.code(for: 3))"
        }
    }
    
}
