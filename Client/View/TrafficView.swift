//
//  MapView.swift
//  Client
//
//  Created by TTC on 30/3/25.
//

import SwiftUI
import MapKit

struct TrafficView: View {
    
    let routes = [
            [
                CLLocationCoordinate2D(latitude: 20.995021, longitude: 105.857055), // Hồ Hoàn Kiếm
                CLLocationCoordinate2D(latitude: 20.995347, longitude: 105.854779), // Điểm giữa
            ],
            [
                CLLocationCoordinate2D(latitude: 20.997229, longitude: 105.850147), // Lăng Bác
                CLLocationCoordinate2D(latitude: 21.002578 , longitude: 105.850898), // Điểm giữa
            ],
            [
                CLLocationCoordinate2D(latitude: 20.982568  , longitude: 105.864015), // Nhà thờ Lớn
                CLLocationCoordinate2D(latitude: 20.976902, longitude: 105.865534)  // Cầu Long Biên
            ]
        ]
    @State private var route: MKRoute?
    @State private var region = MKCoordinateRegion()

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading){
                Text("Trajectory View")
                    .foregroundStyle(.white)
                    .padding(.top, 70)
                    .padding(.horizontal)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.primaryColor)
            VStack{
            
                if #available(iOS 17.0, *) {
                    Map(coordinateRegion: $region, annotationItems: routes.map({ Route(coordinates: $0) })) { route in
                        // Đánh dấu điểm đầu tuyến
                        MapMarker(coordinate: route.coordinates[0])
                    }
                    .overlay(
                        // Vẽ các tuyến đường riêng
                        Map{
                            ForEach(routes.map({ Route(coordinates: $0) }), id: \.id) { route in
                                MapPolyline(coordinates: route.coordinates)
                                    .stroke(.red, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            }
                        }
                    )
                } else {
                    Spacer()
                    Text("MapView in available in ios17 or newer ")
                    Spacer()
                }
                    
            }.onAppear {
                let allCoordinates = routes.flatMap { $0 }
                let polylines = routes.map {
                    MKPolyline(coordinates: $0, count: $0.count)
                }
                let mapRects = polylines.map { $0.boundingMapRect }
                let combinedRect = mapRects.reduce(MKMapRect.null) { $0.union($1) }
                region = MKCoordinateRegion(combinedRect)
            }
        }
        .frame(maxWidth :.infinity)
        .background(Color.primary.opacity(0.05))
        .edgesIgnoringSafeArea(.all)
        
    }
   

}
#Preview {
    TrafficView()
}
struct Route: Identifiable {
    let id = UUID()
    let coordinates: [CLLocationCoordinate2D]
}

