//
//  Connector.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit
import Alamofire

let ENDPOINT_LOCAL = "http://192.168.1.106:3030"

private let KEY_PUBLIC_POSTS = "public_posts"
private let KEY_TEAM_POSTS = "team_posts"

class Connector: NSObject
{
    class func baseAPIEndpoint() -> String {
        return ENDPOINT_LOCAL // for now
    }
    
    func getPostsForCurrentLocation(completion: (([Post]?, [Post]?, NSError?) -> Void))
    {
        let request = Alamofire.request(PostRouter.Locate(lat: 34, long: -84, within: 5))
            .validate(contentType: ["application/json"])
            .validate()
            .responseJSON { response in
                switch response.result
                {
                    case .Success:
                        print(response.result)
                        if let result = response.result.value as? [String:AnyObject],
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

                    case .Failure(let error):
                        print(error)
                        completion(nil, nil, error)
                }
        }
        
        print(request)
    }
}


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
            if let post = Post(params: postResponse) {
                posts.append(post)
            }
        }
        return posts
    }
}


