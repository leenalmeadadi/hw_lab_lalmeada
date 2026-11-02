
import Foundation

// Stores coordinates so they can be saved in a plist
struct CarCoordinate: Codable, Equatable {
    var latitude: Double
    var longitude: Double

    // Creates a coordinate with default values
    init(latitude: Double = 0.0, longitude: Double = 0.0) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
