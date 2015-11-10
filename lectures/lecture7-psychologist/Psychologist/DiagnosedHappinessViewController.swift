//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by Ryan Huebert on 11/9/15.
//  Copyright © 2015 Ryan Huebert. All rights reserved.
//

import UIKit

// HappinessViewController was subclassed to add prepare for segue functionality while leaving the HappinessViewController intact. Important especially if it was referenced from a location.

// Task: Update relavent storyboard view controller

class DiagnosedHappinessViewController: HappinessViewController, UIPopoverPresentationControllerDelegate {
    
    override var happiness: Int {
        
        // This original didSet is still called before this didSet
        didSet {
            diagnosticHistory += [happiness]
        }
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    var diagnosticHistory: [Int] {
        get { return defaults.objectForKey(Keys.Defaults) as? [Int] ?? []}
        set { defaults.setObject(newValue, forKey: Keys.Defaults) }
    }
    
    //var diagnosticHistory = [Int]() // Needs to store this somewhere else because it's overwritten everytime a segue is called.
    
    private struct Storyboard {
        static let SegueIdentifier = "Show Diagnostic History"
    }
    
    private struct Keys {
        static let Defaults = "DiagnosedHappinessViewController.History"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    // Resolving iphone popover size
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default: break
            }
        }
    }
    
    // Popover Delegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None // Do not adapt, put in little window.
    }
    
}
