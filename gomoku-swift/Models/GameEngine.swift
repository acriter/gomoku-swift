//
//  GameEngine.swift
//  gomoku-swift
//
//  Created by Colin Cowles on 12/7/17.
//  Copyright © 2017 Colin Cowles. All rights reserved.
//

import UIKit

class GameEngine: NSObject {
    enum Player {
        case NoOne, AI, Human
    }
    
    let target: Int
    let gameBoard: GameBoard
    let scoring: Scoring
    var currentPlayer: GameEngine.Player
    
    init(gameBoard: GameBoard, target: Int) {
        self.gameBoard = gameBoard
        self.target = target
        self.scoring = Scoring(target: target)
        self.currentPlayer = .NoOne
        super.init()
    }
    
    private func advancePlayer() {
        if (self.currentPlayer == .NoOne) {
            //who should go first? not sure
            self.currentPlayer = .Human
        } else if (self.currentPlayer == .Human) {
            self.currentPlayer = .AI
        } else if (self.currentPlayer == .AI) {
            self.currentPlayer = .Human
        }
    }
}

class Scoring : NSObject {
    enum Direction {
        case Horizontal, Vertical, DiagonalPos, DiagonalNeg
    }
    
    //how many do you need to win?
    let target: Int
    
    //how many in a row are there with self move?
    var horiz, vert, diagPos, diagNeg: Int
    
    //how many friendly pieces were found nearby (with no more than a couple gaps in the middle)?
    var horizNearbyBonus, vertNearbyBonus, diagPosNearbyBonus, diagNegNearbyBonus: Int
    
    //are there some empty squares on both sides?
    var horizBothSidesEmpty, vertBothSidesEmpty, diagPosBothSidesEmpty, diagNegBothSidesEmpty: Bool
    
    init(target: Int) {
        self.target = target
        super.init()
    }
    
    func AddDirection(dir: Direction, consecutive: Int, nearbyBonus: Int, bothSidesEmpty: Bool) {
        switch (dir) {
        case Direction.Horizontal:
            self.horiz = consecutive
            self.horizNearbyBonus = nearbyBonus
            self.horizBothSidesEmpty = bothSidesEmpty
        case Direction.Vertical:
            self.vert = consecutive
            self.vertNearbyBonus = nearbyBonus
            self.vertBothSidesEmpty = bothSidesEmpty
        case Direction.DiagonalPos:
            self.diagPos = consecutive
            self.diagPosNearbyBonus = nearbyBonus
            self.diagPosBothSidesEmpty = bothSidesEmpty
            break
        case Direction.DiagonalNeg:
            self.diagNeg = consecutive
            self.diagNegNearbyBonus = nearbyBonus
            self.diagNegBothSidesEmpty = bothSidesEmpty
            break
        }
    }
    
    public func MoveWins() -> Bool {
        return max(self.horiz, self.vert, self.diagNeg, self.diagPos) >= self.target
    }
    
    public func MoveIsForcing() -> Bool {
        //if you can make n-1 in a row and both sides are empty, you are guaranteed to win
        let forcedWinWithBothSidesEmpty = self.target - 1
        if (self.horiz == forcedWinWithBothSidesEmpty && self.horizBothSidesEmpty ||
            self.vert == forcedWinWithBothSidesEmpty && self.vertBothSidesEmpty ||
            self.diagPos == forcedWinWithBothSidesEmpty && self.diagPosBothSidesEmpty ||
            self.diagNeg == forcedWinWithBothSidesEmpty && self.diagNegBothSidesEmpty) {
            return true
        }
        
        //put any other guaranteed forcing moves here
        return false
    }
    
    public func MoveIsLikelyForcing() -> Bool {
        return self.LikelyForcingMoveScore() > 0
    }
    
    public func LikelyForcingMoveScore() -> Int {
        let chainLengthToWin = self.target
        if (chainLengthToWin < 4) {
            return 0
        }
        
        //if you can make 2 n-2s in a row, it's likely you'll win, based on how many empty squares are around
        // (you need both sides of each n-2 to be empty, and for one of those to have two+ empties on one side)
        let likelyWinLength = chainLengthToWin - 2
        var directionsMeetingCriteria = 0
        if (self.horiz == likelyWinLength && self.horizBothSidesEmpty) {
            directionsMeetingCriteria += 1
        }
        if (self.vert == likelyWinLength && self.vertBothSidesEmpty) {
            directionsMeetingCriteria += 1
        }
        if (self.diagPos == likelyWinLength && self.diagPosBothSidesEmpty) {
            directionsMeetingCriteria += 1
        }
        if (self.diagNeg == likelyWinLength && self.diagNegBothSidesEmpty) {
            directionsMeetingCriteria += 1
        }
        
        if (directionsMeetingCriteria < 2) {
            return 0
        } else {
            return directionsMeetingCriteria
        }
    }
    
    public func TotalScore() -> Double {
        let nearbyBonuses = Double(diagNegNearbyBonus + diagPosNearbyBonus + vertNearbyBonus + horizNearbyBonus) / 6.0
        let consecutiveBonuses = Double(diagNeg + diagPos + vert + horiz) / 2.0
        let forcingMoveBonuses = Double(self.LikelyForcingMoveScore()) * 3.0
        return forcingMoveBonuses + nearbyBonuses + consecutiveBonuses
    }
}
