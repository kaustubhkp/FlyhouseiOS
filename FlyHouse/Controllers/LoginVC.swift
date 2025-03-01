//
//  LoginVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class LoginVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .Login

    @IBOutlet weak var otpView:UIView!
    @IBOutlet weak var otpContainerView:UIView!
    let otcStackView = OneTimeCodeView()
    @IBOutlet weak var phoneNumberTitleLabel:UILabel!
    @IBOutlet weak var numberInputView:UIView!
    @IBOutlet weak var phoneInputView:UIView!
    @IBOutlet weak var mobileView:UIView!
    @IBOutlet weak var mobileNumberTF:UITextField!
    @IBOutlet weak var mobileNumberLabel:UILabel!
    @IBOutlet weak var emailView:UIView!
    @IBOutlet weak var emailInputView:UIView!
    @IBOutlet weak var emailTF:UITextField!
    @IBOutlet weak var emailTilteLabel:UILabel!
    @IBOutlet weak var passwordInputView:UIView!
    @IBOutlet weak var passwordTF:UITextField!
    @IBOutlet weak var passwordTilteLabel:UILabel!
    @IBOutlet weak var continueEmailViewBtn:UIButton!
    @IBOutlet weak var arrowEmailViewImage:UIImageView!
    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var verifyOTPBtn:UIButton!
    @IBOutlet weak var countryCodeButton:UIButton!
    @IBOutlet weak var resendLabel:UILabel!
    @IBOutlet weak var resendBtn:UIButton!
    @IBOutlet weak var loginBackBtn:UIButton!
    @IBOutlet weak var newUserBtn:UIButton!
    @IBOutlet weak var arrowImage:UIImageView!
    @IBOutlet var arrayTextField:[UITextField]!
    @IBOutlet var titlesLableArr:[UILabel]!
    @IBOutlet weak var regUserErrorView:UIView!
    @IBOutlet weak var errorMsgLabel:UILabel!
    @IBOutlet weak var errorEmailMsgLabel:UILabel!
    @IBOutlet weak var forgotBtn:UIButton!
    @IBOutlet weak var mobileLoginErrorView:UIView!
    @IBOutlet weak var mobLoginErrorMsgLabel:UILabel!
    @IBOutlet weak var btnLoginWithEmail:UIButton!
    
    
    var loginWithPhone:Bool = true
    var enteredPin:String! = ""
    var userData:RegisteredUserData!
    fileprivate var password = [String]()
    fileprivate var isLoading = true
    
    var timeSecond : Int = 15 // in seconds
    var timerResendOTP:Timer!
    var toggleButton = UIButton()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setBackButton(viewC: self)
        super.delegateNav = self
        super.setNavigationTitle(title: "Hello, Nice to meet you".uppercased())
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        if self.loginWithPhone == true{
            self.mobileView.isHidden = false
            self.otpView.isHidden = true
            self.emailView.isHidden = true
            self.resendBtn.isHidden = true
        }else{
            self.mobileView.isHidden = true
            self.otpView.isHidden = true
            self.emailView.isHidden = false
            self.resendBtn.isHidden = true
        }
        
        self.toggleButton.setImage(UIImage(named:"password_hide"), for: .normal)
        self.toggleButton.tintColor = .black
        self.toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        UserDefaults.standard.set(false, forKey: "isUserVerified")
        UserDefaults.standard.synchronize()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        //let arrowimage = UIImage(named: "right_arrow")?.withRenderingMode(.alwaysTemplate)
        //self.arrowImage.tintColor = UIColor.black
       // self.arrowImage.image = arrowimage
        //self.arrowEmailViewImage.tintColor = UIColor.black
        //self.arrowEmailViewImage.image = arrowimage
        self.regUserErrorView.isHidden = true
        self.mobileLoginErrorView.isHidden = true
        CommonFunction.setLabelsFonts(lbls: [mobLoginErrorMsgLabel], type: .fReguler, size: 11)
        
        CommonFunction.setRoundedButtons(arrayB: [verifyOTPBtn], radius: self.verifyOTPBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: buttonBGColor, textColor: whiteColorCode)
        CommonFunction.setRoundedButtons(arrayB: [continueBtn], radius: self.continueBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: whiteColorCode, textColor: blackColorCode)
        CommonFunction.setRoundedButtons(arrayB: [continueEmailViewBtn], radius: self.continueEmailViewBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: whiteColorCode, textColor: blackColorCode)
        CommonFunction.setRoundedViews(arrayB: [numberInputView], radius: 10, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUTF_BORDER_COLOR)
        
        CommonFunction.setRoundedViews(arrayB: [emailInputView,passwordInputView], radius: 10, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setRoundedViews(arrayB: [phoneInputView], radius: 0, borderColorCode: "", borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        
        
        self.countryCodeButton.backgroundColor = UIColor.hexStringToUIColor(hex: INPUT_VIEW_BG_COLOR)
        
        // Do any additional setup after loading the view.
        CommonFunction.setTextFieldFontsTypeWithSize(arrayT: [mobileNumberTF,emailTF,passwordTF], size: 14, type: .fReguler)
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [countryCodeButton], size: 14, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        CommonFunction.setTextFieldPlaceHolder(txtF: mobileNumberTF, pholderText: "Enter phone number",size: 12,color: UIColor.hexStringToUIColor(hex: placeHolderColorCode),tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        CommonFunction.setTextFieldPlaceHolder(txtF: emailTF, pholderText: "Enter your email",size: 12,color: UIColor.hexStringToUIColor(hex: placeHolderColorCode),tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        CommonFunction.setTextFieldPlaceHolder(txtF: passwordTF, pholderText: "Enter password",size: 12,color: UIColor.hexStringToUIColor(hex: placeHolderColorCode),tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [btnLoginWithEmail,continueBtn,continueEmailViewBtn], size: 11, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
        CommonFunction.setButtonAttributedButton(btn: forgotBtn, title: "Forgot Password?", titleColor: blackColorCode, fontSize: 11,isunderline: true)
       
        continueBtn.setTitle("Continue", for: .normal)
        continueEmailViewBtn.setTitle("Continue", for: .normal)
        let action = #selector(LoginVC.backBtnClicked)
        self.loginBackBtn.addTarget(self, action:action, for: .touchUpInside)
        
        CommonFunction.setLabelsFonts(lbls: titlesLableArr, type: .fReguler, size: 10)
        
        // Set up the toggle button as the right view of the text field
        passwordTF.rightView = toggleButton
        passwordTF.rightViewMode = .always
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    func setOneTimeCodeView(){
        self.otpContainerView.addSubview(otcStackView)
        otcStackView.heightAnchor.constraint(equalTo: otpContainerView.heightAnchor).isActive = true
        //otcStackView.widthAnchor.constraint(equalTo: otpContainerView.widthAnchor).isActive = true
        otcStackView.centerXAnchor.constraint(equalTo: otpContainerView.centerXAnchor).isActive = true
        otcStackView.centerYAnchor.constraint(equalTo: otpContainerView.centerYAnchor).isActive = true
        otcStackView.delegate = self
    }
    
    @objc func togglePasswordVisibility() {
        passwordTF.isSecureTextEntry.toggle()
            
        // Update the button's image
        let imageName = passwordTF.isSecureTextEntry ? "password_hide" : "password_show"
        toggleButton.setImage(UIImage(named: imageName), for: .normal)
    }

    func APILoginCall(){
        
        //finalcode
        var mobileNum = String(format: "%@%@", self.countryCodeButton.titleLabel!.text!,self.mobileNumberTF.text!)
        mobileNum = CommonFunction.formateMobile(number: mobileNum)
        let getAPIUrl = String(format: "%@/Login/GetOTP?Number=%@&token=kGE68KJ798vZK78C9KyT9Lbhtr26UyByUuhyV9lGeHwq4FkRdJa95Y5kPJ4Z9s120XK4Ek", APIUrl.baseUrl,mobileNum)
        
        //let getAPIUrl = String(format: "%@/Login", APIUrl.baseUrl)
        
        self.view.makeToastActivity(.center)
        APILogin.shared.login(urlStr: getAPIUrl) { response in
            self.view.hideToastActivity()
            if response.data != nil{
                
                if let resultData = response.data {
                    
                    if resultData.userID != nil{
                        UserDefaults.standard.set(resultData.userID!, forKey: "UserLoginUserId")
                    }
                    UserDefaults.standard.synchronize()
                    
                    if resultData.isNewUser == "1"{
                        self.regUserErrorView.isHidden = false
                        if response.description != nil{
                            self.errorMsgLabel.text = response.description!
                        }
                    }else if resultData.isEmailVerified == "1" && resultData.isMobileVerified == "1" && resultData.isNewUser == "0"{
                        
                        self.regUserErrorView.isHidden = true
                        if (resultData.isSMSConsentAccepted == "0") {
                            self.mobileLoginErrorView.isHidden = false
                            if response.description != nil{
                                //self.btnLoginWithEmail.setTitle(response.description!, for: .normal)
                                self.mobLoginErrorMsgLabel.text = response.description!
                            }
                            return
                        }else{
                            self.mobileLoginErrorView.isHidden = true
                        }
                        
                        if resultData.userID != nil{
                            UserDefaults.standard.set(resultData.userID!, forKey: "UserLoginUserId")
                        }
                        UserDefaults.standard.synchronize()
                        
                        self.showResendOTPTimer()
                        self.otpView.isHidden = false
                        self.setOneTimeCodeView()
                        //self.settingsVerificationCodeInputView()
                        self.mobileView.isHidden = true
                        //self.verifyOTPBtn.setTitle("Verify OTP", for: .normal)
                        let  mobile =  String(format: "%@%@", self.countryCodeButton.titleLabel!.text!,CommonFunction.formateMobile(number: self.mobileNumberTF.text!))
                        self.mobileNumberLabel.text = mobile
                        
                    }else{
                        
                        self.regUserErrorView.isHidden = true
                        let verificationCodeVC = VerificationCodeVC.storyboardViewController()
                    
                        if resultData.isMobileVerified != nil{
                            if resultData.isMobileVerified == "1"{
                                verificationCodeVC.isMobileVerified = true
                            }else{
                                verificationCodeVC.isMobileVerified = false
                            }
                        }
                        
                        if resultData.isEmailVerified != nil{
                            
                            if resultData.isEmailVerified == "1"{
                                verificationCodeVC.isEmailVerified = true
                            }else{
                                verificationCodeVC.isEmailVerified = false
                            }
                        }
                        self.navigationController?.pushViewController(verificationCodeVC, animated: true)
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
    
    func APILoginEmailCall(){
        
        self.errorEmailMsgLabel.text = ""
        self.view.makeToastActivity(.center)
        
        let email = self.emailTF.text!.trimmingCharacters(in: .whitespaces)
        
        let password = self.passwordTF.text!.trimmingCharacters(in: .whitespaces)
        
        let parameters = ["ContactNumber": "",
                          "OTP":"",
                          "UserEmail": email,
                          "Password": password] as [String: Any]
        
        
        //finalcode
        let urlStr = String(format: "%@/Login/AuthenticateChartererUpgrade", APIUrl.baseUrl)
        
        //let urlStr = String(format: "%@/authenticate", APIUrl.baseUrl)
        //
        APILogin.shared.loginAuthenticate(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.data != nil{
                    
                    if let token = response.data?.token!{
                        UserDefaults.standard.set(token, forKey: "Authorization")
                    }
                    
                    if let mobile = response.data?.mobileNum{
                        UserDefaults.standard.set(mobile, forKey: "UserLoginMobile")
                    }
                    if response.data!.userID != nil{
                        UserDefaults.standard.set(response.data!.userID!, forKey: "UserLoginUserId")
                    }
                    UserDefaults.standard.synchronize()
                    //self.APIGetAllUrls()
                    if response.data?.isEmailVerified == "1" && response.data?.isMobileVerified == "1"{
                    
                        UserDefaults.standard.set(true, forKey: "isUserVerified")
                        UserDefaults.standard.synchronize()
                        APP_DELEGATE.createMenuView()
                    }else{
                        
                        let verificationCodeVC = VerificationCodeVC.storyboardViewController()
                        
                        if response.data?.isMobileVerified != nil{
                            if response.data?.isMobileVerified == "1"{
                                verificationCodeVC.isMobileVerified = true
                            }else{
                                verificationCodeVC.isMobileVerified = false
                            }
                        }
                        
                        if response.data?.isEmailVerified != nil{
                            
                            if response.data?.isEmailVerified == "1"{
                                verificationCodeVC.isEmailVerified = true
                            }else{
                                verificationCodeVC.isEmailVerified = false
                            }
                        }
                        
                        self.navigationController?.pushViewController(verificationCodeVC, animated: true)
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
    
    func APIVerifyOTP(){
        
        self.view.makeToastActivity(.center)
        var mobNum = String(format: "%@%@", self.countryCodeButton.titleLabel!.text!,self.mobileNumberTF.text!)
        mobNum = CommonFunction.formateMobile(number: mobNum)
        let parameters = ["ContactNumber": mobNum,
                          "OTP":self.enteredPin!] as [String: Any]
        
        
        //finalcode
        let urlStr = String(format: "%@/Login/AuthenticateChartererUpgrade", APIUrl.baseUrl)
        
        //let urlStr = String(format: "%@/authenticate", APIUrl.baseUrl)
        //
        APILogin.shared.loginAuthenticate(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
            if response.data != nil{
                
                
                if let token = response.data?.token!{
                    UserDefaults.standard.set(token, forKey: "Authorization")
                    UserDefaults.standard.synchronize()
                }
                
                if let isNewUser = response.data?.isNewUser!{
                    if isNewUser == "1"{
                        let registration = RegisterVC.storyboardViewController()
                        registration.phoneNum = self.mobileNumberTF.text!.trimmingCharacters(in: .whitespaces)
                        registration.mobileStr = mobNum
                        self.navigationController?.pushViewController(registration, animated: true)
                        return
                    }else{
                        
                        if response.data?.isEmailVerified == "1" && response.data?.isMobileVerified == "1"{
                            UserDefaults.standard.set(mobNum, forKey: "UserLoginMobile")
                            UserDefaults.standard.set(true, forKey: "isUserVerified")
                            UserDefaults.standard.synchronize()
                            APP_DELEGATE.createMenuView()
                            return
                        }
                         
                        let verificationCodeVC = VerificationCodeVC.storyboardViewController()
                        
                        if response.data?.isMobileVerified != nil{
                            if response.data?.isMobileVerified == "1"{
                                verificationCodeVC.isMobileVerified = true
                            }else{
                                verificationCodeVC.isMobileVerified = false
                            }
                        }
                        
                        if response.data?.isEmailVerified != nil{
                            
                            if response.data?.isEmailVerified == "1"{
                                verificationCodeVC.isEmailVerified = true
                            }else{
                                verificationCodeVC.isEmailVerified = false
                            }
                        }

                        self.navigationController?.pushViewController(verificationCodeVC, animated: true)
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

    func showResendOTPTimer(){
        self.resendBtn.isHidden = true
        if self.timerResendOTP == nil{
            self.timerResendOTP = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTime(){
        
        if self.timeSecond > 0{
            self.resendBtn.isHidden = true
            self.resendLabel.isHidden = false
            self.printSecondsToHoursMinutesSeconds(seconds: self.timeSecond)
            //self.timerLabel.text = String(format: "Resend code in 00:%d",self.timeSecond)
            self.timeSecond = self.timeSecond - 1
        }else{
            if self.timerResendOTP != nil{
                self.timerResendOTP.invalidate()
                self.timerResendOTP = nil
            }
            self.timeSecond = 10
            self.resendBtn.isHidden = false
            self.resendLabel.isHidden = true
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func printSecondsToHoursMinutesSeconds (seconds:Int) -> () {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
        //print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
        
        var time = ""
        if h > 0{
            time = String(format: "%d:", h)
        }
        //time.append("\(m)")
        time.append("\(s)")
        
        self.resendLabel.text = String(format: "Resend code in %@ seconds",time)
    }
    
    @IBAction func registerNewBtnClicked(_ sender : UIButton){
        let registration = RegisterVC.storyboardViewController()
        self.navigationController?.pushViewController(registration, animated: true)
    }
    
    @IBAction func loginWithEmailBtnClicked(_ sender : UIButton){
        self.loginWithPhone = false
        self.viewDidLoad()
    }
    
    @IBAction func continueBtnClicked(_ sender : UIButton){
        
        self.view.endEditing(true)
        if sender.tag == 0{
            if self.mobileNumberTF.text?.count != 0 && sender.tag == 0 && self.mobileNumberTF.text!.count >= 10{
                self.APILoginCall()
            }else{
                if self.mobileNumberTF.text!.count < 10{
                    CommonFunction.showToastMessage(msg: "Please enter valid mobile number.", controller: self)
                }else{
                    CommonFunction.showToastMessage(msg:"Please enter your mobile number.", controller: self)
                }
            }
        }else{
            
            if ((self.emailTF.text?.count != 0) && self.passwordTF.text?.count != 0 ){
               
                if !CommonFunction.isValidEmail(emailadd: (self.emailTF.text?.trimmingCharacters(in: .whitespaces))!){
                    CommonFunction.showToastMessage(msg: "Please enter valid email.", controller: self)
                }else{
                    
                    self.APILoginEmailCall()
                }
                
            }else{
                
                if self.emailTF.text!.count == 0{
                    CommonFunction.showToastMessage(msg: "Please enter your email or mobile number.", controller: self)
                }else{
                    CommonFunction.showToastMessage(msg: "Please enter your paasword.", controller: self)
                }
            }
        }
    }
    
    @IBAction func verifyOTPClicked(_ sender : UIButton){
        
        if self.enteredPin.count == 4 {
            self.didFinishEnteringPin(pin: self.enteredPin)
        }else{
            CommonFunction.showToastMessage(msg: "Please enter valid verification code", controller: self)
        }
    }
    
    @IBAction func resendBtnClicked(_ sender: UIButton){
        //self.setClearedOTP()
        //self.settingsVerificationCodeInputView()

        self.enteredPin = self.otcStackView.setClearOTP()
        self.otcStackView.removeFromSuperview()
        self.APILoginCall()
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
//            self.countryCodeButton.setImage(UIImage(named:flag), for: .normal)
//            self.countryCodeButton.setTitle(code, for: .normal)
//        }
    }
    
    @IBAction func newUserBtnClicked(_ sender:UIButton){
        self.loginWithPhone = true
        self.mobileView.isHidden = false
        self.otpView.isHidden = true
        self.emailView.isHidden = true
        self.resendBtn.isHidden = true
        self.continueBtn.tag = 0
    }
    
    @IBAction func forgotPWDClicked(_ sender: UIButton){
//        let previewVC = PreviewOfferVC.storyboardViewController()
//        previewVC.prevUrlStr = APPUrls.fpwdURL
//        previewVC.titleStr = "Forgot Password"
//        previewVC.isFromForgotPWd = true
//        self.navigationController?.pushViewController(previewVC, animated: true)
        
        guard let url = URL(string: APPUrls.fpwdURL) else {
            print("Invalid URL: \(APPUrls.fpwdURL)")
            return
        }
        UIApplication.shared.open(url)
    }
    
    @objc func backBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- verification code view delegate method
    func didFinishEnteringPin(pin:String) {
        self.APIVerifyOTP()
    }
}

extension LoginVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.mobileNumberTF.resignFirstResponder()
        return true
    }
    
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        if textField == self.mobileNumberTF {
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

extension LoginVC :OneTimeCodeViewDelegate{
    
    func didOTCValidity(isValid: Bool,string:String) {
        if isValid{
            self.enteredPin = string
            if self.enteredPin.count == 4 {
                self.didFinishEnteringPin(pin: self.enteredPin)
            }else{
                CommonFunction.showToastMessage(msg: "Please enter valid verification code", controller: self)
            }
        }
    }
}

extension LoginVC : FlagListPopupVCDelegate {
    
    func didSelectedCountry(atIndex: Int, data: CountryData) {
        let imageView = UIImageView()
        let url = String(format: "%@%@",APPUrls.imageBaseUrl,data.flag!)
        imageView.loadImageUsingCache(withUrl:url)
        self.countryCodeButton.setImage(imageView.image, for: .normal)
        print(data.dialCode!)
        self.countryCodeButton.setTitle(data.dialCode!, for: .normal)
    }
}

extension LoginVC:NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
}
