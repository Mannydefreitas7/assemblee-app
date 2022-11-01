//
//  PillView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/31/22.
//

import SwiftUI


struct PillView: View {
    var text: String
    var color: Color
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(color)
            .clipShape(Capsule())
    }
}
