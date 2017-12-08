//
//  GameBoard.swift
//  gomoku-swift
//
//  Created by Colin Cowles on 12/7/17.
//  Copyright © 2017 Colin Cowles. All rights reserved.
//

import UIKit

class GameBoard: NSObject {
    var width: Int
    var height: Int
    var squares: Array<[BoardSquare]>
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.squares = Array(repeating: Array(repeating: BoardSquare(), count: width), count: height)
        super.init()
    }
    
    func squareForIndexPath(path: NSIndexPath) -> BoardSquare {
        return self.squareForRow(row: path.row, column: path.section)
    }
    
    func squareForRow(row: Int, column: Int) -> BoardSquare {
        return self.squares[column][row]
    }
}
