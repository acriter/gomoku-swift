//
//  BoardSquare.swift
//  gomoku-swift
//
//  Created by Colin Cowles on 12/7/17.
//  Copyright © 2017 Colin Cowles. All rights reserved.
//

import UIKit

class BoardSquare: NSObject {
    enum SquareOwner {
        case NoOne, AI, Human
    }
    
    var owner: SquareOwner = .NoOne
    //allow multiple AI to play???
    
}
