//
//  TeamColors.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

let COLOR_YELLOW = UIColor(hex:0xF0B922)
let COLOR_BLUE = UIColor(hex:0x4243A2)
let COLOR_RED = UIColor(hex:0xC54632)
let COLOR_GRAY = UIColor(hex:0x4A4A4A)

class TeamColors: NSObject
{
    class func colorForTeam(team:Team?) -> UIColor
    {
        switch team
        {
            case .Some(.Yellow): return COLOR_YELLOW
            case .Some(.Blue): return COLOR_BLUE
            case .Some(.Red): return COLOR_RED
            default: return COLOR_GRAY
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