//
//  Post.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class Post: NSObject, PostRouterCompliant
{
    var _id : String!
    var content : String!
    var userID : String!
    var username : String!
    var commentCount: Int = 0
    var latitude : Float!
    var longitude : Float!
    var team : Team!
    var isPrivate = false
    var createdAt : NSDate!
    
    required init? (params: [String : AnyObject])
    {
        super.init()
        // scrape the params
        let _id = params["_id"] as? String
        let content = params["content"] as? String
        let userID = params["user"] as? String
        let username = params["username"] as? String
        let comments = params["comment_count"] as? Int
        let latitude = params["latitude"] as? Float
        let longitude = params["longitude"] as? Float
        let teamName = params["team"] as? String
        var team : Team?
        if let teamName = teamName {
            team = Team(rawValue: teamName)
        }
        let isPrivate = params["is_private"] as? Bool
        let createdISO = params["createdAt"] as? String
        var createdAt : NSDate?
        if let createdISO = createdISO {
            createdAt = NSDate(iso8601: createdISO)
        }
        
        self._id = _id
        self.content = content
        self.userID = userID
        self.username = username
        self.latitude = latitude
        self.longitude = longitude
        self.team = team
        self.createdAt = createdAt
        if let isPrivate = isPrivate {
            self.isPrivate = isPrivate
        }
        if let commentCount = comments {
            self.commentCount = commentCount
        }
        
        // validate the post
        if !self.isValid() {
            print("FUCK! Post is invalid.")
            return nil
        }
    }
    
    func postParameters() -> [String : AnyObject]
    {
        let dictionary = [
            "content" : self.content,
            "latitude" : self.latitude,
            "longitude" : self.longitude,
            "team" : User.currentUser().team.rawValue,
            "is_private" : self.isPrivate
        ]
        
        return dictionary as! [String : AnyObject]
    }
    
    func isValid() -> Bool
    {
        let valid = (self._id != nil
                    && self.content != nil
                    && self.userID != nil
                    && self.latitude != nil
                    && self.longitude != nil
                    && self.team != nil
                    && self.createdAt != nil)
        
        return valid
    }
}
