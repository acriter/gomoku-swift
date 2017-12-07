//
//  GameBoardViewController.swift
//  gomoku-swift
//
//  Created by Colin Cowles on 12/7/17.
//  Copyright © 2017 Colin Cowles. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {
    
    var sizeOfGrid: Int
    var target: Int
    
    init(gridSize: Int, target: Int) {
        self.sizeOfGrid = gridSize
        self.target = target
        super.init(nibName: String(describing: GameBoardViewController.self), bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.sizeOfGrid = 0
        self.target = 0
        assertionFailure("should only create GameBoardViewController with model info")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sizeOfGrid = 0
        self.target = 0
        assertionFailure("should only create GameBoardViewController with model info")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
