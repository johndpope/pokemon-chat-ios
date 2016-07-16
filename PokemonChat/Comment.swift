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
    var _id : String?
    var postID : String?
    var userID : String?
    var username : String?
    var user_team : Team?
    var content : String?
    var createdAt : NSDate?
    
    func save(completion:((Comment, NSError?) -> Void))
    {
        if (self._id != nil) // bail if we already saved it
        {
            let error = NSError(domain: "CommentModel", code: 500, userInfo: [NSLocalizedDescriptionKey: "Trying to save an existing comment"])
            completion(self, error)
        }
        else
        {
            Connector().createComment(self, completion: { (comment, error) in
                self.copyComment(comment)
                completion(self, error)
            })
        }
    }
    
    func isValid() -> Bool
    {
        let valid = self.postID != nil
                && self.userID != nil
                && self.user_team != nil
                && self.username != nil
                && self.content != nil
        
        return valid
    }
    
    private func copyComment(comment:Comment?)
    {
        if let comment = comment {
            self._id = comment._id
            self.postID = comment.postID
            self.userID = comment.userID
            self.username = comment.username
            self.user_team = comment.user_team
            self.content = comment.content
            self.user_team = comment.user_team
            self.createdAt = comment.createdAt            
        }
    }
}

extension Comment : CommentRouterCompliant
{
    class func fromParams (params: [String : AnyObject]) -> Comment?
    {
        let comment = Comment()
        // scrape the params
        let _id = params["_id"] as? String
        let content = params["content"] as? String
        let userID = params["user"] as? String
        let username = params["username"] as? String
        let teamName = params["user_team"] as? String
        let parentID = params["parent_post"] as? String
        var team : Team?
        if let teamName = teamName {
            team = Team(rawValue: teamName)
        }
        let createdISO = params["createdAt"] as? String
        var createdAt : NSDate?
        if let createdISO = createdISO {
            createdAt = NSDate(iso8601: createdISO)
        }
        
        comment._id = _id
        comment.postID = parentID
        comment.content = content
        comment.userID = userID
        comment.username = username
        comment.user_team = team
        comment.createdAt = createdAt
        
        // validate the comment
        if comment.isValid()
        {
            return comment
        }
        else // failure
        {
            print("FUCK! Comment is invalid.")
            return nil
        }
    }
    
    func commentParameters() -> [String : AnyObject]
    {
        let dictionary : [String: AnyObject?] = [
            "content" : self.content
        ]
        
        return dictionary as! [String : AnyObject]
    }
}
