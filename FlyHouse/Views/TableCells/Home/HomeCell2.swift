//
//  HomeCell2.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol HomeCell2Delegate{
    
    @objc optional
    func passengerBtnPressed()
    
    @objc optional
    func tripInfoBtnPressed(text:String,index:Int)
    
    @objc optional
    func aircraftBtnPressed(text:String)
    
    @objc optional
    func returnDateBtnPressed(onIndex:Int)
    
    @objc optional
    func returnTimeBtnPressed(onIndex:Int)
    
    @objc optional
    func setPrice(price:String)
    
    @objc optional
    func setPassenger(pax:String)
    
    @objc optional
    func setTollNumber(tno:String)
}

class HomeCell2: UITableViewCell {
    
    var delegate:HomeCell2Delegate?
    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var cellMainView2:UIView!
    @IBOutlet weak var imageV:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var fieldLabel:UILabel!
    @IBOutlet weak var fieldBtn:UIButton!
    @IBOutlet weak var fieldTxtF:UITextField!
    
    @IBOutlet weak var returnDateBtn:UIButton!
    @IBOutlet weak var returnDateTitleLabel:UILabel!
    @IBOutlet weak var returnDateLabel:UILabel!
    
    @IBOutlet weak var returnTimeBtn:UIButton!
    @IBOutlet weak var returnTimeTitleLabel:UILabel!
    @IBOutlet weak var returnTimeLabel:UILabel!
    
    @IBOutlet var imageWidthConst:NSLayoutConstraint!
    
    var tripTypeIndex:Int! = 0
    var tripTypeArr:[String] = ["One Way","Round Trip","Multi City"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellMainView2.isHidden = true
        self.selectionStyle = .none
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setRoundedViews(arrayB: [cellMainView2], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUTF_BORDER_COLOR)
        
        CommonFunction.setLabelsFonts(lbls: [self.returnDateTitleLabel,returnDateLabel,returnTimeTitleLabel,returnTimeLabel], type: .fReguler, size: 12)
        
        self.fieldTxtF.isUserInteractionEnabled = false
        CommonFunction.setTextFieldFontsTypeWithSize(arrayT: [fieldTxtF], size: 12, type: .fReguler)
       // self.fieldTxtF.isHidden = true
        self.fieldTxtF.delegate = self
        self.fieldTxtF.keyboardType = .default
    }
    
    func configuerReturnDateCell(indexPath:IndexPath,dateStr:String){
        
         //Return Date
        self.fieldTxtF.isHidden = false
        self.fieldBtn.isHidden = false
        self.fieldTxtF.text = dateStr
        self.imageV.image = UIImage(named: "calendar")
        self.imageWidthConst.constant = 20
        self.fieldBtn.tag = 4
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont.RegularWithSize(size: 12) // Note the !
        ]
        fieldTxtF.isUserInteractionEnabled = false
        fieldTxtF.attributedPlaceholder = NSAttributedString(string: "Return Date", attributes:attributes)
        self.fieldBtn.addTarget(self, action: #selector(feildBtnClicked), for: .touchUpInside)
    }
    
    
    func configuerReturnTimeCell(indexPath:IndexPath,timeStr:String){
    
        //Return Departure Time
        self.fieldTxtF.isHidden = false
        self.fieldBtn.isHidden = false
        self.fieldTxtF.text = timeStr
        self.imageWidthConst.constant = 24
        self.imageV.image = UIImage(named: "time_unselect")
        self.fieldBtn.tag = 5
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont.RegularWithSize(size: 12) // Note the !
        ]
        fieldTxtF.isUserInteractionEnabled = false
        fieldTxtF.attributedPlaceholder = NSAttributedString(string: "Departure Time", attributes:attributes)
        self.fieldBtn.addTarget(self, action: #selector(feildBtnClicked), for: .touchUpInside)
        
    }
    
    func cofigureReturnDateTimeCell(indexPath:IndexPath,dateStr:String,timeStr:String){
        
        self.cellMainView.isHidden = true
        self.cellMainView2.isHidden = false
        
        if dateStr == ""{
            self.returnDateTitleLabel.isHidden = false
            self.returnDateLabel.text = ""
        }else{
            self.returnDateTitleLabel.isHidden = true
            self.returnDateLabel.text = dateStr
        }
        
        if timeStr == ""{
            self.returnTimeTitleLabel.isHidden = false
            self.returnTimeLabel.text = ""
        }else{
            self.returnTimeTitleLabel.isHidden = true
            self.returnTimeLabel.text = timeStr
        }
        
    }
    
