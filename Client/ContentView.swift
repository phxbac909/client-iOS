//
//  ContentView.swift
//  Client
//
//  Created by TTC on 30/3/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            StatisticView().tabItem{
                Label("Thông số", systemImage: "chart.bar")
            }
            TrajectoryView().tabItem{
                Label("Quỹ đạo",systemImage: "location.fill")
            }
            Model3DView().tabItem {
                Label("Tu thế", systemImage: "scale.3d")
            }
            TrafficView().tabItem{
                Label("Giao Thông",systemImage: "car.2")
            }
            
        }
        .tint(.primaryColor)

    }
}

#Preview {
    ContentView()
}
