//
//  OneTimeCodeView.swift
//


import Foundation
import UIKit

let NO_OTC_FIELDS = 4

protocol OneTimeCodeViewDelegate: AnyObject {
    //triggers when the OTC is valid
    func didOTCValidity(isValid: Bool,string:String)
    
}


class OneTimeCodeView : UIStackView{
    
    var textFArray: [TextFieldOTC] = []
    weak var delegate: OneTimeCodeViewDelegate?
    var verificationCode = ""
    let inactiveFieldBorderColor = UIColor(white: 1, alpha: 0)
    let textBackgroundColor = UIColor.hexStringToUIColor(hex: INPUT_VIEW_BG_COLOR)
    let activeFieldBorderColor = UIColor.white
    var remainingStackStr: [String] = []

    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        createOTCView()
        addOTCFields()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createOTCView()
        addOTCFields()
    }
    
    //Creation OTC Ciew
    private final func createOTCView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 15
    }
    
    //Adding each OTC TF to stack view
    private final func addOTCFields() {
        for index in 0..<NO_OTC_FIELDS{
            let field = TextFieldOTC()
            setupTextField(field)
            textFArray.append(field)
            //focus to previous field
            index != 0 ? (field.prevTextField = textFArray[index-1]) : (field.prevTextField = nil)
            //focus to next field
            index != 0 ? (textFArray[index-1].nextTextField = field) : ()
        }
        textFArray[0].becomeFirstResponder()
    }
    
    //Customisation and setting OTCTextFields
    private final func setupTextField(_ textField: TextFieldOTC){
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = true
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 55).isActive = true
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont.MediumWithSize(size: 25)
        textField.layer.borderWidth = 0
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
        textField.layer.cornerRadius = 5
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .yes
        textField.textContentType = .oneTimeCode
        textField.tintColor = UIColor.black
        textField.textColor = .black
        textField.backgroundColor = textBackgroundColor
    }
    
    //Get OTC text
    final func getCode() -> String {
        var otp = ""
        for textF in textFArray{
            otp += textF.text ?? ""
        }
        self.verificationCode = otp
        return otp
    }

    //set a warning color
    final func setAllFieldColor(isWarningColor: Bool = false, color: UIColor){
        for textF in textFArray{
            textF.layer.borderColor = color.cgColor
        }
    }
    
    
    //checking all the OTC are filled
    private final func checkOTCValid(){
        for fields in textFArray{
            if (fields.text?.trimmingCharacters(in: CharacterSet.whitespaces) == ""){
                delegate?.didOTCValidity(isValid: false,string: self.getCode())
                return
            }
        }
        delegate?.didOTCValidity(isValid: true,string: self.getCode())
    }
    
    //autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStackStr = string.reversed().compactMap{String($0)}
        for textField in textFArray {
            if let charToAdd = remainingStackStr.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkOTCValid()
        remainingStackStr = []
    }
    
    final func setClearOTP() -> String{
        var OTP = ""
        for textField in textFArray{
            textField.text = ""
            OTP += textField.text ?? ""
        }
        remainingStackStr = []
        return OTP
    }
    
}

//MARK: - TextField Handling
extension OneTimeCodeView: UITextFieldDelegate {
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = activeFieldBorderColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkOTCValid()
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
    }
    
    //switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        guard let textField = textField as? TextFieldOTC else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0 && string == "") {
                return false
            } else if (range.length == 0){
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                }else{
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
    
}



class TextFieldOTC: UITextField {
    
    weak var prevTextField: TextFieldOTC?
    weak var nextTextField: TextFieldOTC?
    
    override public func deleteBackward(){
        text = ""
        prevTextField?.becomeFirstResponder()
    }
}

