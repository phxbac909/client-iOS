//
//  MapView.swift
//  Client
//
//  Created by TTC on 30/3/25.
//

import SwiftUI
import MapKit

struct TrajectoryView: View {
    
    @StateObject var viewModel = TrajectoryViewModel()
    @State private var route: MKRoute?

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading){
                Text("Traffic View")
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
                    Map(coordinateRegion: $viewModel.region, annotationItems: [AnnotationItem(coordinate: viewModel.location)]) {_ in 
                        // Đánh dấu điểm đầu tuyến
                        MapMarker(coordinate: viewModel.location)
                    }
                    .overlay(
                        // Vẽ các tuyến đường riêng
                        Map{
                            MapPolyline(coordinates:  viewModel.trajectory)
                                .stroke(.red, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        }
                    )
                } else {
                    Spacer()
                    Text("MapView in available in ios17 or newer ")
                    Spacer()
                }
                    
            }
        }
        .frame(maxWidth :.infinity)
        .background(Color.primary.opacity(0.05))
        .edgesIgnoringSafeArea(.all)
        
    }
   

}
#Preview {
    TrajectoryView()
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
