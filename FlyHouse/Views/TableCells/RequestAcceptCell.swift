//
//  RequestAcceptCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol RequestAcceptCellDelegate{
    
    @objc optional
    func transportBtnPressed(option:String,value:Int)
    
    @objc optional
    func inflightServiceBtnPressed(option:String,value:Int)
}


class RequestAcceptCell: UITableViewCell {

    var delegate : RequestAcceptCellDelegate?
    @IBOutlet weak var transportationNeedTF:UITextField!
    @IBOutlet weak var InflightServiceTF:UITextField!
    
    @IBOutlet weak var dateTitleLabel:UILabel!
    @IBOutlet weak var dateValLabel:UILabel!
    
    @IBOutlet weak var timeTitleLabel:UILabel!
    @IBOutlet weak var timeValLabel:UILabel!
    
    @IBOutlet weak var durationTitleLabel:UILabel!
    @IBOutlet weak var durationValLabel:UILabel!
    
    @IBOutlet weak var paxTitleLabel:UILabel!
    @IBOutlet weak var paxValLabel:UILabel!
    
    @IBOutlet weak var priceTitleLabel:UILabel!
    @IBOutlet weak var priceValLabel:UILabel!
    
    @IBOutlet weak var aircraftTitleLabel:UILabel!
    @IBOutlet weak var aircraftValLabel:UILabel!
    
    @IBOutlet weak var lowPriceTitleLabel:UILabel!
    @IBOutlet weak var lowPriceValLabel:UILabel!
    
    @IBOutlet var titleLabelArr:[UILabel]!
    @IBOutlet var valueLabelArr:[UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        CommonFunction.setLabelsFonts(lbls: titleLabelArr, type: .fReguler, size: 12)
        
        CommonFunction.setLabelsFonts(lbls: valueLabelArr, type: .fSemiBold, size: 12)
    }
    
    func setAircraftAndPrice(name:String,price:Float){
        
        self.aircraftValLabel.text = name
        
        let amount = CommonFunction.getCurrencyValue2(amt: price, code: CURRENCY_CODE)
        self.lowPriceValLabel.text = amount
    }
    
    func configuerAcceptedRequestDetail(indexPath:IndexPath,data:CharterreResponse){
        
        if data.startDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.startDateTime!, format: formate2)
            
            let dateStr = formatter.string(from: date)
            
            self.dateValLabel.text = dateStr
            
            //formatter.dateFormat = "hh:mm a"
            
            //let timeStr = formatter.string(from: date)
            
            //self.timeValLabel.text = timeStr
        }
        
        if data.startTime != nil{
            self.timeValLabel.text = data.startTime!
        }
        
        
        if data.paxCount != nil{
            self.paxValLabel.text = String(data.paxCount!)
        }
        
//        if data.priceExpectation != nil{
//            let amount = CommonFunction.getCurrencyValue(amt: data.priceExpectation!, code: CURRENCY_CODE)
//            self.priceValLabel.text = amount
//        }
        
        if data.estimatedTimeInMinute != nil{
            if data.estimatedTimeInMinute! > 0{
                let time = CommonFunction.minutesToHoursAndMinutes(data.estimatedTimeInMinute!)
                let textStr = String(format: "%d hrs %d min", time.hours,time.leftMinutes)
                self.durationValLabel.text = textStr
            }else{
                self.durationValLabel.text = "0 hrs"
            }
        }
    }
    
    func configuerAcceptedPendingRequestDetail(indexPath:IndexPath,data:CharterReqData){
        
        if data.StartDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.StartDateTime!, format: formate2)
            
            let dateStr = formatter.string(from: date)
            
            self.dateValLabel.text = dateStr
            
            //formatter.dateFormat = "hh:mm a"
            
            //let timeStr = formatter.string(from: date)
            
            //self.timeValLabel.text = timeStr
        }
        
        if data.StartTime != nil{
            self.timeValLabel.text = data.StartTime!
        }
        
        if data.EstimatedTimeInMinute != nil{
            if data.EstimatedTimeInMinute! > 0{
                let time = CommonFunction.minutesToHoursAndMinutes(data.EstimatedTimeInMinute!)
                let textStr = String(format: "%d hrs %d min", time.hours,time.leftMinutes)
                self.durationValLabel.text = textStr
            }else{
                self.durationValLabel.text = "0 hrs"
            }
        }
        
        if data.PaxCount != nil{
            self.paxValLabel.text = String(data.PaxCount!)
        }
        
//        if data.PriceExpectation != nil{
//            let amount = CommonFunction.getCurrencyValue(amt: data.PriceExpectation!, code: CURRENCY_CODE)
//            self.priceValLabel.text = amount
//        }
        
    }
    
    @IBAction func transportButtonClicked(_ sender:UIButton){
        
        ASPicker.selectOption(dataArray: ["Yes","No"]) { value, atIndex in
            self.transportationNeedTF.text = value
            
            if value == "Yes"{
                self.delegate?.transportBtnPressed!(option: value, value: 1)
            }else{
                self.delegate?.transportBtnPressed?(option: value,value:0)
            }
        }
    }
    
    @IBAction func inflightButtonClicked(_ sender:UIButton){
       
        ASPicker.selectOption(dataArray: ["Yes","No"]) { value, atIndex in
            self.InflightServiceTF.text = value
            
            if value == "Yes"{
                self.delegate?.inflightServiceBtnPressed?(option: value,value:1)
            }else{
                self.delegate?.inflightServiceBtnPressed?(option: value,value:0)
            }
        }
    }
    
}

