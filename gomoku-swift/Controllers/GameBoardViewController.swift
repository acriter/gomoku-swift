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
    
    override func awakeFromNib() {
        //collectionView?.register(BoardSquareView.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(BoardSquareView.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView functions
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sizeOfGrid
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizeOfGrid
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        return
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        return
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("highlighted")
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
