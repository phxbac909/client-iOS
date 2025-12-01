//
//  RemoteViewModel.swift
//  Client
//
//  Created by TTC on 1/12/25.
//

import Foundation
import SwiftUIJoystick

// MARK: - ViewModel
class RemoteViewModel: ObservableObject {
    
    static let shared = RemoteViewModel();
    
    private init() {
        
    }
 
    @Published private var monitor1 = JoystickMonitor();
    @Published private var monitor2 = JoystickMonitor();
    
    @Published var pitch: Float = 0;
    @Published var roll: Float =  0;
    

}
