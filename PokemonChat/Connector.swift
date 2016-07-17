//
//  Connector.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit
import Alamofire

let ENDPOINT_LOCAL = "http://127.0.0.1:3030"

private let KEY_PUBLIC_POSTS = "public_posts"
private let KEY_TEAM_POSTS = "team_posts"

class Connector: NSObject
{
    class func baseAPIEndpoint() -> String {
        return ENDPOINT_LOCAL // for now
    }
    
    func getPostsForCurrentLocation(completion: ([Post]?, [Post]?, NSError?) -> Void )
    {
        self.request(PostRouter.Locate(lat: 34, long: -84, within: 5)) { (response, error) in
            if error != nil
            {
                completion(nil, nil, error)
            }
            else // success
            {
                if let result = response as? [String:AnyObject],
                    publicPostResponse = result["public_posts"] as? [[String: AnyObject]],
                    privatePostResponse = result["team_posts"] as? [[String: AnyObject]]
                {
                    let publicPosts = self.postsFromResponse(publicPostResponse)
                    let privatePosts = self.postsFromResponse(privatePostResponse)
                    if publicPostResponse.count == 0 && privatePostResponse.count == 0 {
                        print("No posts made it through. Something bad probably happened.")
                    }
                    completion(publicPosts, privatePosts, nil)
                    return
                }
                
                // catch all parsing errors
                let error = NSError(domain: "Connector", code: 400, userInfo: [NSLocalizedDescriptionKey : "Couldn't understand HTTP response"])
                completion(nil, nil, error)
            }
        }
    }
    
    func commentsForPost(post:Post, completion: ([Comment]?, NSError?) -> Void )
    {
        self.request(CommentRouter.All(post)) { (response, error) in
            if error != nil
            {
                completion(nil, error)
            }
            else // SUCCESS
            {
                if let result = response as? [String : AnyObject],
                    commentsResponse = result["comments"] as? [[String : AnyObject]]
                {
                    let comments = self.commentsFromResponse(commentsResponse)
                    completion(comments, nil)
                    return
                }
                
                // catch all parsing errors
                let error = NSError(domain: "Connector", code: 400, userInfo: [NSLocalizedDescriptionKey : "Couldn't understand HTTP response"])
                completion(nil, error)
            }
        }
    }
    
    func createComment(comment:Comment, completion: (Comment?, NSError?) -> Void )
    {
        self.request(CommentRouter.Create(comment)) { (response, error) in
            if error != nil
            {
                completion(nil, error)
            }
            else
            {
                if let result = response as? [String : AnyObject],
                    let comment = Comment.fromParams(result)
                {
                    completion(comment, nil)
                    return
                }
                
                // catch all parsing errors
                let error = NSError(domain: "Connector", code: 400, userInfo: [NSLocalizedDescriptionKey : "Couldn't understand HTTP response"])
                completion(nil, error)
            }
        }
    }
    
    func createPost(post:Post, completion: (Post?, NSError?) -> Void )
    {
        self.request(PostRouter.Create(post)) { (response, error) in
            if error != nil
            {
                completion(nil, error)
            }
            else
            {
                if let result = response as? [String : AnyObject],
                    let post = Post.fromParams(result)
                {
                    completion(post, nil)
                    return
                }
                
                // catch all parsing errors
                let error = NSError(domain: "Connector", code: 400, userInfo: [NSLocalizedDescriptionKey : "Couldn't understand HTTP response"])
                completion(nil, error)
            }
        }
    }
    
    private func request(router: URLRequestConvertible, completion: (AnyObject?, NSError?) -> Void)
    {
        let request = Alamofire.request(router)
            .validate(contentType: ["application/json"])
            .validate()
            .responseJSON { response in
                switch response.result
                {
                    case .Success:
                        print(response.result)
                        completion(response.result.value, nil)
                        
                    case .Failure(let error):
                        print(error)
                        completion(false, error)
                }
        }
        
        print(request)
    }
    
    
} /* * * * * * */


/**
    Extension for Post parsing
 */
extension Connector
{
    func postsFromResponse(response: [[String:AnyObject]]) -> [Post]
    {
        var posts = [Post]()
        for postResponse in response
        {
            if let post = Post.fromParams(postResponse) {
                posts.append(post)
            }
        }
        return posts
    }
}

/**
 Extension for Comment parsing
 */
extension Connector
{
    func commentsFromResponse(response: [[String:AnyObject]]) -> [Comment]
    {
        var comments = [Comment]()
        for commentResponse in response
        {
            if let comment = Comment.fromParams(commentResponse) {
                comments.append(comment)
            }
        }
        return comments
    }
}


