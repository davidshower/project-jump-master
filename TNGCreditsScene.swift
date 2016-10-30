//
//  TNGCreditsScene.swift
//  Jump Master
//
//  Created by David Xiao & Jian Ren Zhou on 9/9/15.
//  Copyright (c) 2015 Tiny Nova Games. All rights reserved.
//

import Foundation
import SpriteKit

class TNGCreditsScene: SKScene {
    
    var creditsLabel: SKLabelNode!
    var name1Label: SKLabelNode!
    var name2Label: SKLabelNode!
    var name3Label: SKLabelNode!
    var name4Label: SKLabelNode!
    var name5Label: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        
        creditsLabel = SKLabelNode(text: "CREDITS")
        creditsLabel.fontSize = 35
        creditsLabel.fontName = "Pusab"
        creditsLabel.position.x = self.frame.size.width / 2
        creditsLabel.position.y = self.frame.size.height * 0.85
        addChild(creditsLabel)
        
        name1Label = SKLabelNode(text: "David Xiao")
        name1Label.fontSize = 28
        name1Label.fontName = "Pusab"
        name1Label.position.x = self.frame.size.width / 2
        name1Label.position.y = self.frame.size.height * 0.7
        addChild(name1Label)
        
        name2Label = SKLabelNode(text: "Jian Ren Zhou")
        name2Label.fontSize = 28
        name2Label.fontName = "Pusab"
        name2Label.position.x = self.frame.size.width / 2
        name2Label.position.y = self.frame.size.height * 0.6
        addChild(name2Label)
        
        name3Label = SKLabelNode(text: "Sounds and Images By:")
        name3Label.fontSize = 25
        name3Label.fontName = "Pusab"
        name3Label.position.x = self.frame.size.width / 2
        name3Label.position.y = self.frame.size.height * 0.4
        addChild(name3Label)
        
        name4Label = SKLabelNode(text: "www.makeschool.com")
        name4Label.fontSize = 18
        name4Label.fontName = "Pusab"
        name4Label.position.x = self.frame.size.width / 2
        name4Label.position.y = self.frame.size.height * 0.3
        addChild(name4Label)
        
        name5Label = SKLabelNode(text: "www.flashkit.com")
        name5Label.fontSize = 18
        name5Label.fontName = "Pusab"
        name5Label.position.x = self.frame.size.width / 2
        name5Label.position.y = self.frame.size.height * 0.2
        addChild(name5Label)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let scene = GameScene(size: self.size)
        scene.scaleMode = scaleMode
        let reveal = SKTransition.doorsCloseVerticalWithDuration(0.3)
        self.view?.presentScene(scene, transition: reveal)
    }
}