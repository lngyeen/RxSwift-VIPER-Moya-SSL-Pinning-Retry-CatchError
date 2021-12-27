//
//  LocationTracker.swift
//  IPSCoreLib
//
//  Created by Nguyen Truong Luu on 10/4/21.
//  Copyright © 2021 Sicpa. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

public class LocationTracker: NSObject {
    /// Type representing either a Location or a Reason the location could not be determined.
    ///
    /// - success: A successful result with a valid Location.
    /// - failure: An unsuccessful result with a Reason for failure.
    public enum LocationResult {
        case success(CLLocation)
        case failure(Reason)
    }
    
    /// Type representing either an unknown location or an NSError describing why the location failed.
    ///
    /// - unknownLocation: The location is unknown because it has not been determined yet.
    /// - denied: denied description
    /// - other: The NSError describing why the location could not be determined.
    public enum Reason {
        case unknownLocation
        case denied
        case notDetermined
        case other(NSError)
    }
    
    /// An alias for the location change observer type.
    public typealias Observer = (_ location: LocationResult, _ status: CLAuthorizationStatus) -> Void
    
    public static let defaultTracker = LocationTracker(threshold: 20.0)
    
    // MARK: - Properties
    
    // MARK: Public
    
    /// A `LocationResult` representing the current location.
    public var currentLocation: LocationResult {
        return lastResult
    }
    
    /// CLLocationCoordinate2D
    public var currentCoordinate: CLLocationCoordinate2D? {
        switch lastResult {
        case .success(let location):
            return location.coordinate
        default:
            return nil
        }
    }
    
    // MARK: Private
    
    /// The last location result received. Initially the location is unknown.
    private var lastResult: LocationResult = .failure(.unknownLocation) {
        didSet {
            publishChangeWithResult(lastResult)
        }
    }
    
    /// The collection of location observers
    private var observers: [Observer] = []
    
    /// The minimum distance traveled before a location change is published.
    private let threshold: Double
    
    /// The internal location manager
    private let locationManager: CLLocationManager
    
    /// CLAuthorizationStatus
    private let requiredAuthorization: CLAuthorizationStatus
    
    private var setupCompletionCallback: ((_ status: Bool) -> Void)?
    
    // MARK: - Init
    
    /// Initializes a new LocationTracker with the default minimum distance threshold of 0 meters.
    override public convenience init() {
        self.init(threshold: 0.0)
    }
    
    /// Initializes a new LocationTracker with the specified minimum distance threshold.
    ///
    /// - Parameters:
    ///   - threshold: The minimum distance change in meters before a new location is published.
    ///   - locationManager: LocationTracker with the specified minimum distance threshold.
    public init(threshold: Double,
                locationManager: CLLocationManager = CLLocationManager(),
                requiredAuthorization: CLAuthorizationStatus = .authorizedWhenInUse) {
        self.threshold = threshold
        self.locationManager = locationManager
        self.requiredAuthorization = requiredAuthorization
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Functions
    
    // MARK: Public
    
    @discardableResult
    public func startTracking(_ completion: ((_ success: Bool) -> Void)? = nil) -> Bool {
        setupCompletionCallback = completion
        if !isDetermined() {
            if requiredAuthorization == .authorizedWhenInUse {
                locationManager.requestWhenInUseAuthorization()
            } else {
                locationManager.requestAlwaysAuthorization()
            }
            locationManager.requestLocation()
            
            return false
            
        } else if isRestricted() || (!isAuthorized()) {
            return false
        }
        
        // Force update
        locationManager(locationManager, didChangeAuthorization: requiredAuthorization)
        
        return true
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        observers.removeAll()
        lastResult = .failure(.unknownLocation)
    }
    
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// Adds a location change observer to execute whenever the location significantly changes.
    ///
    /// - Parameter observer: The callback function to execute when a location change occurs.
    public func addLocationChangeObserver(_ observer: @escaping Observer) {
        observers.append(observer)
    }
    
    // MARK: Private

    private func isAuthorized() -> Bool {
        if requiredAuthorization == .authorizedAlways {
            return [.authorizedAlways].contains(CLLocationManager.authorizationStatus())
        } else {
            return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
        }
    }
    
    private func isAlwaysAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    private func isInUseAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    private func isDetermined() -> Bool {
        return CLLocationManager.authorizationStatus() != .notDetermined
    }
    
    private func isRestricted() -> Bool {
        return [.restricted, .denied].contains(CLLocationManager.authorizationStatus())
    }
    
    private func publishChangeWithResult(_ result: LocationResult) {
        observers.forEach { $0(result, CLLocationManager.authorizationStatus()) }
    }
    
    private func shouldUpdateWithLocation(_ location: CLLocation) -> Bool {
        switch lastResult {
        case .success(let location):
            return location.distance(from: location) > threshold
        case .failure:
            return true
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationTracker: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let result: LocationResult
        if status == requiredAuthorization {
            result = .failure(.unknownLocation)
        } else if status == .notDetermined {
            result = .failure(.notDetermined)
        } else {
            result = .failure(.denied)
        }
        
        if status != .notDetermined {
            setupCompletionCallback?(status == .authorizedAlways || status == .authorizedWhenInUse)
            setupCompletionCallback = nil
        }
        
        lastResult = result
        
        if status == requiredAuthorization {
            startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let result: LocationResult
        if isRestricted() {
            result = .failure(.denied)
        } else {
            result = .failure(Reason.other(error as NSError))
        }
        lastResult = result
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard
            let currentLocation = locations.last,
            shouldUpdateWithLocation(currentLocation) else { return }
        lastResult = LocationResult.success(currentLocation)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
}
