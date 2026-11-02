
import SwiftUI
import MapKit

struct MapView: View {
    // Stores the location manager
    var locationManager: LocationManager
    @State private var position: MapCameraPosition = .automatic

    // Creates the car coordinate for the map
    private var carCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: locationManager.coordinate.latitude,
            longitude: locationManager.coordinate.longitude
        )
    }

    // Checks if a car location has been saved
    private var hasLocation: Bool {
        locationManager.coordinate.latitude != 0 ||
        locationManager.coordinate.longitude != 0
    }

    // Updates the map to show the car location
    private func updateMapPosition() {
        guard hasLocation else { return }

        let region = MKCoordinateRegion(
            center: carCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

        position = .region(region)
    }

    var body: some View {
        ZStack {
            Map(position: $position) {
                // Shows the user's location
                UserAnnotation()

                // Shows the car location
                if hasLocation {
                    Annotation("Your Car is Here", coordinate: carCoordinate) {
                        VStack(spacing: 4) {
                            Image(systemName: "car.fill")
                                .font(.title)
                                .foregroundColor(.red)
                                .padding(8)
                                .background(Circle().fill(Color.white))
                                .shadow(radius: 3)

                            Text("Your Car")
                                .font(.caption)
                                .padding(4)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(4)
                                .shadow(radius: 2)
                        }
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .ignoresSafeArea()
            .onAppear {
                updateMapPosition()
            }
            .onChange(of: locationManager.coordinate) { _, _ in
                updateMapPosition()
            }

            // Shows the saved coordinates at the top
            VStack {
                if hasLocation {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Car Location")
                            .font(.headline)

                        Text("Lat: \(String(format: "%.6f", carCoordinate.latitude))")
                            .font(.caption)

                        Text("Lon: \(String(format: "%.6f", carCoordinate.longitude))")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                }

                Spacer()
            }
        }
        .navigationTitle("Map View")
        .navigationBarTitleDisplayMode(.inline)
    }
}
