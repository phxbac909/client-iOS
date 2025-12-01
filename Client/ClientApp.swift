//
//  ClientApp.swift
//  Client
//
//  Created by TTC on 30/3/25.
//

import SwiftUI

@main
struct ClientApp: App {
    
    static let IPserver = "192.168.0.102";
    
    private let webSocketManager = WebSocketManager.shared
    var body: some Scene {
        WindowGroup {
            TrafficView()
        }
    }
}
