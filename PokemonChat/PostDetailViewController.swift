//
//  PostDetailViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/14/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit
import MapKit

private let CELL_IDENTIFIER_COMMENT = "CommentCell"

class PostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var headerUsernameLabel: UILabel!
    @IBOutlet weak var headerContentLabel: UILabel!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textContainer: UIView!
    @IBOutlet weak var textBoxBottom: NSLayoutConstraint!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var post : Post?
    var comments : [Comment]?
    
    
//MARK: UITableViewDataSource
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.updateReplies(self.comments?.count)
        self.setupTableView()
        self.textContainer.drawDropShadowWithOffset(-0.5)
        self.commentField.tintColor = TeamColors.colorForTeam(User.currentUser().team)
        self.sendButton.tintColor = User.currentUser().currentColor()
        self.listenForKeyboardNotifications(true)
        
        if let post = self.post {
            Connector().commentsForPost(post) { (comments, error) in
                self.comments = comments
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func sendButtonPressed(sender: UIButton)
    {
        self.sendButton.enabled = false
        self.commentField.enabled = true
        
        if let commentText = self.commentField.text where commentText.hasText() {
            
            self.view.endEditing(true)
            
            let comment = Comment()
            comment.postID = self.post?._id
            comment.content = commentText
            comment.save({ (comment, error) in
                if error != nil {
                    //TODO: error handling
                    self.sendButton.enabled = true
                    self.commentField.enabled = true
                    self.commentField.becomeFirstResponder()
                } else { // success
                    
                    self.commentField.text = nil
                    self.sendButton.enabled = true
                    self.commentField.enabled = true
                    
                    if self.comments == nil { self.comments = [] }
                    self.comments?.append(comment)
                    let index = NSIndexPath(forRow: self.comments!.count-1, inSection: 0)
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Bottom)
                    self.tableView.endUpdates()
                    self.tableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                    
                    self.updateReplies(self.comments?.count)
                }
            })
        }
    }
    
    deinit
    {
        self.listenForKeyboardNotifications(false)
    }
    
    override func keyboardMoved(notification: NSNotification)
    {
        UIView.animateWithKeyboardNotification(notification) { (keyboardHeight, keyboardWindowY) in
            self.textBoxBottom.constant = keyboardHeight
            self.textContainer.layoutIfNeeded()
            self.tableView.layoutIfNeeded()
            self.tableView.scrollToBottom(animated: false)
        }
    }
    
//MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count : Int
        if let comments = self.comments {
            count = comments.count
        } else {
            count = 0
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let comment = self.comments?[indexPath.row]
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER_COMMENT) as! CommentTableViewCell
        cell.usernameLabel.text = comment?.username
        cell.usernameLabel.textColor = comment?.user_team?.color()
        cell.contentLabel.text = comment?.content
        return cell
    }
    
    
//MARK: Utilities
    
    
    func updateReplies(replies:Int?)
    {
        let replyCount = replies != nil ? replies! : 0
        self.repliesLabel.text = "\(replyCount) replies"
    }
    
    func setupTableView()
    {
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        self.tableView.clipsToBounds = false
        
        self.headerContentLabel.text = self.post?.content
        self.headerUsernameLabel.text = self.post?.username
        self.headerUsernameLabel.textColor = TeamColors.colorForTeam(post?.team)
        
        let height = self.headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        self.headerView.frame.size.height = height
        self.tableView.layoutIfNeeded()
        self.tableView.contentInset.bottom = 20
        
        self.headerContentView.drawDropShadow()
        self.headerContentView.rasterizeShadow()
    }

}



