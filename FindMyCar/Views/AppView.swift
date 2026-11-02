
import SwiftUI

struct AppView: View {
    @State private var locationManager = LocationManager()
    @State private var showingAlert = false
    @State private var showingErrorAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                // Shows the app title
                VStack(spacing: 8) {
                    Text("Find My Car")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    if locationManager.coordinate.latitude != 0 ||
                        locationManager.coordinate.longitude != 0 {
                        Text("Location Saved")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }

                Spacer()

                // Saves the car location
                Button(action: {
                    locationManager.saveCurrentLocation {
                        showingAlert = true
                    }
                }) {
                    Label("Here's My Car", systemImage: "car.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // Opens the map
                NavigationLink(destination: MapView(locationManager: locationManager)) {
                    Label("Where's My Car?", systemImage: "map.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(locationManager.coordinate.latitude == 0 &&
                          locationManager.coordinate.longitude == 0)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Location Saved", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                if let error = locationManager.locationError {
                    Text(error)
                } else {
                    Text(generateLocationMessage())
                }
            }
            .alert("Location Error", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(locationManager.locationError ?? "Unknown error")
            }
            .onChange(of: locationManager.locationError) { _, newError in
                if newError != nil && !showingAlert {
                    showingErrorAlert = true
                }
            }
        }
    }

    // Creates the message showing the saved coordinates
    private func generateLocationMessage() -> String {
        let lat = String(format: "%.6f", locationManager.coordinate.latitude)
        let lon = String(format: "%.6f", locationManager.coordinate.longitude)

        return "Your car is at:\n(\(lat), \(lon))\n\nTap 'Where's My Car?' to view on the map."
    }
}
