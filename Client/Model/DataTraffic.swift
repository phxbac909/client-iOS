//
//  DataTraffic.swift
//  Client
//
//  Created by TTC on 1/12/25.
//

import Foundation
import MapKit

struct DataTraffic: Identifiable {
    let id = UUID()
    let quantity : Int
    let timestart: Date
    let timeend: Date
    let coordinate: CLLocationCoordinate2D
    init(quantity: Int, timestart: Date, timeend: Date, coordinate: CLLocationCoordinate2D) {
        self.quantity = quantity
        self.timestart = timestart
        self.timeend = timeend
        self.coordinate = coordinate
    }

}