    func configuerOtherCell(indexPath:IndexPath,noOfPass:String,price:String,aircrafts:[String]){
        self.cellMainView2.isHidden = true
        self.cellMainView.isHidden = false
        if indexPath.row == 0{// Number of Passenger
            
            self.fieldTxtF.isHidden = false
            self.fieldTxtF.isUserInteractionEnabled = true
            self.fieldBtn.isHidden = true
            self.imageWidthConst.constant = 25
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font : UIFont.RegularWithSize(size: 12) // Note the !
            ]
            fieldTxtF.keyboardType = .numberPad
            fieldTxtF.attributedPlaceholder = NSAttributedString(string: "Number of Passengers", attributes:attributes)
            
            self.fieldTxtF.text = noOfPass
            self.fieldTxtF.tag = 1
            self.imageV.image = UIImage(named: "profile_unselect")
        
            
        }else if indexPath.row == 1{ // Price
            
            self.fieldTxtF.isHidden = false
            self.fieldTxtF.isUserInteractionEnabled = true
            self.fieldBtn.isHidden = true
            self.imageWidthConst.constant = 27
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font : UIFont.RegularWithSize(size: 12) // Note the !
            ]
            fieldTxtF.keyboardType = .numberPad
            fieldTxtF.attributedPlaceholder = NSAttributedString(string: "Price", attributes:attributes)
            self.imageV.image = UIImage(named: "dollerSign")!.withRenderingMode(.alwaysTemplate)
            self.imageV.tintColor = UIColor.lightGray
            self.fieldTxtF.text = price
            self.fieldTxtF.tag = 2
            
        }else{ // Prefered Aircraft
            
            
        }
    }
    
    func configuerPassengerTollNumberCell(indexPath:IndexPath,noOfPass:String,tollNo:String){
        
        self.cellMainView.isHidden = false
        self.cellMainView2.isHidden = true
        if indexPath.row == 0{// Number of Passenger
            
            self.fieldTxtF.isHidden = false
            self.fieldTxtF.isUserInteractionEnabled = true
            self.fieldBtn.isHidden = true
            self.imageWidthConst.constant = 25
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font : UIFont.RegularWithSize(size: 12) // Note the !
            ]
            fieldTxtF.keyboardType = .numberPad
            fieldTxtF.attributedPlaceholder = NSAttributedString(string: "Number of Passengers", attributes:attributes)
            
            self.fieldTxtF.text = noOfPass
            self.fieldTxtF.tag = 1
            self.imageV.image = UIImage(named: "passenger_icon")
        
            
        }else if indexPath.row == 1{ // Toll Number
            
            self.fieldTxtF.isHidden = false
            self.fieldTxtF.isUserInteractionEnabled = true
            self.fieldBtn.isHidden = true
            self.imageWidthConst.constant = 27
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font : UIFont.RegularWithSize(size: 12) // Note the !
            ]
            fieldTxtF.keyboardType = .asciiCapable
            fieldTxtF.attributedPlaceholder = NSAttributedString(string: "Tail Number", attributes:attributes)
            self.imageV.image = UIImage(named: "plane_icon")!.withRenderingMode(.alwaysTemplate)
            self.imageV.tintColor = UIColor.lightGray
            self.fieldTxtF.text = tollNo
            self.fieldTxtF.tag = 3
            
        }
    }
    
    @IBAction func feildBtnClicked(_ sender : UIButton){
        
        if sender.tag == 0{
            ASPicker.selectOption(dataArray: tripTypeArr) { value, atIndex in
                self.titleLabel.text = value
                self.tripTypeIndex = atIndex
                self.delegate?.tripInfoBtnPressed?(text: value, index: atIndex)
            }
        }else if sender.tag == 1{
            self.delegate?.passengerBtnPressed?()
        }else if sender.tag == 2{
            
        }else if sender.tag == 3{
            self.delegate?.aircraftBtnPressed?(text: "")
        }else if sender.tag == 4{
            self.delegate?.returnDateBtnPressed?(onIndex: 0)
        }else{
            self.delegate?.returnTimeBtnPressed?(onIndex: 0)
        }
    }
    
    @IBAction func returnDateBtnClicked(_ sender : UIButton){
        self.delegate?.returnDateBtnPressed?(onIndex: 0)
    }
    
    @IBAction func returnTimeBtnClicked(_ sender : UIButton){
        self.delegate?.returnTimeBtnPressed?(onIndex: 0)
    }
}

extension HomeCell2 : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1{
            self.delegate?.setPassenger?(pax: textField.text!)
        }else if textField.tag == 2{
            self.delegate?.setPrice?(price: textField.text!)
        }else{
            self.delegate?.setTollNumber?(tno: textField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

}

