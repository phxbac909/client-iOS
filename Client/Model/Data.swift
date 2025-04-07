//
//  Data.swift
//  Client
//
//  Created by TTC on 6/4/25.
//

import Foundation
struct Data: Codable {
    let id: Int64
    let longitude: Double
    let latitude: Double
    let temperature: Double
    let altitude: Double
    let pressure: Double
    let timestamp: Date
}
