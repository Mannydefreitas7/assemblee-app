//
//  ScheduleCard.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/12/22.
//

import SwiftUI
import RealmSwift
import CongregationServiceKit

struct ScheduleCard: View {
    var week: ABWeek
    var body: some View {
        VStack {
            Image(systemName: "chart.bar.doc.horizontal")
                .imageScale(.large)
                .scaleEffect(1.3)
                .padding()
                .background(Color.accentColor.gradient, in: Circle())
                .foregroundColor(.white)
            Text("Week")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(week.range ?? "")
                .bold()
        }
        .padding()
        .frame(width: 170, height: 150)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 10))
    }
}
