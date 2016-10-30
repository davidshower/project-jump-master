//
//  GameScene.swift
//  Jump Master
//
//  Created by David Xiao & Jian Ren Zhou on 9/9/15.
//  Copyright (c) 2015 Tiny Nova Games. All rights reserved.
//

import SpriteKit
import iAd

enum BodyType: UInt32 {
    
    case ghost = 1
    case cloud = 2
    
}

class GameScene: SKScene, SKPhysicsContactDelegate, ADBannerViewDelegate {
    // used to detect the number of touches on the screen during gameplay
    // used in a way to detect multiple touches and moving the ghost appropriately
    var numberOfTouches = 0
    
    var isStarted = false
    var isGameOver = false
    var isLeft = false
    var isRight = false
    var leftSideActive = false
    var rightSideActive = false
    var isMoving = false
    
    var sky: TNGMovingBackground!
    var background: TNGMovingBackground!
    var startButton: TNGButton!
    var shopButton: TNGButton!
    var restartButton: TNGButton!
    var settingsButton: TNGButton!
    var creditsButton: TNGButton!
    //var ghost: TNGGhost!
    var cloud: TNGCloud!
    var startingCloud: TNGCloud!
    var gameOverLabel: SKLabelNode!
    var moveSky = SKAction()
    var moveBackground = SKAction()
    var highScore: Int!
    var highScoreLabel: SKLabelNode!
    var highScoreTextLabel: SKLabelNode!
    var newHighScoreLabel = SKLabelNode()
    var scaleFactor: CGFloat!
    var ghostID: UInt32 = 1
    var leftSide: SKSpriteNode!
    var rightSide: SKSpriteNode!
    var tutorialLabelLeft: SKLabelNode!
    var tutorialLabelRight: SKLabelNode!
    var tutorialLabelLeft2: SKLabelNode!
    var tutorialLabelRight2: SKLabelNode!
    var ghostVelocity = 275
    var arrow = SKSpriteNode()
    var overlay = SKSpriteNode()
    var pointInfoLabel = SKLabelNode()
    var pointInfoLabel2 = SKLabelNode()
    var pointInfoLabel3 = SKLabelNode()
    var pointInfoLabel4 = SKLabelNode()
    var popUpMenu = SKSpriteNode()
    var settingsLabel: SKLabelNode!
    var tutorialButton: TNGButton!
    var soundButton: TNGButton!
    var xButton: TNGButton!
    
    let playBounceSound = SKAction.playSoundFileNamed("bounce.mp3", waitForCompletion: false)
    let playClickSound = SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        let shopTutorialFinished = getDataFromPlist("shopTutorialFinished") as! Int
        
        loadBackground()
        loadGhost()
        loadCloud()
        loadStartandShopButton()
        loadCurrentScore()
        loadHighScore()
        if shopTutorialFinished == 0 {
            loadPointInfoLabel()
        }

