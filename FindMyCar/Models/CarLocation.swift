
import Foundation
import CoreLocation

// Makes the car location identifiable for map annotations
struct CarLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String
}
