//
//  MapView.swift
//  Client
//
//  Created by TTC on 30/3/25.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct TrajectoryView: View {
    
    @State var data = [
        DataTrajectory(coordinate: CLLocationCoordinate2D(latitude: 20.185419, longitude: 106.238224)),
        DataTrajectory(coordinate:  CLLocationCoordinate2D(latitude: 20.183881716067148, longitude: 106.23820162396527)),
        DataTrajectory(coordinate: CLLocationCoordinate2D(latitude: 20.183804757920093, longitude: 106.23730994655155)),
    ]
    @State private var position: MapCameraPosition = .automatic
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        VStack(spacing: 0) {
            title
            
            Map(position: $position) {
                MapPolyline(coordinates: data.map { $0.coordinate })
                    .stroke(.blue, lineWidth: 3)
                
                if let last = data.last {
                    Annotation("", coordinate: last.coordinate) {
                        Image(systemName: "location.north.fill")
                            .rotationEffect(.degrees(270))
                            .foregroundColor(.red)
                            .font(.title)
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .background(Color.primary.opacity(0.05))
    }
    private var title : some View {
            VStack(alignment: .leading) {
                Text("Giao thông")
                    .foregroundStyle(.white)
                    .padding(.top, 70)
                    .padding(.horizontal)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.primaryColor)
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        TrajectoryView()
    } else {
        // Fallback on earlier versions
    }
}

