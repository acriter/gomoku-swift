//
//  GameBoardViewController.swift
//  gomoku-swift
//
//  Created by Colin Cowles on 12/7/17.
//  Copyright © 2017 Colin Cowles. All rights reserved.
//

import UIKit

class GameBoardViewController: UICollectionViewController {
    
    let reuseIdentifier = "customCell"
    var gridWidth: Int
    var gridHeight: Int
    var target: Int
    var gameBoard: GameBoard
    
    init(gridWidth: Int, gridHeight: Int, target: Int) {
        self.gridWidth = gridWidth
        self.gridHeight = gridHeight
        self.target = target
        self.gameBoard = GameBoard(width: gridWidth, height: gridHeight)
        super.init(nibName: String(describing: GameBoardViewController.self), bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.gridWidth = 0
        self.gridHeight = 0
        self.target = 0
        self.gameBoard = GameBoard(width: 0, height: 0)
        assertionFailure("should only create GameBoardViewController with model info")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.gridWidth = 0
        self.gridHeight = 0
        self.target = 0
        self.gameBoard = GameBoard(width: 0, height: 0)
        assertionFailure("should only create GameBoardViewController with model info")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(BoardSquareView.self, forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView?.register(UINib.init(nibName: String(describing: BoardSquareView.self), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView functions
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gridWidth
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridHeight
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BoardSquareView {
            cell.changeToSquareType(type: .Human)
        }
        return
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        return
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        return
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        return
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BoardSquareView
        return cell
    }
}
