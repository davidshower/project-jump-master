//
//  TNGConstants.swift
//  Jump Master
//
//  Created by David Xiao & Jian Ren Zhou on 9/9/15.
//  Copyright (c) 2015 Tiny Nova Games. All rights reserved.
//

import Foundation
import SpriteKit

var activeClouds = [TNGCloud]()

var currentScore: Int = 0
var currentScoreLabel = SKLabelNode()
var adsLoaded = false
var ghost: TNGGhost!

let ghostNames = [
    "Bloo",
    "Lemonade",
    "Mr. Orange",
    "Limeade",
    "Pinky Twinky",
    "Cyan Ryan",
    "Reddie Freddie",
    "Purp the Derp",
    "Color Confusion",
    "Howdy Powdy Wowdy Dowdy",
    "Rainbow",
    "Mrs. Checkmate",
    "Mr. Checkmate",
    "Ed",
    "Edd",
    "Eddy",
    "You Camo See Me",
    "Green Bean",
    "Purp the Slurp",
    "Mr. Orange Makeover",
    "What Did the Fox Say?",
    "Slime",
    "Grandpa G",
    "Grandpa G's Son",
    "Grandpa G's Grandson",
    "Chef Burnt Mr. Orange",
    "Chef Blueberry",
    "Chef Veggie Reggie",
    "Chef Flaming Hot Pepper",
    "Where Did My Eye Go?",
    "100101011101010",
    "Princess Mediocre",
    "Jump Master",
]