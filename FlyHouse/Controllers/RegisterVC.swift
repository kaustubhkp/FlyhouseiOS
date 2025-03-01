//
//  RegisterVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
// 

import UIKit

class RegisterVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .Login
    
    @IBOutlet weak var fnameTextField:UITextField!
    @IBOutlet weak var mnameTextField:UITextField!
    @IBOutlet weak var lnameTextField:UITextField!
    @IBOutlet weak var streetTextField:UITextField!
    @IBOutlet weak var cityTextField:UITextField!
    @IBOutlet weak var stateTextField:UITextField!
    @IBOutlet weak var countryTextField:UITextField!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var cPasswordTextField:UITextField!
    @IBOutlet weak var phoneNoTextField:UITextField!
    @IBOutlet weak var addUserEmailTextField:UITextField!
    @IBOutlet weak var termsBtn:UIButton!
    @IBOutlet weak var countinueBtn:UIButton!
    @IBOutlet weak var submitBtn:UIButton!
    @IBOutlet weak var smsEnableBtn:UIButton!
    @IBOutlet weak var countryCodeBtn:UIButton!
    var mobileStr:String! = ""
    var phoneNum:String! = ""
    var userData:RegisteredUserData!
    
    @IBOutlet weak var registerPage1:UIView!
    @IBOutlet weak var registerPage2:UIView!
    var pageNo:Int! = 1
    
    @IBOutlet var fieldsArr:[UITextField]!
    @IBOutlet var fieldsTitleArr:[UILabel]!
    @IBOutlet weak var mobileInputView:UIView!
    @IBOutlet weak var phoneInputView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setBackButton(viewC: self)
        self.registerPage1.isHidden = false
        self.registerPage2.isHidden = true
        self.setNavigationTitle(title: "Create Account".uppercased())
        self.setRightButton(viewC: self, imageName: "", title: "1 of 3")
        self.rightButton.isEnabled = false
        self.rightButton.titleLabel?.textAlignment = .center
        super.delegateNav = self
        self.termsBtn.setImage(UIImage(named: "selected_not"), for: .normal)
        //self.smsEnableBtnClicked(self.smsEnableBtn)
        CommonFunction.setRoundedButtons(arrayB: [submitBtn], radius: 10, borderColorCode: "", borderW: 0, bgColor: buttonBGColor, textColor: blackColorCode)
        // Do any additional setup after loading the view.
        self.setFieldsBGColor()
        CommonFunction.setTextFieldPlaceHolder(txtF: addUserEmailTextField, pholderText: "Enter additional user email",size: 11,color: UIColor.hexStringToUIColor(hex: placeHolderColorCode), tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        
        CommonFunction.setRoundedViews(arrayB: [mobileInputView], radius: 10, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUTF_BORDER_COLOR)
        CommonFunction.setRoundedViews(arrayB: [phoneInputView], radius: 0, borderColorCode: "", borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        self.countryCodeBtn.backgroundColor = UIColor.hexStringToUIColor(hex: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setTextFieldPlaceHolder(txtF: phoneNoTextField, pholderText: "Enter phone number", size: 14, color: UIColor.hexStringToUIColor(hex: placeHolderColorCode), tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        
        CommonFunction.setRoundedButtons(arrayB: [countinueBtn,submitBtn], radius: self.submitBtn.frame.height/2, borderColorCode: "", borderW: 0, bgColor: whiteColorCode, textColor: blackColorCode)
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [countinueBtn,submitBtn], size: 11, type: .fSemiBold, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    func setFieldsBGColor(){
        
        for txtf in fieldsArr{
            
            txtf.backgroundColor = UIColor.hexStringToUIColor(hex: INPUT_VIEW_BG_COLOR)
            txtf.textColor  = UIColor.black
            CommonFunction.setTextFieldFontsTypeWithSize(arrayT: [txtf], size: 14, type: .fReguler)
        }
        
        for lbl in fieldsTitleArr{
            lbl.textColor = UIColor.black
            lbl.font = UIFont.RegularWithSize(size: 12)
        }
    }
    
    func checkStep1Fields() -> Bool{
        
        let firstN = self.fnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let lastN = self.lnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        //let streetS = self.streetTextField.text!.trimmingCharacters(in: .whitespaces)
        
        //let middleN = self.mnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        //let cityS = self.cityTextField.text!.trimmingCharacters(in: .whitespaces)
        
        //let stateS = self.stateTextField.text!.trimmingCharacters(in: .whitespaces)
        
        //let countryS = self.countryTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let emailS = self.emailTextField.text!.trimmingCharacters(in: .whitespaces)
        
        var mobile = self.phoneNoTextField.text!.trimmingCharacters(in: .whitespaces)
        mobile = CommonFunction.cleanPhoneNumber(mobile)
                
        if firstN.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter first name.", controller: self)
            return false
            
        }else if lastN.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter last name.", controller: self)
            return false
            
        }
        /*else if streetS.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter street address.", controller: self)
            return false
            
        }else if cityS.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter city.", controller: self)
            return false
            
        }else if stateS.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter state.", controller: self)
            return false
            
        }else if countryS.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter country.", controller: self)
            return false
        }*/
        else if emailS.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter email.", controller: self)
            return false
        }else if !CommonFunction.isValidEmail(emailadd: emailS){
            CommonFunction.showToastMessage(msg:"Please enter valid email.", controller: self)
            return false
        }
        else if mobile.count == 0{
            CommonFunction.showToastMessage(msg:"Please enter phone number.", controller: self)
            return false
        }else if mobile.count < 10{
            CommonFunction.showToastMessage(msg:"Please enter valid phone number.", controller: self)
            return false
        }
        return true
        
    }
    
    
    func checkStep2Fields() -> Bool{
        
        let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespaces)

        let cpassword = self.cPasswordTextField.text!.trimmingCharacters(in: .whitespaces)

        let altUserEmail = self.addUserEmailTextField.text!.trimmingCharacters(in: .whitespaces)


        if password.count == 0{
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
                CommonFunction.showToastMessage(msg:"Password and the confirm password entries do not match. Please review", controller: self)
                return false
            }
        }
        
        if altUserEmail.count > 0{
            if !CommonFunction.isValidEmail(emailadd: altUserEmail){
                    CommonFunction.showToastMessage(msg: "Please enter valid email.", controller: self)
                    return false
            }
        }else{
            return true
        }
        
        return true
    }
    
    
    func APIRegiCall(){
        
        let firstN = self.fnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let lastN = self.lnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let streetS = self.streetTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let middleN = self.mnameTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let cityS = self.cityTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let stateS = self.stateTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let countryS = self.countryTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let emailS = self.emailTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let altUserEmail = self.addUserEmailTextField.text!.trimmingCharacters(in: .whitespaces)
        
        self.phoneNum = self.phoneNoTextField.text!.trimmingCharacters(in: .whitespaces)
        self.phoneNum = CommonFunction.cleanPhoneNumber(self.phoneNum)
        print(self.phoneNum!)
        let countryCode = String(format: "%@", self.countryCodeBtn.titleLabel!.text!.trimmingCharacters(in: .whitespaces))
        print(countryCode)
        self.mobileStr = String(format: "%@", self.phoneNoTextField.text!.trimmingCharacters(in: .whitespaces))
        self.mobileStr = CommonFunction.formateMobile(number: self.mobileStr)
        print(self.mobileStr!)
        
        var smsFlag : Int = 0
        if self.smsEnableBtn.isSelected{
            smsFlag = 1
        }
        
        let dName = String(format: "%@ %@", firstN,lastN)
        let parameters = ["UserTypeID": 3,
                          "UserType": "",
                          "DisplayName": dName,
                          "FirstName": firstN,
                          "MiddleName": middleN,
                          "LastName": lastN,
                          "Email": emailS,
                          "PhoneNumber": self.phoneNum!,
                          "Mobile": Int64(self.mobileStr!)!,
                          "ProfilePhotoUrl": "",
                          "PreferredCurrency": "",
                          "ComponyID": 0,
                          "Address": streetS,
                          "City": cityS,
                          "State": stateS,
                          "Country": countryS,
                          "PostCode": "",
                          "ActiveUserID": 0,
                          "IsNewUser": "",
                          "Gender": "Male",
                          "DOB": "",
                          "Password":password,
                          "AlternateEmail":altUserEmail,
                          "IsSMSConsentAccepted": smsFlag,
                          "IsMobileVerified": 0,
                          "IsEmailVerified": 0,
                          "MobileCountryCode":countryCode] as [String: Any]
        
        //finalcode
        let getAPIUrl = String(format: "%@/user/post", APIUrl.baseUrl)
        
        self.view.makeToastActivity(.center)
        APILogin.shared.registrationUser(urlStr: getAPIUrl,param: parameters) { response in
            self.view.hideToastActivity()
            
            if response.result == "success"{
                
                if response.data != nil{
                    
                    self.userData = response.data!
                    
                    /*if self.userData.firstName != nil && self.userData.lastName != nil{
                     let dName = String(format: "%@ %@", self.userData.firstName!,self.userData.lastName!)
                     UserDefaults.standard.set(dName, forKey: "UserProfileName")
                     }
                     
                     if self.userData.userID != nil{
                     UserDefaults.standard.set(self.userData.userID!, forKey: "UserProfileID")
                     }
                     
                     UserDefaults.standard.set(true, forKey: "isUserVerified")
                     UserDefaults.standard.synchronize()
                     APP_DELEGATE.createMenuView()*/
                    
                    if let token = response.data?.token!{
                        UserDefaults.standard.set(token, forKey: "Authorization")
                    }

                    if self.userData.userID != nil{
                        UserDefaults.standard.set(self.userData.userID!, forKey: "UserLoginUserId")
                        UserDefaults.standard.synchronize()
                    }
                    
    
                    let verificationCodeVC = VerificationCodeVC.storyboardViewController()
                    verificationCodeVC.isMobileVerified = false
                    verificationCodeVC.isEmailVerified = false
                    verificationCodeVC.userData = response.data!
                    self.navigationController?.pushViewController(verificationCodeVC, animated: true)
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
    
    @IBAction func submitBtnClicked(_ sender : UIButton){
    
        if self.checkStep2Fields(){
            
            if self.termsBtn.isSelected == true{
                //set after API Success
                self.APIRegiCall()
            }else{
                CommonFunction.showToastMessage(msg:"Please accept terms and conditions.", controller: self)
            }
        }
    }
    
    @IBAction func continueBtnClicked(_ sender : UIButton){
        
        if self.checkStep1Fields(){
            self.pageNo = 2
            self.setRightButton(viewC: self, imageName: "", title: "2 of 3")
            self.registerPage2.isHidden = false
            self.registerPage1.isHidden = true
        }
    }
    
    @IBAction func termsBtnClicked(_ sender : UIButton){
        
        sender.isSelected = !sender.isSelected
        self.termsBtn.tintColor = UIColor.clear
        self.termsBtn.backgroundColor = UIColor.clear
        if sender.isSelected == true{
            self.termsBtn.setImage(UIImage(named: "selected"), for: .selected)
            
        }else{
            self.termsBtn.setImage(UIImage(named: "selected_not"), for: .normal)
        }
    }
    
    @IBAction func smsEnableBtnClicked(_ sender : UIButton){
        
        sender.isSelected = !sender.isSelected
        self.smsEnableBtn.tintColor = UIColor.clear
        self.smsEnableBtn.backgroundColor = UIColor.clear
        if sender.isSelected == true{
            self.smsEnableBtn.setImage(UIImage(named: "selected"), for: .selected)
            
        }else{
            self.smsEnableBtn.setImage(UIImage(named: "selected_not"), for: .normal)
        }
    }
    
    @IBAction func termsConditionBtnClicked(_ sender:UIButton){
        
        let previewVC = PreviewOfferVC.storyboardViewController()
        previewVC.prevUrlStr = APPUrls.termsCondNew
        previewVC.titleStr = "Terms & Conditions"
        previewVC.isFromTermsAndCond = true
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    @IBAction func countryCodeButtonClicked(_ sender: Any){
        self.view.endEditing(true)
        
        let flagview = FlagListPopupVC.storyboardViewController()
        //flagview.modalTransitionStyle = .crossDissolve
        flagview.delegate = self
        flagview.modalPresentationStyle = .overFullScreen
        self.present(flagview, animated: true)
        
//        ASPicker.selectOption(title:"Select Country",dataArray: COUNTRY_DATA) { (selctedText, atIndex) in
//            // TODO: Your implementation for selection
//            let code = COUNTRY_PHONENO_CODE[atIndex]
//            let flag = COUNTRY_FLAGS[atIndex]
//            self.countryCodeBtn.setImage(UIImage(named:flag), for: .normal)
//            self.countryCodeBtn.setTitle(code, for: .normal)
//        }
    }
}

extension RegisterVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        
        if self.pageNo == 1{
            UserDefaults.standard.removeObject(forKey: "Authorization")
            UserDefaults.standard.synchronize()
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.registerPage1.isHidden = false
            self.registerPage2.isHidden = true
            self.pageNo = 1
            self.setRightButton(viewC: self, imageName: "", title: "1 of 3")
        }
    }
}

extension RegisterVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.phoneNoTextField.resignFirstResponder()
        return true
    }
    
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        
        if textField == self.fnameTextField || textField == self.lnameTextField{
            
            // Allow only letters (alphabets) and spaces
                let allowedCharacters = CharacterSet.letters.union(CharacterSet.whitespaces)
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
        }
        
        if textField == self.phoneNoTextField {
//            // Allow only alphanumeric characters
//            let allowedCharacterSet = CharacterSet.alphanumerics
//            let isAlphanumeric = string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
//            
//            // Ensure the replacement string is alphanumeric
//            if !isAlphanumeric {
//                return false
//            }

            // Attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }

            // Add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // Ensure the result is under 16 characters
            return updatedText.count <= 15
        } else {
            return true
        }
    }
}

extension RegisterVC : FlagListPopupVCDelegate {
    
    func didSelectedCountry(atIndex: Int, data: CountryData) {
        let imageView = UIImageView()
        let url = String(format: "%@%@",APPUrls.imageBaseUrl,data.flag!)
        imageView.loadImageUsingCache(withUrl:url)
        self.countryCodeBtn.setImage(imageView.image, for: .normal)
        print(data.dialCode!)
        self.countryCodeBtn.setTitle(data.dialCode!, for: .normal)
    }
}
