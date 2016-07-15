//
//  UIView+Help.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

extension UIView
{
    func drawDropShadow()
    {
        self.drawDropShadowWithOffset(0.5)
    }
    
    func drawDropShadowWithOffset(offset: CGFloat)
    {
        self.layer.shadowOffset = CGSize(width: 0, height: offset)
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 1.5
        self.layer.shadowOpacity = 0.40
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    func rasterizeShadow()
    {
        self.layer.shadowPath = UIBezierPath(rect: self.layer.bounds).CGPath
    }
}