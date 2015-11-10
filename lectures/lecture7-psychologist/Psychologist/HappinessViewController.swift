//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Ryan Huebert on 11/6/15.
//  Copyright © 2015 Ryan Huebert. All rights reserved.
//

import UIKit

var globalHappinessInstanceCount = 0

class HappinessViewController: UIViewController, FaceViewDataSource { // // Protocol dataSource step 4
    
    var instanceCount = { globalHappinessInstanceCount++ }()
    
    var happiness: Int = 75 { // 0 = ver sad, 100 = ecstatic
        didSet {
            happiness = min(max(happiness, 0), 100) // Validation
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    
    private struct Constants {
        static let happinessGestureScaleFactor: CGFloat = 4
    }
    
    @IBAction func changeHappiness(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(faceView)
            let happinessChange = Int(translation.y / Constants.happinessGestureScaleFactor)
            if happinessChange != 0 {
                happiness += happinessChange
                sender.setTranslation(CGPoint.zero, inView: faceView)
            }
        default: break
        }
    }
    
    // Protocol dataSource step 6
    @IBOutlet weak var faceView: FaceView! {
        // Protocol dataSource step 7 Called when program loads
        didSet {
            print("didSet var faceView")
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
            // faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "changeHappiness"))
            // Valid, alternately setup in story board.
        }
    }
    
    private func updateUI() {
        faceView?.setNeedsDisplay() // Use optional chaining to prevent crashing when calling updateUI using property observers didSet
        title = "\(happiness)"
        
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? { // Protocol dataSource step 5
        return Double(happiness - 50)/50 // Interpret the model for the view
    }
    
    func logVCL(msg: String) {
        print(logVCLprefix + "Happiness \(instanceCount) " + msg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logVCL("init(coder)")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        logVCL("init(nibName, bundle)")
    }
    
    deinit {
        logVCL("deinit")
    }
    
    override func awakeFromNib() {
        logVCL("awakeFromNib()")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logVCL("viewDidLoad()")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logVCL("viewWillAppear(animated = \(animated))")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        logVCL("viewDidAppear(animated = \(animated))")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        logVCL("viewWillDisappear(animated = \(animated))")
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        logVCL("viewDidDisappear(animated = \(animated))")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logVCL("viewWillLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logVCL("viewDidLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        logVCL("viewWillTransitionToSize")
        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.logVCL("animatingAlongsideTransition")
            }, completion: { context -> Void in
                self.logVCL("doneAnimatingAlongsideTransition")
        })
    }
}

