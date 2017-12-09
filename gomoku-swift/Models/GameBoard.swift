//
//  GameBoard.swift
//  gomoku-swift
//
//  Created by Colin Cowles on 12/7/17.
//  Copyright © 2017 Colin Cowles. All rights reserved.
//

import UIKit

class GameBoard: NSObject {
    let width: Int
    let height: Int
    private let squares: [[BoardSquare]]
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        var squareArr = [[BoardSquare]]()
        for i in 0...self.height - 1 {
            squareArr.append([BoardSquare]())
            for _ in 0...self.width - 1 {
                squareArr[i].append(BoardSquare())
            }
        }
        self.squares = squareArr
        
        super.init()
    }
    
    func setOwnerForIndexPath(owner: GameEngine.Player, path: IndexPath) {
        self.squareForIndexPath(path: path).owner = owner
    }
    
    func ownerForIndexPath(path: IndexPath) -> GameEngine.Player {
        return self.squareForIndexPath(path: path).owner
    }
    
    func ownerForTuple(tuple: (Int, Int)) -> GameEngine.Player {
        return self.ownerForIndexPath(path: IndexPath(row: tuple.0, section: tuple.1))
    }
    
    private func squareForIndexPath(path: IndexPath) -> BoardSquare {
        return self.squareForRow(row: path.row, column: path.section)
    }
    
    private func squareForRow(row: Int, column: Int) -> BoardSquare {
        return self.squares[row][column]
    }
}
