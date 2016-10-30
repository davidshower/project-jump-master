//
//  TNGShopScene.swift
//  Jump Master
//
//  Created by David Xiao & Jian Ren Zhou on 9/9/15.
//  Copyright (c) 2015 Tiny Nova Games. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

let MARGIN_VERTICAL: CGFloat = 20.0
let MARIGN_HORIZONTAL: CGFloat = 20.0
let SPACING_VERTICAL: CGFloat = 20.0
let SPACING_HORIZONTAL: CGFloat = 20.0
let WIDTH_GHOST: CGFloat = 45.0
let HEIGHT_GHOST: CGFloat = 45.0
let PADDING_X: CGFloat = 30.0
let PADDING_Y: CGFloat = 70.0
let WIDTH_SELECT_BUTTON: CGFloat = 150.0
let HEIGHT_SELECT_BUTTON: CGFloat = 50.0
let WIDTH_POP_UP_MENU: CGFloat = 350.0
let HEIGHT_POP_UP_MENU: CGFloat = 200.0
let WIDTH_WATCH_BUTTON: CGFloat = 144.0
let HEIGHT_WATCH_BUTTON: CGFloat = 50.0
let WIDTH_BACK_BUTTON: CGFloat = 50.0
let HEIGHT_BACK_BUTTON: CGFloat = 40.0
let FONT_SIZE_GHOST_NAME: CGFloat = 36.0
let FONT_SIZE_DESCRIPTIONS: CGFloat = 24.0
let MARGIN_VERTICAL_BOTTOM: CGFloat = 17.0

class TNGShopScene: SKScene {
    
