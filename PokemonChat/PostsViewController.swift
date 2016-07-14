//
//  PostsViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/13/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit
import MapKit

private let CELL_IDENTIFIER_POST = "PostCell"
private let TITLE_NEARBY = "nearby"
private let TITLE_TEAM_ONLY = "team chat"

private let SEGUE_TO_DETAIL = "ListToDetail"

enum PostMode
{
    case Local
    case Team
}

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var displayButton: UIButton!
    
    @IBOutlet weak var contentContainer: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var teamSwitch: UISwitch!
    
    var postMode = PostMode.Local
    
    lazy var localPosts = [Post]()
    lazy var teamPosts = [Post]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.teamSwitch.setOn(false, animated: false)
        self.tableView.estimatedRowHeight = 88
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.top = 10
        self.tableView.contentInset.bottom =  96
        // Do any additional setup after loading the view.
        
        Connector().getPostsForCurrentLocation { (localPosts, teamPosts, error) in
            if let localPosts = localPosts, teamPosts = teamPosts {
                self.localPosts = localPosts
                self.teamPosts = teamPosts
                self.tableView.reloadData()
            }
        }
    }
    
    
//MARK: Actions

    @IBAction func menuButtonTapped(sender: UIButton)
    {
        //TODO: go to menu
    }
    
    @IBAction func displayButtonPressed(sender: UIButton)
    {
        //TODO: show the map
        
        let tableViewVisible = (sender.tag == 0)

        if self.contentContainer.hidden {
            self.contentContainer.hidden = false
        }
        
        UIView.animateWithDuration(0.23, animations: {
            self.contentContainer.alpha = CGFloat(sender.tag)
        }) { (done) in
            self.contentContainer.hidden = tableViewVisible
        }
        
        sender.tag = tableViewVisible ? 1 : 0
    }
    
    @IBAction func teamSliderSwitched(sender: UISwitch)
    {
        self.postMode = sender.on ? .Team : .Local
        self.title = self.postMode == .Team ? TITLE_TEAM_ONLY : TITLE_NEARBY
        UIView.animateWithDuration(0.22, animations: {
            self.tableView.alpha = 0
        }) { (done) in
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
                self.tableView.contentOffset = CGPoint(x:0, y:-self.tableView.contentInset.top)
            
            UIView.animateWithDuration(0.12, animations: {
                self.tableView.alpha = 1
            })
        }
    }
    
//MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count : Int
        switch self.postMode
        {
            case .Local: count = self.localPosts.count
            case .Team: count = self.teamPosts.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER_POST) as! PostTableViewCell
        
        let post : Post
        switch self.postMode
        {
            case .Local: post = self.localPosts[indexPath.row]
            case .Team: post = self.teamPosts[indexPath.row]
        }
        
        cell.contentLabel.text = post.content
        cell.usernameLabel.text = post.username
        cell.usernameLabel.textColor = TeamColors.colorForTeam(post.team)
        
        return cell
    }
    
//MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier(SEGUE_TO_DETAIL, sender: self)
    }
    
    
}
