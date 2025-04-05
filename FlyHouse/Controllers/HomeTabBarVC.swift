//
//  Untitled.swift
//  FlyHouse
//
//  Created by Atul on 12/01/25.
//

import UIKit

class HomeTabBarVC: UITabBarController,Storyboardable {
    static let storyboardName :StoryBoardName = .Home
    
    var isFromReedem:Bool? = false
    let firstViewController = RequestVC()
    let secondViewController = TripTabVC()
    let thirdViewController = ProfileTabVC()
    let fourthViewController = LeftMenuViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        if self.isFromReedem == true{
            if let firstVC = self.viewControllers?[0] as? UINavigationController {
                if let controller = firstVC.viewControllers[0] as? RequestVC{
                    controller.isRedeem = "Yes"
                }
            }
        }
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
}
