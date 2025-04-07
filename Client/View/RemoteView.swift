//
//  MapView.swift
//  Client
//
//  Created by TTC on 30/3/25.
//

import SwiftUI
import MapKit

struct RemoteView: View {
    
    let routes = [
            [
                CLLocationCoordinate2D(latitude: 20.995021, longitude: 105.857055), // Hồ Hoàn Kiếm
                CLLocationCoordinate2D(latitude: 20.995347, longitude: 105.854779), // Điểm giữa
            ]
        ]
    @State private var route: MKRoute?
    @State private var region = MKCoordinateRegion()

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading){
                Text("Remote View")
                    .foregroundStyle(.white)
                    .padding(.top, 70)
                    .padding(.horizontal)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.primaryColor)
            if #available(iOS 17.0, *) {
                VStack{
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
                    .onAppear {
                        let polylines = routes.map {
                            MKPolyline(coordinates: $0, count: $0.count)
                        }
                        let mapRects = polylines.map { $0.boundingMapRect }
                        let combinedRect = mapRects.reduce(MKMapRect.null) { $0.union($1) }
                        region = MKCoordinateRegion(combinedRect)
                    }   .background(.white)
                        .cornerRadius(10)
                        .padding()
                        .shadow(radius: 2)
                    remote.padding(25)
                    Spacer()
                }
            } else {
                    Spacer()
                    Text("MapView in available in ios17 or newer ")
                    Spacer()
                }
            
        }
        .frame(maxWidth :.infinity)
        .background(Color.primary.opacity(0.05))
        .edgesIgnoringSafeArea(.top)
        
    }
    private var remote : some View {
        VStack(spacing: 10) {
            HStack(alignment : .center, spacing: 15) {
                Button(action: {
                }) {
                    Label("Function 1 ", systemImage: "location")
                     
                }
                .buttonStyle(.bordered)
                .tint(.primaryColor)
                Button(action: {
                    print("Up pressed")
                }) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 30))
                        .frame(width: 60, height: 60)
                        .background(Color.gray.opacity(0.2))
                        .foregroundStyle(Color.primaryColor)
                        .clipShape(Circle())
                }
                Button(action: {
                }) {
                    Label("Function 2 ", systemImage: "exclamationmark.bubble")
                }
                .buttonStyle(.bordered)
                .tint(.primaryColor)

            }
                    
            HStack(spacing: 70) {
                        Button(action: {
                            print("Left pressed")
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 30))
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.2))                    .foregroundStyle(Color.primaryColor)
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            print("Right pressed")
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 30))
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.2))
                                .foregroundStyle(Color.primaryColor)
                                .clipShape(Circle())
                        }
                    }
                    
            HStack(alignment : .center, spacing: 15) {
                Button(action: {
                }) {
                    Label("Function 3 ", systemImage: "circle.lefthalf.striped.horizontal")
                     
                }
                .buttonStyle(.bordered)
                .tint(.primaryColor)
                Button(action: {
                    print("Up pressed")
                }) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 30))
                        .frame(width: 60, height: 60)
                        .background(Color.gray.opacity(0.2))
                        .foregroundStyle(Color.primaryColor)
                        .clipShape(Circle())
                }
                Button(action: {
                }) {
                    Label("Function 4 ", systemImage: "bolt")
                }
                .buttonStyle(.bordered)
                .tint(.primaryColor)

            }
        }
    }

}
#Preview {
    RemoteView()
}


