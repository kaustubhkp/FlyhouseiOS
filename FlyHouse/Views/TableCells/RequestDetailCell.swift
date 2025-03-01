//
//  RequestDetailCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class RequestDetailCell: UITableViewCell {
    
    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var timerView:UIView!
    
    @IBOutlet weak var timerTitleLabel:UILabel!
    @IBOutlet weak var timerLbel:UILabel!
    
    @IBOutlet weak var currentBidTitleLabel:UILabel!
    @IBOutlet weak var currentBidLabel:UILabel!
    
    @IBOutlet weak var dateTitleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    
    @IBOutlet weak var timeTitleLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    
    @IBOutlet weak var durationTitleLabel:UILabel!
    @IBOutlet weak var durationLabel:UILabel!
    
    @IBOutlet weak var passengersTitleLabel:UILabel!
    @IBOutlet weak var passengersLabel:UILabel!
    
    @IBOutlet weak var priceTitleLabel:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    
    @IBOutlet weak var aircraftsTitleLabel:UILabel!
    @IBOutlet weak var aircraftsLabel:UILabel!
    
    @IBOutlet var detailViewToTopHeaderViewConst:NSLayoutConstraint!
    @IBOutlet var detailViewToTopSuperviewConst:NSLayoutConstraint!
    
    @IBOutlet weak var acceptTimerView:UIView!
    @IBOutlet weak var acceptTimerTitleLabel:UILabel!
    @IBOutlet weak var acceptTimerLabel:UILabel!
    
    @IBOutlet var titleLblArr:[UILabel]!
    @IBOutlet var valueLblArr:[UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        //cellMainView.backgroundColor = .white
        
        CommonFunction.setLabelsFonts(lbls: [self.acceptTimerTitleLabel], type: .fBold, size: 11)
       
        CommonFunction.setLabelsFonts(lbls: [self.acceptTimerLabel], type: .fReguler, size: 11)
        
        CommonFunction.setRoundedViews(arrayB: [timerView,acceptTimerView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setLabelsFonts(lbls: [timerTitleLabel,currentBidTitleLabel,acceptTimerTitleLabel], type: .fReguler, size: 11)
        
        CommonFunction.setLabelsFonts(lbls: [timerLbel,currentBidLabel,acceptTimerLabel], type: .fReguler, size: 11)
        
        CommonFunction.setLabelsFonts(lbls: titleLblArr, type: .fReguler, size: 11)
        CommonFunction.setLabelsFonts(lbls: valueLblArr, type: .fReguler, size: 11)
    }
    
    func hideTimerView(){
        self.timerView.isHidden = true
    }
    
    func showTimerView(){
        self.timerView.isHidden = false
    }
    
    
    func configuerConfirmRequestDetail(indexPath:IndexPath,data:CharterreResponse,typeIndex:Int){
        
        let data1 = data.crleg!.first!
        
        
        if data.estimatedTimeInMinute != nil{
            if data.estimatedTimeInMinute! > 0{
                
                let time = CommonFunction.minutesToHoursAndMinutes(data.estimatedTimeInMinute!)
                let textStr = String(format: "%d hrs %d min", time.hours,time.leftMinutes)
                self.durationLabel.text = textStr
            }else{
                self.durationLabel.text = "0 hrs"
            }
        }
        
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
        
//        if data.priceExpectation != nil{
//
//            let amount = CommonFunction.getCurrencyValue(amt: data.priceExpectation!, code: CURRENCY_CODE)
//            self.priceLabel.text = amount
//        }
        
        /*if typeIndex > 0{
           // self.showEndDateTimeView()
            let data2 = data.crleg!.last!
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
        }*/
        
    }
    
    func configuerConfirmPendingRequestDetail(indexPath:IndexPath,data:CharterReqData){
        
        if data.EstimatedTimeInMinute != nil{
            if data.EstimatedTimeInMinute! > 0{
                let time = CommonFunction.minutesToHoursAndMinutes(data.EstimatedTimeInMinute!)
                let textStr = String(format: "%d hrs %d min", time.hours,time.leftMinutes)
                self.durationLabel.text = textStr
            }else{
                self.durationLabel.text = "0 hrs"
            }
        }
        
        if data.StartDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.StartDateTime!, format: formate2)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLabel.text = dateStr
            
            //formatter.dateFormat = "hh:mm a"
            
           // let timeStr = formatter.string(from: date)
            
            //self.timeLabel.text = timeStr
        }
        
        if data.StartTime != nil{
            self.timeLabel.text = data.StartTime!
        }
        
        if data.PaxCount != nil{
            self.passengersLabel.text = String(data.PaxCount!)
        }
        
//        if data.PriceExpectation != nil{
//            let amount = CommonFunction.getCurrencyValue(amt: data.PriceExpectation!, code: CURRENCY_CODE)
//            self.priceLabel.text = amount
//        }
        
    }
}
