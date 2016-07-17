//
//  ComposeViewController.swift
//  PokemonChat
//
//  Created by ----- --- on 7/16/16.
//  Copyright © 2016 PokemonGoTeamChat. All rights reserved.
//

import UIKit
import MapKit

private let TITLE_DEFAULT = "new post"
private let TITLE_MAP = "choose location"

protocol ComposeViewControllerDelegate
{
    func composeViewControllerCancelled(controller: ComposeViewController)
    func composeViewControllerWillSave(controller: ComposeViewController, post: Post)
    func composeViewControllerSubmitted(controller: ComposeViewController, post: Post, location: CLLocationCoordinate2D)
}

class ComposeViewController: UIViewController, MKMapViewDelegate
{
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottom: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: BouncingButton!
    @IBOutlet weak var coordinateLabel: UILabel!
    
    var location : CLLocationCoordinate2D? {
        didSet {
            if location != nil {
                self.coordinateLabel.text = String(format: "%5f, %5f", location!.latitude, location!.longitude)
            }
        }
    }
    
    var delegate : ComposeViewControllerDelegate?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupMap()
        
        self.textView.tintColor = User.currentUser().currentColor()
        self.textView.text = nil
        self.textView.contentInset.bottom = 8
        self.listenForKeyboardNotifications(true)
        self.textView.becomeFirstResponder()
    }
    
    deinit
    {
        self.listenForKeyboardNotifications(false)
    }
    
    override func keyboardMoved(notification: NSNotification)
    {
        UIView.animateWithKeyboardNotification(notification) { (keyboardHeight, keyboardWindowY) in
            self.textViewBottom.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
// MARK: Utilities

    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        self.textView.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sendButtonPressed(sender: UIButton)
    {
        if self.contentView.hidden // we're looking at the map
        {
            // return to the composer
            self.mapButtonPressed(self.mapButton)
        }
        else
        {
            if let text = self.textView.text, location = self.location where text.hasText()
            
            {
                sender.enabled = false
                let post = Post()
                post.content = text
                post.latitude = location.latitude
                post.longitude = location.longitude
                post.isPrivate = false
                
                // go refresh shit
                self.delegate?.composeViewControllerWillSave(self, post: post)
                
                post.save({ (post, error) in
                    if error != nil
                    {
                        // indicate error
                        sender.enabled = true
                    }
                    else // success
                    {
                        // add the post to the top
                        self.view.endEditing(true)
                        self.delegate?.composeViewControllerSubmitted(self, post: post, location: location)
                    }
                })
                
            }
        }
    }
    
    var leftNavigationButton : UIBarButtonItem?
    
    @IBAction func mapButtonPressed(sender: UIButton)
    {
        UIView.animateWithDuration(0.23, animations: { 
            let contentVisible = (sender.tag == 0) // this is funny and stupid
            
            if self.contentView.hidden
            {
                // show content
                self.contentView.hidden = false
                self.textView.becomeFirstResponder()
                self.title = TITLE_DEFAULT
                
                // show left button
                self.navigationItem.leftBarButtonItem = self.leftNavigationButton
            }
            else
            {
                // show map
                self.textView.resignFirstResponder()
                self.title = TITLE_MAP
                
                // hide left button
                self.leftNavigationButton = self.navigationItem.leftBarButtonItem
                self.navigationItem.leftBarButtonItem = nil
            }
            
            UIView.animateWithDuration(0.23, animations: {
                self.contentView.alpha = CGFloat(sender.tag)
            }) { (done) in
                self.contentView.hidden = contentVisible
            }
            
            sender.tag = contentVisible ? 1 : 0
            
        }) { (done) in
                //
        }
    }
    
//MARK: Utilities
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        self.location = mapView.centerCoordinate
    }
    
    func setupMap()
    {
        self.mapView.delegate = self
        
        if let coordinate = self.location {
            self.mapView.setCenterCoordinate(coordinate, animated: false)
            // set the zoom level
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
            self.mapView.region = self.mapView.regionThatFits(region)
        }
    }
}