    let playClickSound = SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false)
    
    // used for scrolling
    var scrollView: UIScrollView!
    var ghostScroll: UIScrollView!
    var previousGhostButton = UIButton()
    var previousGhostImage = UIImage()
    
    // elements in the main view
    var ghostName = UILabel()
    var selectButton = UIButton()
    var adCounter = UILabel()
    var buyLabel = UILabel()
    var backButton = UIButton()
    var numOfUnlockedLabel = SKLabelNode()
    var buyButton = UIButton()
    var watchButton = UIButton()
    var descriptionForUnlock = UILabel()
    var tutorialLabel = SKLabelNode()
    var tutorialLabel2 = SKLabelNode()
    var popUpMenu = UIButton()
    var popUpDescription = UILabel()
    var continueButton = UIButton()
    var userTotalPointsLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        loadBackground()
        loadUserTotalPoints()
        let shopTutorialFinished = getDataFromPlist("shopTutorialFinished") as! Int
        if shopTutorialFinished == 0 {
            loadTutorialLabel()
        }
        
        let scrollingView = ghostView(33)
        ghostScroll = UIScrollView(frame: self.frame)
        ghostScroll.contentSize = scrollingView.bounds.size
        ghostScroll.addSubview(scrollingView)
        ghostScroll.showsHorizontalScrollIndicator = false
        view.addSubview(ghostScroll)
        
        loadBackButton()
        loadNumOfUnlockedBalls()
    }
    
    func ghostView(ghostCount: Int) -> UIView {
        let ghostView = UIView()
        let padding = CGSizeMake(PADDING_X, PADDING_Y)
        
        ghostView.backgroundColor = UIColor.clearColor()
        ghostView.frame.origin = CGPointMake(0, 0)
        ghostView.frame.size.width = (WIDTH_GHOST + padding.width) * CGFloat(ghostCount)
        ghostView.frame.size.height = (HEIGHT_GHOST + 2.0 * padding.height)
        
        var ghostPosition = CGPointMake(padding.width * 0.5, padding.height)
        let ghostIncrement = WIDTH_GHOST + padding.width
        var ghostUnlockedArray = getArrayFromPlist("ghostUnlocked")
        
        // for loop to add all ghosts to the ghostView
        for i in 1...(ghostCount)  {
            var ghostImage: UIImage!
            var ghostImageActive: UIImage!
            let unlockedAnyObject: AnyObject = ghostUnlockedArray[i - 1]
            let unlocked = unlockedAnyObject as! Int
            
            if i < 10 && unlocked == 1 {
                ghostImage = UIImage(named: "ghost0\(i)")
                ghostImageActive = UIImage(named: "ghost0\(i)_active")
            }
            else if i < 10 && unlocked == 0 {
                ghostImage = UIImage(named: "ghost0\(i)_gray")
                ghostImageActive = UIImage(named: "ghost0\(i)_gray_active")
            }
            else if i >= 10 && unlocked == 1 {
                ghostImage = UIImage(named: "ghost\(i)")
                ghostImageActive = UIImage(named: "ghost\(i)_active")
            }
            else {
                ghostImage = UIImage(named: "ghost\(i)_gray")
                ghostImageActive = UIImage(named: "ghost\(i)_gray_active")
            }
            
            let ghostUIButton = UIButton(type: .Custom)
            ghostUIButton.setImage(ghostImage, forState: .Normal)
            ghostUIButton.setImage(ghostImageActive, forState: .Selected)
            var temp = UIImage()
            temp = ghostUIButton.imageForState(.Normal)!
            ghostUIButton.frame.size = CGSizeMake(temp.size.width, temp.size.height)
            ghostPosition.y = padding.height + (HEIGHT_GHOST - temp.size.height)
            ghostUIButton.frame.origin = ghostPosition
            ghostPosition.x = ghostPosition.x + ghostIncrement
            ghostUIButton.tag = i
            ghostUIButton.addTarget(self, action: #selector(TNGShopScene.ghostPressed(_:)), forControlEvents: .TouchUpInside)
            ghostView.addSubview(ghostUIButton)
        }
        
        return ghostView
    }
    
    func ghostPressed(sender: UIButton) {
        let soundSetting = getDataFromPlist("soundSetting") as! Int
        if soundSetting == 1 {
            runAction(playClickSound)
        }
        // change the button into the selected state
        sender.selected = true
        
        // avoid a selected button to change state
        if previousGhostButton.tag != sender.tag {
            previousGhostButton.selected = false
        }
        
        // change previously selected button back to normal state
        previousGhostButton = sender
        
        tutorialLabel.removeFromParent()
        
        displayGhostName(sender.tag)
        displayButton(sender.tag)
    }
    
    func displayGhostName(ghostNum: Int) {
        let ghostString = setMutableString(ghostNames[ghostNum - 1])
        ghostName.removeFromSuperview()
        ghostName.frame.size.width = self.frame.width - 200
        ghostName.frame.size.height = FONT_SIZE_GHOST_NAME + 5
        ghostName.frame.origin.x = (self.frame.width / 2) - ((self.frame.width - 200) / 2)
        ghostName.frame.origin.y = 10
        ghostName.attributedText = ghostString
        ghostName.font = UIFont(name: "Pusab", size: 36.0)
        ghostName.textColor = UIColor.whiteColor()
        ghostName.textAlignment = .Center
        ghostName.adjustsFontSizeToFitWidth = true
        view?.addSubview(ghostName)
    }
    
    func displayButton(ghostNum: Int) {
        // load the array and see if the given ghost is unlocked or not
        var ghostUnlockedArray = getArrayFromPlist("ghostUnlocked")
        let unlockedAnyObject: AnyObject = ghostUnlockedArray[ghostNum - 1]
        let unlocked = unlockedAnyObject as! Int
        
        cleanUpDuplicates()
        
        if unlocked == 0 {
            var ghostCost: Int!
            buyButton = UIButton(type: .Custom)
            buyButton.setImage(UIImage(named: "buy_button"), forState: .Normal)
            buyButton.setImage(UIImage(named: "buy_button_active"), forState: .Highlighted)
            buyButton.frame.size.width = WIDTH_WATCH_BUTTON
            buyButton.frame.size.height = HEIGHT_WATCH_BUTTON
            buyButton.frame.origin.x = self.frame.width / 2 - WIDTH_WATCH_BUTTON / 2
            buyButton.frame.origin.y = self.frame.height - 150
            buyButton.tag = ghostNum
            buyButton.addTarget(self, action: #selector(TNGShopScene.buyGhost(_:)), forControlEvents: .TouchUpInside)
            view?.addSubview(buyButton)
            
            buyLabel.frame.size.width = 140
            buyLabel.frame.size.height = 50
            buyLabel.frame.origin.x = self.frame.width / 2 - WIDTH_WATCH_BUTTON / 2
            buyLabel.frame.origin.y = self.frame.height - 150
            if ghostNum > 1 && ghostNum < 9 {
                ghostCost = 5
            }
            else if ghostNum == 9 {
                ghostCost = 200
            }
            else if ghostNum == 10 {
                ghostCost = 250
            }
            else if ghostNum == 11 {
                ghostCost = 500
            }
            else if ghostNum == 12 || ghostNum == 13 {
                ghostCost = 750
            }
            else if ghostNum == 14 || ghostNum == 15 || ghostNum == 16 {
                ghostCost = 1000
            }
            else if ghostNum == 17 {
                ghostCost = 1250
            }
            else if ghostNum == 18 || ghostNum == 19 || ghostNum == 20 {
                ghostCost = 1500
            }
            else if ghostNum == 21 {
                ghostCost = 1750
            }
            else if ghostNum == 22 {
                ghostCost = 2000
            }
            else if ghostNum == 23 || ghostNum == 24 || ghostNum == 25 {
                ghostCost = 2250
            }
            else if ghostNum == 26 || ghostNum == 27 || ghostNum == 28 || ghostNum == 29 {
                ghostCost = 2500
            }
            else if ghostNum == 30 {
                ghostCost = 2750
            }
            else if ghostNum == 31 {
                ghostCost = 3000
            }
            else if ghostNum == 32 {
                ghostCost = 3250
            }
            else if ghostNum == 33 {
                ghostCost = 3500
            }
            
            buyLabel.text = "\(ghostCost) pts"
            buyLabel.textAlignment = .Center
            buyLabel.font = UIFont(name: "Pusab", size: FONT_SIZE_DESCRIPTIONS)
            buyLabel.textColor = UIColor.whiteColor()
            buyLabel.numberOfLines = 1
            buyLabel.adjustsFontSizeToFitWidth = true
            view?.addSubview(buyLabel)
        }
        else {
            selectButton = UIButton(type: .Custom)
            selectButton.setImage(UIImage(named: "select_button"), forState: .Normal)
            selectButton.setImage(UIImage(named: "select_button_active"), forState: .Highlighted)
            selectButton.frame.size = CGSizeMake(WIDTH_SELECT_BUTTON, HEIGHT_SELECT_BUTTON)
            selectButton.frame.origin.x = (self.frame.width / 2) - (WIDTH_SELECT_BUTTON / 2)
            selectButton.frame.origin.y = self.frame.height - 150
            selectButton.tag = ghostNum
            selectButton.addTarget(self, action: #selector(TNGShopScene.selectGhost(_:)), forControlEvents: .TouchUpInside)
            view?.addSubview(selectButton)
        }
    }
    
    func setMutableString(string: String) -> NSMutableAttributedString {
        var myMutableString: NSMutableAttributedString!
        
        if let font = UIFont(name: "Pusab", size: FONT_SIZE_DESCRIPTIONS) {
            let textFontAttributes = [
                NSFontAttributeName : font,
                // Note: SKColor.whiteColor().CGColor breaks this
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                // Note: Use negative value here if you want foreground color to show
            ]
            let lineSpacingStyle = NSMutableParagraphStyle()
            lineSpacingStyle.lineSpacing = 10
            myMutableString = NSMutableAttributedString(string: string, attributes: textFontAttributes)
            myMutableString.addAttribute(NSParagraphStyleAttributeName, value: lineSpacingStyle, range: NSMakeRange(0, myMutableString.length))
        }
        
        return myMutableString
    }
    
    func selectGhost(sender: UIButton) {
        let soundSetting = getDataFromPlist("soundSetting") as! Int
        if soundSetting == 1 {
            runAction(playClickSound)
        }
        // remove all UI elements from the view
        ghostScroll.removeFromSuperview()
        backButton.removeFromSuperview()
        ghostName.removeFromSuperview()
        cleanUpDuplicates()
        
        // update the current ghost in the save data
        updateCurrentGhost(sender.tag)
        
        // change scenes
        let scene = GameScene(size: self.size)
        scene.scaleMode = scaleMode
        let reveal = SKTransition.doorsOpenVerticalWithDuration(0.5)
        self.view?.presentScene(scene, transition: reveal)
    }
    
    func buyGhost(sender: UIButton) {
        let soundSetting = getDataFromPlist("soundSetting") as! Int
        if soundSetting == 1 {
            runAction(playClickSound)
        }
        let userTotalPoints = getDataFromPlist("userTotalPoints") as! Int
        var ghostCost: Int!
        if sender.tag > 1 && sender.tag < 9 {
            ghostCost = 5
        }
        else if sender.tag == 9 {
            ghostCost = 200
        }
        else if sender.tag == 10 {
            ghostCost = 250
        }
        else if sender.tag == 11 {
            ghostCost = 500
        }
        else if sender.tag == 12 || sender.tag == 13 {
            ghostCost = 750
        }
        else if sender.tag == 14 || sender.tag == 15 || sender.tag == 16 {
            ghostCost = 1000
        }
        else if sender.tag == 17 {
            ghostCost = 1250
        }
        else if sender.tag == 18 || sender.tag == 19 || sender.tag == 20 {
            ghostCost = 1500
        }
        else if sender.tag == 21 {
            ghostCost = 1750
        }
        else if sender.tag == 22 {
            ghostCost = 2000
        }
        else if sender.tag == 23 || sender.tag == 24 || sender.tag == 25 {
            ghostCost = 2250
        }
        else if sender.tag == 26 || sender.tag == 27 || sender.tag == 28 || sender.tag == 29 {
            ghostCost = 2500
        }
        else if sender.tag == 30 {
            ghostCost = 2750
        }
        else if sender.tag == 31 {
            ghostCost = 3000
        }
        else if sender.tag == 32 {
            ghostCost = 3250
        }
        else if sender.tag == 33 {
            ghostCost = 3500
        }
        if userTotalPoints < ghostCost {
            let userTotalPoints: AnyObject = getDataFromPlist("userTotalPoints")
            let errorMessage = SKLabelNode(text: "You have: \(userTotalPoints) points")
            errorMessage.fontColor = UIColor.redColor()
            errorMessage.fontSize = FONT_SIZE_DESCRIPTIONS
            errorMessage.fontName = "Pusab"
            errorMessage.verticalAlignmentMode = .Bottom
            errorMessage.position.x = self.frame.width / 2
            errorMessage.position.y = MARGIN_VERTICAL_BOTTOM * 4
            addChild(errorMessage)
            let action = SKAction.fadeOutWithDuration(1)
            errorMessage.runAction(action)
        }
        else {
            updateUserTotalPoints(userTotalPoints - ghostCost)
            updateGhostUnlocked(sender.tag)
            
            // remove all UI elements from the view
            ghostScroll.removeFromSuperview()
            backButton.removeFromSuperview()
            ghostName.removeFromSuperview()
            cleanUpDuplicates()
            
            // update the current ghost in the save data
            updateCurrentGhost(sender.tag)
            
            let shopTutorialFinished = getDataFromPlist("shopTutorialFinished") as! Int
            if shopTutorialFinished == 0 {
                ghostName.removeFromSuperview()
                updateShopTutorialFinished()
                
                popUpMenu = UIButton(type: .Custom)
                popUpMenu.setImage(UIImage(named: "pop_up_menu"), forState: .Normal)
                popUpMenu.frame.size.width = WIDTH_POP_UP_MENU
                popUpMenu.frame.size.height = HEIGHT_POP_UP_MENU
                popUpMenu.frame.origin.x = self.frame.width / 2 - WIDTH_POP_UP_MENU / 2
                popUpMenu.frame.origin.y = self.frame.height / 2 - HEIGHT_POP_UP_MENU / 2
                popUpMenu.adjustsImageWhenHighlighted = false
                view?.addSubview(popUpMenu)
                
                let popUpString = setMutableString("congratulations! you have finished the tutorial. enjoy the game!")
                popUpDescription = UILabel()
                popUpDescription.frame.size.width = WIDTH_POP_UP_MENU - 80
                popUpDescription.frame.size.height = 140
                popUpDescription.frame.origin.x = WIDTH_POP_UP_MENU / 2 - popUpDescription.frame.size.width / 2
                popUpDescription.frame.origin.y = 0
                popUpDescription.attributedText = popUpString
                popUpDescription.textColor = UIColor.blackColor()
                popUpDescription.textAlignment = .Center
                popUpDescription.numberOfLines = 4
                popUpMenu.addSubview(popUpDescription)
                
                continueButton = UIButton(type: .Custom)
                continueButton.setImage(UIImage(named: "continue_button"), forState: .Normal)
                continueButton.setImage(UIImage(named: "continue_button_active"), forState: .Highlighted)
                continueButton.frame.size.width = WIDTH_SELECT_BUTTON
                continueButton.frame.size.height = HEIGHT_SELECT_BUTTON
                continueButton.frame.origin.x = WIDTH_POP_UP_MENU / 2 - WIDTH_SELECT_BUTTON / 2
                continueButton.frame.origin.y = HEIGHT_POP_UP_MENU - 10 - HEIGHT_SELECT_BUTTON
                continueButton.addTarget(self, action: #selector(TNGShopScene.back), forControlEvents: .TouchUpInside)
                popUpMenu.addSubview(continueButton)
                
                let userTotalPoints: AnyObject = getDataFromPlist("userTotalPoints")
                userTotalPointsLabel.text = "You have: \(userTotalPoints) points"
            }
            else {
                // change scenes
                let scene = GameScene(size: self.size)
                scene.scaleMode = scaleMode
                let reveal = SKTransition.doorsOpenVerticalWithDuration(0.5)
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
    
    func loadBackground() {
        let background = SKSpriteNode(imageNamed: "shop_background")
        background.anchorPoint = CGPointMake(0, 0)
        background.position = CGPointMake(0, 0)
        addChild(background)
    }
    
    func loadUserTotalPoints() {
        let userTotalPoints: AnyObject = getDataFromPlist("userTotalPoints")
        userTotalPointsLabel = SKLabelNode(text: "You have: \(userTotalPoints) points")
        userTotalPointsLabel.fontColor = UIColor.whiteColor()
        userTotalPointsLabel.fontSize = FONT_SIZE_DESCRIPTIONS
        userTotalPointsLabel.fontName = "Pusab"
        userTotalPointsLabel.verticalAlignmentMode = .Bottom
        userTotalPointsLabel.position.x = self.frame.width / 2
        userTotalPointsLabel.position.y = MARGIN_VERTICAL_BOTTOM * 4
        addChild(userTotalPointsLabel)
    }
    
    func loadTutorialLabel() {
        tutorialLabel = SKLabelNode(fontNamed: "Pusab")
        tutorialLabel.text = "Tap on a ball and"
        tutorialLabel.fontColor = UIColor.whiteColor()
        tutorialLabel.verticalAlignmentMode = .Top
        tutorialLabel.fontSize = 30.0
        tutorialLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 30.0)
        addChild(tutorialLabel)
        
        tutorialLabel2 = tutorialLabel.copy() as! SKLabelNode
        tutorialLabel2.text = "purchase to unlock it"
        tutorialLabel2.position = CGPointMake(0, -25)
        tutorialLabel.addChild(tutorialLabel2)
    }
    
    func loadBackButton() {
        let shopTutorialFinished = getDataFromPlist("shopTutorialFinished") as! Int
        if shopTutorialFinished == 1 {
            backButton = UIButton(type: .Custom)
            backButton.setImage(UIImage(named: "back_button"), forState: .Normal)
            backButton.setImage(UIImage(named: "back_button_active"), forState: .Highlighted)
            backButton.frame.size = CGSizeMake(WIDTH_BACK_BUTTON, HEIGHT_BACK_BUTTON)
            backButton.frame.origin.x = (PADDING_Y - HEIGHT_BACK_BUTTON) / 2
            backButton.frame.origin.y = (PADDING_Y - HEIGHT_BACK_BUTTON) / 2
            backButton.addTarget(self, action: #selector(TNGShopScene.back), forControlEvents: .TouchUpInside)
            view?.addSubview(backButton)
        }
    }
    
    func loadNumOfUnlockedBalls() {
        let shopTutorialFinished = getDataFromPlist("shopTutorialFinished") as! Int
        if shopTutorialFinished == 1 {
            var numOfUnlocked = 0
            var ghostUnlockedArray = getArrayFromPlist("ghostUnlocked")
            for i in 1...33 {
                if ghostUnlockedArray[i-1] as! Int == 1 {
                    numOfUnlocked += 1
                }
            }
            numOfUnlockedLabel = SKLabelNode(text: "\(numOfUnlocked)/33")
            numOfUnlockedLabel.fontName = "Pusab"
            numOfUnlockedLabel.fontSize = 20
            numOfUnlockedLabel.fontColor = UIColor.whiteColor()
            numOfUnlockedLabel.horizontalAlignmentMode = .Right
            numOfUnlockedLabel.verticalAlignmentMode = .Top
            numOfUnlockedLabel.position.x = self.frame.size.width - 25
            numOfUnlockedLabel.position.y = self.frame.size.height - 25
            addChild(numOfUnlockedLabel)
        }
    }
    
    func back() {
        let soundSetting = getDataFromPlist("soundSetting") as! Int
        if soundSetting == 1 {
            runAction(playClickSound)
        }
        ghostScroll.removeFromSuperview()
        backButton.removeFromSuperview()
        ghostName.removeFromSuperview()
        cleanUpDuplicates()
        
        let scene = GameScene(size: self.size)
        scene.scaleMode = scaleMode
        let reveal = SKTransition.doorsCloseVerticalWithDuration(0.3)
        self.view?.presentScene(scene, transition: reveal)
    }
    
    func cleanUpDuplicates() {
        buyButton.removeFromSuperview()
        selectButton.removeFromSuperview()
        buyLabel.removeFromSuperview()
        popUpMenu.removeFromSuperview()
        
    }
}