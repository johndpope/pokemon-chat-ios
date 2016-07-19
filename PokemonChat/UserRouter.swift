//
//  UserRouter.swift
//  PokemonChat
//
//  Created by ----- --- on 7/17/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import Alamofire

protocol UserRouterCompliant
{
    func userParameters() -> [String:AnyObject]
    static func fromParams(params: [String:AnyObject]) -> User?
}

enum UserRouter: URLRequestConvertible
{
    
    static var authToken: String?
    
    case Login(User)
    case Signup(User)
    case LogOut(User)
    case CheckName(String)
    
    var method: Alamofire.Method
    {
        switch self
        {
            case .Login:
                return .POST
            case .Signup:
                return .POST
            case .LogOut:
                return .POST
            case .CheckName:
                return .GET
        }
    }
    
    var path: String
    {
        switch self
        {
            case .Login( _):
                return "/login"
            case .Signup( _):
                return "/signup"
            case .LogOut( _):
                return "/logout"
            case .CheckName(let name):
                return "/check_username/\(name.lowercaseString)"
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
        } else if let token = User.currentUserToken() {
            print("Using default user token")
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No auth token");
        }
        
        switch self
        {
            case .Login(let user):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: user.userParameters()).0
            case .Signup(let user):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: user.userParameters()).0
            case .LogOut(_):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
            case .CheckName(_):
                return Alamofire.ParameterEncoding.URLEncodedInURL.encode(mutableURLRequest, parameters: nil).0
            
        }
    }
}
