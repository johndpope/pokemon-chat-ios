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
    static var lastLocation : CLLocationCoordinate2D?
    
    private let locationManager : CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        return manager
    }()
    
    private var locationCompletionClosure : ((CLLocationCoordinate2D?, NSError?) -> Void)?
    
    
    func getLocation(completion: (CLLocationCoordinate2D?, NSError?) -> Void )
    {
        print("Looking for location...")
        self.locationManager.requestWhenInUseAuthorization()
        self.locationCompletionClosure = completion
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation)
    {
        print("Location: \(newLocation.coordinate)")
        let coordinate = newLocation.coordinate
        
        Magellan.lastLocation = coordinate
        
        self.complete(coordinate, error: nil)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("ERROR getting location: \(error)")
        self.complete(nil, error: error)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        print("Location Manager Authorization changed: \(status.rawValue)")
        if status != CLAuthorizationStatus.AuthorizedWhenInUse && status != CLAuthorizationStatus.AuthorizedAlways && status != CLAuthorizationStatus.NotDetermined
        {
            let error = NSError(domain: "Magellan", code: Int(status.rawValue), userInfo: nil)
            self.complete(nil, error: error)
        }
    }
    
    static func alertForFailedLocationFrom(hostController:UIViewController, completion:((Void)->Void)?)
    {
        // handle location error with alert
        let controller = UIAlertController(title: "Drat", message: "Can't find your location. Check Settings to make sure you've given us permission to use your location.", preferredStyle: UIAlertControllerStyle.Alert)
        // dismiss the controller option
        let okayButton = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: { (_) in
            controller.dismissViewControllerAnimated(true, completion: completion)
        })
        // open settings option
        let settingsButton = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { (_) in
            completion?()
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        })
        
        controller.addAction(okayButton)
        controller.addAction(settingsButton)
        
        hostController.presentViewController(controller, animated: true, completion: nil)
    }
    
    private func complete(location:CLLocationCoordinate2D?, error:NSError?)
    {
        self.locationManager.stopUpdatingLocation()

        dispatch_async(dispatch_get_main_queue()) {
            self.locationCompletionClosure?(location, error)
            self.locationCompletionClosure = nil
        }
    }
    
}
