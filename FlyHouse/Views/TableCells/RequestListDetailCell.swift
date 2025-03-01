//
//  RequestListDetailCell.swift
//  FlyHouse
//
//  Created by Atul on 22/01/25.
//

import UIKit

class RequestListDetailCell: UITableViewCell {

    @IBOutlet weak var cellDetailView:UIView!
    
    @IBOutlet weak var distanceLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var detailDateLabel:UILabel!
    @IBOutlet weak var detailTimeLabel:UILabel!
    @IBOutlet weak var passengersLabel:UILabel!
    @IBOutlet weak var aircraftLabel:UILabel!
    @IBOutlet weak var amountLabel:UILabel!
    @IBOutlet weak var inflightLabel:UILabel!
    @IBOutlet weak var transportLabel:UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var aircraftTitleLabel:UILabel!
    
    @IBOutlet var titleLabelArr:[UILabel]!
    @IBOutlet var valueLabelArr:[UILabel]!
    
    @IBOutlet weak var timeDistanceView:UIView!
    @IBOutlet var transportViewToBottomSuperview:NSLayoutConstraint!
    @IBOutlet var transportViewToBottomStatusView:NSLayoutConstraint!
    @IBOutlet var statusView:UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        CommonFunction.setRoundedViews(arrayB: [timeDistanceView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setLabelsFonts(lbls: titleLabelArr, type: .fReguler, size: 11)
        CommonFunction.setLabelsFonts(lbls: valueLabelArr, type: .fReguler, size: 11)
        
    }
    
    
    func configuerPastRequest(indexPath:IndexPath,data:CPRequestData){
        
        
        if data.distance != nil{
            let distance = Double(data.distance!)
            self.distanceLabel.text = String(format: "%.0f miles", round(distance!))
        }
        
        if data.estimatedTimeInMinute != nil{
            
            let time = CommonFunction.minutesToHoursAndMinutes(data.estimatedTimeInMinute!)
            self.timeLabel.text = String(format: "%dh %dm", time.hours,time.leftMinutes)
        }
        
        if data.endDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.endDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.detailDateLabel.text = dateStr
        }
        
        if data.StartTime != nil{
            self.detailTimeLabel.text = data.StartTime
        }
        
        
        if data.paxCount != nil{
            self.passengersLabel.text = String(data.paxCount!)
        }
        
        if data.ownerAircraft != nil{ //aircraft
            self.aircraftLabel.text = data.ownerAircraft!
        }
        
        if data.FinalAmount != nil{
            
            let amount = CommonFunction.getCurrencyValue2(amt: Float(data.FinalAmount!), code: CURRENCY_CODE)
            self.amountLabel.text = amount
        }
        
        if data.isInflightServiceNeeded != nil{
            
            if (data.isInflightServiceNeeded == 0 || data.isInflightServiceNeeded == -1){
                self.inflightLabel.text = "No"
            }else{
                self.inflightLabel.text = "Yes"
            }
            //self.inflightLabel.text = String(data.isInflightServiceNeeded!)
        }
        
        if data.isTransportNeeded != nil{
            
            if (data.isTransportNeeded == 0 || data.isTransportNeeded == -1){
                self.transportLabel.text = "No"
            }else{
                self.transportLabel.text = "Yes"
            }
        }
        
        if data.requestStatus != nil{
            self.statusLabel.text = data.requestStatus!
        }
    }
    
    func configuerRequestConfrimCell(indexPath:IndexPath,data:CharterReqData){
        
        if data.Distance != nil{
            let distance = Double(data.Distance!)
            self.distanceLabel.text = String(format: "%.0f miles", round(distance!))
        }
        
        if data.EstimatedTimeInMinute != nil{
            
            let time = CommonFunction.minutesToHoursAndMinutes(data.EstimatedTimeInMinute!)
            self.timeLabel.text = String(format: "%dh %dm", time.hours,time.leftMinutes)
        }
        
        if data.EndDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.EndDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.detailDateLabel.text = dateStr
        }
        
        if data.StartTime != nil{
            self.detailTimeLabel.text = data.StartTime
        }
        
        
        if data.PaxCount != nil{
            self.passengersLabel.text = String(data.PaxCount!)
        }
        
        if data.Aircraft != nil{ //Aircraft
            self.aircraftLabel.text = data.OwnerAircraft!
        }
        
        if data.FinalAmount != nil{ // PriceExpectation
            
            let amount = CommonFunction.getCurrencyValue2(amt: Float(data.FinalAmount!), code: CURRENCY_CODE)
            self.amountLabel.text = amount
        }
        
        if data.IsInflightServiceNeeded != nil{
            
            if (data.IsInflightServiceNeeded == 0 || data.IsInflightServiceNeeded == -1){
                self.inflightLabel.text = "No"
            }else{
                self.inflightLabel.text = "Yes"
            }
            //self.inflightLabel.text = String(data.isInflightServiceNeeded!)
        }
        
        if data.IsTransportNeeded != nil{
            
            if (data.IsTransportNeeded == 0 || data.IsTransportNeeded == -1){
                self.transportLabel.text = "No"
            }else{
                self.transportLabel.text = "Yes"
            }
        }
        
        if data.RequestStatus != nil{
            self.statusLabel.text = data.RequestStatus!
        }
    }
    
    func configuerViewPastRequestDetailCell(indexPath:IndexPath,data:CPRequestData){
        
        if data.distance != nil{
            let distance = Double(data.distance!)
            self.distanceLabel.text = String(format: "%.0f miles", round(distance!))
        }
        
        if data.estimatedTimeInMinute != nil{
            
            if data.estimatedTimeInMinute! > 0{
                let time = CommonFunction.minutesToHoursAndMinutes(data.estimatedTimeInMinute!)
                self.timeLabel.text = String(format: "%dh %dm", time.hours,time.leftMinutes)
            }else{
                self.timeLabel.text = "--"
            }
        }
        
        if data.endDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.endDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.detailDateLabel.text = dateStr
        }
        
        if data.StartTime != nil{
            self.detailTimeLabel.text = data.StartTime
        }
        
        
        if data.paxCount != nil{
            self.passengersLabel.text = String(data.paxCount!)
        }
        
        if data.ownerAircraft != nil{
            self.aircraftLabel.text = data.ownerAircraft!
        }
        self.aircraftLabel.text = ""
        self.aircraftTitleLabel.text = ""
        
        if data.FinalAmount != nil{
            
            let amount = CommonFunction.getCurrencyValue2(amt: Float(data.FinalAmount!), code: CURRENCY_CODE)
            self.amountLabel.text = amount
        }
        
        if data.isInflightServiceNeeded != nil{
            
            if (data.isInflightServiceNeeded == 0 || data.isInflightServiceNeeded == -1){
                self.inflightLabel.text = "No"
            }else{
                self.inflightLabel.text = "Yes"
            }
            //self.inflightLabel.text = String(data.isInflightServiceNeeded!)
        }
        
        if data.isTransportNeeded != nil{
            
            if (data.isTransportNeeded == 0 || data.isTransportNeeded == -1){
                self.transportLabel.text = "No"
            }else{
                self.transportLabel.text = "Yes"
            }
        }
        
        if data.requestStatus != nil{
            self.statusLabel.text = data.requestStatus!
        }
        
        
    }
}
