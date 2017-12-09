//
//  MainScreenViewController.swift
//  gomoku-swift
//
//  Created by Colin Cowles on 12/7/17.
//  Copyright © 2017 Colin Cowles. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var sidebarView: UIView!
    
    var sidebarIsShowing = false
    var gridWidth = 10
    var gridHeight = 10
    var target = 5
    
    private func setUpGameBoard() {
        let gameBoardVC = GameBoardViewController(gridWidth: gridWidth, gridHeight: gridHeight, target: target)
        addChildViewController(gameBoardVC)
        gameBoardVC.didMove(toParentViewController: self)
        
        gameBoardVC.view.frame = self.view.bounds
        self.view.insertSubview(gameBoardVC.view, belowSubview: self.sidebarView)
    }
    
    // MARK: - view functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftBarButtonImg = #imageLiteral(resourceName: "icons8-menu-50")
        let leftBarButtonItem = UIBarButtonItem(image: leftBarButtonImg, style: .plain, target: self, action: #selector(didTapHamburgerButton(sender:)))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        toggleSidebar(hide: true, instant: true, completion: nil)
        
        setUpGameBoard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - sidebar functions
    
    private func toggleSidebar(hide: Bool, instant: Bool, completion: ((Bool) -> Void)?) {
        let targetPosition = hide ? CGPoint(x: -sidebarView.frame.size.width, y: 0) : CGPoint(x: -5, y: 0)
        UIView.animate(withDuration: instant ? 0 : 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut, animations: {
                        self.sidebarView.frame.origin = targetPosition
        }, completion: completion)
    }
    
    @objc private func didTapHamburgerButton(sender: UIBarButtonItem) {
        toggleSidebar(hide: self.sidebarIsShowing, instant: false, completion: nil)
        self.sidebarIsShowing = !self.sidebarIsShowing
    }
}

