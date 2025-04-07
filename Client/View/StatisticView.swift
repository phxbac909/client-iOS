//
//  StatisticView.swift
//  Client
//
//  Created by TTC on 30/3/25.
//

import SwiftUI
import Charts
import SceneKit

struct DataPoint: Identifiable {
    let id: Int
    let value: Double
}


struct StatisticView: View {
    
    let tabs = ["thermometer.sun","pencil.and.ruler","rectangle.compress.vertical","scale.3d"]
    let tabName = ["Temperature","Height","Pressure","Statistics"]
    let tabColor : [Color] = [ .red, .green, .blue , .black ]
   
    @State var tabIndex = 0
    @State var date = Date()
        
    @StateObject var viewModel = StatisticViewModel()
        
        private var points: [DataPoint] {
            switch tabIndex {
            case 0 :
                viewModel.data.map({$0.temperature}).enumerated().map { DataPoint(id: $0.offset, value: $0.element) }
            case 1 :
                viewModel.data.map({$0.altitude}).enumerated().map { DataPoint(id: $0.offset, value: $0.element) }
            case 2 :
                viewModel.data.map({$0.pressure}).enumerated().map { DataPoint(id: $0.offset, value: $0.element) }
                
            default:
                []
            }
        
            
        }
    private var largest: Double {
        points.max(by: { $0.value < $1.value })?.value ?? 0.0
    }
    private var smallest : Double {
        points.map({$0.value}).min() ?? 0
    }
    private var average : Double {
        Double(points.map({$0.value}).reduce(0, +) / Double( points.count) ?? 0)
    }
    
    var body: some View {
      
        NavigationView {
            if #available(iOS 17.0, *) {
                VStack(spacing: 0) {
                    VStack(alignment: .leading){
                        Text("Statistics")
                            .foregroundStyle(.white)
                            .padding(.top, 70)
                            .padding(.horizontal)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        MySlidingTabView(selection: $tabIndex, tabs: tabs, animation: .easeInOut, activeAccentColor: .white, inactiveAccentColor : Color.white.opacity(0.4), selectionBarColor: .white , inactiveTabColor: Color.white.opacity(0), selectionBarHeight: 4)
                            .padding(.horizontal,4)
                            .padding(.bottom,-6)
                    }
                    .background(Color.primaryColor)
                    
                    VStack{
                        switch tabIndex {
                        case 3:
                            Model3dTab
                            Spacer()
                        default:
                            DataTab
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                let horizontalDistance = value.translation.width
                                if horizontalDistance > 50 && tabIndex > 0 {
                                    tabIndex -= 1
                                } else if horizontalDistance < -50 && tabIndex < tabs.count - 1 {
                                    tabIndex += 1
                                }
                            }
                    )
                }
                .frame(maxWidth: .infinity)
                .background(Color.primary.opacity(0.05))
                .edgesIgnoringSafeArea(.all)
                .onAppear{
                    Task {
                        try await viewModel.fetchData(for: date)
                    }
                }
                .onChange(of: date){
                    Task {
                        try await viewModel.fetchData(for: date)
                    }
                }
            } else {
                // Fallback on earlier versions
            }

        }

    }
    
    private var DataTab : some View {
        VStack {
            
            HStack (alignment : .center){
                Text("Date ").fontWeight(.bold).padding(.top).padding(.horizontal)
                
                DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                              Text("")
                }.tint(.primaryColor)
                    .padding()
              
            }
            .background(.white)
            .cornerRadius(10)
            .padding()
            .shadow(radius: 0.3)


            VStack (alignment : .leading){
                Text("Chart  \(tabName[tabIndex])").fontWeight(.bold).padding(.top).padding(.horizontal)
                Chart(points){
                    data in
                    LineMark(
                        x: .value("", data.id),
                        y: .value("", data.value)
                    )
                    .foregroundStyle(tabColor[tabIndex])
                }
                .frame(height: 170)
                .padding()
                .chartYAxis {
                    AxisMarks(position: .trailing) {
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartYScale(domain: (smallest - 10 )...(largest + 10 ))
                .chartXAxis {
                    AxisMarks {
                        AxisGridLine()
                        AxisTick()
                    }
                }
                .padding(.bottom,20)
            }
            .background(.white)
            .cornerRadius(10)
            .padding()
            .shadow(radius: 0.3)

            
            VStack (alignment : .leading){
                Text("Record \(tabName[tabIndex]) ").fontWeight(.bold).padding(.top).padding(.horizontal)
                LazyVGrid(columns: [ GridItem(.flexible()),
                                     GridItem(.flexible())],spacing: 20,  content: {
                    Text("Largest   : ").font(.body)
                    Text(formattedNumber(largest))
                        .fontWeight(.semibold).font(.headline)
                    Text("Smallest : ").font(.body)
                    Text(formattedNumber(smallest))
                        .fontWeight(.semibold).font(.headline)
                    Text("Average : ").font(.body)
                    Text(formattedNumber(average))
                        .fontWeight(.semibold).font(.headline)

                }).padding()
            }
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(radius: 0.3)
            Spacer()
        }
    }
    private var Model3dTab : some View {
        VStack (alignment : .leading){
            Text("Posture Satellite ").fontWeight(.bold).padding(.top).padding(.horizontal)
            SCNViewContainer(scene: Content3DView.loadMultipleObjModels())
                .frame(height: 300).padding()
            VStack (alignment : .leading){

                LazyVGrid(columns: [ GridItem(.flexible()),
                                     GridItem(.flexible())],spacing: 20,  content: {
                    Text("Largest   : ").font(.body)
                    Text(formattedNumber(largest))
                        .fontWeight(.semibold).font(.headline)
                    Text("Smallest : ").font(.body)
                    Text(formattedNumber(smallest))
                        .fontWeight(.semibold).font(.headline)
                    Text("Average : ").font(.body)
                    Text(formattedNumber(average))
                        .fontWeight(.semibold).font(.headline)

                }).padding()
            }
        }
        .background(.white)
        .cornerRadius(10)
        .padding(.top, 16)
        .padding(.bottom, 40)
        .padding(.horizontal)
        .shadow(radius: 0.3)
    }
    func formattedNumber(_ value: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.decimalSeparator = "." // Đảm bảo dùng dấu chấm
            formatter.minimumFractionDigits = 2 // Tối thiểu 2 chữ số thập phân
            formatter.maximumFractionDigits = 2 // Tối đa 2 chữ số thập phân
            return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        }
}

#Preview {
    ContentView()
}
