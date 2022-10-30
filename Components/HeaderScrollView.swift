//
//  HeaderScrollView.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/10/22.
//

import SwiftUI

struct HeaderScrollView<Content: View, Header: View>: View {
    var image: String
    var height: CGFloat = 200
    @ViewBuilder var header: () -> Header
    @ViewBuilder var content: () -> Content
    @Environment(\.colorScheme) var scheme
    
    
    @State var reader: GeometryProxy?
    @State var scrollOffset = CGFloat.zero
    @Namespace private var animation
    
    @ViewBuilder func headerImage() -> some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                
                ZStack(alignment: .bottom) {
                    if let reader {
                        if reader.frame(in: .global).minY <= 0 {
                            Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: reader.size.width, height: reader.size.height, alignment: .bottom)
                            .offset(y: -reader.frame(in: .global).minY/2)
                            .clipped()
                            
                            if scheme == .dark  {
                                    LinearGradient(colors: [.black.opacity(0.8), .black.opacity(0.7), .black.opacity(0.6), .black.opacity(0.5)], startPoint: .bottom, endPoint: .top)
                                        
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: reader.size.width, height: reader.size.height, alignment: .bottom)
                                    .offset(y: -reader.frame(in: .global).minY/2)
                                    .clipped()
                            }
                            
                        } else {
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: reader.size.width, height: reader.size.height + reader.frame(in: .global).minY, alignment: .bottom)
                                .clipped()
                                .offset(y: -reader.frame(in: .global).minY)
                            
                            if scheme == .dark  {
                                    LinearGradient(colors: [.black.opacity(0.8), .black.opacity(0.7), .black.opacity(0.6), .black.opacity(0.5)], startPoint: .bottom, endPoint: .top)
                                        
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: reader.size.width, height: reader.size.height + reader.frame(in: .global).minY, alignment: .bottom)
                                    .clipped()
                                    .offset(y: -reader.frame(in: .global).minY)
                            }
                        }
                    }
                   
                }
                .onAppear {
                    self.reader = geometry
                }
            }
            
            if scheme == .light  {
                LinearGradient(colors: [.black.opacity(0.8), .black.opacity(0.6), .black.opacity(0.3), .black.opacity(0.1), .black.opacity(0.0)], startPoint: .bottom, endPoint: .top)
                    .frame(height: height > 100 ? (height / 2) : height)
            }
            
           
            LazyVStack(alignment: .leading) {
                header()
            }
            .padding()
        }
        .frame(height: height > 200 ? height : (getRect().height / 4))
       
        .onReceive(reader.publisher) { self.reader = $0 }
    }
    
    var body: some View {
            ZStack(alignment: .top) {
                ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                    headerImage()
                    VStack {
                       content()
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
         //   .navigationBarTitleDisplayMode(.inline)
    }
}

struct HeaderScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderScrollView(image: "today") {
            Text("Header")
        } content: {
            Text("Content")
        }
    }
}
