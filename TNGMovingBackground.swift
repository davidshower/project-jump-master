//
//  TNGMovingBackground.swift
//  Jump Master
//
//  Created by David Xiao & Jian Ren Zhou on 9/9/15.
//  Copyright (c) 2015 Tiny Nova Games. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class TNGMovingBackground: SKSpriteNode {
    init(image: SKSpriteNode) {
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(image.size.width, image.size.height))
        
        let background = image
        background.anchorPoint = CGPointMake(0, 0)
        background.position = CGPointMake(0, 0)
        addChild(background)
    }
    
    func startMovingSky() {
        let wait = SKAction.waitForDuration(NSTimeInterval(10.0))
        let moveDownSky = SKAction.moveBy(CGVectorMake(0, -(self.size.height - UIScreen.mainScreen().bounds.height)), duration: 120.0)
        let resetSky = SKAction.moveToY(0, duration: 0)
        let move = SKAction.sequence([wait, moveDownSky, resetSky])
        self.runAction(SKAction.repeatActionForever(move))
    }
    
    func moveSky() {
        let moveDownSky = SKAction.moveBy(CGVectorMake(0, -(self.size.height - UIScreen.mainScreen().bounds.height)), duration: 120)
        let resetSky = SKAction.moveToY(0, duration: 0)
        let move = SKAction.sequence([moveDownSky, resetSky])
        self.runAction(SKAction.repeatActionForever(move))
    }
    
    func startMovingScenery() {
        let moveLeftScenery = SKAction.moveByX(-(self.size.width - UIScreen.mainScreen().bounds.width), y: 0, duration: 90)
        let resetScenery = SKAction.moveToX(0, duration: 0)
        let move = SKAction.sequence([moveLeftScenery, resetScenery])
        self.runAction(SKAction.repeatActionForever(move))
    }
    
    func stop() {
        self.removeAllActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
