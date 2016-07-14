//
//  PostRouter.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import Alamofire

protocol PostRouterCompliant
{
    func postParameters() -> [String:AnyObject]
    init?(params: [String:AnyObject])
}

enum PostRouter: URLRequestConvertible
{
    
    static var authToken: String?
    
    case Locate(lat: Float, long: Float, within: Float)
    case Create(Post)
    case Read(Post)
    case Update(Post)
    case Destroy(Post)
    
    var method: Alamofire.Method
    {
        switch self
        {
            case .Locate:
                return .GET
            case .Create:
                return .POST
            case .Read:
                return .GET
            case .Update:
                return .PUT
            case .Destroy:
                return .DELETE
        }
    }
    
    var path: String
    {
        switch self
        {
            case .Locate(_,_,_):
                return "/posts_by_location"
            case .Create:
                return "/posts"
            case .Read(let post):
                return "/posts/\(post._id)"
            case .Update(let post):
                return "/posts/\(post._id)"
            case .Destroy(let post):
                return "/posts/\(post._id)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest
    {
        let URL = NSURL(string: Connector.baseAPIEndpoint())!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        // use current user auth
        if let token = PostRouter.authToken {
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
            case.Locate(let lat, let long, let within):
                return Alamofire.ParameterEncoding.URLEncodedInURL.encode(mutableURLRequest, parameters: ["latitude" : lat, "longitude": long, "within" : within]).0
            case .Create(let post):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: post.postParameters()).0
            case .Update(let post):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: post.postParameters()).0
            default:
                return mutableURLRequest
        }
    }
    
    
}