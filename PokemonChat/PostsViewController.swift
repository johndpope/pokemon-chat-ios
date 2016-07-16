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
private let SEGUE_TO_MENU = "ListToMenu"


class PostsViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var displayButton: UIButton!
    
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var teamSwitch: UISwitch!
    @IBOutlet weak var menuButton: BouncingButton!
    
    lazy var localPosts = [Post]()
    lazy var teamPosts = [Post]()
    
    var currentPosts : [Post] {
        get {
            return self.teamSwitch.on ? self.teamPosts : self.localPosts
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.teamSwitch.setOn(false, animated: false)
        self.tableView.estimatedRowHeight = 88
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.top = 10
        self.tableView.contentInset.bottom =  96
        
        self.navigationController?.delegate = self
        // Do any additional setup after loading the view.
        
        Connector().getPostsForCurrentLocation { (localPosts, teamPosts, error) in
            if let localPosts = localPosts, teamPosts = teamPosts {
                self.localPosts = localPosts
                self.teamPosts = teamPosts
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == SEGUE_TO_DETAIL && sender is Post
        {
            let detailController = segue.destinationViewController as! PostDetailViewController
            detailController.post = sender as? Post
        }
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if toVC is MenuViewController || fromVC is MenuViewController
        {
            let animator = ListMenuAnimator()
            animator.isPushAnimation = (operation == .Push)
            return animator
        }
        else
        {
            return nil
        }
    }
    
    
//MARK: Actions

    @IBAction func menuButtonTapped(sender: UIButton)
    {
        //TODO: go to menu
        self.performSegueWithIdentifier(SEGUE_TO_MENU, sender: self)
    }
    
    @IBAction func displayButtonPressed(sender: UIButton)
    {
        // show the map, or unhide the list
        
        let tableViewVisible = (sender.tag == 0) // this is funny and stupid

        if self.self.tableView.hidden {
            self.tableView.hidden = false
            self.blurView.hidden = false
            self.menuButton.hidden = false
        }
        
        UIView.animateWithDuration(0.23, animations: {
            self.tableView.alpha = CGFloat(sender.tag)
            self.blurView.alpha = CGFloat(sender.tag)
            self.menuButton.alpha = CGFloat(sender.tag)
        }) { (done) in
            self.tableView.hidden = tableViewVisible
            self.blurView.hidden = tableViewVisible
            self.menuButton.hidden = tableViewVisible
        }
        
        sender.tag = tableViewVisible ? 1 : 0
    }
    
    @IBAction func teamSliderSwitched(sender: UISwitch)
    {
        User.currentUser().teamMode = sender.on ? .Team : .Local
        self.title = User.currentUser().teamMode == .Team ? TITLE_TEAM_ONLY : TITLE_NEARBY
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
        let count = self.currentPosts.count
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER_POST) as! PostTableViewCell
        
        let post = self.currentPosts[indexPath.row]
        
        cell.contentLabel.text = post.content
        cell.usernameLabel.text = post.username
        cell.usernameLabel.textColor = TeamColors.colorForTeam(post.team)
        
        return cell
    }
    
//MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let post = self.currentPosts[indexPath.row]
        self.performSegueWithIdentifier(SEGUE_TO_DETAIL, sender: post)
    }
    
    
}
