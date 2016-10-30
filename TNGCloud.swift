//
//  TNGCloud.swift
//  Jump Master
//
//  Created by David Xiao & Jian Ren Zhou on 9/9/15.
//  Copyright (c) 2015 Tiny Nova Games. All rights reserved.
//

import Foundation
import SpriteKit

class TNGCloud: SKSpriteNode {
    
    var cloudNum: UInt32!
    var yPosition: CGFloat!
    var id: UInt32!
    
    init() {
        let imageNamed: String!
        cloudNum = arc4random_uniform(7)
        switch(cloudNum) {
        case 0:
            imageNamed = "cyan_cloud"
        case 1:
            imageNamed = "red_cloud"
        case 2:
            imageNamed = "green_cloud"
        case 3:
            imageNamed = "yellow_cloud"
        case 4:
            imageNamed = "purple_cloud"
        case 5:
            imageNamed = "blue_cloud"
        case 6:
            imageNamed = "orange_cloud"
        default:
            imageNamed = "this will never be executed lololol"
        }
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: UIColor.clearColor(), size: imageTexture.size())
        
        let body: SKPhysicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(imageTexture.size().width - 10, imageTexture.size().height - 20))
        body.dynamic = false
        //body.affectedByGravity = true
        //body.allowsRotation = false
        body.categoryBitMask = BodyType.cloud.rawValue
        
        self.physicsBody = body
    }
    
    func startMoving() {
        var timer: CGFloat!
        if currentScore < 10 {
            timer = 0.009
        }
        else if currentScore >= 10 && currentScore < 20 {
            timer = 0.008
        }
        else if currentScore >= 20 && currentScore < 30 {
            timer = 0.007
        }
        else if currentScore >= 30 && currentScore < 40 {
            timer = 0.006
        }
        else if currentScore >= 40 && currentScore < 50 {
            timer = 0.005
        }
        else if currentScore >= 50 && currentScore < 100 {
            timer = 0.004
        }
        else if currentScore >= 100 && currentScore < 200 {
            timer = 0.0035
        }
        else {
            timer = 0.003
        }
        
        var distanceToMoveHorizontal: CGFloat!
        var distanceToMoveVertical: CGFloat!
        var distanceToMoveDiagonal: CGFloat!
        
        var moveCloud = SKAction()
        var moveLeft = SKAction()
        var moveUp = SKAction()
        var moveDown = SKAction()
        var moveRight = SKAction()
        var moveDiagonalUp = SKAction()
        var moveDiagonalDown = SKAction()
        
        switch(self.cloudNum) {
        case 0: // cyan cloud
            distanceToMoveHorizontal = CGFloat(UIScreen.mainScreen().bounds.width + self.size.width * 2)
            
            moveCloud = SKAction.moveByX(-distanceToMoveHorizontal, y: 0.0, duration: NSTimeInterval(timer * distanceToMoveHorizontal))
        case 1: // red cloud
            distanceToMoveHorizontal = CGFloat((UIScreen.mainScreen().bounds.width / 2) + (self.size.width / 2))
            distanceToMoveVertical = 120.0
            
            moveLeft = SKAction.moveByX(-distanceToMoveHorizontal, y: 0.0, duration: NSTimeInterval(timer * distanceToMoveHorizontal))
            moveUp = SKAction.moveBy(CGVectorMake(0.0, distanceToMoveVertical), duration: NSTimeInterval(0.0085 * distanceToMoveVertical))
            moveCloud = SKAction.sequence([moveLeft, moveUp, moveLeft])
        case 2: // green cloud
            distanceToMoveHorizontal = CGFloat((UIScreen.mainScreen().bounds.width / 2) + (self.size.width / 2))
            distanceToMoveVertical = 120.0
            
            moveLeft = SKAction.moveByX(-distanceToMoveHorizontal, y: 0.0, duration: NSTimeInterval(timer * distanceToMoveHorizontal))
            moveDown = SKAction.moveBy(CGVectorMake(0.0, -distanceToMoveVertical), duration: NSTimeInterval(timer * distanceToMoveVertical))
            moveCloud = SKAction.sequence([moveLeft, moveDown, moveLeft])
        case 3: // yellow cloud
            distanceToMoveHorizontal = CGFloat(UIScreen.mainScreen().bounds.width - self.size.width)
            distanceToMoveVertical = 120.0
            let distanceToMoveRight: CGFloat = distanceToMoveHorizontal - (2 * self.size.width)
            
            moveLeft = SKAction.moveByX(-distanceToMoveHorizontal, y: 0.0, duration: NSTimeInterval(timer * distanceToMoveHorizontal))
            moveUp = SKAction.moveBy(CGVectorMake(0.0, distanceToMoveVertical), duration: NSTimeInterval(0.0085 * distanceToMoveVertical))
            moveRight = SKAction.moveByX(distanceToMoveRight, y: 0.0, duration: NSTimeInterval(timer * (distanceToMoveRight)))
            moveDown = SKAction.moveBy(CGVectorMake(0.0, -distanceToMoveVertical), duration: NSTimeInterval(timer * distanceToMoveVertical))
            moveCloud = SKAction.sequence([moveLeft, moveUp, moveRight, moveDown, moveLeft])
        case 4: // purple cloud
            distanceToMoveHorizontal = CGFloat((UIScreen.mainScreen().bounds.width / 4) + (self.size.width))
            distanceToMoveVertical = 120.0
            
            moveLeft = SKAction.moveByX(-distanceToMoveHorizontal, y: 0.0, duration: NSTimeInterval(timer * distanceToMoveHorizontal))
            moveUp = SKAction.moveBy(CGVectorMake(0.0, distanceToMoveVertical), duration: NSTimeInterval(0.0085 * distanceToMoveVertical))
            moveDown = SKAction.moveBy(CGVectorMake(0.0, -distanceToMoveVertical), duration: NSTimeInterval(timer * distanceToMoveVertical))
            
            moveCloud = SKAction.sequence([moveLeft, moveUp, moveLeft, moveDown, moveLeft])
            //moveCloud = SKAction.repeatAction(moveCloudCycle, count: 2)
        case 5: // blue cloud
            distanceToMoveHorizontal = CGFloat((UIScreen.mainScreen().bounds.width / 2) + (self.size.width / 2))
            distanceToMoveVertical = 120.0
            distanceToMoveDiagonal = sqrt(pow(distanceToMoveHorizontal, 2) + pow(distanceToMoveVertical, 2))
            
            moveDiagonalUp = SKAction.moveBy(CGVectorMake(-distanceToMoveHorizontal, distanceToMoveVertical), duration: NSTimeInterval(timer * distanceToMoveDiagonal))
            moveDiagonalDown = SKAction.moveBy(CGVectorMake(-distanceToMoveHorizontal, -distanceToMoveVertical), duration: NSTimeInterval(timer * distanceToMoveDiagonal))
            
            moveCloud = SKAction.sequence([moveDiagonalUp, moveDiagonalDown])
        case 6: // orange cloud
            distanceToMoveHorizontal = CGFloat((UIScreen.mainScreen().bounds.width / 2) + (self.size.width / 2))
            distanceToMoveVertical = 120.0
            distanceToMoveDiagonal = sqrt(pow(distanceToMoveHorizontal, 2) + pow(distanceToMoveVertical, 2))
            
            moveDiagonalUp = SKAction.moveBy(CGVectorMake(-distanceToMoveHorizontal, distanceToMoveVertical), duration: NSTimeInterval(timer * distanceToMoveDiagonal))
            moveDiagonalDown = SKAction.moveBy(CGVectorMake(-distanceToMoveHorizontal, -distanceToMoveVertical), duration: NSTimeInterval(timer * distanceToMoveDiagonal))
            
            moveCloud = SKAction.sequence([moveDiagonalDown, moveDiagonalUp])
        default:
            distanceToMoveHorizontal = CGFloat(UIScreen.mainScreen().bounds.width + self.size.width * 2)
            moveCloud = SKAction.moveByX(-distanceToMoveHorizontal, y: 0.0, duration: NSTimeInterval(timer * distanceToMoveHorizontal))
            
        }
        
        let removeClouds = SKAction.removeFromParent()
        let removeFromArray = SKAction.runBlock({() in self.removeFromArray()})
        let addPoint = SKAction.runBlock({() in self.addPoint()})
        
        let cloudsMoveAndRemove = SKAction.sequence([moveCloud, addPoint, removeFromArray, removeClouds])
        
        self.runAction(cloudsMoveAndRemove)
    }
    
    func calculateRandomYPosition() {
        let maxHeight: UInt32 = UInt32(UIScreen.mainScreen().bounds.height - 100)
        var upperSpawnBound: UInt32 = maxHeight
        var lowerSpawnBound: UInt32 = 60
        var y: UInt32!
        
        switch(self.cloudNum) {
        case 0: // cyan cloud
            upperSpawnBound = maxHeight
        case 1: // red cloud
            upperSpawnBound = maxHeight - 120
        case 2: // green cloud
            lowerSpawnBound += 120
        case 3: // yellow cloud
            upperSpawnBound = maxHeight - 120
        case 4: // purple cloud
            upperSpawnBound = maxHeight - 120
        case 5: // blue cloud
            upperSpawnBound = maxHeight - 120
        case 6: // orange cloud
            lowerSpawnBound += 120
        default:
            return
        }
        
        y = arc4random_uniform(upperSpawnBound - lowerSpawnBound) + lowerSpawnBound
        self.yPosition = CGFloat(y)
    }
    
    func fade() {
        let fade = SKAction.fadeOutWithDuration(3)
        let remove = SKAction.removeFromParent()
        
        self.runAction(SKAction.sequence([fade, remove]))
    }
    
    func removeFromArray() {
        for i in 0 ..< activeClouds.count {
            if activeClouds[i].id == self.id {
                activeClouds.removeAtIndex(i)
            }
        }
    }
    
    func addPoint() {
        currentScore += 1
        currentScoreLabel.text = "\(currentScore)"
    }
    
    func stopMoving() {
        self.removeAllActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}