//
//  Comment.swift
//  PokemonChat
//
//  Created by ----- --- on 7/15/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class Comment: NSObject
{
    var userID : String!
    var user_team : Team!
    var username : String!
    var content : String!
    
    func isValid() -> Bool
    {
        let valid = self.userID != nil
                    && self.user_team != nil
                    && self.content != nil
        
        return valid
    }
    
    func save(completion:((Comment, NSError?) -> Void))
    {
        delay(0.6) {
            self.userID = "4q823482cn478"
            self.username = "2blest"
            self.user_team = Team.Yellow
            completion(self, nil)
        }
    }
}
