//
//  BoardSquareView.swift
//  gomoku-swift
//
//  Created by Colin Cowles on 12/7/17.
//  Copyright © 2017 Colin Cowles. All rights reserved.
//

import UIKit

class BoardSquareView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
