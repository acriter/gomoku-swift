//
//  GameBoardViewController.swift
//  gomoku-swift
//
//  Created by Colin Cowles on 12/7/17.
//  Copyright © 2017 Colin Cowles. All rights reserved.
//

import UIKit

class GameBoardViewController: UICollectionViewController, GameUpdateDelegate {
    func AIMovedToSquare(tuple: (Int, Int)) {
        if let cell = collectionView?.cellForItem(at: IndexPath(row: tuple.1, section: tuple.0)) as? BoardSquareView {
            cell.changeToSquareType(type: .AI, instant: false)
            print("should update?")
        } else {
            print("shouldn't update...")
        }
    }
    
    func gameEnded() {
        self.toggleOverlayView(hide: false, delay: 0.4)
        print("woo game is over, winner is \(self.gameEngine.winner)")
    }
    
    
    let reuseIdentifier = "customCell"
    var gridWidth: Int
    var gridHeight: Int
    var target: Int
    var gameBoard: GameBoard
    var gameEngine: GameEngine
    
    var overlayViewIsShowing = false
    var overlayView : UIView? = nil
    
    init(gridWidth: Int, gridHeight: Int, target: Int) {
        self.gridWidth = gridWidth
        self.gridHeight = gridHeight
        self.target = target
        self.gameBoard = GameBoard(width: gridWidth, height: gridHeight)
        self.gameEngine = GameEngine(gameBoard: self.gameBoard, target: self.target)
        super.init(nibName: String(describing: GameBoardViewController.self), bundle: nil)
        self.gameEngine.gameUpdateDelegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.gridWidth = 0
        self.gridHeight = 0
        self.target = 0
        self.gameBoard = GameBoard(width: 0, height: 0)
        self.gameEngine = GameEngine(gameBoard: self.gameBoard, target: self.target)
        assertionFailure("should only create GameBoardViewController with model info")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.gridWidth = 0
        self.gridHeight = 0
        self.target = 0
        self.gameBoard = GameBoard(width: 0, height: 0)
        self.gameEngine = GameEngine(gameBoard: self.gameBoard, target: self.target)
        assertionFailure("should only create GameBoardViewController with model info")
        super.init(coder: aDecoder)
    }
    
    func toggleOverlayView(hide: Bool, delay: Double) {
        let targetOpacity = hide ? 0 : 0.6
        UIView.animate(withDuration: 1.2,
                       delay: delay,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut, animations: {
                        self.overlayView?.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(targetOpacity))
        }, completion: nil)
        self.overlayView?.isUserInteractionEnabled = hide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(BoardSquareView.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if (self.overlayView == nil) {
            let anOverlayView = UIView(frame: self.view.bounds)
            anOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0)
            anOverlayView.isUserInteractionEnabled = false
            self.view.insertSubview(anOverlayView, aboveSubview: self.collectionView!)
            self.overlayView = anOverlayView
        }
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
        if (self.gameEngine.playerCanMove()) {
            self.gameEngine.makePlayerMoveToSquare(tuple: (indexPath.section, indexPath.row))
        
            if let cell = collectionView.cellForItem(at: indexPath) as? BoardSquareView {
                cell.changeToSquareType(type: .Human, instant: false)
            }
        }
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
        
        let owner: GameEngine.Player = gameBoard.ownerForIndexPath(path: indexPath)
        cell.setUpCell(owner: owner)
        return cell
    }
}
