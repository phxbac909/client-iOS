//
//  DataService.swift
//  Client
//
//  Created by TTC on 6/4/25.
//


import Foundation

class DataService {
    private let baseURL = "http://\(ClientApp.IPserver):8080/data" // Replace with your actual API URL
    private let session: URLSession
    
    public static let shared = DataService()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getDataByDay(date: Date) async throws -> [Data] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        urlComponents.queryItems = [URLQueryItem(name: "date", value: dateString)]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        let decoder = JSONDecoder()
        let dateFormatterDecoder = DateFormatter()
        dateFormatterDecoder.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatterDecoder)
        return try decoder.decode([Data].self, from: data)
    }
}

// Error enum for network operations
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case noData
}


