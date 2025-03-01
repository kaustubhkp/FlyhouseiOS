//
//  VerificationCodeCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

protocol VerificationCodeCellDelegate{
    
    func resendBtnPressed(sender:UIButton,captchacode:String)
    func verifyBtnPressed(sender:UIButton,code:String)
    func cancelBtnPressed(captchacode:String,atIndex:Int)
    func refreshCaptcha(captchacode:String,atIndex:Int)
    func checkBtnPressed(enteredCaptcha:String,atIndex:Int)
    func reloadData()
}

class VerificationCodeCell: UITableViewCell {
    
    var delegate:VerificationCodeCellDelegate?
    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var vCodeTextField:UITextField!
    @IBOutlet weak var resendBtn:UIButton!
    @IBOutlet weak var vCodeBtn:UIButton!
    @IBOutlet weak var arrowImage:UIImageView!
    
    @IBOutlet weak var captchaView:UIView!
    @IBOutlet weak var cancelBtn:UIButton!
    @IBOutlet weak var checkBtn:UIButton!
    @IBOutlet weak var refreshBtn:UIButton!
    @IBOutlet weak var captchaTextField:UITextField!
    @IBOutlet weak var capthaLabel:UILabel!
    @IBOutlet var verifyBntTopToTextFieldConst:NSLayoutConstraint!
    @IBOutlet var verifyBtnBottomToCapthaViewConst:NSLayoutConstraint!
    @IBOutlet weak var errorLabel:UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.hideCapthaView()
        self.captchaView.layer.cornerRadius = 15
        self.errorLabel.text = ""
        
        self.selectionStyle = .none
        //cellMainView.backgroundColor = UIColor.clear
        
        //CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 10, borderColorCode: whiteColorCode, borderW: 1, bgColor: THEME_COLOR_LIGHT)
        
        CommonFunction.setRoundedButtons(arrayB: [vCodeBtn], radius: vCodeBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: whiteColorCode, textColor: blackColorCode)
        
        CommonFunction.setTextFieldPlaceHolder(txtF: captchaTextField, pholderText: "", size: 15, color: UIColor.hexStringToUIColor(hex: placeHolderColorCode),tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        
        
        self.vCodeTextField.layer.borderColor = UIColor.hexStringToUIColor(hex: INPUTF_BORDER_COLOR).cgColor
        self.vCodeTextField.layer.borderWidth = 1
        
        CommonFunction.setTextFieldFontsTypeWithSize(arrayT: [captchaTextField], size: 14, type: .fBold)
        CommonFunction.setLabelsFonts(lbls: [capthaLabel], type: .fBold, size: 22)
        CommonFunction.setLabelsFonts(lbls: [errorLabel], type: .fMedium, size: 12)
        //self.vCodeTextField.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BLIGHT)
        self.vCodeTextField.layer.cornerRadius = 5
       
        CommonFunction.setTextFieldPlaceHolder(txtF: vCodeTextField, pholderText: "Enter code received in email or text",size: 13,color: UIColor.hexStringToUIColor(hex: placeHolderColorCode),tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        
        CommonFunction.setLabelsFonts(lbls: [titleLabel], type: .fReguler, size: 12)
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [vCodeBtn], size: 11, type: .fSemiBold, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
        CommonFunction.setButtonAttributedButton(btn: resendBtn, title: "Re-send verification code", titleColor: blackColorCode, fontSize: 12,isunderline: true)
        
        //let arrowimage = UIImage(named: "right_arrow")?.withRenderingMode(.alwaysTemplate)
        //self.arrowImage.tintColor = UIColor.darkGray
        //self.arrowImage.image = arrowimage
    }
    
    func hideCapthaView(){
        
        self.verifyBntTopToTextFieldConst.priority = UILayoutPriority(999)
        self.verifyBtnBottomToCapthaViewConst.priority = UILayoutPriority(250)
        self.captchaView.isHidden = true
    }
    
    func showCapthaView(){
        
        self.verifyBntTopToTextFieldConst.priority = UILayoutPriority(250)
        self.verifyBtnBottomToCapthaViewConst.priority = UILayoutPriority(999)
        self.captchaView.isHidden = false
    }
    
    func configuerCell(indexPath:IndexPath,isMobileVerify:Bool,isEmailVerify:Bool,captcha:String){
        
        self.resendBtn.tag = indexPath.row
        self.vCodeBtn.tag = indexPath.row
        self.vCodeTextField.tag = indexPath.row
        self.cancelBtn.tag = indexPath.row
        self.checkBtn.tag = indexPath.row
        self.refreshBtn.tag = indexPath.row
        self.captchaTextField.tag = indexPath.row
        self.capthaLabel.text = captcha
        
        if indexPath.row == 0 && isMobileVerify == false{
            self.titleLabel.text = "Please verify your mobile number"
        }else{
            self.vCodeTextField.text = ""
            self.titleLabel.text = "Please verify you email ID"
        }
    }
    

    @IBAction func resendBtnClicked(_ sender:UIButton){
        //self.showCapthaView()
        //let new = CommonFunction.randomCaptchaString(length: 4)
        self.delegate?.resendBtnPressed(sender: sender,captchacode:"")
    }
    
    @IBAction func verifyBtnClicked(_ sender:UIButton){
        
        let code = self.vCodeTextField.text?.trimmingCharacters(in: .whitespaces)
            
        if code?.count == 0{
            self.errorLabel.text = "Please enter verification code."
            self.delegate?.reloadData()
        }else{
            self.errorLabel.text = ""
            self.delegate?.verifyBtnPressed(sender: sender,code:self.vCodeTextField.text!.trimmingCharacters(in: .whitespaces))
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender : UIButton){
        self.captchaTextField.text = ""
        self.errorLabel.text = ""
        self.hideCapthaView()
        self.delegate?.cancelBtnPressed(captchacode: "", atIndex: sender.tag)
    }
    
    @IBAction func checkBtnClicked(_ sender : UIButton){
        
        if self.captchaTextField.text! == self.capthaLabel.text!{
            
            self.errorLabel.text = ""
            self.captchaTextField.text = ""
            self.hideCapthaView()
            self.delegate?.checkBtnPressed(enteredCaptcha: self.captchaTextField.text!, atIndex: sender.tag)
        }else{
            self.errorLabel.text = "You have enterered incorrect captcha code."
        }
        self.delegate?.reloadData()
    }
    
    @IBAction func refreshCaptchaBtnClicked(_ sender : UIButton){
        let new = CommonFunction.randomCaptchaString(length: 4)
        self.delegate?.refreshCaptcha(captchacode: new,atIndex: sender.tag)
    }
    
}
