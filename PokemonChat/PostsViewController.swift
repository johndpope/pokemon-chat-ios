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

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var displayButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    lazy var posts = [User]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 88
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.top = 10
        // Do any additional setup after loading the view.
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

        if self.tableView.hidden {
            self.tableView.hidden = false
        }
        
        UIView.animateWithDuration(0.23, animations: {
            self.tableView.alpha = CGFloat(sender.tag)
        }) { (done) in
            self.tableView.hidden = tableViewVisible
        }
        
        sender.tag = tableViewVisible ? 1 : 0
    }
    
    @IBAction func teamSliderSwitched(sender: UISwitch)
    {
        self.title = sender.on ? TITLE_TEAM_ONLY : TITLE_NEARBY
    }
    
//MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER_POST) as! PostTableViewCell
        cell.contentLabel.text = "PokemonGO woo hooooooooooo"
        return cell
    }
    
//MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //
    }
    
    
}
