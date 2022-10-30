//
//  ABLocalSearch.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import Foundation
import MapKit
import Combine
import CongregationServiceKit

struct LocalSearch: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var completion: MKLocalSearchCompletion
    
    init(_ searchCompletion: MKLocalSearchCompletion) {
       
        self.title = searchCompletion.title
        self.subtitle = searchCompletion.subtitle
        self.completion = searchCompletion
    }
}

struct PointOfInterest: Identifiable {
    // 2.
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let congregation: GeoLocationList?
    
    // 3.
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
