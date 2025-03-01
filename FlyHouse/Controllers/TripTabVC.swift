//
//  TripTabVC.swift
//  FlyHouse
//
//  Created by Atul on 22/01/25.
//

import UIKit
import Foundation

class TripTabVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .Home
    
    @IBOutlet weak var myTripBtn: UIButton!
    @IBOutlet weak var pastReqBtn:UIButton!
    @IBOutlet var btnArr:[UIButton]!
    
    var firstChildVC: MyTripsVC!
    var secondChildVC: RequestListVC!

    @IBOutlet weak var containerView: UIView! // Connect this to the container view in your storyboard

    override func viewDidLoad() {
        super.viewDidLoad()
        super.showNavLogoImage()
        self.setSelectedButton(myTripBtn)
            // Instantiate child view controllers
        firstChildVC = MyTripsVC.storyboardViewController()
        secondChildVC = RequestListVC.storyboardViewController()
        CommonFunction.setBottomGradientShadowToView(vC: self)
        if APP_DELEGATE.tabIndex == 1 {
            self.setSelectedButton(pastReqBtn)
            displayChildViewController(secondChildVC)
        }else{
            // Add the first child view controller by default
            displayChildViewController(firstChildVC)
        }
        
    }

        
    func displayChildViewController(_ childVC: UIViewController) {
        // Remove any existing child view controller
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        // Add the new child view controller
        addChild(childVC)
        childVC.view.frame = containerView.bounds
        containerView.addSubview(childVC.view)
        childVC.didMove(toParent: self)
        
    }
    
    
    func setSelectedButton(_ button: UIButton) {
        
        for btn in btnArr {
            CommonFunction.setRoundedButtons(arrayB: [btn], radius: myTripBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: whiteColorCode, textColor: INPUTF_BORDER_COLOR)
            CommonFunction.setButtonFontsTypeWithSize(arrayB: [btn], size: 7, type: .fSemiBold, textColor: UIColor.hexStringToUIColor(hex: INPUTF_BORDER_COLOR))
        }
        CommonFunction.setRoundedButtons(arrayB: [button], radius: myTripBtn.frame.size.height/2, borderColorCode: blackColorCode, borderW: 1, bgColor: whiteColorCode, textColor: blackColorCode)
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [button], size: 7, type: .fSemiBold, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
    }
    

    @IBAction func switchToFirstChild(_ sender: UIButton) {
        self.setSelectedButton(sender)
        displayChildViewController(firstChildVC)
    }

    @IBAction func switchToSecondChild(_ sender: UIButton) {
        self.setSelectedButton(sender)
        displayChildViewController(secondChildVC)
    }
    
}
