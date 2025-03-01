//
//  VerificationCodeVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class VerificationCodeVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .Verification
    
    @IBOutlet weak var verifiacationTableView:UITableView!
    var isMobileVerified:Bool! = false
    var isEmailVerified:Bool! = false
    var vCode:String! = ""
    var captchaArray = NSMutableArray()
    var userData = RegisteredUserData()
    var isVerifiedCodeCall:Bool! = false
    @IBOutlet weak var verifyBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        super.setNavigationTitle(title: "Verification")
        self.setRightButton(viewC: self, imageName: "", title: "3 of 3")
        self.rightButton.isEnabled = false
        super.delegateNav = self
        super.setBackButton(viewC: self)
        // Do any additional setup after loading the view.
        
        for _ in 0...1{
            let captcha = CommonFunction.randomCaptchaString(length: 4)
            self.captchaArray.add(captcha)
        }
        
        verifiacationTableView.delegate = self
        verifiacationTableView.dataSource = self
        verifiacationTableView.register(UINib(nibName: TableCells.HeaderImageCell, bundle: nil), forCellReuseIdentifier: TableCells.HeaderImageCell)
        verifiacationTableView.register(UINib(nibName: TableCells.VerificationCodeCell, bundle: nil), forCellReuseIdentifier: TableCells.VerificationCodeCell)
        
        self.isMobileVerified = true
    }
    
    func APICallVerifyCode(typeID:Int){
        self.view.makeToastActivity(.center)
        
        var userId = 0
        if UserDefaults.standard.value(forKey: "UserLoginUserId") != nil{
            userId = (UserDefaults.standard.value(forKey: "UserLoginUserId") as! Int)
        }
        
        let parameters = ["UserID": userId,
                          "VerificationTypeID": typeID,
                          "VerificationCode": self.vCode!] as [String: Any]
        
        //finalcode
        let urlStr = String(format: "%@/User/VerifyEmailMobileCode", APIUrl.baseUrl)
        
        APILogin.shared.verifyMobileEmailCode(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
            if response.data != nil{
                if response.data == 1{
                   
                    DispatchQueue.main.async {
                        
                        if self.isMobileVerified == true{
                            if typeID == 2{
                                self.gotoHome()
                            }
                        }else{
                            if typeID == 1 {
                                if self.isEmailVerified == false{
                                    self.isMobileVerified = true
                                    self.verifiacationTableView.reloadData()
                                }else{
                                    self.gotoHome()
                                }
                            }else{
                                self.isEmailVerified = true
                                self.verifiacationTableView.reloadData()
                            }
                        }
                    }
                    
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
    
    func gotoHome(){
        if self.userData.firstName != nil && self.userData.lastName != nil{
            let dName = String(format: "%@ %@", self.userData.firstName!,self.userData.lastName!)
            UserDefaults.standard.set(dName, forKey: "UserProfileName")
        }
        
        if self.userData.userID != nil{
            UserDefaults.standard.set(self.userData.userID!, forKey: "UserProfileID")
        }
        
        if self.userData.mobileNum != nil{
            UserDefaults.standard.set(String(self.userData.mobileNum!), forKey: "UserLoginMobile")
        }
        
        
        UserDefaults.standard.set(true, forKey: "isUserVerified")
        UserDefaults.standard.synchronize()
        APP_DELEGATE.createMenuView()
    }
    
    func APICallResendEmailMobileVerificationCode(typeId:Int){
        self.view.makeToastActivity(.center)
        
        var userId = 0
        if UserDefaults.standard.value(forKey: "UserLoginUserId") != nil{
            userId = (UserDefaults.standard.value(forKey: "UserLoginUserId") as! Int)
        }
        
        let parameters = ["UserID": userId,
                          "VerificationTypeID": typeId] as [String: Any]
        
        //finalcode
        let urlStr = String(format: "%@/User/ResendEmailMobileVerificationCode", APIUrl.baseUrl)
        
        APILogin.shared.resendVerificationCode(urlStr: urlStr, param: parameters) { response in
          
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.title != nil && response.description != nil{
                    CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                        
                    }
                }
            }else{
                if response.title != nil && response.description != nil{
                    CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                        
                    }
                }
            }
            
        }fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }

}

extension VerificationCodeVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension VerificationCodeVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else {
            if self.isMobileVerified == true && self.isEmailVerified == true {
                return 0
            }else if self.isMobileVerified == false && self.isEmailVerified == false{
                return 2
            }else{
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.HeaderImageCell, for: indexPath) as! HeaderImageCell
            
            cell.imageBGView.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.VerificationCodeCell, for: indexPath) as! VerificationCodeCell
            
            cell.delegate = self
            cell.configuerCell(indexPath: indexPath,isMobileVerify: self.isMobileVerified,isEmailVerify:self.isEmailVerified,captcha: captchaArray[indexPath.row] as! String)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}

extension VerificationCodeVC : VerificationCodeCellDelegate{
    
    func reloadData() {
        self.verifiacationTableView.reloadData()
    }
    
    func refreshCaptcha(captchacode: String, atIndex: Int) {
        
        self.captchaArray.replaceObject(at: atIndex, with: captchacode)
        self.verifiacationTableView.reloadData()
    }
    
    func resendBtnPressed(sender: UIButton ,captchacode:String) {
        print(sender.tag)
        //self.captchaArray.replaceObject(at: sender.tag, with: captchacode)
        //self.verifiacationTableView.reloadData()
        self.APICallResendEmailMobileVerificationCode(typeId: 2)
    }
    
    func verifyBtnPressed(sender: UIButton,code:String) {
        
        print(code)
        self.vCode = code
        if sender.tag == 0 && self.isMobileVerified == false{
            //print("Mobile verification code")
            self.isVerifiedCodeCall = true
            self.APICallVerifyCode(typeID: 1)
        }else{
            //print("E-Mail verification code")
            self.APICallVerifyCode(typeID: 2)
        }
    }
    
    func cancelBtnPressed(captchacode: String, atIndex: Int) {
        self.captchaArray.replaceObject(at: atIndex, with: captchacode)
        self.verifiacationTableView.reloadData()
    }
    
    func checkBtnPressed(enteredCaptcha: String, atIndex: Int) {
        //print(enteredCaptcha)
        //print(atIndex)
        if atIndex == 0{
            self.APICallResendEmailMobileVerificationCode(typeId: 1)
        }else{
            self.APICallResendEmailMobileVerificationCode(typeId: 2)
        }
    }
}

extension VerificationCodeVC : VerificationCodeCheckVCDelegate{
    
    func didCheckCode(code:String) {
        print(code)
    }
}

/*///////////////////////////////////////////////////////////////// */

@objc protocol VerificationCodeCheckVCDelegate{
    
    @objc optional
    func didCheckCode(code:String)
}

class VerificationCodeCheckVC: UIViewController,Storyboardable {
    static let storyboardName :StoryBoardName = .Verification
    
    var delegate:VerificationCodeCheckVCDelegate?
    @IBOutlet weak var codeTextF:UITextField!
    @IBOutlet weak var mainPopupView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CommonFunction.setRoundedViews(arrayB: [mainPopupView], radius: 10, borderColorCode: "", borderW: 0, bgColor: blackColorCode)
    }
    
    @IBAction func checkBtnClicked(_ sender : UIButton){
        self.delegate?.didCheckCode?(code: self.codeTextF.text!.trimmingCharacters(in: .whitespaces))
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelBtnClicked(_ sender :UIButton){
        self.dismiss(animated: true)
    }
}
