//
//  RequestConfirmCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol RequestConfirmCellDelegate{
    
    @objc optional
    func editBtnPressed()
    
    @objc optional
    func confirmBtnPressed()
    
    @objc optional
    func cancelRequestBtnPressed()
}

class RequestConfirmCell: UITableViewCell {
    

    var delegate:RequestConfirmCellDelegate?
    @IBOutlet weak var cellMainView:UIView!
    
    @IBOutlet weak var dateTitleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    
    @IBOutlet weak var timeTitleLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    
    @IBOutlet weak var edateTitleLabel:UILabel!
    @IBOutlet weak var edateLabel:UILabel!
    
    @IBOutlet weak var etimeTitleLabel:UILabel!
    @IBOutlet weak var etimeLabel:UILabel!
    
    @IBOutlet weak var passengersTitleLabel:UILabel!
    @IBOutlet weak var passengersLabel:UILabel!
    
    @IBOutlet weak var priceTitleLabel:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    
    @IBOutlet weak var aircraftsTitleLabel:UILabel!
    @IBOutlet weak var aircraftsLabel:UILabel!
    
    @IBOutlet var startTimeToTopPassengerConst:NSLayoutConstraint!
    @IBOutlet var startTimeToTopEndDateConst:NSLayoutConstraint!
    @IBOutlet weak var endDateTimeView:UIView!
    
    @IBOutlet  var titleLabelArr:[UILabel]!
    @IBOutlet  var valueLabelArr:[UILabel]!
    
    @IBOutlet weak var editBtn:UIButton!
    @IBOutlet weak var confirmBtn:UIButton!
    @IBOutlet weak var cancelReqBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.hideEndDateTimeView()
        //CommonFunction.setRoundedButtons(arrayB: [confirmBtn,cancelReqBtn], radius: 10, borderColorCode: "", borderW: 0, bgColor: buttonBGColor, textColor: blackColorCode)
        
        CommonFunction.setLabelsFonts(lbls: titleLabelArr, type: .fReguler, size: 12)
        CommonFunction.setLabelsFonts(lbls: valueLabelArr, type: .fSemiBold, size: 12)
        
    }
    
    func configuerConfirmRequestDetail(indexPath:IndexPath,data:CharterreResponse,typeIndex:Int){
        
        let data1 = data.crleg!.first!
        let data2 = data.crleg!.last!
        
        if data1.startDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data1.startDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLabel.text = dateStr
        }
          
        if data1.startTime != nil{
            self.timeLabel.text = data1.startTime!
            
        }
        
        if data.paxCount != nil{
            self.passengersLabel.text = String(data.paxCount!)
        }
        
        //if data.priceExpectation != nil{
            
            //let amount = CommonFunction.getCurrencyValue(amt: data.priceExpectation!, code: CURRENCY_CODE)
            //self.priceLabel.text = amount
        //}
        
        if typeIndex > 0{
            self.showEndDateTimeView()
            
            if data2.endDateTime != nil{
                let formatter = DateFormatter()
                formatter.dateFormat = formate8
                
                let date = CommonFunction.getOriginalDateFromString(dateStr: data2.endDateTime!, format: formate3)
                
                let dateStr = formatter.string(from: date)
                self.edateLabel.text = dateStr
            }
            
            if data2.startTime != nil{
                self.etimeLabel.text = data2.startTime!
            }
            
            if typeIndex == 1 || typeIndex == 2{
                if typeIndex == 1{
                    self.edateTitleLabel.text = "Return Date"
                    self.etimeTitleLabel.text = "Return Time"
                }else{
                    self.edateTitleLabel.text = "End Date"
                    self.etimeTitleLabel.text = "End Time"
                }
            }
            
        }else{
            self.hideEndDateTimeView()
        }
        
//        if data.preferredAircraftIDCSV != nil{
//            self.aircraftsLabel.text = data.preferredAircraftIDCSV!
//        }
        
    }
    
    func showEndDateTimeView(){
        
        self.startTimeToTopEndDateConst.priority = UILayoutPriority(999)
        self.startTimeToTopPassengerConst.priority = UILayoutPriority(250)
        self.endDateTimeView.isHidden = false
    }
    
    func hideEndDateTimeView(){
        
        self.startTimeToTopEndDateConst.priority = UILayoutPriority(250)
        self.startTimeToTopPassengerConst.priority = UILayoutPriority(999)
        self.endDateTimeView.isHidden = true
    }
    
    @IBAction func editButtonClicked(_ sender:UIButton){
        self.delegate?.editBtnPressed?()
    }
    
//    @IBAction func confirmButtonClicked(_ sender:UIButton){
//        self.delegate?.confirmBtnPressed?()
//    }
//    
//    @IBAction func cancelRequestButtonPressed(_ sender: UIButton){
//        self.delegate?.cancelRequestBtnPressed?()
//    }
}
