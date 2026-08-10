//
//  LocationManager.swift
//  SalesJump
//
//  Created by San eforce on 06/08/26.
//

import Foundation
import CoreLocation
import MapKit
import Combine

struct IdentifiableAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

import Foundation
import MapKit
import CoreLocation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Published Properties
    
    @Published var userLatitude: Double?
    @Published var userLongitude: Double?
    
    @Published var coordinate: CLLocationCoordinate2D =
        CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @Published var fullAddress: String = ""
    
    // 🔥 NEW (IMPORTANT)
    @Published var currentPlacemark: CLPlacemark?
    
    @Published var userLocationAnnotation: [IdentifiableAnnotation] = []
    
    // MARK: - Properties
    
    var allowGPSUpdates = true
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    // MARK: - Init
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
    }
    
    // MARK: - Permission
    
    func requestLocationAccess() {
        guard allowGPSUpdates else { return }
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard allowGPSUpdates else { return }
        
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            stopGPSUpdates()
        }
    }
    
    // MARK: - Location Updates
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard allowGPSUpdates else { return }
        guard let location = locations.last else { return }
        
        updateFromLocation(location)
    }
    
    func stopGPSUpdates() {
        locationManager.stopUpdatingLocation()
        
        DispatchQueue.main.async {
            self.userLatitude = nil
            self.userLongitude = nil
            self.fullAddress = ""
            self.currentPlacemark = nil
            self.userLocationAnnotation = []
        }
    }
    
    // MARK: - Update Helpers
    
    private func updateFromLocation(_ location: CLLocation) {
        let newCoordinate = location.coordinate
        
        DispatchQueue.main.async {
            self.coordinate = newCoordinate
            
            self.region = MKCoordinateRegion(
                center: newCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01,
                                       longitudeDelta: 0.01)
            )
            
            self.userLocationAnnotation = [
                IdentifiableAnnotation(coordinate: newCoordinate)
            ]
            
            self.userLatitude = newCoordinate.latitude
            self.userLongitude = newCoordinate.longitude
        }
        
        getAddressFromLocation(location)
    }
    
    func updateRegion(latitude: Double, longitude: Double) {
        allowGPSUpdates = false
        locationManager.stopUpdatingLocation()
        
        let newCoordinate = CLLocationCoordinate2D(latitude: latitude,
                                                   longitude: longitude)
        
        DispatchQueue.main.async {
            self.coordinate = newCoordinate
            
            self.region = MKCoordinateRegion(
                center: newCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01,
                                       longitudeDelta: 0.01)
            )
            
            self.userLocationAnnotation = [
                IdentifiableAnnotation(coordinate: newCoordinate)
            ]
            
            self.userLatitude = latitude
            self.userLongitude = longitude
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        getAddressFromLocation(location)
    }
    
    // MARK: - Reverse Geocoding
    
    private func getAddressFromLocation(_ location: CLLocation) {
        
        // Cancel previous request if running
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            
            guard let self = self,
                  let placemark = placemarks?.first,
                  error == nil else { return }
            
            DispatchQueue.main.async {
                
                //Save structured placemark
                self.currentPlacemark = placemark
                
                // Optional full formatted address
                let addressParts = [
                    placemark.name,
                    placemark.subLocality,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode,
                    placemark.country
                ]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                
                self.fullAddress = addressParts
            }
        }
    }
}
