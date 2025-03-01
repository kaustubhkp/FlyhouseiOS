//
//  AppUpdatePopupVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 08/05/24.
//

import UIKit

class AppUpdatePopupVC: UIViewController,Storyboardable {
    
    static let storyboardName :StoryBoardName = .Login
    
    var updateString:String! = ""
    @IBOutlet weak var updateLabel:UILabel!
    @IBOutlet weak var okButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateLabel.text = self.updateString
    }

    @IBAction func okButtonClicked(_ sender: UIButton){
        
        let storeUrl = CommonFunction.getValueFromForKey(key: "appstoreurl")
        guard let url = URL(string: storeUrl) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

}
