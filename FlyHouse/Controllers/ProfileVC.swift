//
//  ProfileVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class ProfileVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .Profile
    
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var submitButton:UIButton!
    @IBOutlet weak var userNameLabel:UILabel!
    
    @IBOutlet weak var fnameTextField:UITextField!
    @IBOutlet weak var mnameTextField:UITextField!
    @IBOutlet weak var lnameTextField:UITextField!
    @IBOutlet weak var streetTextView:UITextView!
    @IBOutlet weak var cityTextField:UITextField!
    @IBOutlet weak var stateTextField:UITextField!
    @IBOutlet weak var countryTextField:UITextField!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var cPasswordTextField:UITextField!
    @IBOutlet weak var addUserEmailTextField:UITextField!
    @IBOutlet weak var mobileTextField:UITextField!
    @IBOutlet weak var termsBtn:UIButton!
    @IBOutlet weak var yesBtn:UIButton!
    @IBOutlet weak var noBtn:UIButton!
    var titleStr: String! = ""
    
    var userData:RegisteredUserData!
    var userId:Int! = -1
    
    @IBOutlet var fieldsTitleArr:[UILabel]!
    @IBOutlet var fieldsArr:[UITextField]!
    @IBOutlet var smsBtnArr:[UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setNavigationTitle(title: self.titleStr)
        self.setBackButton(viewC: self)
        super.delegateNav = self
        // Do any additional setup after loading the view.
        /*profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.backgroundColor = UIColor.gray
        profileImage.layer.borderColor = UIColor.systemYellow.cgColor
        profileImage.layer.borderWidth = 3*/
        
        self.submitButton.isEnabled = false
        CommonFunction.setRoundedButtons(arrayB: [submitButton], radius: self.submitButton.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: lightGrayColorCode, textColor: blackColorCode)
        
        CommonFunction.setTextFieldPlaceHolder(txtF: addUserEmailTextField, pholderText: "Enter additional user email",size: 11,color: UIColor.hexStringToUIColor(hex: lightGrayColorCode),tColor: UIColor.white)
        
        if UserDefaults.standard.value(forKey: "UserLoginUserId") != nil{
            self.userId = (UserDefaults.standard.value(forKey: "UserLoginUserId") as! Int)
        }
        
        self.noBtn.setImage(UIImage(named: "selected"), for: .normal)
        self.setFieldsBGColor()
        
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserData()
    }
    
    func setFieldsBGColor(){
        
        self.streetTextView.backgroundColor = UIColor.hexStringToUIColor(hex: INPUT_VIEW_BG_COLOR)
        self.stateTextField.textColor = UIColor.white
        for txtf in fieldsArr{
            
            txtf.tintColor = UIColor.black
            txtf.backgroundColor = UIColor.hexStringToUIColor(hex: INPUT_VIEW_BG_COLOR)
            txtf.textColor  = UIColor.black
        }
        
        for lbl in fieldsTitleArr{
            lbl.textColor = UIColor.black
        }
        
        self.streetTextView.textColor = UIColor.black
        self.streetTextView.tintColor = UIColor.black
    }
    
    
    
    func getUserData(){
        self.view.makeToastActivity(.center)
        
        //finalcode
        let urlStr = String(format: "%@/User/Get/%@", APIUrl.baseUrl,String(self.userId))
        
        //let urlStr = String(format: "%@/GetAirports", APIUrl.baseUrl)
        
        APIUser.shared.getUser(urlStr: urlStr) { response in
            self.view.hideToastActivity()
            if response.result?.lowercased() == "success"{
                if response.data != nil{
                    self.userData = response.data!
                    self.setUserData()
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
    
    func setUserData(){
        
        self.userNameLabel.text = String(format: "%@ %@", self.userData.firstName!,self.userData.lastName!)
        self.fnameTextField.text = self.userData.firstName!
        self.mnameTextField.text = self.userData.middleName!
        self.lnameTextField.text = self.userData.lastName!
        self.mobileTextField.text = self.userData.phoneNumber!
        self.streetTextView.text = self.userData.address!
        self.cityTextField.text = self.userData.city!
        self.countryTextField.text = self.userData.country!
        self.stateTextField.text = self.userData.state!
        self.emailTextField.text = self.userData.email!
        self.passwordTextField.text = self.userData.password!
        self.cPasswordTextField.text = self.userData.password!
        self.addUserEmailTextField.text = self.userData.altUserEmail!
        self.userId = self.userData.userID!
        
        if self.userData.isSMSConsentAccepted == 1{
            self.setSmsOptOption(button: self.yesBtn)
        }else{
            self.setSmsOptOption(button: self.noBtn)
        }
    }
    
    func checkFields() -> Bool{
        
        let firstN = self.fnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let lastN = self.lnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        //let streetS = self.streetTextView.text.trimmingCharacters(in: .whitespaces)
        
        //let middleN = self.mnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        //let cityS = self.cityTextField.text!.trimmingCharacters(in: .whitespaces)
        
        //let stateS = self.stateTextField.text!.trimmingCharacters(in: .whitespaces)
        
        //let countryS = self.countryTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let emailS = self.emailTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let cpassword = self.cPasswordTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let altUserEmail = self.addUserEmailTextField.text!.trimmingCharacters(in: .whitespaces)
        
        if firstN.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter first name.", controller: self)
            return false
            
        }
//        else if middleN.count == 0{
//            CommonFunction.showToastMessage(msg:"Please enter middle name.", controller: self)
//            return false
//
//        }
        else if lastN.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter last name.", controller: self)
            return false
            
        }
        
//        else if streetS.count == 0{
//            CommonFunction.showToastMessage(msg:"Please enter street address.", controller: self)
//            return false
//            
//        }else if cityS.count == 0{
//            CommonFunction.showToastMessage(msg:"Please enter city.", controller: self)
//            return false
//            
//        }else if stateS.count == 0{
//            CommonFunction.showToastMessage(msg:"Please enter state.", controller: self)
//            return false
//            
//        }else if countryS.count == 0{
//            CommonFunction.showToastMessage(msg:"Please enter country.", controller: self)
//            return false
//        }
        
        else if emailS.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter your email.", controller: self)
            return false
        }else if !CommonFunction.isValidEmail(emailadd: emailS){
            CommonFunction.showToastMessage(msg:"Please enter valid email.", controller: self)
            return false
        }else if password.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter password.", controller: self)
            return false
        }else if password.count < 4{
            CommonFunction.showToastMessage(msg:"Please enter password atleast 4 digit.", controller: self)
            return false
        }else if cpassword.count == 0 {
            CommonFunction.showToastMessage(msg:"Please enter confirm password.", controller: self)
            return false
        }else if password.count != 0 && cpassword.count != 0{
            
            if password != cpassword{
                CommonFunction.showToastMessage(msg:"Password and Confirm Password not match.", controller: self)
                return false
            }
        }
        
        if altUserEmail.count != 0{
            if !CommonFunction.isValidEmail(emailadd: altUserEmail){
                CommonFunction.showToastMessage(msg: "Please enter valid email.", controller: self)
                return false
            }
            return true
        }else{
            return true
        }
    }
    
    func APIUpdateUserCall(){
        
        //let aPIUrl = String(format: "%@/User/Put/%d", APIUrl.baseUrl,self.userId)
        let aPIUrl = String(format: "%@/User/UpdateUser", APIUrl.baseUrl)
        
        let firstN = self.fnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let lastN = self.lnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let streetS = self.streetTextView.text.trimmingCharacters(in: .whitespaces)
        
        let middleN = self.mnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let cityS = self.cityTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let stateS = self.stateTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let countryS = self.countryTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let emailS = self.emailTextField.text!.trimmingCharacters(in: .whitespaces)
        
        var mobile = self.mobileTextField.text!.trimmingCharacters(in: .whitespaces)
        mobile = CommonFunction.cleanPhoneNumber(mobile)
        
        let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespaces)
        
        
        let altUserEmail = self.addUserEmailTextField.text!.trimmingCharacters(in: .whitespaces)
        
        var userId = 0
        if UserDefaults.standard.value(forKey: "UserLoginUserId") != nil{
            userId = (UserDefaults.standard.value(forKey: "UserLoginUserId") as! Int)
        }
        
        var smsFlag = 0
        if self.yesBtn.isSelected{
            smsFlag = 1
        }
        
        let dName = String(format: "%@ %@", firstN,lastN)
        let parameters = ["UserID": userId,
                          "ChartererRequestID": 0,
                          "UserTypeID": 3,
                          "UserType": "",
                          "DisplayName": dName,
                          "FirstName": firstN,
                          "MiddleName": middleN,
                          "LastName": lastN,
                          "Email": emailS,
                          "PhoneNumber": mobile,
                          "Mobile": Int64(mobile)!,
                          "ProfilePhotoUrl": "",
                          "PreferredCurrency": "",
                          "ComponyID": 0,
                          "Address": streetS,
                          "City": cityS,
                          "State": stateS,
                          "Country": countryS,
                          "PostCode": "",
                          "ActiveUserID": 0,
                          "AutoBid": true,
                          "IsNewUser": "",
                          "Gender": "Male",
                          "DOB": "",
                          "Password":password,
                          "AlternateEmail":altUserEmail,
                          "Weight": 0,
                          "Istheaddresspermanant": 0,
                          "Postbox": "",
                          "PostalCode": "",
                          "ProvinceCode": "",
                          "CountryCode": "",
                          "GovtDocumenttype": "",
                          "DocumentNo": "",
                          "DateofIssue":"",
                          "IssuingProvincecode": "",
                          "IssuingCountrycode": "",
                          "ExpirationDate": "",
                          "IsSMSConsentAccepted":smsFlag] as [String: Any]
        
        self.view.makeToastActivity(.center)
        APIUser.shared.updateUser(urlStr: aPIUrl,param: parameters) { response in
            self.view.hideToastActivity()
            if response.result == "success"{
                CommonFunction.showToastMessage(msg: "User data updated successfully.", controller: self)
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
    
    @IBAction func termsConditionBtnClicked(_ sender:UIButton){
        
        let previewVC = PreviewOfferVC.storyboardViewController()
        previewVC.prevUrlStr = APPUrls.termsCondNew
        previewVC.titleStr = "Terms & Conditions"
        previewVC.isFromTermsAndCond = true
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    @IBAction func termsBtnClicked(_ sender : UIButton){
        
        sender.isSelected = !sender.isSelected
        self.termsBtn.tintColor = UIColor.clear
        self.termsBtn.backgroundColor = UIColor.clear
        if sender.isSelected == true{
            self.termsBtn.setImage(UIImage(named: "selected"), for: .selected)
            self.submitButton.isEnabled = true
            CommonFunction.setRoundedButtons(arrayB: [submitButton], radius: self.submitButton.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: blackColorCode, textColor: whiteColorCode)
        }else{
            self.termsBtn.setImage(UIImage(named: "selected_not"), for: .normal)
            CommonFunction.setRoundedButtons(arrayB: [submitButton], radius: self.submitButton.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: lightGrayColorCode, textColor: blackColorCode)
            self.submitButton.isEnabled = false
        }
    }
    
    @IBAction func submitBtnClicked(_ sender : UIButton){
        
        if self.checkFields(){
            
            if self.termsBtn.isSelected == true{
                //set after API Success
                self.APIUpdateUserCall()
            }else{
                CommonFunction.showToastMessage(msg:"Please accept terms and conditions.", controller: self)
            }
        }
    }
    
    @IBAction func smsBtnsClicked(_ sender : UIButton){
        self.setSmsOptOption(button: sender)
    }
    
    func setSmsOptOption(button:UIButton){
        
        for btn in smsBtnArr{
            btn.isSelected = false
            btn.setImage(UIImage(named: "selected_not"), for: .normal)
        }
        button.isSelected = true
        button.setImage(UIImage(named: "selected"), for: .normal)
    }
}

extension ProfileVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
}
