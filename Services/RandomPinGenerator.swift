//
//  RandomPinGenerator.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/15/22.
//

import Foundation

class RandomPinGenerator {
    
    let characters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    static let instance = RandomPinGenerator()
    
    func generate() -> String {
        let partition_1 = String((0..<3).compactMap { _ in characters.randomElement() })
        let partition_2 = String((0..<3).compactMap { _ in characters.randomElement() })
        let partition_3 = String((0..<4).compactMap { _ in characters.randomElement() })
        
        let code = "\(partition_1)-\(partition_2)-\(partition_3)"
        return code
    }
    
}
