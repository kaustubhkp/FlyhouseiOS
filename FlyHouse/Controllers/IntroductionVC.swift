//
//  IntroductionVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class IntroductionVC: UIViewController,Storyboardable {
    static let storyboardName :StoryBoardName = .Main
    
    @IBOutlet weak var copyrightLabel:UILabel!
    @IBOutlet weak var loginBtn:UIButton!
    @IBOutlet weak var loginEmailBtn:UIButton!
    @IBOutlet weak var registerNewBtn:UIButton!
    @IBOutlet weak var arrowImage:UIImageView!
    @IBOutlet weak var arrowEmailImage:UIImageView!
    
    @IBOutlet var buttonArr:[UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        // Do any additional setup after loading the view.
        
        
//        let arrowimage = UIImage(named: "right_arrow")?.withRenderingMode(.alwaysTemplate)
//        self.arrowImage.tintColor = UIColor.black
//        self.arrowImage.image = arrowimage
//        self.arrowEmailImage.tintColor = UIColor.black
//        self.arrowEmailImage.image = arrowimage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewsControl()
        self.APIGetAllUrls()
    }
    
    func setupViewsControl(){
        
        CommonFunction.setRoundedButtons(arrayB: [loginBtn,loginEmailBtn], radius: self.loginBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: buttonBGColor, textColor: blackColorCode)
        
        CommonFunction.setRoundedButtons(arrayB: [loginEmailBtn], radius: self.loginEmailBtn.frame.size.height/2, borderColorCode: whiteColorCode, borderW: 1, bgColor: "", textColor: whiteColorCode)
        
        loginBtn.setTitle("Login with Phone", for: .normal)
        loginEmailBtn.setTitle("Continue", for: .normal)
        registerNewBtn.setTitle("Create account", for: .normal)
        
        //loginBtn.titleLabel?.font = UIFont.BoldWithSize(size: 18)
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [loginBtn], size: 11, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [loginEmailBtn,registerNewBtn], size: 11, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: whiteColorCode))
        
    }
    
    func setSelectedButton(sender:UIButton){
        
        for btn in buttonArr{
            btn.layer.borderColor = UIColor.hexStringToUIColor(hex: whiteColorCode).cgColor
            btn.layer.borderWidth = 0
        }
        sender.layer.borderWidth = 2
    }
    
    func APIGetAllUrls(){
        
        let urlStr = String(format: "%@/UserDevice/GetAllAppUrls", APIUrl.baseUrl)
        
        APILogin.shared.getAppAllUrls(urlStr: urlStr) { response in
            //
            if response.result == "success"{
                if response.data != nil{
                    let resultData = response.data!
                    CommonFunction.setAPIUrlsSettingsAndVersion(data: resultData)
                }
            }
            
        } fail: { error in
            print("Error:\(error.localizedDescription)")
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton){
        
        self.setSelectedButton(sender: sender)
        let loginVC = LoginVC.storyboardViewController()
        loginVC.loginWithPhone = true
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    @IBAction func emailButtonClicked(_ sender: UIButton){
        
        self.setSelectedButton(sender: sender)
        let loginVC = LoginVC.storyboardViewController()
        loginVC.loginWithPhone = false
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    @IBAction func registerNewBtnClicked(_ sender : UIButton){
        let registration = RegisterVC.storyboardViewController()
        self.navigationController?.pushViewController(registration, animated: true)
    }

}
