//
//  GameViewController.swift
//  Jump Master
//
//  Created by David Xiao & Jian Ren Zhou on 9/9/15.
//  Copyright (c) 2015 Tiny Nova Games. All rights reserved.
//

import UIKit
import SpriteKit
import iAd

class GameViewController: UIViewController, ADBannerViewDelegate {
    
    var scene: GameScene!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGameData()
        loadAds()
        let skView = view as! SKView
        skView.multipleTouchEnabled = true
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        
        skView.presentScene(scene)
    }
    
    func loadAds() {
        self.appDelegate.adBannerView.removeFromSuperview()
        self.appDelegate.adBannerView.delegate = nil
        self.appDelegate.adBannerView = ADBannerView(frame: CGRect.zero)
        self.appDelegate.adBannerView.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height - self.appDelegate.adBannerView.frame.size.height / 2)
        self.appDelegate.adBannerView.delegate = self
        self.appDelegate.adBannerView.hidden = true
        originalContentView.addSubview(self.appDelegate.adBannerView)
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.appDelegate.adBannerView.hidden = false
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        ghost.removeAllActions()
        let skView = self.view as! SKView!
        skView.paused = true
        
        return true
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        let skView = self.view as! SKView!
        skView.paused = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.appDelegate.adBannerView.hidden = true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
