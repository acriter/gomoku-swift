//
//  BoardSquareView.swift
//  gomoku-swift
//
//  Created by Colin Cowles on 12/7/17.
//  Copyright © 2017 Colin Cowles. All rights reserved.
//

import UIKit

@IBDesignable
class BoardSquareView: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing:BoardSquareView.self), owner: self, options: nil)
        //self.contentView.frame = self.bounds
        //self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.layer.backgroundColor = UIColor.blue.cgColor
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5.0
    }
}
