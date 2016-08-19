//
//  ViewController.swift
//  OriginStamp-Mac
//
//  Created by Rogerio Hirooka on 8/11/16.
//  Copyright © 2016 Rogerio Hirooka. All rights reserved.
//

import Cocoa
import AFNetworking
import AppSandboxFileAccess

class ViewController: NSViewController {

    @IBOutlet weak var textFieldFilePath: NSTextField!
    @IBOutlet weak var textFieldHash: NSTextField!
    @IBOutlet weak var textFieldFileSize: NSTextField!
    
    
    @IBOutlet weak var buttonCalculateHash: NSButton!
    
    @IBOutlet weak var buttonCreateStamp: NSButton!
    @IBOutlet weak var buttonVerifyStamp: NSButton!
    
    var filePath = ""
    var hashToBeSent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonCalculateHash.enabled = false

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(dragNotificationHandler),
                                                         name: "DragNotification",
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(menuPreferences),
                                                         name: "MenuPreferences",
                                                         object: nil)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func menuPreferences(notification: NSNotification) {
        self.performSegueWithIdentifier("segueSettings", sender: nil)
    }
    
    
    @IBAction func tapCalculateHash(sender: AnyObject) {
        self.textFieldFilePath.stringValue = "Processing File Hash..."
        AppDelegate.log.info("Processing SHA256 of contents at \(self.filePath)...")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //let data = NSFileManager.defaultManager().contentsAtPath(self.filePath)
            //let stringHash = SHA256.sha256AsString(data!)
            
            let fileAccess = AppSandboxFileAccess()
            // persist permission to access the file the user introduced to the app, so we can always
            // access it and then the AppSandboxFileAccess class won't prompt for it if you wrap access to it
            
            fileAccess.persistPermissionPath(self.filePath)
            // get the parent directory for the file
            let parentDirectory = (self.filePath as NSString).stringByDeletingLastPathComponent
            // get access to the parent directory
            
            var stringHash = ""
            var initialDate = NSDate()

            let accessAllowed = fileAccess.accessFilePath(parentDirectory, persistPermission: true, withBlock: {
                initialDate = NSDate()
                stringHash = LargeFileHasher.sha256HashOfFileAtPath(self.filePath)
            })

            if (!accessAllowed) {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = NSAlert()
                    alert.messageText = "Access denied to path: \(self.filePath)"
                    alert.runModal()
                })
                return
            }
            
            if stringHash == "" {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = NSAlert()
                    alert.messageText = "Could not calculate Hash for file: \(self.filePath)"
                    alert.runModal()
                })
                return
            }

            let size = FileSystem.fileSizeForPath(self.filePath)
            
            let readableLength = DataLength.bytesToMultipleString(Float(size), targetUnit: DataLength.DL_AUTO, numberOfDecimals: 2)
            let bytesLength = DataLength.bytesToMultipleString(Float(size), targetUnit: DataLength.DL_BYTES, numberOfDecimals: 0)
            
            dispatch_async(dispatch_get_main_queue(), {
                let finalDate = NSDate()
                let timeTaken = DateUtils.offsetFrom(initialDate, toDate: finalDate)
                let elapsed = initialDate.timeIntervalSinceNow
                let speed = abs(Double(size) / elapsed)
                let readableSpeed = DataLength.bytesToMultipleString(Float(speed), targetUnit: DataLength.DL_AUTO, numberOfDecimals: 2)
                self.hashToBeSent = stringHash
                
                AppDelegate.log.info("Done. Hash: \(stringHash)")
                AppDelegate.log.info("Filesize was: \(bytesLength) bytes. Processing took \(timeTaken).")
                
                self.textFieldFileSize.stringValue = "File Size  : \(readableLength) - (\(bytesLength)) @\(readableSpeed)/s"
                self.textFieldHash.stringValue = "File SHA256: \(stringHash)"
                self.textFieldFilePath.stringValue = "Hash calculation completed. Calculation Took: \(timeTaken)"
                
                self.buttonCreateStamp.enabled = true
                self.buttonVerifyStamp.enabled = true
            })
        })
    }
    
    @IBAction func tapCheckStamp(sender: AnyObject) {
        //http://www.originstamp.org/s/22f73e114d35a84751e16e8fb7c1c997b63052c1633c560eaaee46680c4ef06a
        let url = "http://www.originstamp.org/s/\(self.hashToBeSent)"
        if let checkURL = NSURL(string: url) {
            if NSWorkspace.sharedWorkspace().openURL(checkURL) {
                AppDelegate.log.info("Openning external URL at \(checkURL)...")
            }
        } else {
        }
    }

    @IBAction func tapCreateStamp(sender: AnyObject) {
        
        /*
         POST http://www.originstamp.org/api/stamps
         Authorization: Token token="{YOUR_API_KEY}"
         Content-Type: application/json
         {
         "hash_sha256" : "6b4a1673b225e8bf5f093b91be8c864427df32ca41b17cc0b82112b8f0185e41"
         }
         */
        
        let body = NSMutableDictionary()
        
        body.setValue(self.hashToBeSent, forKey: "hash_sha256")
        
        let manager = AFHTTPSessionManager()
        let serializer = AFJSONRequestSerializer()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var apiKey = defaults.stringForKey("APIKey")
        
        if apiKey == nil || apiKey == "" {
            apiKey = Constants.DefaultAPIKey
        }
        
        let authValue = String.init(format: "Token token=\"%@\"", apiKey!)
        
        serializer.setValue(authValue,          forHTTPHeaderField: "Authorization")
        serializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        serializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = serializer
        
        AppDelegate.log.info("Starting POST operation for http://www.originstamp.org/api/stamps with APIKey: \(apiKey)...")
        
        manager.POST("http://www.originstamp.org/api/stamps",
                     parameters: body,
                     progress: nil,
                     success:
        { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
            let resp = responseObject!
            AppDelegate.log.info("Server response: \(resp)")
            
            var errorShown = false

            if let errors = resp["errors"] {
                if let errorObject = errors {
                    if let errHash = errorObject["hash_sha256"] {
                        if let errHashObject = errHash {
                            if errHashObject.count > 0 {
                                let internalError = errHashObject.objectAtIndex(0)
                                print("\(internalError)")
                                let alert = NSAlert()
                                alert.messageText = "Error: Hash \(internalError)"
                                alert.runModal()
                                errorShown = true
                            }
                        }
                    }
                }
            }
            
            if !errorShown {
                let alert = NSAlert()
                alert.messageText = "Success: Hash was sent to the server and will soon be processed. Click \"3. Check OriginStamp\" to check the status on the Blockchain."
                alert.runModal()
            }
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            
            AppDelegate.log.info("Error: \(error)")
            
            if error.description.containsString("unauthorized (401)") {
                let alert = NSAlert()
                alert.messageText = "Error: Unauthorized - Please, check the APIKey on the Preferences Panel. Create a new one if necessary."
                alert.runModal()
            }

        }
    }

    
    func dragNotificationHandler(notification: NSNotification) {
        let customNotification = notification
        if ((customNotification.object?.isKindOfClass(DragAndDropView)) != nil) {
            let d = customNotification.object as! DragAndDropView
            textFieldFilePath.stringValue = d.filePath
            self.filePath = d.filePath
            
            self.buttonCalculateHash.enabled = true
            self.buttonCreateStamp.enabled = false
            self.buttonVerifyStamp.enabled = false
            
            self.textFieldFileSize.stringValue = "File Size  :"
            self.textFieldHash.stringValue = "File SHA256:"
        }
        
    }
}

