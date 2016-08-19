//
//  AppDelegate.swift
//  OriginStamp-Mac
//
//  Created by Rogerio Hirooka on 8/11/16.
//  Copyright © 2016 Rogerio Hirooka. All rights reserved.
//

import Cocoa
import XCGLogger

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static var log = XCGLogger()
    static let identifier = "Lirum-Labs.OriginStamp-Mac"
    static var logFile = ""

    @IBAction func tapPreferences(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("MenuPreferences", object: nil)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        // Create a logger object with no destinations
        let log = XCGLogger(identifier: "OriginStamp", includeDefaultDestinations: false)
        
        // Create a destination for the system console log (via NSLog)
        let systemLogDestination = XCGNSLogDestination(owner: log, identifier: AppDelegate.identifier)
        
        // Optionally set some configuration options
        systemLogDestination.outputLogLevel = .Debug
        systemLogDestination.showLogIdentifier = false
        systemLogDestination.showFunctionName = true
        systemLogDestination.showThreadName = true
        systemLogDestination.showLogLevel = true
        systemLogDestination.showFileName = true
        systemLogDestination.showLineNumber = true
        systemLogDestination.showDate = true
        
        // Add the destination to the logger
        log.addLogDestination(systemLogDestination)
        
        // get daily string
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dailyString = (dateFormatter.stringFromDate(NSDate()) as NSString).stringByAppendingString(".log")
        
        // get home directory
        let homeDirectory = NSHomeDirectory() as NSString
        var dataPath = (homeDirectory.stringByAppendingPathComponent(AppDelegate.identifier) as NSString)
        dataPath = dataPath.stringByAppendingPathComponent("Logs")
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath as String)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(dataPath as String, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("\(error.localizedDescription)")
            }
        }
        
        let logPath = dataPath.stringByAppendingPathComponent(dailyString)
        print("Log files will be stored @ \(logPath)")
        AppDelegate.logFile = logPath
        
        //<home folder>/Library/Logs
        // Create a file log destination
        let fileLogDestination = XCGFileLogDestination(owner: log, writeToFile: logPath, identifier: "\(AppDelegate.identifier).LogDestination")
        
        // Optionally set some configuration options
        fileLogDestination.outputLogLevel = .Debug
        fileLogDestination.showLogIdentifier = false
        fileLogDestination.showFunctionName = true
        fileLogDestination.showThreadName = true
        fileLogDestination.showLogLevel = true
        fileLogDestination.showFileName = true
        fileLogDestination.showLineNumber = true
        fileLogDestination.showDate = true
        
        // Process this destination in the background
        fileLogDestination.logQueue = XCGLogger.logQueue
        
        // Add the destination to the logger
        log.addLogDestination(fileLogDestination)
        
        // Add basic app info, version info etc, to the start of the logs
        log.logAppDetails()
        
        AppDelegate.log = log
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

