//
//  User.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit
import KeychainAccess

//// SENSITIVE KEYs
private let LockBox = Keychain(service: "com.PokemonGOTeamChat")
private let LOCKBOX_KEY_TOKEN = "LOGIN___TOKEN"
//// DO NOT CHANGE


/// global in-memory reference for current user
private var _currentUser : User? = nil

enum TeamMode
{
    case Local
    case Team
}

class User: NSObject
{
    private static var userDefaults = NSUserDefaults(suiteName: "CurrentUser")! // do not modify name

    var _id : String?
    var username: String?
    var team : Team?
    var password : String?
    var teamMode = TeamMode.Local
    
    class func currentUserToken() -> String?
    { // for the current user session
        return LockBox[LOCKBOX_KEY_TOKEN]
    }
    
    class func currentUser() -> User?
    {
        if _currentUser == nil
        {
            print("!!! Loading the user from disk..")
            _currentUser = User.fromDefaults()
            print(_currentUser)
        }
        return _currentUser
    }
    
    func currentColor() -> UIColor
    {
        switch self.teamMode
        {
            case .Local:
                return TeamColors.colorForTeam(nil)
            case .Team:
                return TeamColors.colorForTeam(self.team)
        }
    }
    
    func isValid() -> Bool
    {
        let valid = self.username != nil && self.team != nil
        return valid
    }
    
    func login(completion:((User, NSError?) -> Void)?)
    {
        Connector().logInUser(self) { user, token, error in
            if let user = user, token = token {
                self.updateUser(user, token: token)
            }
            completion?(self, error)
        }
    }
    
    func logOut(completion: (Bool, NSError?) -> Void)
    {
        // do something, then
        // destroy local token
        LockBox[LOCKBOX_KEY_TOKEN] = nil
    }
    
    private func updateUser(fromUser:User, token:String)
    {
        self.copyFromUser(fromUser)
        self.saveAuthToken(token)
        self.persistUserData()
    }
    
    private func copyFromUser(user:User)
    {
        self._id = user._id
        self.username = user.username
        self.team = user.team
    }
    
    private func saveAuthToken(token:String)
    {
        LockBox[LOCKBOX_KEY_TOKEN] = token
    }
    
    private func persistUserData()
    {
        User.userDefaults.setObject(self._id, forKey: "_id")
        User.userDefaults.setObject(self.username, forKey: "username")
        User.userDefaults.setObject(self.team?.rawValue, forKey: "team")
    }
    
    private class func fromDefaults() -> User?
    {
        if let id = User.userDefaults.stringForKey("_id"),
                username = User.userDefaults.stringForKey("username"),
                teamName = User.userDefaults.stringForKey("team")
        {
            let user = User()
            user._id = id
            user.username = username
            user.team = Team(rawValue:teamName)
            return user
        }
        else
        {
            return nil
        }
    }
}


//MARK: UserRouterCompliant

extension User : UserRouterCompliant
{
    func userParameters() -> [String : AnyObject]
    {
        let params : [String: AnyObject?] = [
            "username" : self.username,
            "password" : self.password,
            "team" : self.team?.rawValue
        ]
        return params as! [String : AnyObject];
    }
    
    class func fromParams(params: [String : AnyObject]) -> User?
    {
        let user = User()
        user._id = params["_id"] as? String
        user.username = params["username"] as? String
        if let teamName = params["team"] as? String {
            user.team = Team(rawValue: teamName)
        }
        
        if user.isValid()
        {
            return user
        }
        else
        {
            return nil
        }
    }
}
