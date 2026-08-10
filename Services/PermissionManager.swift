//
//  PermissionManager.swift
//  SalesJump
//
//  Created by San eforce on 06/08/26.
//

import AVFoundation
import Photos
import CoreLocation
import UIKit
import Combine

class PermissionManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: - Published values for SwiftUI
    @Published var cameraGranted = false
    @Published var microphoneGranted = false
    @Published var photoLibraryGranted = false

    @Published var locationGranted = false
    @Published var showPermissionAlert = false

    @Published var currentLocation: CLLocation? = nil

    private let locationManager = CLLocationManager()
    var onLocationReceived: ((CLLocation) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // ---------------------------------------------------------
    // MARK: - CAMERA PERMISSION
    // ---------------------------------------------------------
    func requestCameraPermission(completion: (() -> Void)? = nil) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraGranted = granted
                completion?()
            }
        }
    }

    // ---------------------------------------------------------
    // MARK: - PHOTO LIBRARY PERMISSION
    // ---------------------------------------------------------
    func requestPhotoLibraryPermission(completion: (() -> Void)? = nil) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.photoLibraryGranted = (status == .authorized || status == .limited)
                    completion?()
                }
            }
        }
        else {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    self.photoLibraryGranted = (status == .authorized)
                    completion?()
                }
            }
        }
    }

    func checkLocationStatusOnLaunch(allowRequest: Bool = true, isViewMode: Bool = false) {
        // Skip everything if in view mode and not requesting permissions
        guard allowRequest && !isViewMode else { return }

        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedAlways, .authorizedWhenInUse:
            locationGranted = true
            locationManager.startUpdatingLocation()

        case .denied, .restricted:
            locationGranted = false
            currentLocation = nil
            showPermissionAlert = true

        @unknown default:
            break
        }
    }


    /// Called before Submit button
    func validateLocationBeforeSubmit() -> Bool {
        let status = locationManager.authorizationStatus

        if status == .authorizedAlways {
            return true
        }

        showPermissionAlert = true
        return false
    }

//    func requestLocation() {
//        locationManager.requestWhenInUseAuthorization()
//    }
    
    func requestLocation() {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            // Ask for permission first time
            locationManager.requestWhenInUseAuthorization()

        case .authorizedAlways, .authorizedWhenInUse:
            // Permission granted → request location update
            locationManager.requestLocation()

        case .denied, .restricted:
            // Permission denied → show alert
            showPermissionAlert = true
            currentLocation = nil
            locationGranted = false

        @unknown default:
            break
        }
    }

    // ---------------------------------------------------------
    // MARK: - LOCATION DELEGATES
    // ---------------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
        case .authorizedAlways:
            locationGranted = true
            locationManager.startUpdatingLocation()

        case .authorizedWhenInUse, .denied, .restricted:
            locationGranted = false
            currentLocation = nil
            showPermissionAlert = true

        case .notDetermined:
            break

        @unknown default:
            break
        }
    }

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let last = locations.last else { return }
//        DispatchQueue.main.async {
//            self.currentLocation = last
//            self.locationGranted = true
//        }
//
//        print("Latitude: \(last.coordinate.latitude)")
//        print("Longitude: \(last.coordinate.longitude)")
//    }
    
//    func locationManager(_ manager: CLLocationManager,
//                         didUpdateLocations locations: [CLLocation]) {
//
//        guard let last = locations.last else { return }
//
//        DispatchQueue.main.async {
//            self.currentLocation = last
//            self.locationGranted = true
//
//            // Notify whoever requested the location
//            self.onLocationReceived?(last)
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else { return }

        onLocationReceived?(location)
        onLocationReceived = nil   // Prevent future automatic callbacks
    }
    

//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location fetch failed: \(error.localizedDescription)")
//
//        DispatchQueue.main.async {
//            self.currentLocation = nil
//            self.locationGranted = false
//            self.showPermissionAlert = true
//        }
//    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {

        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()      // Location will be received

        case .denied, .restricted:
            showPermissionAlert = true     // Don't call onLocationReceived

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError, clError.code == .locationUnknown {
            // Temporary failure, ignore
            return
        }

        print("Location fetch failed: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.currentLocation = nil
            self.locationGranted = false
            self.showPermissionAlert = true
        }
    }

    func requestAllPermissionsSequentially() {
        requestCameraPermission {
            self.requestPhotoLibraryPermission {
                self.checkLocationStatusOnLaunch()
            }
        }
    }
}
