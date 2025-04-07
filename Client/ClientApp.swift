//
//  ClientApp.swift
//  Client
//
//  Created by TTC on 30/3/25.
//

import SwiftUI

@main
struct ClientApp: App {
    private let webSocketManager = WebSocketManager.shared
    var body: some Scene {
        WindowGroup {
            TrajectoryView()
        }
    }
}
