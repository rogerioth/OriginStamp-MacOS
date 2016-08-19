//
//  DragAndDropView.swift
//  OriginStamp-Mac
//
//  Created by Rogerio Hirooka on 8/11/16.
//  Copyright © 2016 Rogerio Hirooka. All rights reserved.
//

import Foundation
import AppKit

class DragAndDropView: NSImageView  {
    
    var filePath : String = ""
    var highlight : Bool = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType, NSPasteboardTypeTIFF])
    }
    
    var fileTypeIsOk = false
    var droppedFilePath: String?
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) {
            fileTypeIsOk = true
            highlight = true
            self.setNeedsDisplay()
            return .Copy
        } else {
            fileTypeIsOk = false
            return []
        }
    }
    
    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
        if fileTypeIsOk {
            return .Copy
        } else {
            return []
        }
    }
    
    override func draggingExited(sender: NSDraggingInfo?) {
        highlight = false
        self.setNeedsDisplay()
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if highlight {
            NSColor.grayColor().set()
            NSBezierPath.setDefaultLineWidth(6)
            NSBezierPath.strokeRect(dirtyRect)
        }
    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        highlight = false
        self.setNeedsDisplay()
        return true
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        if let board = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
            imagePath = board[0] as? String {

            droppedFilePath = imagePath
            
            if droppedFilePath != nil && droppedFilePath != "" {
                self.filePath = droppedFilePath!
            }
            return true
        }
        return false
    }
    
    override func concludeDragOperation(sender: NSDraggingInfo?) {
        NSNotificationCenter.defaultCenter().postNotificationName("DragNotification", object: self)
    }
    
    func checkExtension(drag: NSDraggingInfo) -> Bool {
        if let board = drag.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
            path = board[0] as? String {
            let url = NSURL(fileURLWithPath: path)
            AppDelegate.log.info("Received Drop operation with FilePath: \(url)")
            return true
        }
        return false
    }
}
