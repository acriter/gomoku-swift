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
    
    private var lowestRowWithStone = Int.max
    private var highestRowWithStone = Int.min
    private var lowestColumnWithStone = Int.max
    private var highestColumnWithStone = Int.min
    private var friendlyStonesPlaced = 0;
    
    
    func ScoreForMoveToSquareWithStatus(tuple: (Int, Int), player: GameEngine.Player) -> Scoring {
        return Scoring(target: self.target)
    }
    
    func BestMove() -> (Int, Int) {
        /* AI implentation:
         * 0) If no friendly pieces are placed, pick an unoccupied center square
         * 1) If move would win, play that move
         * 2) If move would prevent opponent from winning, play that move
         * 3) If move would create an unstoppable threat, play that move
         * 4) If move would prevent opponent from creating said unstoppable threat, play that move
         * 4b/c) Play or prevent a threat that might be unstoppable, but I didn't gather enough score data to tell
         * 5) Evaluate using naive and arbitrary score based on maximizing size of open-ended own-color chains and likely forcing moves
         * 6) [Unimplemented] If score is tied in 5, pick a random qualifying square closest to the "average position" of our pieces
         *
         * For pruning purposes, do not consider moves more than two places (row or column) away from an existing piece
         * The AI only looks for two different "unstoppable threats".
         *   There are likely many more that the machine does not currently look for specifically, but might find with step 5.
         * The AI only looks 1 ply deep.
         */
        var ret: (Int, Int)?
        
        //these "categories" correspond to the cases above, in order from most to least forcing move
        var category2Square: (Int, Int)?
        var category3Square: (Int, Int)?
        var category4Square: (Int, Int)?
        var candidateForForcingMoveScore = 0.0
        var candidateForForcingMoveSquare: (Int, Int)?
        
        var bestScore = -1.0
        var bestScoringSquare: (Int, Int)?
        
        let boardSize = self.target
        if (self.friendlyStonesPlaced == 0) {
            /* Case 0 */
            let middle = boardSize / 2
            var middleSquare1Owner = gameBoard.ownerForTuple(tuple: (middle, middle))
            if (middleSquare1Owner == Player.NoOne) {
                ret = (middle, middle)
            } else {
                if (boardSize == 3) {
                    //don't auto-lose in tic-tac-toe :)
                    ret = (0, 0)
                } else {
                    ret = (middle - 1, middle)
                }
            }
        } else {
            //prune outside squares
            var minRow = max(0, self.lowestRowWithStone - 2)
            var maxRow = min(boardSize - 1, self.highestRowWithStone + 2)
            var minCol = max(0, self.lowestColumnWithStone - 2)
            var maxCol = min(boardSize - 1, self.highestColumnWithStone + 2)
            
            var finished = false
            
            for i in minRow...maxRow where !finished {
                for j in minCol...maxCol where !finished {
                    var square = (i, j)
                    if (gameBoard.ownerForTuple(tuple: square) != .NoOne) {
                        continue
                    }
                    
                    let aiScoreForSquare = self.ScoreForMoveToSquareWithStatus(tuple: square, player: .AI)
                    if (aiScoreForSquare.MoveWins()) {
                        /* Case 1 */
                        ret = square
                        finished = true
                        break
                    }
                    
                    let humanScoreForSquare = self.ScoreForMoveToSquareWithStatus(tuple: square, player: .Human)
                    if (humanScoreForSquare.MoveWins()) {
                        /* Case 2 */
                        if (category2Square == nil) {
                            category2Square = square
                        }
                        continue
                    }
                    
                    if (aiScoreForSquare.MoveIsForcing()) {
                        /* Case 3 */
                        if (category3Square == nil) {
                            category3Square = square
                        }
                        continue
                    }
                    
                    if (humanScoreForSquare.MoveIsForcing()) {
                        /* Case 4 */
                        if (category4Square == nil) {
                            category4Square = square
                        }
                        continue
                    }
                    
                    if (aiScoreForSquare.MoveIsLikelyForcing()) {
                        /* Case 4b/c */
                        if (aiScoreForSquare.TotalScore() > candidateForForcingMoveScore) {
                            candidateForForcingMoveScore = Double(aiScoreForSquare.LikelyForcingMoveScore())
                            candidateForForcingMoveSquare = square
                        }
                    }
                    
                    if (humanScoreForSquare.MoveIsLikelyForcing()) {
                        /* Case 4b/c */
                        if (humanScoreForSquare.TotalScore() > candidateForForcingMoveScore) {
                            candidateForForcingMoveScore = Double(humanScoreForSquare.LikelyForcingMoveScore())
                            candidateForForcingMoveSquare = square
                        }
                    }
                    
                    if (aiScoreForSquare.TotalScore() > bestScore) {
                        /* Case 5 */
                        bestScore = aiScoreForSquare.TotalScore()
                        bestScoringSquare = square
                    }
                }
            }
        }
        
        //if it's set already, it's category 1
        if (ret == nil) {
            if (category2Square != nil) {
                ret = category2Square
            } else if (category3Square != nil) {
                ret = category3Square
            } else if (category4Square != nil) {
                ret = category4Square
            } else if (candidateForForcingMoveSquare != nil) {
                ret = candidateForForcingMoveSquare
            } else {
                ret = bestScoringSquare
            }
        }
        
        print("Best score: \(bestScore) for square \(ret ?? (-1, -1))")
        
        if (ret == nil) {
            print("Game is over, probably!")
        } else {
            self.UpdateSearchBoundsForPlayedSquare(tuple: ret!)
            self.friendlyStonesPlaced += 1
        }
        
        return ret!
    }
    
    private func UpdateSearchBoundsForPlayedSquare(tuple: (Int, Int)) {
        let x = tuple.0
        let y = tuple.1
        //possible for both of each pair to be true, but only for the first piece
        if (self.highestRowWithStone < x) {
            self.highestRowWithStone = x;
        }
        if (self.lowestRowWithStone > x) {
            self.lowestRowWithStone = x;
        }
        if (self.highestColumnWithStone < y) {
            self.highestColumnWithStone = y;
        }
        if (self.lowestColumnWithStone > y) {
            self.lowestColumnWithStone = y;
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
