
//
//  NewOrderChannel.swift
//  FoodOrder
//
//  Created by TTC on 18/3/25.
//

import Foundation
import Starscream


class DataChannel: WebSocketChannel {
   
    let destination = "/topic/data"
    let subscriptionId = "sub-1"
    var onDataReceived: ((Data) -> Void)?
    var onLocationReceived: ((Data) -> Void)?
    
    static let shared = DataChannel()
    
    func subscribe(using socket: WebSocket) {
        let subscribeFrame = """
        SUBSCRIBE
        id:\(subscriptionId)
        destination:\(destination)

        \0
        """
        socket.write(string: subscribeFrame)
    }
    
    func handleMessage(_ message: String) {
        if let range = message.range(of: #"\{.*\}"#, options: .regularExpression),
           let data = message[range].data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let dateFormatterDecoder = DateFormatter()
                dateFormatterDecoder.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatterDecoder)
                let newData = try decoder.decode(Data.self, from: data)
                DataChannel.shared.onDataReceived?(newData)
                DataChannel.shared.onLocationReceived?(newData)
                print(newData)
            } catch {
                print("Error decoding new order: \(error)")
            }
        }
    }
}
