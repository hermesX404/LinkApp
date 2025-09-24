//
//  LocationManager.swift
//  Link
//
//  Created by KAON SOU on 2025/03/22.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    @Published var userLocation: CLLocation?
    @Published var locationName: String = ""
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
        userLocation = nil
        locationName = ""
    }
    
    private func fetchLocationName(from location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                self?.locationName = "Unknown location"
                return
            }
            
            let country = placemark.country ?? ""
            let administrativeArea = placemark.administrativeArea ?? ""
            let locality = placemark.locality ?? ""
            let subLocality = placemark.subLocality ?? ""
            DispatchQueue.main.async {
                if locality.isEmpty || locality == administrativeArea {
                    self?.locationName = "\(country)\(administrativeArea)\(subLocality)"
                } else {
                    self?.locationName = "\(country)\(administrativeArea)\(locality)\(subLocality)"
                }
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latestLocation = locations.last {
            DispatchQueue.main.async {
                self.userLocation = latestLocation
                self.fetchLocationName(from: latestLocation)
            }
            manager.stopUpdatingLocation()
        }
    }
}
