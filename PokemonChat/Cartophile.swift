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
        let region = MKCoordinateRegionMakeWithDistance(self.centerCoordinate, 1000, 1000)
        self.region = self.regionThatFits(region)
    }
}
