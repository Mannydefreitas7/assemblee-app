//
//  Avatar.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/11/22.
//

import SwiftUI

struct Avatar: View {
    
    var firstName: String
    var lastName: String
    var imageUrl: String?
    
    var body: some View {
        
        
        if let imageUrl {
            AsyncImage(url: URL(string: imageUrl)) { image in
                
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } placeholder: {
                
                Image(systemName: "photo.fill")
                
            }
            .frame(width: 60, height: 60)
        } else {
            if let fn = firstName.first, let ln = lastName.first {
                Text("\(fn.uppercased())\(ln.uppercased())")
                    .font(.caption)
                    .bold()
                    //.frame(width: 30, height: 30)
                    .padding(8)
                    .background(Color(.systemGray5).gradient, in: Circle())
            }
        }
    }
}

struct Avatar_Previews: PreviewProvider {
    static var previews: some View {
        Avatar(firstName: "John", lastName: "Doe", imageUrl: "https://monstar-lab.com/global/wp-content/uploads/sites/11/2019/04/male-placeholder-image.jpeg")
    }
}
