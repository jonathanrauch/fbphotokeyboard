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
        
        //loginButton.readPermissions = ["photos"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        
    }
}

