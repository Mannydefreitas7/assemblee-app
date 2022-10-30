//
//  MeetingCard.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import SwiftUI

struct MeetingCard<Content:View>: View {
    
    var week: ABWeek?
    var image: String
    @ViewBuilder var destination: () -> Content
    
    init(week: ABWeek?, image: String = "today", @ViewBuilder destination: @escaping () -> Content) {
        self.week = week
        self.image = image
        self.destination = destination
    }
    
    var body: some View {
        
        NavigationLink {
            destination()
        } label: {
            VStack {
                ZStack(alignment:.bottomLeading) {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                       
                    
//                    LinearGradient(colors: [Color.black, Color.black.opacity(0.7), Color.black.opacity(0.5), Color.black.opacity(0.4)], startPoint: .bottom, endPoint: .top)
                    HStack(alignment: .center) {
                        
                        LazyVStack(alignment: .leading) {
                            Text("Semaine")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if let week, let range = week.range {
                                Text(range)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                   // .font(.title)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: Rectangle())
                }
            }
            
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

struct MeetingCard_Previews: PreviewProvider {
    static var previews: some View {
        MeetingCard(week: ABWeek.week) {
            Text("Test")
        }
    }
}
