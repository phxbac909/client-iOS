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
                Label("Statistic", systemImage: "chart.bar")
            }
            TrafficView().tabItem{
                Label("Trajectory",systemImage: "car.2")
            }
            RemoteView().tabItem{
                Label("Remote",systemImage: "av.remote")
            }
            
        }
        .tint(.primaryColor)

    }
}

#Preview {
    ContentView()
}
