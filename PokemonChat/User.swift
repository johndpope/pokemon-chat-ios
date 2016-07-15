//
//  User.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

/// for now
let _me = User()
///

enum TeamMode
{
    case Local
    case Team
}

class User: NSObject
{
    var username: String!
    var team : Team!
    var token : String!
    
    var teamMode = TeamMode.Local
    
    class func currentUser() -> User!
    {
        _me.username = "2blest"
        _me.team = Team.Yellow
        _me.token = "a7cf595661d5d75c55114e91c9451fa7"
        return _me
    }
    
    func currentColor() -> UIColor
    {
        switch self.teamMode
        {
            case .Local:
                return TeamColors.colorForTeam(nil)
            case .Team:
                return TeamColors.colorForTeam(self.team)
        }
    }
}
