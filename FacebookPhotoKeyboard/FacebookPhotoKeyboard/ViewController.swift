//
//  ViewController.swift
//  FacebookPhotoKeyboard
//
//  Created by Jonathan Rauch on 8/6/15.
//  Copyright (c) 2015 Rababa. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.delegate = self
        loginButton.readPermissions = ["user_photos"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        let token = FBSDKAccessToken.currentAccessToken()
        let graphRequest = "/\(token.userID)/photos?redirect=false&fields=link,images"
        FBSDKGraphRequest(graphPath: graphRequest, parameters: nil, HTTPMethod:"GET").startWithCompletionHandler({ (connection, result, error) -> Void in
            let userDefaults = NSUserDefaults(suiteName: "group.com.rababa.FacebookPhotoKeyboard")
            userDefaults?.setObject(result, forKey: "user_photos")
            userDefaults?.synchronize()
        })
//        let userDefaults = NSUserDefaults(suiteName: "group.com.rababa.FacebookPhotoKeyboard")
//        
//        let tokenDictionary = [
//            "appID":token.appID,
//            "userID":token.userID,
//            "tokenString":token.tokenString,
//            "permissions":Array(token.permissions),
//            "declinedPermissions":Array(token.declinedPermissions),
//            "expirationDate":token.expirationDate,
//            "refreshDate":token.refreshDate]
//        userDefaults?.setObject(tokenDictionary, forKey: "access_token")
//        userDefaults?.synchronize()
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        
    }
}

