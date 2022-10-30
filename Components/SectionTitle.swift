//
//  SectionTitle.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import Foundation
import SwiftUI

struct SectionTitle: View {
    var text: String
    var color: Color
    var body: some View {
        Text(text)
            .foregroundColor(color)
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
    }
}