@objc protocol PaymentSplitCellDelegate{
    
    @objc optional
    func manageBtnPressed()
    
    @objc optional
    func splitBtnPressed(isSplit:Bool)
    
    func didNoOfPassengerChange(pax:Int)
}

class PaymentSplitCell : UITableViewCell{
    
    var delegate:PaymentSplitCellDelegate?
    @IBOutlet weak var splitView:UIView!
    @IBOutlet weak var labelSplit:UILabel!
    @IBOutlet weak var yesBtn:UIButton!
    @IBOutlet weak var noBtn:UIButton!
    @IBOutlet weak var frendShareSwitch:UISwitch!
    @IBOutlet weak var manageContBtn:UIButton!
    @IBOutlet var btnArr:[UIButton]!
    
    @IBOutlet weak var selfPaxLabel:UILabel!
    @IBOutlet weak var selfPaxTF:UITextField!
    @IBOutlet weak var selfPaxView:UIView!
    
    @IBOutlet weak var selfAmtLabel:UILabel!
    @IBOutlet weak var selfAmtTF:UITextField!
    @IBOutlet weak var selfAmtView:UIView!
    
    @IBOutlet weak var splitPaymentView:UIView!
    @IBOutlet var splitBtnViewToBottomSuperview:NSLayoutConstraint!
    @IBOutlet var splitBtnViewToView:NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //CommonFunction.setRoundedViews(arrayB: [splitView,selfAmtView,selfPaxView], radius: 5, borderColorCode: ThemeBorderColor, borderW: 1, bgColor: THEME_COLOR_BLIGHT)
        
        CommonFunction.setLabelsFonts(lbls: [selfPaxLabel,selfAmtLabel,labelSplit], type: .fReguler, size: 12)
        
        CommonFunction.setRoundedButtons(arrayB: [manageContBtn], radius: manageContBtn.frame.size.height/2, borderColorCode: blackColorCode, borderW: 1, bgColor: "", textColor: blackColorCode)
        
        CommonFunction.setTextFieldPlaceHolder(txtF: selfPaxTF, pholderText: "",size: 12,color: UIColor.hexStringToUIColor(hex: placeHolderColorCode),tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        
        CommonFunction.setTextFieldPlaceHolder(txtF: selfAmtTF, pholderText: "",size: 12,color: UIColor.hexStringToUIColor(hex: placeHolderColorCode),tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
    
        self.frendShareSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        //self.showSplitPaymentView()
        selfPaxTF.delegate = self
    }
    
    func configureCell(indexPath:IndexPath,tpax:Int,splitPax:Int,amount:Float,isSPlit:Int){
        
        
        self.selfPaxTF.text = String(tpax)
        
        let totalPaxAmt = (amount * Float(tpax))
        let amt = CommonFunction.getCurrencyValue2(amt: Float(totalPaxAmt), code: CURRENCY_CODE)
        self.selfAmtTF.text = amt
        
        if isSPlit == 1{
            frendShareSwitch.isOn = true
            self.showSplitPaymentView()
        }else{
            frendShareSwitch.isOn = false
            self.hideSplitPaymentView()
        }
    }
    
    func showSplitPaymentView(){
        self.splitBtnViewToBottomSuperview.priority = UILayoutPriority(250)
        self.splitBtnViewToView.priority = UILayoutPriority(999)
        self.splitPaymentView.isHidden = false
        
    }
    
    func hideSplitPaymentView(){
        self.splitBtnViewToBottomSuperview.priority = UILayoutPriority(999)
        self.splitBtnViewToView.priority = UILayoutPriority(250)
        self.splitPaymentView.isHidden = true
        
    }
    
    @objc func switchToggled(_ sender : UISwitch){
        if sender.isOn {
            //sender.thumbTintColor = UIColor.black
            self.delegate?.splitBtnPressed?(isSplit: true)
        }else{
            //sender.thumbTintColor = UIColor.hexStringToUIColor(hex: "A09387")
            self.delegate?.splitBtnPressed?(isSplit: false)
        }
    }
    
    @IBAction func manangeBtnClicked(_ sender:UIButton){
        self.delegate?.manageBtnPressed?()
    }
    
    @IBAction func splitBtnClicked(_ sender : UIButton){
        
        for btn in btnArr{
            btn.setImage(UIImage(named: "selected_not"), for: .normal)
        }
        sender.setImage(UIImage(named: "selected"), for: .normal)
        if sender.tag == 1{
            self.delegate?.splitBtnPressed?(isSplit: true)
        }else{
            self.delegate?.splitBtnPressed?(isSplit: false)
        }
    }
}

extension PaymentSplitCell : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
        if textField.text != ""{
            self.delegate?.didNoOfPassengerChange(pax: Int(textField.text!)!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        if textField == self.selfPaxTF{
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 2 characters
            return updatedText.count <= 2
        }else{
            return true
        }
    }
}
