
import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject {

    // Stores the car location and permission status
    var coordinate = CarCoordinate()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationError: String?

    @ObservationIgnored private let locationManager = CLLocationManager()
    @ObservationIgnored private let plistFileName = "Coordinates.plist"
    @ObservationIgnored private var locationSaveCompletion: (() -> Void)?

    // Sets up the location manager
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        authorizationStatus = locationManager.authorizationStatus
        loadLocation()
    }

    // Requests permission and gets the current location
    func saveCurrentLocation(completion: @escaping () -> Void = {}) {
        locationError = nil
        locationSaveCompletion = completion

        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationError = "Location access denied. Please enable in Settings."
            locationSaveCompletion?()
            locationSaveCompletion = nil
            return
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            locationError = "Unknown authorization status"
            locationSaveCompletion?()
            locationSaveCompletion = nil
        }
    }

    // Clears the saved car location
    func clearLocation() {
        coordinate = CarCoordinate()
        saveLocationToPlist()
    }

    // Saves the current coordinate to a plist file
    private func saveLocationToPlist() {
        do {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            let data = try encoder.encode(coordinate)
            try data.write(to: plistURL(), options: .atomic)
        } catch {
            print("Error saving location: \(error.localizedDescription)")
            locationError = "Failed to save location"
        }
    }

    // Loads the saved coordinate from the plist file
    private func loadLocation() {
        let url = plistURL()

        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            coordinate = try decoder.decode(CarCoordinate.self, from: data)
        } catch {
            print("Error loading location: \(error.localizedDescription)")
        }
    }

    // Starts getting location updates
    private func startLocationUpdates() {
        guard CLLocationManager.locationServicesEnabled() else {
            locationError = "Location services are disabled"
            return
        }

        locationManager.startUpdatingLocation()
    }

    // Gets the URL for the plist file
    private func plistURL() -> URL {
        URL.documentsDirectory.appendingPathComponent(plistFileName)
    }
}

// Handles location updates and permission changes
extension LocationManager: CLLocationManagerDelegate {

    // Checks when location permission changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        if authorizationStatus == .authorizedWhenInUse ||
            authorizationStatus == .authorizedAlways {
            startLocationUpdates()
        }
    }

    // Saves the updated location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        coordinate = CarCoordinate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )

        saveLocationToPlist()
        locationManager.stopUpdatingLocation()

        locationSaveCompletion?()
        locationSaveCompletion = nil
    }

    // Handles location errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = "Failed to get location: \(error.localizedDescription)"
        locationManager.stopUpdatingLocation()

        locationSaveCompletion?()
        locationSaveCompletion = nil
    }
}

