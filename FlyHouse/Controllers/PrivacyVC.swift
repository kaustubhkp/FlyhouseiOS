//
//  PrivacyVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 23/04/24.
//

import UIKit

class PrivacyVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .Privacy
    
    @IBOutlet weak var titleLable1:UILabel!
    @IBOutlet weak var titleLable2:UILabel!
    @IBOutlet weak var titleLable3:UILabel!
    @IBOutlet weak var privacyBtn:UIButton!
    var titleStr:String! = ""
    var pUrl:String! = APPUrls.privacyURL
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setBackButton(viewC: self)
        self.getPrivacyBaseUrl()
        super.setNavigationTitle(title: titleStr)
        // Do any additional setup after loading the view.
        CommonFunction.setLabelsFonts(lbls: [titleLable1], type: .fMedium, size: 10)
        CommonFunction.setLabelsFonts(lbls: [titleLable2], type: .fReguler, size: 9)
        CommonFunction.setLabelsFonts(lbls: [titleLable3], type: .fReguler, size: 6)
        CommonFunction.setRoundedButtonsWithColor(arrayB: [privacyBtn], radius: privacyBtn.frame.size.height/2, borderColor: UIColor.clear, borderW: 0, bgColor: UIColor.hexStringToUIColor(hex: blackColorCode), textColor: UIColor.hexStringToUIColor(hex: whiteColorCode))
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    @IBAction func privacyBtnClicked(_ sender: UIButton){
        
        var userId = 0
        if UserDefaults.standard.value(forKey: "UserLoginUserId") != nil{
            userId = (UserDefaults.standard.value(forKey: "UserLoginUserId") as! Int)
        }
        var token:String! = ""
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            token = (UserDefaults.standard.value(forKey: "Authorization") as! String)
        }
        self.open(url: "\(self.pUrl!)/flyhouseprivacycenter/cPrivacyCenter.aspx?uid=\(userId)&token=\(token!)")
    }
    
    func getPrivacyBaseUrl(){
        self.view.makeToastActivity(.center)
       
        let urlStr = String(format: "%@/UserDevice/GetPrivacyCenterBaseURL", APIUrl.baseUrl)
        
        APILogin.shared.getBaseURL(urlStr: urlStr) { response in
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.data != nil{
                    self.pUrl = response.data!
                }else{
                    if response.title != nil && response.description != nil{
                        CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                            
                        }
                    }
                }
            }else{
                if response.title != nil && response.description != nil{
                    CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                        
                    }
                }
            }
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    func clearData(){
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        APP_DELEGATE.setMainController()
    }
    
    func open(url: String) {
       if let url = URL(string: url) {
          if #available(iOS 10, *) {
             UIApplication.shared.open(url, options: [:],
               completionHandler: {
                   (success) in
                    self.clearData()
               })
         } else {
             let success = UIApplication.shared.openURL(url)
             if success{
                 self.clearData()
             }
         }
       }
     }
}

extension PrivacyVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
}
