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

class KeyboardViewController: UIInputViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    var photos : JSON!
    var collectionView : UICollectionView!
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
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumLineSpacing = 10000.0
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.collectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell_identifier")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.view.addSubview(self.collectionView)
        
        let userDefaults = NSUserDefaults(suiteName: "group.com.rababa.FacebookPhotoKeyboard")
        
        if let rawPhotosData = userDefaults?.valueForKey("user_photos") {
            self.photos = JSON(rawPhotosData)["data"]
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.frame = self.view.bounds
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : ImageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell_identifier", forIndexPath: indexPath) as! ImageCollectionViewCell

        let currentImages = photos[indexPath.row]["images"]
        let imageIndex = getBestFittingPhoto(currentImages)
//        cell.backgroundColor = UIColor.redColor()
        
        cell.configureForDisplay(NSURL(string: currentImages[imageIndex]["source"].string!))
        return cell
    }
    
    func getBestFittingPhoto(images : JSON) -> Int {
        var minimumHeightDiff = Float(Int.max)
        var indexOfMinimum = 0
        for (index,element) in enumerate(images.array!) {
            var currentHeightDiff = abs(Float(self.view.bounds.height) - element["height"].float!)
            if currentHeightDiff < minimumHeightDiff {
                minimumHeightDiff = currentHeightDiff
                indexOfMinimum = index
            }
        }
        return indexOfMinimum
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        var images = photos[indexPath.row]["images"]
        let width = CGFloat(images[getBestFittingPhoto(images)]["width"].float!)
        let height = self.view.bounds.height - 10
        return CGSizeMake(width, height)
    }
    
}



class ImageCollectionViewCell : UICollectionViewCell {
    var imageView : UIImageView!
    var cacheImageView : UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = UIImageView(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func configureForDisplay(url : NSURL!) {
        let imageView = UIImageView()
        imageView.pin_setImageFromURL(url, completion: { (result) -> Void in
            self.imageView.image = result.image
            self.contentView.addSubview(self.imageView)
            self.imageView.frame = self.contentView.bounds
            self.contentView.setNeedsLayout()
        })
        self.cacheImageView = imageView
    }
    
    override func prepareForReuse() {
        self.cacheImageView = nil
        for subview in Array(self.contentView.subviews) {
            subview.removeFromSuperview()
        }
    }
}
