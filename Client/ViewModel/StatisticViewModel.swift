//
//  StatisticViewModel.swift
//  Client
//
//  Created by TTC on 6/4/25.
//

import Foundation
class StatisticViewModel : ObservableObject {
    
    @Published var tabIndex = 0
    @Published var data : [Data] = []
    
    private let dataService = DataService.shared

    init() {
        DataChannel.shared.onDataReceived = { [weak self] newData in
            DispatchQueue.main.async {
                self?.data.append(newData)
            }
        }
    }
    
    func fetchData(for date: Date) async throws {
        do {
            let data = try await dataService.getDataByDay(date: date)
            print("Received \(data.count) data entities")
            self.data = data
        } catch {
            print("Error fetching data: \(error)")
            self.data = []
        }
    }
}
