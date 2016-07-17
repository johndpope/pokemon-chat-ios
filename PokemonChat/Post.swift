//
//  Post.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit

class Post: NSObject
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
    
    func save(completion:(Post, NSError?) -> Void )
    {
        if (self._id != nil) // bail if we already saved it
        {
            let error = NSError(domain: "PostModel", code: 500, userInfo: [NSLocalizedDescriptionKey: "Trying to save an existing post"])
            completion(self, error)
        }
        else
        {
            Connector().createPost(self, completion: { (post, error) in
                self.copyPost(post)
                completion(self, error)
            })
        }
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
    
    private func copyPost(post:Post?)
    {
        if let post = post {
            self._id = post._id
            self.userID = post.userID
            self.username = post.username
            self.content = post.content
            self.latitude = post.latitude
            self.longitude = post.longitude
            self.createdAt = post.createdAt
            self.team = post.team
        }
    }
}

extension Post : PostRouterCompliant
{
    class func fromParams (params: [String : AnyObject]) -> Post?
    {
        let post = Post()
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
        
        post._id = _id
        post.content = content
        post.userID = userID
        post.username = username
        post.latitude = latitude
        post.longitude = longitude
        post.team = team
        post.createdAt = createdAt
        if let isPrivate = isPrivate {
            post.isPrivate = isPrivate
        }
        if let commentCount = comments {
            post.commentCount = commentCount
        }
        
        // validate the post
        if post.isValid()
        {
            return post
        }
        else // failure
        {
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

}