
import Testing
import Foundation
@testable import FindMyCar

struct CarCoordinateTests {

    // Tests the default coordinate values
    @Test func defaultInitializerIsZero() {
        let coord = CarCoordinate()
        #expect(coord.latitude == 0.0)
        #expect(coord.longitude == 0.0)
    }

    // Tests that custom coordinates are saved
    @Test func customInitializerStoresValues() {
        let coord = CarCoordinate(latitude: 40.7128, longitude: -74.0060)
        #expect(coord.latitude == 40.7128)
        #expect(coord.longitude == -74.0060)
    }

    // Tests that coordinate equality works
    @Test func equalityWorks() {
        let a = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        let b = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        let c = CarCoordinate(latitude: 0, longitude: 0)

        #expect(a == b)
        #expect(a != c)
    }

    // Tests saving and loading coordinates
    @Test func encodesAndDecodesRoundTrip() throws {
        let original = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        let data = try PropertyListEncoder().encode(original)
        let decoded = try PropertyListDecoder().decode(CarCoordinate.self, from: data)
        #expect(decoded == original)
    }
}
