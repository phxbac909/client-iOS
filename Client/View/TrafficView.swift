import SwiftUI
import MapKit

struct TrafficView: View {
    
    @State var data = [
        DataTraffic(quantity: 5, timestart: Date(), timeend: Date().addingTimeInterval(TimeInterval(120)),coordinate: CLLocationCoordinate2D(latitude: 20.184257, longitude: 106.238209)),
        DataTraffic(quantity: 7, timestart: Date(), timeend: Date().addingTimeInterval(TimeInterval(115)), coordinate: CLLocationCoordinate2D(latitude: 20.18308437940721, longitude: 106.2384722702011)),
        DataTraffic(quantity: 1, timestart: Date(),timeend: Date().addingTimeInterval(TimeInterval(117)), coordinate: CLLocationCoordinate2D(latitude: 20.185419, longitude: 106.238224))
    ]
        
    @State private var region = MKCoordinateRegion()

    var body: some View {
        VStack(spacing: 0) {
            TitleView()
            
            Map(coordinateRegion: $region, annotationItems: data) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    let isLatest = item.id == data.last?.id
                    TrafficInfoView(d: item, latest: isLatest)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.primary.opacity(0.05))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            setupRegion()
        }
    }
    
    private func setupRegion() {
        guard !data.isEmpty else { return }
        
        let coordinates = data.map { $0.coordinate }
        
        let minLat = coordinates.min { $0.latitude < $1.latitude }?.latitude ?? 0
        let maxLat = coordinates.max { $0.latitude < $1.latitude }?.latitude ?? 0
        let minLon = coordinates.min { $0.longitude < $1.longitude }?.longitude ?? 0
        let maxLon = coordinates.max { $0.longitude < $1.longitude }?.longitude ?? 0
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let latDelta = (maxLat - minLat) * 2
        let lonDelta = (maxLon - minLon) * 2
        
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(
                latitudeDelta: max(latDelta, 0.001),
                longitudeDelta: max(lonDelta, 0.001)
            )
        )
    }
}

struct TitleView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Giao thông")
                .foregroundStyle(.white)
                .padding(.top, 70)
                .padding(.horizontal)
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryColor)
    }
}

struct TrafficInfoView: View {
    var d: DataTraffic
    var latest: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                VStack {
                    Label(d.timestart.ISO8601Format(), systemImage: "calendar")

                    if (latest ) {
                        Text("Vị trí đang được khảo sát")
                        Label("Hiện tại đang có : \(d.quantity) xe", systemImage: "moped.fill")

                    }
                    else {
                        Label(" Đã khảo sát trong : \(Int(d.timeend.timeIntervalSince(d.timestart))) giây ", systemImage: "timer")
                        Label("Tổng đếm được : \(d.quantity) xe", systemImage: "moped.fill")


                    }
                }
                .padding(5)
            }
            .background(latest ? .orange : .white)
            .cornerRadius(10)
            
            Image(systemName: "triangle.fill")
                .foregroundColor(latest ? .orange : .white)
                .rotationEffect(.degrees(180))
                .offset(y: -2)
        }
    }
}

#Preview {
    TrafficView()
}
