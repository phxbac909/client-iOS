//
//  Joystick.swift
//  Client
//
//  Created by TTC on 1/12/25.
//


//
//  Joystick.swift
//  AirCraftController
//
//  Created by TTC on 15/10/25.
//


// An example Joystick
// Copy this example and modify it

import SwiftUI
import SwiftUIJoystick

public struct Joystick: View {
    
    @StateObject private var viewModel = RemoteViewModel.shared
    
    /// The monitor object to observe the user input on the Joystick in XY or Polar coordinates
    @ObservedObject public var joystickMonitor: JoystickMonitor
    /// The width or diameter in which the Joystick will report values
    ///  For example: 100 will provide 0-100, with (50,50) being the origin
    private let dragDiameter: CGFloat
    /// Can be `.rect` or `.circle`
    /// Rect will allow the user to access the four corners
    /// Circle will limit Joystick it's radius determined by `dragDiameter / 2`
    private let shape: JoystickShape
    
    public init(monitor: JoystickMonitor, width: CGFloat, shape: JoystickShape = .rect) {
        self.joystickMonitor = monitor
        self.dragDiameter = width
        self.shape = shape
    }
    
    public var body: some View {
        ZStack {
            Model3DView()
            VStack{
                Spacer()
                HStack{
                    JoystickBuilder(
                        monitor: self.joystickMonitor,
                        width: self.dragDiameter,
                        shape: .circle,
                        background: {
                            // Example Background
                            Circle().fill(Color.gray.opacity(0.2))
                                .frame(width: 210,height: 210)
                        },
                        foreground: {
                            // Example Thumb
                            Circle().fill(Color.black)
                                .frame(width: 100,height: 100)
                        },
                        locksInPlace: false)
                    Spacer()
                    JoystickBuilder(
                        monitor: self.joystickMonitor,
                        width: self.dragDiameter,
                        shape: .circle,
                        background: {
                            // Example Background
                            Circle().fill(Color.gray.opacity(0.2))
                                .frame(width: 210,height: 210)
                        },
                        foreground: {
                            // Example Thumb
                            Circle().fill(Color.black)
                                .frame(width: 100,height: 100)
                        },
                        locksInPlace: false)
                }
            }
        }
    }
}

#Preview {
    Joystick(monitor: JoystickMonitor(), width: 250)
}
