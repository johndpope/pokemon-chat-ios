//
//  CommentRouter.swift
//  PokemonChat
//
//  Created by ----- --- on 7/15/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import Alamofire

protocol CommentRouterCompliant
{
    func commentParameters() -> [String:AnyObject]
    static func fromParams(params: [String:AnyObject]) -> Comment?
}

enum CommentRouter: URLRequestConvertible
{
    
    static var authToken: String?
    
    case All(Post)
    case Create(Comment)
    case Destroy(Comment)
    
    var method: Alamofire.Method
    {
        switch self
        {
            case .All:
                return .GET
            case .Create:
                return .POST
            case .Destroy:
                return .DELETE
        }
    }
    
    var path: String
    {
        switch self
        {
            case .All(let post):
                return "/posts/\(post._id)/comments"
            case .Create(let comment):
                return "/posts/\(comment.postID!)/comments"
            case .Destroy(let comment):
                return "/posts/\(comment.postID!)/comments/\(comment._id)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest
    {
        let URL = NSURL(string: Connector.baseAPIEndpoint())!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        // use current user auth
        if let token = CommentRouter.authToken {
            print("Using given user token")
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if let token = User.currentUser()?.token {
            print("Using default user token")
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No auth token");
        }
        
        switch self
        {
            case .All(_):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
            case .Create(let comment):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: comment.commentParameters()).0
            case .Destroy(_):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0

        }
    }
    
    
}