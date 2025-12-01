//
//  DataTrajectory.swift
//  Client
//
//  Created by TTC on 2/12/25.
//
import Foundation
import MapKit

struct DataTrajectory : Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let active : Bool

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.active = true
    }
}
