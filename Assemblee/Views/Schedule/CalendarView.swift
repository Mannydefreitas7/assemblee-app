//
//  CalendarView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/25/22.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        VStack {
            DatePicker("Test", selection: .constant(.now), in: ...Date(), displayedComponents: .date)
            .datePickerStyle(.graphical)
            
        }
        .padding()
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
