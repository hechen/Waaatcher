//
//  ViewController.swift
//  FSEventsDemo
//
//  Created by chen he on 2019/4/8.
//  Copyright © 2019 chen he. All rights reserved.
//

import Cocoa
import Waaatcher

class ViewController: NSViewController {
    
    @IBOutlet weak var pathTextField: NSTextField!
    
    @IBOutlet weak var revealButton: NSButton!
    
    @IBOutlet weak var eventsLogTextView: NSTextView!
    
    
    private var watcher: Waaatcher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func revealObsevePaths(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canCreateDirectories = false
        openPanel.begin { [weak self] r in
            if r == .OK, let path = openPanel.url?.path {
                self?.pathTextField.stringValue = path
                self?.reObserve()
            }
        }
    }
    
    
    
    private func reObserve() {
        let path = self.pathTextField.stringValue
        
        watcher = Waaatcher(paths: [path], latency: 1)
        watcher?.watcherEventCallback = { [weak self] in
            self?.output("Callback called!!")
            for event in $0 {
                self?.output("Event: \(event)")
            }
        }
        if let ret = watcher?.start(), ret {
            output("Create Wathcer Successfully.")
        }
    }
    
    
    private func output(_ output: String) {
        print(output)
        
        var previous = eventsLogTextView.string
        previous.append("\n\(output)")
        eventsLogTextView.string = previous
        
        eventsLogTextView.scrollToEndOfDocument(nil)
    }
}


