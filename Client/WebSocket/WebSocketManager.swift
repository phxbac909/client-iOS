//
//  WebSocketManager.swift
//  Client
//
//  Created by TTC on 6/4/25.
//


import Foundation
import Starscream


class WebSocketManager: ObservableObject {
    public static let shared = WebSocketManager()
    private var socket: WebSocket!
    private var channels: [WebSocketChannel] = [
        DataChannel.shared
    ]
    
    init() {
        setupWebSocket()
    }
    
    private func setupWebSocket() {
        guard let url = URL(string: "ws://\(ClientApp.IPserver)8080/ws") else { return }
        socket = WebSocket(request: URLRequest(url: url))
        socket.delegate = self
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    private func sendConnectFrame() {
        let connectFrame = """
        CONNECT
        accept-version:1.0,1.1,1.2
        heart-beat:10000,10000

        \0
        """
        socket.write(string: connectFrame)
    }
}

extension WebSocketManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(_):
            print("WebSocket Connected")
            sendConnectFrame()
            
        case .text(let string):
            print(string)
            if string.contains("CONNECTED") {
                print("STOMP Connected, sending SUBSCRIBEs")
                channels.forEach { $0.subscribe(using: socket) }
            }
            else if string.contains("MESSAGE") {
                for channel in channels {
                    if string.contains(channel.destination) {
                        channel.handleMessage(string)
                        break
                    }
                }
            }
            
        case .disconnected(_, _):
            print("WebSocket Disconnected")
            
        case .error(let error):
            print("WebSocket Error: \(error?.localizedDescription ?? "Unknown error")")
            
        default:
            break
        }
    }
}
