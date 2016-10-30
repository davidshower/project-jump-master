//
//  TNGGhost.swift
//  Jump Master
//
//  Created by David Xiao & Jian Ren Zhou on 9/9/15.
//  Copyright (c) 2015 Tiny Nova Games. All rights reserved.
//

import Foundation
import SpriteKit

class TNGGhost: SKSpriteNode {
    
    init(imageNamed: String) {
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: UIColor.clearColor(), size: imageTexture.size())
        
        let body: SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().width / 2, center: CGPointMake(0, (imageTexture.size().width / 2) - (imageTexture.size().height / 2)))
        body.dynamic = false
        body.affectedByGravity = true
        body.allowsRotation = false
        body.usesPreciseCollisionDetection = true
        body.categoryBitMask = BodyType.ghost.rawValue
        body.collisionBitMask = 0
        body.contactTestBitMask = BodyType.cloud.rawValue
        
        body.restitution = 1.0
        
        self.physicsBody = body
    }
    
    func moveLeft() {
        let moveLeft = SKAction.moveByX(-2, y: 0, duration: 0.0075)
        runAction(SKAction.repeatActionForever(moveLeft))
    }
    
    func moveRight() {
        let moveRight = SKAction.moveByX(2, y: 0, duration: 0.0075)
        runAction(SKAction.repeatActionForever(moveRight))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}