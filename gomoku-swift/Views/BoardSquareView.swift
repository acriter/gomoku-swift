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
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5.0
        self.changeToSquareType(type: .NoOne)
    }
    
    public func changeToSquareType(type: BoardSquare.SquareOwner) {
        var color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        switch type {
        case .AI:
            color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .Human:
            color = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        case .NoOne:
            color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut, animations: {
                        self.contentView.backgroundColor = color
        }, completion: nil)
    }
}
