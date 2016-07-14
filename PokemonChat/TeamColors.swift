//
//  TeamColors.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

private let COLOR_YELLOW = UIColor(hex:0xDFAC22)
private let COLOR_BLUE = UIColor(hex:0xDFAC22)
private let COLOR_RED = UIColor(hex:0x4243A2)

class TeamColors: NSObject
{
    class func colorForTeam(team:Team?) -> UIColor
    {
        if let team = team {
            switch team
            {
                case .Yellow: return COLOR_YELLOW
                case .Blue: return COLOR_BLUE
                case .Red: return COLOR_RED
            }
        } else {
            return UIColor.darkGrayColor()
        }
    }
}


/**
    Hex Color Utility Extension
 */
extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int)
    {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}