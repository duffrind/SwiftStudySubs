//
//  ViewController.swift
//  StudySubs
//
//  Created by David Duffrin on 10/20/16.
//  Copyright © 2016 David Duffrin. All rights reserved.
//

import Cocoa
//import ProcessFile.swift

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func srs(_ sender: NSButton) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a subtitles file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = false;
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                
                let file = processFile(file:path)
                file.startProcess()

            }
        } else {
            // User clicked on "Cancel"
            return
        }

    }
    
    @IBAction func quit(_ sender: NSButton) {
        exit(0)
    }
}

