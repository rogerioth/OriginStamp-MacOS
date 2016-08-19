//
//  APIViewController.swift
//  OriginStamp-Mac
//
//  Created by Rogerio Hirooka on 8/17/16.
//  Copyright © 2016 Rogerio Hirooka. All rights reserved.
//

import Cocoa
import Foundation


class APIViewController : NSViewController {

    @IBOutlet weak var buttonAPIKey: NSButton!
    
    @IBOutlet weak var txtAPIKey: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textColor = NSColor.blueColor()
        let colorTitle = NSMutableAttributedString(attributedString: buttonAPIKey.attributedTitle)
        let titleRange = NSMakeRange(0, colorTitle.length)
        
        colorTitle.addAttribute(NSForegroundColorAttributeName, value: textColor, range: titleRange)
        buttonAPIKey.attributedTitle = colorTitle
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let apiKey = defaults.stringForKey("APIKey") {
            txtAPIKey.stringValue = apiKey
        } else {
            txtAPIKey.stringValue = Constants.DefaultAPIKey
        }

    }

    @IBAction func tapAPIKey(sender: AnyObject) {
        if let checkURL = NSURL(string: "https://www.originstamp.org/developer") {
            if NSWorkspace.sharedWorkspace().openURL(checkURL) {
                AppDelegate.log.info("Openning external URL at \(checkURL)...")
            }
        } else {
        }

    }
    
    override func viewWillDisappear() {
        // saves the API Key to storage
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(txtAPIKey.stringValue, forKey: "APIKey")

        AppDelegate.log.info("Updating APIKey to: \(txtAPIKey.stringValue)")
    }
    
    
}