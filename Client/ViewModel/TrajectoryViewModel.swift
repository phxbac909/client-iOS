//
//  TrajectoryViewModel.swift
//  Client
//
//  Created by TTC on 7/4/25.
//

import Foundation
import MapKit

class TrajectoryViewModel : ObservableObject {
    
    @Published var region = MKCoordinateRegion()
    @Published var trajectory : [CLLocationCoordinate2D] = []
    @Published var location =  CLLocationCoordinate2D()
    
    init(){
        if trajectory.isEmpty {
                    let defaultCoordinates = [
                        CLLocationCoordinate2D(latitude: 20.997229, longitude: 105.850147),
                        CLLocationCoordinate2D(latitude: 21.002578, longitude: 105.850898)
                    ]
                    let polyline = MKPolyline(coordinates: defaultCoordinates, count: defaultCoordinates.count)
                    let mapRect = polyline.boundingMapRect
                region =  MKCoordinateRegion(mapRect)
                }
                
                // Trường hợp trajectory có dữ liệu
            else {
                let polyline = MKPolyline(coordinates: trajectory, count: trajectory.count)
                        let mapRect = polyline.boundingMapRect
                region =   MKCoordinateRegion(mapRect)
            }
        DataChannel.shared.onLocationReceived = { [weak self] newData in
            DispatchQueue.main.async {
                var newLocation = CLLocationCoordinate2D(latitude : newData.latitude, longitude: newData.longitude)
                print(newLocation)
                self?.location = newLocation
                self?.trajectory.append( newLocation)
            }
        }
    }
    
    
}
