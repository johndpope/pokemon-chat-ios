//
//  User.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class User: NSObject
{
    var username: String!
    var team : Team!
    var token : String!
    
    class func currentUser() -> User!
    {
        let me = User()
        me.username = "2blest"
        me.team = Team.Yellow
        me.token = "a7cf595661d5d75c55114e91c9451fa7"
        return me
    }
}
