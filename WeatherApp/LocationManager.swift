//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Musa Yazici on 10/1/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var cityName: String?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        fetchCityName(from: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            print("Location access not determined")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location access accepted")
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    private func fetchCityName(from location: CLLocation?) {
        print("fetch city name: \(String(describing: location))")
        guard let location = location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                print("Failed to get city name: \(error)")
                return
            }
            
            if let city = placemarks?.first?.locality {
                print("City Name: \(city)")
                DispatchQueue.main.async {
                    self?.cityName = city
                }
            }
        }
    }
}
