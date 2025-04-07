//
//  WebSocketChannel.swift
//  FoodOrder
//
//  Created by TTC on 18/3/25.
//

import Foundation
import Starscream
protocol WebSocketChannel {
    var destination: String { get }
    var subscriptionId: String { get }
    func subscribe(using socket: WebSocket)
    func handleMessage(_ message: String)
}
