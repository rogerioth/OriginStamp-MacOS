//
//  LogViewController.swift
//  OriginStamp-Mac
//
//  Created by Rogerio Hirooka on 8/18/16.
//  Copyright © 2016 Rogerio Hirooka. All rights reserved.
//

import Foundation
import Cocoa

class LogViewController : NSViewController {
    
    @IBOutlet weak var lblLogFilePath: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblLogFilePath.stringValue = AppDelegate.logFile
    }
    
    @IBAction func tapShowLogFile(sender: AnyObject) {
        
        //let commandLine = String.init(format: "/Applications/Console.app %@", AppDelegate.logFile)
        let commandLine = AppDelegate.logFile
        NSWorkspace.sharedWorkspace().openURL(NSURL(fileURLWithPath: commandLine))

    }
    
}