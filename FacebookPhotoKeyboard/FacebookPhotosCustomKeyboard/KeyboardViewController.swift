//
//  KeyboardViewController.swift
//  FacebookPhotosCustomKeyboard
//
//  Created by Soluto on 8/6/15.
//  Copyright (c) 2015 Rababa. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import PINRemoteImage
import SwiftyJSON

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton.buttonWithType(.System) as! UIButton
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
        
        let userDefaults = NSUserDefaults(suiteName: "group.com.rababa.FacebookPhotoKeyboard")
        if let token = userDefaults?.valueForKey("access_token") as? Dictionary<String, AnyObject> {
            let fbToken = FBSDKAccessToken(tokenString: token["tokenString"] as? String, permissions: token["permissions"] as? Array, declinedPermissions: token["declindePermissions"] as? Array, appID: token["appID"] as? String, userID: token["userID"] as? String, expirationDate: token["expirationDate"] as? NSDate, refreshDate: token["refreshDate"] as? NSDate)
            FBSDKAccessToken.setCurrentAccessToken(fbToken)
            let graphRequest = "/\(fbToken.userID)/photos?redirect=false&fields=link,images"
            FBSDKGraphRequest(graphPath: graphRequest, parameters: nil, HTTPMethod:"GET").startWithCompletionHandler({ (connection, result, error) -> Void in
                let jsonResult = JSON(result)
                if let imageUrlString = jsonResult["data"][0]["images"][0]["source"].string {
                    var imageView = UIImageView()
                    self.view.addSubview(imageView)
                    imageView.pin_setImageFromURL(NSURL(string: imageUrlString))
                }
            })
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        var proxy = self.textDocumentProxy as! UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }
    
}