        physicsWorld.gravity = CGVectorMake(0.0, -2.5)
        physicsWorld.contactDelegate = self
    }

    func generateClouds() {
        let spawn = SKAction.runBlock({() in self.spawnCloud()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        self.runAction(SKAction.repeatActionForever(spawnThenDelay))
    }
    
    func spawnCloud() {
        let cloud = TNGCloud()
        cloud.position.x = self.frame.size.width + (cloud.size.width / 2)
        cloud.calculateRandomYPosition()
        cloud.position.y = cloud.yPosition
        cloud.id = ghostID
        ghostID += 1
        
        activeClouds.append(cloud)
        cloud.startMoving()
        addChild(cloud)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //this gets called automatically when two objects begin contact with each other
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let soundSetting = getDataFromPlist("soundSetting") as! Int
        switch(contactMask) {
        case BodyType.ghost.rawValue | BodyType.cloud.rawValue:
            if ghost.physicsBody?.velocity.dy <= 0 {
                ghost.physicsBody?.velocity = CGVectorMake(ghost.physicsBody!.velocity.dx, CGFloat(ghostVelocity))
                if soundSetting == 1 {
                    runAction(playBounceSound)
                }
            }
        default:
            return
        }
    }
    
    func loadBackground() {
        scaleFactor = self.frame.size.width / 568.0
        
        sky = TNGMovingBackground(image: SKSpriteNode(imageNamed: "sky"))
        sky.zPosition = -3
        addChild(sky)
        
        background = TNGMovingBackground(image: SKSpriteNode(imageNamed: "background"))
        background.setScale(scaleFactor)
        background.zPosition = -2
        addChild(background)
    }
    
    func loadGhost() {
        let ghostName: AnyObject = getDataFromPlist("currentGhost")
        let ghostString: String = ghostName as! String
        ghost = TNGGhost(imageNamed: ghostString)
        ghost.position = CGPointMake(self.frame.width * 0.5, self.frame.height / 2 + 100)
        addChild(ghost)
    }
    
    func loadCloud() {
        startingCloud = TNGCloud()
        startingCloud.texture = SKTexture(imageNamed: "cloud")
        startingCloud.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        addChild(startingCloud)
    }
    
    func displaySettings() {
        popUpMenu.removeFromParent()
        
        if isGameOver == true {
            restartButton.removeFromParent()
            shopButton.removeFromParent()
        }
        else {
            startButton.removeFromParent()
            shopButton.removeFromParent()
        }
        
        popUpMenu = SKSpriteNode(imageNamed: "pop_up_menu")
        popUpMenu.position.x = self.frame.width / 2
        popUpMenu.position.y = self.frame.height / 2
        addChild(popUpMenu)
        
        xButton = TNGButton(defaultButtonImage: "x_button", activeButtonImage: "x_button_active", buttonAction: closeSettings, anchorPoint: CGPointMake(0.5, 0.5))
        xButton.position = CGPointMake(145.0, 70.0)
        xButton.setScale(0.95)
        popUpMenu.addChild(xButton)
        
        settingsLabel = SKLabelNode(fontNamed: "Pusab")
        settingsLabel.text = "Settings"
        settingsLabel.fontColor = UIColor.blackColor()
        settingsLabel.verticalAlignmentMode = .Top
        settingsLabel.fontSize = 30.0
        settingsLabel.position = CGPointMake(0, 90.0)
        popUpMenu.addChild(settingsLabel)
        
        let tutorialSetting = getDataFromPlist("tutorialSetting") as! Int
        let soundSetting = getDataFromPlist("soundSetting") as! Int
        
        if tutorialSetting == 1 && soundSetting == 1 {
            tutorialButton = TNGButton(defaultButtonImage: "tutorial_on", activeButtonImage: "tutorial_on_active", buttonAction: toggleTutorial, anchorPoint: CGPointMake(0.5, 0.5))
            soundButton = TNGButton(defaultButtonImage: "sound_on", activeButtonImage: "sound_on_active", buttonAction: toggleSetting, anchorPoint: CGPointMake(0.5, 0.5))
        }
        else if tutorialSetting == 1 && soundSetting == 0 {
            tutorialButton = TNGButton(defaultButtonImage: "tutorial_on", activeButtonImage: "tutorial_on_active", buttonAction: toggleTutorial, anchorPoint: CGPointMake(0.5, 0.5))
            soundButton = TNGButton(defaultButtonImage: "sound_off", activeButtonImage: "sound_off_active", buttonAction: toggleSetting, anchorPoint: CGPointMake(0.5, 0.5))
        }
        else if tutorialSetting == 0 && soundSetting == 1 {
            tutorialButton = TNGButton(defaultButtonImage: "tutorial_off", activeButtonImage: "tutorial_off_active", buttonAction: toggleTutorial, anchorPoint: CGPointMake(0.5, 0.5))
            soundButton = TNGButton(defaultButtonImage: "sound_on", activeButtonImage: "sound_on_active", buttonAction: toggleSetting, anchorPoint: CGPointMake(0.5, 0.5))
        }
        else if tutorialSetting == 0 && soundSetting == 0 {
            tutorialButton = TNGButton(defaultButtonImage: "tutorial_off", activeButtonImage: "tutorial_off_active", buttonAction: toggleTutorial, anchorPoint: CGPointMake(0.5, 0.5))
            soundButton = TNGButton(defaultButtonImage: "sound_off", activeButtonImage: "sound_off_active", buttonAction: toggleSetting, anchorPoint: CGPointMake(0.5, 0.5))
        }
        
        tutorialButton.position = CGPointMake(0, 20)
        soundButton.position = CGPointMake(0, -50)
        
        tutorialButton.setScale(1.2)
        soundButton.setScale(1.2)
        
        popUpMenu.addChild(tutorialButton)
        popUpMenu.addChild(soundButton)
        
    }
    
    func toggleTutorial() {
        updateTutorialSetting()
        tutorialButton.removeFromParent()
        let tutorialSetting = getDataFromPlist("tutorialSetting") as! Int
        
        if tutorialSetting == 1 {
            tutorialButton = TNGButton(defaultButtonImage: "tutorial_on", activeButtonImage: "tutorial_on_active", buttonAction: toggleTutorial, anchorPoint: CGPointMake(0.5, 0.5))
        }
        else {
            tutorialButton = TNGButton(defaultButtonImage: "tutorial_off", activeButtonImage: "tutorial_off_active", buttonAction: toggleTutorial, anchorPoint: CGPointMake(0.5, 0.5))
        }
        
        tutorialButton.position = CGPointMake(0, 20)
        tutorialButton.setScale(1.2)
        popUpMenu.addChild(tutorialButton)
    }
    
    func toggleSetting() {
        updateSoundSetting()
        soundButton.removeFromParent()
        let soundSetting = getDataFromPlist("soundSetting") as! Int
        
        if soundSetting == 1 {
            soundButton = TNGButton(defaultButtonImage: "sound_on", activeButtonImage: "sound_on_active", buttonAction: toggleSetting, anchorPoint: CGPointMake(0.5, 0.5))
        }
        else {
            soundButton = TNGButton(defaultButtonImage: "sound_off", activeButtonImage: "sound_off_active", buttonAction: toggleSetting, anchorPoint: CGPointMake(0.5, 0.5))
        }
        
        soundButton.position = CGPointMake(0, -50)
        soundButton.setScale(1.2)
        popUpMenu.addChild(soundButton)
    }
    
    func closeSettings() {
        popUpMenu.removeFromParent()
        
        if isGameOver == true {
            // restart button
            restartButton = TNGButton(defaultButtonImage: "restart_button", activeButtonImage: "restart_button_active", buttonAction: restart, anchorPoint: CGPointMake(0, 0.5))
            restartButton.position = CGPointMake((self.size.width / 2) + 20.0, (self.size.height / 2) - 50)
            addChild(restartButton)
            
            // shop button
            shopButton = TNGButton(defaultButtonImage: "shop_button", activeButtonImage: "shop_button_active", buttonAction: shop, anchorPoint: CGPointMake(1, 0.5))
            shopButton.position = CGPointMake((self.size.width / 2) - 20.0, (self.size.height / 2) - 50)
            addChild(shopButton)
        }
        else {
            // restart button
            startButton = TNGButton(defaultButtonImage: "start_button", activeButtonImage: "start_button_active", buttonAction: start, anchorPoint: CGPointMake(0, 0.5))
            startButton.position = CGPointMake((self.size.width / 2) + 20.0, (self.size.height / 2) - 50)
            addChild(startButton)
            
            // shop button
            shopButton = TNGButton(defaultButtonImage: "shop_button", activeButtonImage: "shop_button_active", buttonAction: shop, anchorPoint: CGPointMake(1, 0.5))
            shopButton.position = CGPointMake((self.size.width / 2) - 20.0, (self.size.height / 2) - 50)
            addChild(shopButton)
        }
    }
    
    func displayCreditsScene() {
        
        let scene = TNGCreditsScene(size: self.size)
        scene.scaleMode = scaleMode
        let reveal = SKTransition.doorsOpenVerticalWithDuration(0.3)
        self.view?.presentScene(scene, transition: reveal)
    }
    
    func loadStartandShopButton() {
        let shopTutorialFinished = getDataFromPlist("shopTutorialFinished") as! Int
        let userTotalPoints = getDataFromPlist("userTotalPoints") as! Int
        
        // to prevent Optional errors later on
        settingsButton = TNGButton(defaultButtonImage: "settings_button", activeButtonImage: "settings_button_active", buttonAction: displaySettings, anchorPoint: CGPointMake(0, 0))
        
        creditsButton = TNGButton(defaultButtonImage: "credits_button", activeButtonImage: "credits_button_active", buttonAction: displayCreditsScene, anchorPoint: CGPointMake(1, 0))
        
        if shopTutorialFinished == 0 {
            if userTotalPoints >= 5 {
                startButton = TNGButton(defaultButtonImage: "start_button", activeButtonImage: "start_button", buttonAction: doNothing, anchorPoint: CGPointMake(0, 0.5))
                startButton.position = CGPointMake((self.size.width / 2) + 20.0, (self.size.height / 2) - 50)
                addChild(startButton)
                
                overlay = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width, self.frame.size.height))
                overlay.anchorPoint = CGPointMake(0, 0)
                overlay.position = CGPointMake(0, 0)
                overlay.alpha = 0.40
                addChild(overlay)
                
                shopButton = TNGButton(defaultButtonImage: "shop_button", activeButtonImage: "shop_button_active", buttonAction: shop, anchorPoint: CGPointMake(1, 0.5))
                shopButton.position = CGPointMake((self.size.width / 2) - 20.0, (self.size.height / 2) - 50)
                addChild(shopButton)
                
                arrow = SKSpriteNode(imageNamed: "arrow")
                arrow.position = CGPointMake(-75, 40)
                arrow.setScale(1.0)
                arrow.zRotation = CGFloat(M_PI_2)
                shopButton.addChild(arrow)
                arrow.runAction(bounce())
            }
            else if userTotalPoints < 5 {
                shopButton = TNGButton(defaultButtonImage: "shop_button", activeButtonImage: "shop_button", buttonAction: doNothing, anchorPoint: CGPointMake(1, 0.5))
                shopButton.position = CGPointMake((self.size.width / 2) - 20.0, (self.size.height / 2) - 50)
                addChild(shopButton)
                
                overlay = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width, self.frame.size.height))
                overlay.anchorPoint = CGPointMake(0, 0)
                overlay.position = CGPointMake(0, 0)
                overlay.alpha = 0.40
                addChild(overlay)
                
                startButton = TNGButton(defaultButtonImage: "start_button", activeButtonImage: "start_button_active", buttonAction: start, anchorPoint: CGPointMake(0, 0.5))
                startButton.position = CGPointMake((self.size.width / 2) + 20.0, (self.size.height / 2) - 50)
                addChild(startButton)
                
                arrow = SKSpriteNode(imageNamed: "arrow")
                arrow.position = CGPointMake(75, 40)
                arrow.setScale(1.0)
                arrow.zRotation = CGFloat(M_PI_2)
                startButton.addChild(arrow)
                arrow.runAction(bounce())
            }
        }
        else {
            // restart button
            startButton = TNGButton(defaultButtonImage: "start_button", activeButtonImage: "start_button_active", buttonAction: start, anchorPoint: CGPointMake(0, 0.5))
            startButton.position = CGPointMake((self.size.width / 2) + 20.0, (self.size.height / 2) - 50)
            addChild(startButton)
            
            // shop button
            shopButton = TNGButton(defaultButtonImage: "shop_button", activeButtonImage: "shop_button_active", buttonAction: shop, anchorPoint: CGPointMake(1, 0.5))
            shopButton.position = CGPointMake((self.size.width / 2) - 20.0, (self.size.height / 2) - 50)
            addChild(shopButton)
            
            // settings button
            settingsButton = TNGButton(defaultButtonImage: "settings_button", activeButtonImage: "settings_button_active", buttonAction: displaySettings, anchorPoint: CGPointMake(0, 0))
            settingsButton.position = CGPointMake(10, 40)
            settingsButton.setScale(1.2)
            addChild(settingsButton)
            
            // credits button
            creditsButton = TNGButton(defaultButtonImage: "credits_button", activeButtonImage: "credits_button_active", buttonAction: displayCreditsScene, anchorPoint: CGPointMake(1, 0))
            creditsButton.position = CGPointMake(self.frame.size.width - 10, 40)
            creditsButton.setScale(1.2)
            addChild(creditsButton)
        }
    }
    
    func doNothing() {
        // YOLO
    }
    
    func loadPointInfoLabel() {
        pointInfoLabel = SKLabelNode(fontNamed: "Pusab")
        pointInfoLabel.text = "Stay alive as long as"
        pointInfoLabel.fontColor = UIColor.whiteColor()
        pointInfoLabel.verticalAlignmentMode = .Top
        pointInfoLabel.fontSize = 24.0
        pointInfoLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 40.0)
        addChild(pointInfoLabel)
        
        pointInfoLabel2 = pointInfoLabel.copy() as! SKLabelNode
        pointInfoLabel2.text = "possible by bouncing on clouds."
        pointInfoLabel2.position = CGPointMake(0, -25)
        pointInfoLabel.addChild(pointInfoLabel2)
        
        pointInfoLabel3 = pointInfoLabel2.copy() as! SKLabelNode
        pointInfoLabel3.text = "Earn points when"
        pointInfoLabel3.position = CGPointMake(0, -25)
        pointInfoLabel2.addChild(pointInfoLabel3)
        
        pointInfoLabel4 = pointInfoLabel3.copy() as! SKLabelNode
        pointInfoLabel4.text = "clouds move off the screen."
        pointInfoLabel4.position = CGPointMake(0, -25)
        pointInfoLabel3.addChild(pointInfoLabel4)
    }
    
    func loadCurrentScore() {
        currentScoreLabel.removeFromParent()
        currentScore = 0
        currentScoreLabel = SKLabelNode(fontNamed: "Pusab")
        currentScoreLabel.text = "\(currentScore)"
        currentScoreLabel.fontColor = UIColor.whiteColor()
        currentScoreLabel.horizontalAlignmentMode = .Left
        currentScoreLabel.verticalAlignmentMode = .Top
        currentScoreLabel.fontSize = 24.0
        currentScoreLabel.position = CGPointMake(20.0, self.frame.size.height - 20.0)
        addChild(currentScoreLabel)
    }
    
    func loadHighScore() {
        let highScore = getDataFromPlist("highscore") as! Int
        
        highScoreLabel = SKLabelNode(fontNamed: "Pusab")
        highScoreLabel.text = "\(highScore)"
        highScoreLabel.fontColor = UIColor.whiteColor()
        highScoreLabel.horizontalAlignmentMode = .Right
        highScoreLabel.verticalAlignmentMode = .Top
        highScoreLabel.fontSize = 24.0
        highScoreLabel.position = CGPointMake(self.frame.size.width - 40.0, self.frame.size.height - 20.0)
        addChild(highScoreLabel)
        
        highScoreTextLabel = SKLabelNode(fontNamed: "Pusab")
        highScoreTextLabel.text = "high"
        highScoreTextLabel.fontColor = UIColor.whiteColor()
        highScoreTextLabel.fontSize = 14.0
        highScoreLabel.horizontalAlignmentMode = .Center
        highScoreTextLabel.position = CGPointMake(0, -35.0)
        highScoreLabel.addChild(highScoreTextLabel)
    }
    
    func loadTutorial() {
        leftSide = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(self.frame.size.width / 2, self.frame.size.height))
        leftSide.anchorPoint = CGPointMake(0, 0)
        leftSide.position = CGPointMake(0, 0)
        leftSide.alpha = 0.5
        leftSide.zPosition = -1
        addChild(leftSide)
        leftSideActive = true
        
        rightSide = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width / 2, self.frame.size.height))
        rightSide.anchorPoint = CGPointMake(0, 0)
        rightSide.position = CGPointMake(self.frame.size.width / 2, 0)
        rightSide.alpha = 0.5
        addChild(rightSide)
        rightSide.zPosition = -1
        rightSideActive = true
        
        tutorialLabelLeft = SKLabelNode(fontNamed: "Pusab")
        tutorialLabelLeft.text = "Tap and hold this side"
        tutorialLabelLeft.fontColor = UIColor.whiteColor()
        tutorialLabelLeft.fontSize = 20.0
        tutorialLabelLeft.position = CGPointMake(self.frame.size.width / 4, self.frame.size.height / 2)
        tutorialLabelLeft.zPosition = 1
        addChild(tutorialLabelLeft)
        
        tutorialLabelLeft2 = tutorialLabelLeft.copy() as! SKLabelNode
        tutorialLabelLeft2.text = "to move left"
        tutorialLabelLeft2.position = CGPointMake(0, -25)
        tutorialLabelLeft.addChild(tutorialLabelLeft2)
        
        tutorialLabelRight = SKLabelNode(fontNamed: "Pusab")
        tutorialLabelRight.text = "Tap and hold this side"
        tutorialLabelRight.fontColor = UIColor.whiteColor()
        tutorialLabelRight.fontSize = 20.0
        tutorialLabelRight.position = CGPointMake((self.frame.size.width / 4) * 3, self.frame.size.height / 2)
        tutorialLabelRight.zPosition = 1
        addChild(tutorialLabelRight)
        
        tutorialLabelRight2 = tutorialLabelRight.copy() as! SKLabelNode
        tutorialLabelRight2.text = "to move right"
        tutorialLabelRight2.position = CGPointMake(0, -25)
        tutorialLabelRight.addChild(tutorialLabelRight2)
    }
    
    func shop() {
        
        let scene = TNGShopScene(size: self.size)
        scene.scaleMode = scaleMode
        let reveal = SKTransition.doorsOpenVerticalWithDuration(0.3)
        self.view?.presentScene(scene, transition: reveal)
    }
    
    func start() {
        // remove the buttons form the screen
        startButton.removeFromParent()
        shopButton.removeFromParent()
        settingsButton.removeFromParent()
        creditsButton.removeFromParent()
        overlay.removeFromParent()
        pointInfoLabel.removeFromParent()
        
        let tutorialSetting = getDataFromPlist("tutorialSetting") as! Int
        if tutorialSetting == 1 {
            loadTutorial()
        }
        else {
            beginMoving()
        }
        
        // adjust booleans accordingly
        isStarted = true
        isGameOver = false
    }
    
    func beginMoving() {
        // make the ghost fall and start moving
        ghost.physicsBody?.dynamic = true
        
        // move the background elements
        sky.startMovingSky()
        background.startMovingScenery()
        
        // fade starting cloud and generate cloud
        startingCloud.fade()
        generateClouds()
        
        isMoving = true
    }
    
    func restart() {
        // remove buttons and labels from scene
        restartButton.removeFromParent()
        shopButton.removeFromParent()
        settingsButton.removeFromParent()
        creditsButton.removeFromParent()
        gameOverLabel.removeFromParent()
        newHighScoreLabel.removeFromParent()
        overlay.removeFromParent()
        ghost.removeFromParent()
        
        let ghostName: AnyObject = getDataFromPlist("currentGhost")
        let ghostString: String = ghostName as! String
        ghost = TNGGhost(imageNamed: ghostString)
        ghost.position = CGPointMake(self.frame.width * 0.5, self.frame.size.height - ghost.size.height)
        addChild(ghost)
        ghostID = 1
        
        sky.position = CGPointMake(0, 0)
        background.position = CGPointMake(0, 0)
        
        // cloud stuff
        if activeClouds.count > 0 {
            for onScreenCloud in activeClouds {
                onScreenCloud.removeFromParent()
            }
        }
        activeClouds = []
        loadCloud()
        
        let tutorialSetting = getDataFromPlist("tutorialSetting") as! Int
        if tutorialSetting == 1 {
            loadTutorial()
        }
        else {
            beginMoving()
        }
        
        
        
        // update score text
        currentScore = 0
        currentScoreLabel.text = "\(currentScore)"
        
        // adjust booleans accordingly
        isStarted = true
        isGameOver = false
    }
    
    func gameOver() {
        let shopTutorialFinished = getDataFromPlist("shopTutorialFinished") as! Int
        var userTotalPoints = getDataFromPlist("userTotalPoints") as! Int
        updateUserTotalPoints(userTotalPoints + currentScore)
        userTotalPoints = getDataFromPlist("userTotalPoints") as! Int
        
        // prevent Optional errors later on
        settingsButton = TNGButton(defaultButtonImage: "settings_button", activeButtonImage: "settings_button_active", buttonAction: displaySettings, anchorPoint: CGPointMake(0, 0))
        
        creditsButton = TNGButton(defaultButtonImage: "credits_button", activeButtonImage: "credits_button_active", buttonAction: displayCreditsScene, anchorPoint: CGPointMake(1, 0))
        
        // ghost stuff
        ghost.removeAllActions()
        ghost.physicsBody?.dynamic = false
        
        if shopTutorialFinished == 0 {
            if userTotalPoints >= 5 {
                restartButton = TNGButton(defaultButtonImage: "restart_button", activeButtonImage: "restart_button", buttonAction: doNothing, anchorPoint: CGPointMake(0, 0.5))
                restartButton.position = CGPointMake((self.size.width / 2) + 20.0, (self.size.height / 2) - 50)
                addChild(restartButton)
                
                overlay = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width, self.frame.size.height))
                overlay.anchorPoint = CGPointMake(0, 0)
                overlay.position = CGPointMake(0, 0)
                overlay.alpha = 0.40
                addChild(overlay)
                
                shopButton = TNGButton(defaultButtonImage: "shop_button", activeButtonImage: "shop_button_active", buttonAction: shop, anchorPoint: CGPointMake(1, 0.5))
                shopButton.position = CGPointMake((self.size.width / 2) - 20.0, (self.size.height / 2) - 50)
                addChild(shopButton)
                
                arrow = SKSpriteNode(imageNamed: "arrow")
                arrow.position = CGPointMake(-75, 40)
                arrow.setScale(1.0)
                arrow.zRotation = CGFloat(M_PI_2)
                shopButton.addChild(arrow)
                arrow.runAction(bounce())
            }
            else if userTotalPoints < 5 {
                shopButton = TNGButton(defaultButtonImage: "shop_button", activeButtonImage: "shop_button", buttonAction: doNothing, anchorPoint: CGPointMake(1, 0.5))
                shopButton.position = CGPointMake((self.size.width / 2) - 20.0, (self.size.height / 2) - 50)
                addChild(shopButton)
                
                overlay = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width, self.frame.size.height))
                overlay.anchorPoint = CGPointMake(0, 0)
                overlay.position = CGPointMake(0, 0)
                overlay.alpha = 0.40
                addChild(overlay)
                
                restartButton = TNGButton(defaultButtonImage: "restart_button", activeButtonImage: "restart_button_active", buttonAction: restart, anchorPoint: CGPointMake(0, 0.5))
                restartButton.position = CGPointMake((self.size.width / 2) + 20.0, (self.size.height / 2) - 50)
                addChild(restartButton)
                
                arrow = SKSpriteNode(imageNamed: "arrow")
                arrow.position = CGPointMake(75, 40)
                arrow.setScale(1.0)
                arrow.zRotation = CGFloat(M_PI_2)
                restartButton.addChild(arrow)
                arrow.runAction(bounce())
            }
        }
        else {
            // restart button
            restartButton = TNGButton(defaultButtonImage: "restart_button", activeButtonImage: "restart_button_active", buttonAction: restart, anchorPoint: CGPointMake(0, 0.5))
            restartButton.position = CGPointMake((self.size.width / 2) + 20.0, (self.size.height / 2) - 50)
            addChild(restartButton)
            
            // shop button
            shopButton = TNGButton(defaultButtonImage: "shop_button", activeButtonImage: "shop_button_active", buttonAction: shop, anchorPoint: CGPointMake(1, 0.5))
            shopButton.position = CGPointMake((self.size.width / 2) - 20.0, (self.size.height / 2) - 50)
            addChild(shopButton)
            
            // settings
            settingsButton = TNGButton(defaultButtonImage: "settings_button", activeButtonImage: "settings_button_active", buttonAction: displaySettings, anchorPoint: CGPointMake(0, 0))
            settingsButton.position = CGPointMake(10, 40)
            settingsButton.setScale(1.2)
            addChild(settingsButton)
            
            // credits button
            creditsButton = TNGButton(defaultButtonImage: "credits_button", activeButtonImage: "credits_button_active", buttonAction: displayCreditsScene, anchorPoint: CGPointMake(1, 0))
            creditsButton.position = CGPointMake(self.frame.size.width - 10, 40)
            creditsButton.setScale(1.2)
            addChild(creditsButton)
        }
        
        // background stuff
        sky.stop()
        background.stop()
        
        // game over label
        gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontColor = UIColor.redColor()
        gameOverLabel.fontName = "Pusab"
        gameOverLabel.position.x = view!.center.x
        gameOverLabel.position.y = view!.center.y + 60
        gameOverLabel.fontSize = 36.0
        addChild(gameOverLabel)
        gameOverLabel.runAction(blink())
        
        // tutorial stuff
        if leftSideActive {
            leftSide.removeFromParent()
            tutorialLabelLeft.removeFromParent()
            leftSideActive = false
        }
        if rightSideActive {
            rightSide.removeFromParent()
            tutorialLabelRight.removeFromParent()
            rightSideActive = false
        }
        
        // highscore label
        newHighScoreLabel = SKLabelNode()
        let highScore = getDataFromPlist("highscore") as! Int
        if currentScore > highScore {
            updateHighscore(currentScore)
            highScoreLabel.text = "\(currentScore)"
            newHighScoreLabel.text = "You got a new high score: \(currentScore)"
            newHighScoreLabel.fontColor = UIColor.yellowColor()
            newHighScoreLabel.fontName = "Pusab"
            newHighScoreLabel.position.x = view!.center.x
            newHighScoreLabel.position.y = view!.center.y + 10
            newHighScoreLabel.fontSize = 24.0
            addChild(newHighScoreLabel)
        }
        
        // cloud stuff
        for onScreenCloud in activeClouds {
            onScreenCloud.stopMoving()
        }
        self.removeAllActions()
        
        userTotalPoints = getDataFromPlist("userTotalPoints") as! Int
        
        // adjust booleans accordingly
        isStarted = false
        isGameOver = true
        isMoving = false
    }
    
    func loadShopTutorial() {
        overlay = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width, self.frame.size.height))
        overlay.anchorPoint = CGPointMake(0, 0)
        overlay.position = CGPointMake(0, 0)
        overlay.alpha = 0.50
        addChild(overlay)
        
        let tempShopButton = TNGButton(defaultButtonImage: "shop_button", activeButtonImage: "shop_button_active", buttonAction: shop, anchorPoint: CGPointMake(1, 0.5))
        tempShopButton.position = CGPointMake((self.size.width / 2) - 20.0, (self.size.height / 2) - 50)
        addChild(tempShopButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            numberOfTouches += 1
            ghost.removeAllActions()
            let touchLocation = touch.locationInNode(self)
            if isStarted {
                
                if touchLocation.x < self.frame.width / 2 { // left side of the screen
                    ghost.moveLeft()
                    isLeft = true
                    isRight = false
                    if leftSideActive == true {
                        if isMoving == false {
                            beginMoving()
                        }
                        leftSide.removeFromParent()
                        tutorialLabelLeft.removeFromParent()
                    }
                }
                else { // right side of the screen
                    ghost.moveRight()
                    isLeft = false
                    isRight = true
                    if rightSideActive == true {
                        if isMoving == false {
                            beginMoving()
                        }
                        rightSide.removeFromParent()
                        tutorialLabelRight.removeFromParent()
                    }
                }
                
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch ends */
        for touch: AnyObject in touches {
            numberOfTouches -= 1
            ghost.removeAllActions()
            let touchLocation = touch.locationInNode(self)
            if numberOfTouches > 0 && isStarted {
                if (touchLocation.x < self.frame.width / 2) {
                    if isLeft == false {
                        ghost.removeAllActions()
                        ghost.moveRight()
                        isLeft = false
                        isRight = true
                    }
                }
                else if (touchLocation.x > self.frame.width / 2) {
                    if isRight == false {
                        ghost.removeAllActions()
                        ghost.moveLeft()
                        isLeft = true
                        isRight = false
                    }
                }
            }
            else {
                isLeft = false
                isRight = false
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if !isGameOver {
            if ghost.position.x < -(ghost.size.width + 5) {
                gameOver()
            }
            else if ghost.position.x > self.frame.width + ghost.size.width + 5 {
                gameOver()
            }
            else if ghost.position.y < -(ghost.size.height + 5) {
                gameOver()
            }
        }
    }
    
    func blink() -> SKAction {
        let duration = 0.75
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: duration)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatActionForever(blink)
    }
    
    func bounce() -> SKAction {
        let moveUp = SKAction.moveByX(0, y: 10, duration: 0.5)
        let moveDown = SKAction.moveByX(0, y: -10, duration: 0.5)
        let bounce = SKAction.sequence([moveUp, moveDown])
        return SKAction.repeatActionForever(bounce)
    }
}
