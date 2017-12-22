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
    
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var increaseTargetButton: UIButton!
    @IBOutlet weak var decreaseTargetButton: UIButton!
    @IBOutlet weak var increaseHeightButton: UIButton!
    @IBOutlet weak var increaseWidthButton: UIButton!
    @IBOutlet weak var decreaseHeightButton: UIButton!
    @IBOutlet weak var decreaseWidthButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    let gridSizeMin = 3
    let gridSizeMax = 20
    let targetMin = 3
    var sidebarIsShowing = true
    var gridWidth = 8
    var gridHeight = 8
    var target = 5
    var gameBoardVC : GameBoardViewController? = nil
    
    @IBAction func startGame() {
        self.didTapHamburgerButton(sender: nil)
        
        if self.gameBoardVC != nil {
            self.gameBoardVC?.willMove(toParentViewController: nil)
            self.gameBoardVC?.view.removeFromSuperview()
            self.gameBoardVC?.removeFromParentViewController()
            self.gameBoardVC = nil
        }
        
        self.setUpGameBoard()
    }
    
    private func setUpGameBoard() {
        let gameBoardViewController = GameBoardViewController(gridWidth: gridWidth, gridHeight: gridHeight, target: target)
        self.gameBoardVC = gameBoardViewController
        addChildViewController(gameBoardViewController)
        gameBoardViewController.willMove(toParentViewController: self)
        gameBoardViewController.view.frame = CGRect(origin: CGPoint(x: 0, y: (self.navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height), size: self.view.frame.size)
        self.view.insertSubview(gameBoardViewController.view, belowSubview: self.sidebarView)
    }
    
    // MARK: - view functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftBarButtonImg = #imageLiteral(resourceName: "icons8-menu-50")
        let leftBarButtonItem = UIBarButtonItem(image: leftBarButtonImg, style: .plain, target: self, action: #selector(didTapHamburgerButton(sender:)))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        toggleSidebar(hide: !self.sidebarIsShowing, instant: true, completion: nil)
        refreshSidebarButtons()        
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
        
        self.gameBoardVC?.toggleOverlayView(hide: hide, delay: 0, completion: nil)
    }
    
    @objc private func didTapHamburgerButton(sender: UIBarButtonItem?) {
        toggleSidebar(hide: self.sidebarIsShowing, instant: false, completion: nil)
        self.sidebarIsShowing = !self.sidebarIsShowing
    }
    
    private func refreshSidebarButtons() {
        self.widthLabel.text = "\(self.gridWidth)"
        self.heightLabel.text = "\(self.gridHeight)"
        self.targetLabel.text = "\(self.target)"
        
        if self.target == self.targetMin {
            self.decreaseTargetButton.isEnabled = false
        } else {
            self.decreaseTargetButton.isEnabled = true
        }
        
        if self.target == max(self.gridWidth, self.gridHeight) {
            self.increaseTargetButton.isEnabled = false
        } else {
            self.increaseTargetButton.isEnabled = true
        }
        
        if self.gridWidth == self.gridSizeMin || (self.gridWidth > self.gridHeight && self.gridWidth == self.target) {
            self.decreaseWidthButton.isEnabled = false
        } else {
            self.decreaseWidthButton.isEnabled = true
        }
        
        if self.gridWidth == self.gridSizeMax {
            self.increaseWidthButton.isEnabled = false
        } else {
            self.increaseWidthButton.isEnabled = true
        }
        
        if self.gridHeight == self.gridSizeMin || (self.gridHeight > self.gridWidth && self.gridHeight == self.target) {
            self.decreaseHeightButton.isEnabled = false
        } else {
            self.decreaseHeightButton.isEnabled = true
        }
        
        if self.gridHeight == self.gridSizeMax {
            self.increaseHeightButton.isEnabled = false
        } else {
            self.increaseHeightButton.isEnabled = true
        }
    }
    
    @IBAction private func increaseTarget() {
        self.target += 1
        refreshSidebarButtons()
    }
    
    @IBAction private func decreaseTarget() {
        self.target -= 1
        refreshSidebarButtons()
    }
    
    @IBAction private func increaseWidth() {
        self.gridWidth += 1
        refreshSidebarButtons()
    }
    
    @IBAction private func decreaseWidth() {
        self.gridWidth -= 1
        refreshSidebarButtons()
    }
    
    @IBAction private func increaseHeight() {
        self.gridHeight += 1
        refreshSidebarButtons()
    }
    
    @IBAction private func decreaseHeight() {
        self.gridHeight -= 1
        refreshSidebarButtons()
    }
}

