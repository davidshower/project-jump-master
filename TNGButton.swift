//
//  TNGButton.swift
//  Jump Master
//
//  Created by David Xiao & Jian Ren Zhou on 9/9/15.
//  Copyright (c) 2015 Tiny Nova Games. All rights reserved.
//

import Foundation
import SpriteKit

let playClickSound = SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false)

class TNGButton : SKNode {
    var defaultButton: SKSpriteNode
    var activeButton: SKSpriteNode
    var action: () -> Void
    var anchorPoint: CGPoint = CGPointMake(0.5, 0.5)
    
    init(defaultButtonImage: String, activeButtonImage: String, buttonAction: () -> Void, anchorPoint: CGPoint) {
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        defaultButton.anchorPoint = anchorPoint
        activeButton = SKSpriteNode(imageNamed: activeButtonImage)
        activeButton.anchorPoint = anchorPoint
        activeButton.hidden = true
        action = buttonAction
        
        super.init()
        
        userInteractionEnabled = true
        addChild(defaultButton)
        addChild(activeButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        activeButton.hidden = false
        defaultButton.hidden = true
        
        let soundSetting = getDataFromPlist("soundSetting") as! Int
        if soundSetting == 1 {
            runAction(playClickSound)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.locationInNode(self)
        
        if defaultButton.containsPoint(location) {
            activeButton.hidden = false
            defaultButton.hidden = true
        }
        else {
            activeButton.hidden = true
            defaultButton.hidden = false
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.locationInNode(self)
        
        if defaultButton.containsPoint(location) {
            action()
        }
        
        activeButton.hidden = true
        defaultButton.hidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}