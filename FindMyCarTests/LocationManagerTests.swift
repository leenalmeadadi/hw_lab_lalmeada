
import Testing
import CoreLocation
@testable import FindMyCar

@MainActor
struct LocationManagerTests {

    // Tests that the manager starts with zero coordinates
    @Test func startsWithZeroCoordinate() {
        let manager = LocationManager()
        #expect(manager.coordinate == CarCoordinate())
    }

    // Tests that clearing the location resets coordinates
    @Test func clearLocationResetsCoordinate() {
        let manager = LocationManager()
        manager.coordinate = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        manager.clearLocation()
        #expect(manager.coordinate == CarCoordinate())
    }

    // Tests that denied permission produces an error
    @Test func deniedAuthorizationProducesError() {
        let manager = LocationManager()
        manager.authorizationStatus = .denied
        manager.saveCurrentLocation()
        #expect(manager.locationError != nil)
    }
}
