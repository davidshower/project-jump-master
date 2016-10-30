//
//  TNGUserData.swift
//  Jump Master
//
//  Created by David Xiao & Jian Ren Zhou on 9/9/15.
//  Copyright (c) 2015 Tiny Nova Games. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

// KEY declarations
let ghostUnlockedKey = "ghostUnlocked"
let currentGhostKey = "currentGhost"
let highscoreKey = "highscore"
let userTotalPointsKey = "userTotalPoints"
let shopTutorialFinishedKey = "shopTutorialFinished"
let tutorialSettingKey = "tutorialSetting"
let soundSettingKey = "soundSetting"

// VALUE/ID declarations
var ghostUnlockedID: Array<AnyObject> = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var currentGhostID: AnyObject = "ghost01"
var highscoreID: AnyObject = 0
var userTotalPointsID: AnyObject = 0
var shopTutorialFinishedID: AnyObject = 0
var tutorialSettingID: AnyObject = 1
var soundSettingID: AnyObject = 1

func loadGameData() {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
    let documentsDirectory = paths[0] as! String
    let path = (documentsDirectory as NSString).stringByAppendingPathComponent("UserData.plist")
    let fileManager = NSFileManager.defaultManager()
    //check if file exists
    if(!fileManager.fileExistsAtPath(path)) {
        // If it doesn't, copy it from the default file in the Bundle
        if let bundlePath = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist") {
            //let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
            do {
                //println("Bundle UserData.plist file is --> \(resultDictionary?.description)")
                try fileManager.copyItemAtPath(bundlePath, toPath: path)
            } catch _ {
            }
            //println("copy")
        } else {
            //println("UserData.plist not found. Please, make sure it is part of the bundle.")
        }
    } else {
        //println("UserData.plist already exits at path.")
        // use this to delete file from documents directory
        //fileManager.removeItemAtPath(path, error: nil)
    }
    //let resultDictionary = NSMutableDictionary(contentsOfFile: path)
    //println("Loaded UserData.plist file is --> \(resultDictionary?.description)")
    let myDict = NSDictionary(contentsOfFile: path)
    if let dict = myDict {
        //loading values
        
        ghostUnlockedID = dict.objectForKey(ghostUnlockedKey)! as! Array<AnyObject>
        currentGhostID = dict.objectForKey(currentGhostKey)!
        highscoreID = dict.objectForKey(highscoreKey)!
        userTotalPointsID = dict.objectForKey(userTotalPointsKey)!
        shopTutorialFinishedID = dict.objectForKey(shopTutorialFinishedKey)!
        tutorialSettingID = dict.objectForKey(tutorialSettingKey)!
        soundSettingID = dict.objectForKey(soundSettingKey)!
        
        //...
    } else {
        //println("WARNING: Couldn't create dictionary from UserData.plist! Default values will be used!")
    }
}

func saveGameData() {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
    let documentsDirectory = paths.objectAtIndex(0) as! NSString
    let path = documentsDirectory.stringByAppendingPathComponent("UserData.plist")
    let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
    //saving values
    
    dict.setObject(ghostUnlockedID, forKey: ghostUnlockedKey)
    dict.setObject(currentGhostID, forKey: currentGhostKey)
    dict.setObject(highscoreID, forKey: highscoreKey)
    dict.setObject(userTotalPointsID, forKey: userTotalPointsKey)
    dict.setObject(shopTutorialFinishedID, forKey: shopTutorialFinishedKey)
    dict.setObject(tutorialSettingID, forKey: tutorialSettingKey)
    dict.setObject(soundSettingID, forKey: soundSettingKey)
    
    //...
    //writing to GameData.plist
    dict.writeToFile(path, atomically: false)
    //let resultDictionary = NSMutableDictionary(contentsOfFile: path)
    //println("Saved UserData.plist file is --> \(resultDictionary?.description)")
}

func updateShopTutorialFinished() {
    shopTutorialFinishedID = 1
    saveGameData()
}

func updateGhostUnlocked(ghostNum: AnyObject) {
    let num = Int(ghostNum as! NSNumber)
    ghostUnlockedID[num - 1] = 1
    saveGameData()
}

func updateCurrentGhost(ghostNum: AnyObject) {
    let ghostNumInt = ghostNum as! Int
    if ghostNumInt < 10 {
        currentGhostID = "ghost0\(ghostNumInt)"
    }
    else {
        currentGhostID = "ghost\(ghostNumInt)"
    }
    saveGameData()
}

func updateTutorialSetting() {
    // automatically toggles
    if tutorialSettingID as! Int == 0 {
        tutorialSettingID = 1
    }
    else {
        tutorialSettingID = 0
    }
    saveGameData()
}

func updateSoundSetting() {
    // automatically toggles
    if soundSettingID as! Int == 0 {
        soundSettingID = 1
    }
    else {
        soundSettingID = 0
    }
    saveGameData()
}

func updateHighscore(score: Int) {
    highscoreID = score as AnyObject
    saveGameData()
}

func updateUserTotalPoints(points: Int) {
    userTotalPointsID = points as AnyObject
    saveGameData()
}

func getArrayFromPlist(variableName: String) -> Array<AnyObject> {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
    let documentsDirectory = paths[0] as! String
    let path = (documentsDirectory as NSString).stringByAppendingPathComponent("UserData.plist")
    let myDict = NSDictionary(contentsOfFile: path)
    var array: Array<AnyObject>!
    if let dict = myDict {
        array = dict.objectForKey(variableName) as! Array<AnyObject>
    }
    return array
}

func getDataFromPlist(variableName: String) -> AnyObject {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
    let documentsDirectory = paths[0] as! String
    let path = (documentsDirectory as NSString).stringByAppendingPathComponent("UserData.plist")
    let myDict = NSDictionary(contentsOfFile: path)
    var data: AnyObject!
    if let dict = myDict {
        data = dict.objectForKey(variableName)
    } else {
        data = 0
    }
    return data
}