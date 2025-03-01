//
//  Untitled.swift
//  FlyHouse
//
//  Created by Atul on 12/01/25.
//

import UIKit

class HomeTabBarVC: UITabBarController,Storyboardable {
    static let storyboardName :StoryBoardName = .Home
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
}
