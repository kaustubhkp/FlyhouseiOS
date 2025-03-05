//
//  CommonFunction.swift
//

import Foundation
import UIKit
import Toast_Swift

let sharedInstanceCF = CommonFunction()

class CommonFunction: NSObject {
    
    var reachability:Reachability?
    class func CommonFunctionInstance() -> CommonFunction {
        return sharedInstanceCF
    }
    
    class func isInternetAvailable() -> Bool
    {
        let reachability:Reachability = Reachability()!
        return reachability.isReachable
    }
    
    /**
     @param : emailadd is the email address string
     @brief : check valid email formate
     
     **/
    class func isValidEmail(emailadd:String) -> Bool {
        
        let emailRegEx = REXP_VALID_EMAIL
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailadd)
    }
    
    class func validatePhoneNoFormate(value: String) -> Bool {
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    /**
     @param : aStrTitle is the title of alert
     @param : aStrMessage is the alert message
     @param : aViewController is the controller where alert show
     @param : OKActionTap is the handler of ok button action
     @brief : show alert with message and title
     **/
    class func showAlertMessage(aStrTitle : String, aStrMessage : String, aViewController : UIViewController, OKActionTap :@escaping (_ OkAction: AnyObject) -> ()) {
        
        let alertController = UIAlertController(title: aStrTitle, message:aStrMessage, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            OKActionTap([:] as AnyObject)
        }
        alertController.addAction(OKAction)
        
        aViewController.present(alertController, animated: true, completion:nil)
    }
    
    class func showError(message:String){
        CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: message, aViewController: (APP_DELEGATE.window?.currentController)!) { OkAction in
            
        }
    }
    
    class func showToastMessage(msg:String,controller:UIViewController){
        controller.view.hideToast()
        // Customize toast appearance
        var style = ToastStyle()
        style.messageFont = UIFont.systemFont(ofSize: 22) // Set your desired font
        controller.view.makeToast(msg,position: .bottom,style: style)
        //controller.view.makeToast(msg,position: .center)
    }
    
    class func showToastMesage(msg:String,title:String,duration:TimeInterval,point:CGPoint,controller:UIViewController){
        
        // Customize toast appearance
        var style = ToastStyle()
        style.messageFont = UIFont.systemFont(ofSize: 20) // Set your desired font
        controller.view.hideToast()
        controller.view.makeToast(msg, point: point, title: title, image: nil,style: style ,completion: nil)
        
    }
    
    class func showToastMesage(msg:String,controller:UIViewController,fontSize:CGFloat){
        
        // Customize toast appearance
        var style = ToastStyle()
        style.messageFont = UIFont.systemFont(ofSize: fontSize) // Set your desired font
        controller.view.hideToast()
        controller.view.makeToast(msg, point: CGPoint(x: controller.view.frame.size.width/2,y: controller.view.frame.size.height-200),title: "", image: nil,style: style ,completion: nil)
        
    }
    
    class func showLoader(to:UIViewController){
        to.view.makeToastActivity(.center)
    }
    
    class func hideLoader(to:UIViewController){
        to.view.hideToastActivity()
    }
    /**
     @param : aStrTitle is the title of alert
     @param : aStrMessage is the alert message
     @param : Oktitle is the Button title
     @param : CancelTitle is the Button title
     @param : aViewController is the controller where alert show
     @param : CancelActionTap is the handler of cancel action
     @param : OKActionTap is the handler of ok button action
     @brief : show message with two button
     **/
    class func showAlertMessageWithTitle(aStrTitle : String, aStrMessage : String, Oktitle : String, CancelTitle : String, aViewController : UIViewController, CancelActionTap :@escaping (_ cancelAction: AnyObject) -> (), OKActionTap :@escaping (_ OkAction: AnyObject) -> ()) {
        
        let alertController = UIAlertController(title: aStrTitle, message:aStrMessage, preferredStyle: .alert)
        
        let CancelAction = UIAlertAction(title: CancelTitle, style: .destructive) { (action:UIAlertAction!) in
            CancelActionTap([:] as AnyObject)
        }
        alertController.addAction(CancelAction)
        
        let OKAction = UIAlertAction(title: Oktitle, style: .default) { (action:UIAlertAction!) in
            OKActionTap([:] as AnyObject)
        }
        alertController.addAction(OKAction)
        
        aViewController.present(alertController, animated: true, completion:nil)
    }
    
    class func setTextFieldFontsTypeWithSize(arrayT:[UITextField],size:CGFloat,type:fontType){
        
        for txtf in arrayT{
            if type.rawValue == 0{
                txtf.font = UIFont.RegularWithSize(size: size)
            }else if type.rawValue == 1{
                txtf.font = UIFont.BoldWithSize(size: size)
            }else if type.rawValue == 2{
                txtf.font = UIFont.SemiBoldWithSize(size: size)
            }else if type.rawValue == 3{
                txtf.font = UIFont.LightWithSize(size: size)
            }else{
                txtf.font = UIFont.MediumWithSize(size: size)
            }
        }
        
    }
    
    class func setButtonFontsTypeWithSize(arrayB:[UIButton],size:CGFloat,type:fontType,textColor:UIColor){
        
        for btn in arrayB{
            if type.rawValue == 0{
                btn.titleLabel?.font = UIFont.RegularWithSize(size: size)
            }else if type.rawValue == 1{
                btn.titleLabel?.font = UIFont.BoldWithSize(size: size)
            }else if type.rawValue == 2{
                btn.titleLabel?.font = UIFont.SemiBoldWithSize(size: size)
            }else if type.rawValue == 3{
                btn.titleLabel?.font = UIFont.LightWithSize(size: size)
            }else if type.rawValue == 4{
                btn.titleLabel?.font = UIFont.MediumWithSize(size: size)
            }else if type.rawValue == 5{
                btn.titleLabel?.font = UIFont.boldItalicWithSize(size: size)
            }else if type.rawValue == 6{
                btn.titleLabel?.font = UIFont.ThinWithSize(size: size)
            }else {
                btn.titleLabel?.font = UIFont.BlackBoldItalicWithSize(size: size)
            }
            btn.setTitleColor(textColor, for: .normal)
        }
    }
    
    class func setRoundedTextFields(arrayTF:[UITextField],radius:CGFloat,borderColorCode:String,borderW:CGFloat,bgColor:String){
        
        if arrayTF.count>0{
            for textf in arrayTF{
                textf.layer.cornerRadius = radius
                textf.layer.masksToBounds = true
                textf.layer.borderColor = UIColor.hexStringToUIColor(hex: borderColorCode).cgColor
                textf.layer.borderWidth = borderW
                textf.backgroundColor = UIColor.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    
    class func setTextfieldFontsTypeSizeAndColor(txtFArr:[UITextField],size:CGFloat,txtcolor:UIColor,type:fontType){
        
        for txtF in txtFArr{
            if type.rawValue == 0{
                txtF.font = UIFont.RegularWithSize(size: size)
            }else if type.rawValue == 1{
                txtF.font = UIFont.BoldWithSize(size: size)
            }else if type.rawValue == 2{
                txtF.font = UIFont.SemiBoldWithSize(size: size)
            }else if type.rawValue == 3{
                txtF.font = UIFont.LightWithSize(size: size)
            }else if type.rawValue == 4{
                txtF.font = UIFont.MediumWithSize(size: size)
            }else if type.rawValue == 5{
                txtF.font = UIFont.boldItalicWithSize(size: size)
            }else if type.rawValue == 6{
                txtF.font = UIFont.ThinWithSize(size: size)
            }else {
                txtF.font = UIFont.BlackBoldItalicWithSize(size: size)
            }
            txtF.textColor = txtcolor
        }
    }
    
    class func setButtonsFontsSizeAndColor(arrayB: [UIButton],size:CGFloat,textColor:String,bgColor:String){
        
        for btn in arrayB{
            btn.titleLabel?.font = UIFont.RegularWithSize(size: size)
            btn.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: textColor)
            btn.backgroundColor = UIColor.hexStringToUIColor(hex: bgColor)
        }
    }
    
    class func setRoundedButtons(arrayB:[UIButton],radius:CGFloat,borderColorCode:String,borderW:CGFloat,bgColor:String,textColor:String){
        
        if arrayB.count>0{
            for btn in arrayB{
                btn.setTitleColor(UIColor.hexStringToUIColor(hex: textColor), for: .normal)
                btn.layer.cornerRadius = radius
                btn.layer.masksToBounds = true
                btn.layer.borderColor = UIColor.hexStringToUIColor(hex: borderColorCode).cgColor
                btn.layer.borderWidth = borderW
                if bgColor == ""{
                    btn.backgroundColor = UIColor.clear
                }else{
                    btn.backgroundColor = UIColor.hexStringToUIColor(hex: bgColor)
                }
            }
        }
    }
    
    class func setRoundedButtonsWithColor(arrayB:[UIButton],radius:CGFloat,borderColor:UIColor,borderW:CGFloat,bgColor:UIColor,textColor:UIColor){
        
        if arrayB.count>0{
            for btn in arrayB{
                btn.setTitleColor(textColor, for: .normal)
                btn.layer.cornerRadius = radius
                btn.layer.masksToBounds = true
                btn.layer.borderColor = borderColor.cgColor
                btn.layer.borderWidth = borderW
                btn.backgroundColor = bgColor
                
            }
        }
    }
    
    class func setTextFieldPlaceHolder(txtF:UITextField,pholderText:String,size:CGFloat,color:UIColor,tColor:UIColor){
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 12, txtF.frame.height))
        txtF.leftView = paddingView
        txtF.leftViewMode = .always
        txtF.tintColor = tColor
        
        let attributes = [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font : UIFont.RegularWithSize(size: size)]
            
        txtF.attributedPlaceholder = NSAttributedString(string: pholderText, attributes:attributes)
    }
    
    class func randomCaptchaString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
      }
    
    class func setRoundedViews(arrayB:[UIView],radius:CGFloat,borderColorCode:String,borderW:CGFloat,bgColor:String){
        
        if arrayB.count>0{
            for btn in arrayB{
                btn.layer.cornerRadius = radius
                btn.layer.masksToBounds = true
                btn.layer.borderColor = UIColor.hexStringToUIColor(hex: borderColorCode).cgColor
                btn.layer.borderWidth = borderW
                if bgColor == ""{
                    btn.backgroundColor = UIColor.clear
                }else{
                    btn.backgroundColor = UIColor.hexStringToUIColor(hex: bgColor)
                }
                
            }
        }
    }
    
    class func setButtonAttributedButton(btn:UIButton,title:String,titleColor:String,fontSize:CGFloat,isunderline:Bool){
        
        var attributes = [NSAttributedString.Key: Any]()
        if isunderline == false{
            attributes = [
                .font: UIFont.RegularWithSize(size: fontSize),              // Set font
                .foregroundColor: UIColor.hexStringToUIColor(hex: titleColor)
            ]
        }else{
            attributes =  [
                .font: UIFont.RegularWithSize(size: fontSize),              // Set font
                .foregroundColor: UIColor.hexStringToUIColor(hex: titleColor),                  // Set text color
                .underlineStyle: NSUnderlineStyle.single.rawValue      // Set underline
            ]
        }
        

        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        btn.setAttributedTitle(attributedTitle, for: .normal)
        
    }
    
    class func setRoundedViewsWithColor(arrayB:[UIView],radius:CGFloat,borderColorCode:UIColor,borderW:CGFloat,bgColor:UIColor){
        
        if arrayB.count>0{
            for btn in arrayB{
                btn.layer.cornerRadius = radius
                btn.layer.masksToBounds = true
                btn.layer.borderColor =  UIColor(named: "#ebe5df")?.cgColor
                btn.layer.borderWidth = borderW
                btn.backgroundColor = bgColor
            }
        }
    }
    
    class func setShadowToView(arrayV:[UIView],shadowColor:String,radius:CGFloat){
        let borderColor = UIColor.hexStringToUIColor(hex: "#ebe5df").cgColor
        let borderWidth: CGFloat = 1.0  // Adjust the border width as needed
            
        
        for view in arrayV{
            
            view.alpha = 0.9
            view.layer.shadowColor = UIColor.hexStringToUIColor(hex: shadowColor).cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.masksToBounds = false
            view.clipsToBounds = false
            view.layer.shadowRadius = 0.0
            view.layer.shadowOpacity = 0.0
            view.layer.cornerRadius = radius
            view.layer.borderColor = borderColor
            view.layer.borderWidth = borderWidth
        }
    }
    
    // e.g +1(234)-161-4567 -> +12341614567
    class func formateMobile(number: String) -> String {
        
        var mobileNumber = number
        mobileNumber = mobileNumber.trimmingCharacters(in: .whitespaces)
        mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        
        return mobileNumber
    }
    
    //getLength
    class func getLength(number: String) -> Int {
        
        var mobileNumber = number
        mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        
        return mobileNumber.count
    }
    
    class func cleanPhoneNumber(_ phoneNumber: String) -> String {
        do {
            // Create a regular expression pattern to match digits
            let regex = try NSRegularExpression(pattern: "[0-9]+", options: .caseInsensitive)
            
            // Find all the matches in the input string
            let matches = regex.matches(in: phoneNumber, options: [], range: NSRange(location: 0, length: phoneNumber.utf16.count))
            
            // Extract the digit matches and join them into a single string
            let digitsOnly = matches.map {
                (phoneNumber as NSString).substring(with: $0.range)
            }.joined()
            
            return digitsOnly
        } catch {
            // Handle any errors with regular expression processing
            print("Error processing regular expression: \(error)")
            return phoneNumber // Return the original string in case of an error
        }
    }
    
    /*class func getDepartureTime() -> [String]{
        
        var timeSlots = [String]()
        //timeSlots.append("TBD")
        timeSlots.append("12:00 AM")
        timeSlots.append("12:30 AM")
       // timeSlots.append("12:30 AM")
       // timeSlots.append("12:45 AM")
        for i in 1...11{
            timeSlots.append("\(i):00 AM")
            timeSlots.append("\(i):30 AM")
            //timeSlots.append("\(i):30 AM")
            //timeSlots.append("\(i):45 AM")
        }
        timeSlots.append("12:00 PM")
        timeSlots.append("12:30 PM")
        //timeSlots.append("12:30 PM")
        //timeSlots.append("12:45 PM")
        for i in 1...11{
            timeSlots.append("\(i):00 PM")
            timeSlots.append("\(i):30 PM")
            //timeSlots.append("\(i):30 PM")
            //timeSlots.append("\(i):45 PM")
        }
        
        //print(timeSlots)
        return timeSlots
    }*/
    
    class func getDepartureTime() -> [String] {
        var timeSlots = [String]()

        // Start from 7:00 AM
        timeSlots.append("7:00 AM")
        timeSlots.append("7:30 AM")

        // Add slots for the rest of the AM times
        for i in 8...11 {
            timeSlots.append("\(i):00 AM")
            timeSlots.append("\(i):30 AM")
        }

        // Add the noon time slot
        timeSlots.append("12:00 PM")
        timeSlots.append("12:30 PM")

        // Add slots for the PM times
        for i in 1...11 {
            timeSlots.append("\(i):00 PM")
            timeSlots.append("\(i):30 PM")
        }
        
        // Add the noon time slot
        timeSlots.append("12:00 AM")
        timeSlots.append("12:30 AM")
        
        // Add slots for the PM times
        for i in 1...6 {
            timeSlots.append("\(i):00 AM")
            timeSlots.append("\(i):30 AM")
        }

        // Return the generated time slots
        return timeSlots
    }
    
    class func getfontsList(){
        
        for family in UIFont.familyNames {

            let sName: String = family as String
            print("family: \(sName)")
                    
            for name in UIFont.fontNames(forFamilyName: sName) {
                print("name: \(name as String)")
            }
        }
    }
    
    
    class func getOriginalDateFromString(dateStr:String,format:String)->Date{
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = format
        
        var date = formatter.date(from: dateStr)
        
        if date == nil{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formate1
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            date = dateFormatter.date(from: dateStr)
        }
        
        if date == nil{
            let dateFormatter = DateFormatter()
            formatter.dateFormat = formate2
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            date = formatter.date(from: dateStr)
        }
        
        if date == nil{
            let dateFormatter = DateFormatter()
            formatter.dateFormat = formate3
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            date = formatter.date(from: dateStr)
        }
        
        if date == nil{
            let dateFormatter = DateFormatter()
            formatter.dateFormat = formate4
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            date = formatter.date(from: dateStr)
        }
        
        return date!
    }
    
    class func getStringFromDate(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    class func setLabelsFonts(lbls:[UILabel],type:fontType,size:CGFloat){
        for lbl in lbls{
            if type.rawValue == 0{
                lbl.font = UIFont.RegularWithSize(size: size)
            }else if type.rawValue == 1{
                lbl.font = UIFont.BoldWithSize(size: size)
            }else if type.rawValue == 2{
                lbl.font = UIFont.SemiBoldWithSize(size: size)
            }else if type.rawValue == 3{
                lbl.font = UIFont.LightWithSize(size: size)
            }else if type.rawValue == 4{
                lbl.font = UIFont.MediumWithSize(size: size)
            }else if type.rawValue == 5{
                lbl.font = UIFont.boldItalicWithSize(size: size)
            }else if type.rawValue == 6{
                lbl.font = UIFont.ThinWithSize(size: size)
            }else {
                lbl.font = UIFont.BlackBoldItalicWithSize(size: size)
            }
        }
    }
    
    class func getCurrencyValueDouble(amt:Double,code:String) -> String{
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en-US") // US
        formatter.currencyCode = code
        //print(formatter.string(from: amt as NSNumber)?.components(separatedBy: ".")[0] ?? "")
        let amount = (formatter.string(from: NSNumber(value: amt)))
        return amount!
    }
    
    class func getCurrencyValue(amt:Float,code:String) -> String{
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en-US") // US
        formatter.currencyCode = code
        //print(formatter.string(from: amt as NSNumber)?.components(separatedBy: ".")[0] ?? "")
        let amount = (formatter.string(from: NSNumber(value: round(amt)))?.components(separatedBy: ".")[0] ?? "")
        return amount.replacingOccurrences(of: " ", with: "")
    }
    
    class func getCurrencyValue2(amt:Float,code:String) -> String{
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en-US") // US
        formatter.currencyCode = code
        //print(formatter.string(from: amt as NSNumber)?.components(separatedBy: ".")[0] ?? "")
        let amount = (formatter.string(from: NSNumber(value: amt)))
        return amount!
    }
    
    class func setAPIUrlsSettingsAndVersion(data:getUrlsData?){
        
        if data != nil{
            let key = "APIVersrion"
            print("Key:\(key) ----> Value:\(data!.version!)")
            UserDefaults.standard.set(data!.version!, forKey: key)
            if data!.settingList != nil{
                if data!.settingList!.count > 0{
                    for i in 0...data!.settingList!.count - 1{
                        let d = data!.settingList![i]
                        print("Key:\(d.name!) ----> Value:\(d.value!)")
                        UserDefaults.standard.set(d.value, forKey: d.name!)
                    }
                }
            }
            UserDefaults.standard.synchronize()
        }
    }
    
   class func getValueFromForKey(key:String)-> String{
       if UserDefaults.standard.value(forKey: key) != nil{
           let link = UserDefaults.standard.value(forKey: key) as! String
           return link
       }else{
           return ""
       }
    }
    
    class func setBottomGradientShadowToView(vC:UIViewController) {
        // Create a UIView to hold the gradient background
        let gradientView = UIView()
        gradientView.isUserInteractionEnabled = false
        gradientView.frame = CGRect(x: 0, y: vC.view.bounds.height - 250, width: vC.view.bounds.width, height: 250)
        
        // Create a CAGradientLayer for the gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [
            UIColor.hexStringToUIColor(hex: THEME_COLOR_BG).cgColor,   // End color (transparent)
            UIColor.hexStringToUIColor(hex: "FFF6C6").cgColor,  // Start color (dark)
        ]
        gradientLayer.locations = [0.0, 0.5] // Start and end points of the gradient

        // Add the gradient layer to the gradientView
        gradientView.layer.addSublayer(gradientLayer)
        
        // Add the gradient view as a subview to the main view
        vC.view.insertSubview(gradientView, at: 0) // Add behind all other views
    }
    
    
    class func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    class func getMinutesFromDate(date:Date) -> Int{
        
        var calendar = Calendar.current
        // *** Get components using current Local & Timezone ***
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))

        // *** define calendar components to use as well Timezone to UTC ***
        calendar.timeZone = NSTimeZone.local
        let minutes = calendar.component(.minute, from: date)
        
        return minutes
    }
    
    class func getTitles() -> String{
        
        return "Hi"
//        let hour = Calendar.current.component(.hour, from: Date())
//
//        switch hour {
//        case 6..<12 :  return NSLocalizedString("Good Morning", comment: "Good Morning")
//        case 12..<17 : return NSLocalizedString("Good Afternoon", comment: "Good Afternoon")
//        case 17..<19 : return NSLocalizedString("Good Evening", comment: "Good Evening")
//        default: return NSLocalizedString("Good Night", comment: "Good Night")
//        }
    }
    
    
    class func getSecondsFromDate(sDate:Date,eDate:Date) -> Int{
        
        var calendar = Calendar.current
        // *** define calendar components to use as well Timezone to UTC ***
        calendar.timeZone = NSTimeZone.local
        let sDateMinutes = calendar.component(.minute, from: sDate)
        let eDateMinutes = calendar.component(.minute, from: eDate)
        
        let sDateSeconds = calendar.component(.second, from: sDate)
        
    
        let min = eDateMinutes - sDateMinutes
        let remainingSec = ((min * 60) - sDateSeconds)
        //print(remainingSec)
        return remainingSec
    }
    
    class func makeSubstringBoldWithCustomFontAndColor(
        fullText: String,
        boldText: String,
        fullTextFont: UIFont,
        fullTextColor: UIColor,
        boldFont: UIFont,
        boldTextColor: UIColor
    ) -> NSAttributedString {
        // Create the base attributed string with the font and color for the full text
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: fullTextFont,
                .foregroundColor: fullTextColor
            ]
        )
        
        // Find the range of the bold text
        if let boldRange = fullText.range(of: boldText) {
            let nsRange = NSRange(boldRange, in: fullText)
            // Add the bold font and bold text color attributes to the bold text range
            attributedString.addAttributes(
                [
                    .font: boldFont,
                    .foregroundColor: boldTextColor
                ],
                range: nsRange
            )
        }
        
        return attributedString
    }
}

class GradientBottomView: UIView {
    override init(frame: CGRect) {
            super.init(frame: frame)
            setupGradient()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupGradient()
        }
        
        private func setupGradient() {
            // Create a gradient layer
            let gradientLayer = CAGradientLayer()
            
            // Set the colors for the gradient
            gradientLayer.colors = [
                UIColor.hexStringToUIColor(hex: THEME_COLOR_BG).cgColor,  // Top color
                UIColor.hexStringToUIColor(hex: "#FFF6C6").cgColor, // Bottom color
                UIColor.hexStringToUIColor(hex: "#fff3b5").cgColor, // Bottom color
                UIColor.hexStringToUIColor(hex: "#fcf8e1").cgColor, // Bottom color
                UIColor.hexStringToUIColor(hex: "#fff3b5").cgColor // Bottom color
            ]
            
            // Set start and end points for a vertical gradient
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)   // Top center
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)     // Bottom center
            
            // Set the gradient layer frame to cover the entire view
            gradientLayer.frame = self.bounds
            
            // Add the gradient layer to the view
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            // Ensure the gradient layer frame is updated if the view's bounds change
            self.layer.sublayers?.first?.frame = self.bounds
        }
}

extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}
