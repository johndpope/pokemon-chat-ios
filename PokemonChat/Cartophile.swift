//
//  Cartophile.swift
//  PokemonChat
//
//  Created by ----- --- on 7/17/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import MapKit

extension MKMapView
{
    func zoomToHumanLevel()
    {
        let region = MKCoordinateRegionMakeWithDistance(self.centerCoordinate, 3000, 3000)
        self.region = self.regionThatFits(region)
    }
}


/// Pokemon-Specific help
extension MKMapView : MKMapViewDelegate
{
    func addMapPinForPost(post:Post)
    {
        let annotation = MKPointAnnotation()
        if let lat = post.latitude, long = post.longitude
        {
            let coordinate = CLLocationCoordinate2D(latitude:lat, longitude: long)
            annotation.coordinate = coordinate
            annotation.title = post.content
            
            self.addAnnotation(annotation)
        }
        self.delegate = self
    }
    
    //MARK: MKMapViewDelegate
    
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation
        {
            return nil
        }
        else
        {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PINZ")
            view.canShowCallout = true
            view.animatesDrop = true
            return view
        }
        
    }
}