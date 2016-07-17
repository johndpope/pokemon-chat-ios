//
//  Magellan.swift
//  PokemonChat
//
//  Created by ----- --- on 7/17/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit
import CoreLocation

class Magellan: NSObject, CLLocationManagerDelegate
{
    static let sharedMagellan = Magellan()
    var lastLocation : CLLocationCoordinate2D?
    
    private let locationManager : CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        return manager
    }()
    
    private var locationCompletionClosure : ((CLLocationCoordinate2D?, NSError?) -> Void)?
    
    
    func getLocation(completion: (CLLocationCoordinate2D?, NSError?) -> Void )
    {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationCompletionClosure = completion
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation)
    {
        let coordinate = newLocation.coordinate
        self.lastLocation = coordinate
        self.locationCompletionClosure?(coordinate, nil)
        self.locationCompletionClosure = nil
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        self.locationCompletionClosure?(nil, error)
        self.locationCompletionClosure = nil
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        //
    }
    
}
