//
//  RequestListCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class RequestListCell: UITableViewCell {
    
    @IBOutlet weak var confirmBtn:UIButton!
    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var cellDetailView:UIView!
    
    @IBOutlet weak var fromWayLable:UILabel!
    @IBOutlet weak var fromAddressLabel:UILabel!
    @IBOutlet weak var fromLabel:UILabel!
    
    @IBOutlet weak var toWayLable:UILabel!
    @IBOutlet weak var toAddressLabel:UILabel!
    @IBOutlet weak var toLabel:UILabel!

    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var durationLabel:UILabel!
    @IBOutlet weak var durationLineLabel:UILabel!
    
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
    
    @IBOutlet var confirmBtnHeightConst:NSLayoutConstraint!
    @IBOutlet var mainCellToBottomSuperview:NSLayoutConstraint!
    @IBOutlet var mainCellToDetailCellView:NSLayoutConstraint!
    @IBOutlet var detailCellBottomSuperview:NSLayoutConstraint!
    @IBOutlet var detailCellTopToSuperview:NSLayoutConstraint!
    
    @IBOutlet var transportViewToBottomSuperview:NSLayoutConstraint!
    @IBOutlet var transportViewToBottomStatusView:NSLayoutConstraint!
    @IBOutlet var statusView:UIView!
    
    //UI View
    @IBOutlet weak var s_routeRoundedView:UIView!
    @IBOutlet weak var d_routeRoundedView:UIView!
    
    @IBOutlet var titleLabelArr:[UILabel]!
    @IBOutlet var valueLabelArr:[UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        //self.contentView.backgroundColor = UIColor.black
        //self.backgroundColor = UIColor.black
        self.hideDetailView()
        //CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 10, borderColorCode: "", borderW: 0, bgColor: whiteColorCode)
        //fromWayLable.layer.cornerRadius = fromWayLable.frame.size.height/2
        //fromWayLable.layer.masksToBounds = true
        //toWayLable.layer.cornerRadius = toWayLable.frame.size.height/2
        //toWayLable.layer.masksToBounds = true
        
        //CommonFunction.setShadowToView(arrayV: [cellMainView], shadowColor: lightGrayColorCode, radius: 10)
        //CommonFunction.setShadowToView(arrayV: [cellDetailView], shadowColor: lightGrayColorCode, radius: 10)
       // CommonFunction.setRoundedButtons(arrayB: [self.confirmBtn], radius: self.confirmBtn.frame.size.height / 2, borderColorCode: "", borderW: 0, bgColor: "", textColor: blackColorCode)
        
        //self.durationLineLabel.backgroundColor = UIColor.clear
        
        CommonFunction.setRoundedViews(arrayB: [s_routeRoundedView,d_routeRoundedView], radius: 11, borderColorCode: INPUTF_BORDER_COLOR, borderW: 2, bgColor: THEME_COLOR_BG)
        
        CommonFunction.setLabelsFonts(lbls: [fromLabel,toLabel], type: .fSemiBold, size: 18.0)
        
        CommonFunction.setLabelsFonts(lbls: [fromAddressLabel,toAddressLabel], type: .fReguler, size: 10.0)
        
        CommonFunction.setLabelsFonts(lbls: titleLabelArr, type: .fReguler, size: 11)
        CommonFunction.setLabelsFonts(lbls: valueLabelArr, type: .fReguler, size: 11)
        
    }
    
    func hideDetailView(){
        
        self.mainCellToBottomSuperview.priority = UILayoutPriority(999)
        self.mainCellToDetailCellView.priority = UILayoutPriority(250)
        self.cellDetailView.isHidden = true
        self.detailCellBottomSuperview.priority = UILayoutPriority(250)
    }
    
    func showDetailView(){
        
        self.mainCellToBottomSuperview.priority = UILayoutPriority(250)
        self.mainCellToDetailCellView.priority = UILayoutPriority(999)
        self.detailCellBottomSuperview.priority = UILayoutPriority(999)
        self.cellDetailView.isHidden = false
        
    }
    
    func showDetailViewAndHideTop(){
        
        self.mainCellToBottomSuperview.priority = UILayoutPriority(250)
        self.mainCellToDetailCellView.priority = UILayoutPriority(250)
        self.detailCellTopToSuperview.priority = UILayoutPriority(999)
        self.detailCellBottomSuperview.priority = UILayoutPriority(999)
        self.cellDetailView.isHidden = false
        self.cellMainView.isHidden = true
    }
    
    func setDuration(text:String){
        //self.durationLineLabel.backgroundColor = UIColor.white
        //self.durationLabel.text = text
    }
    
    func configuerConfirmRequest(indexPath:IndexPath,data:CRLegData,fromVC:String){
        
        /*if fromVC != "RequestDetailVC"{
            if data.estimatedTimeInMinute != nil{
                if data.estimatedTimeInMinute! > 0{
                    let time = CommonFunction.minutesToHoursAndMinutes(data.estimatedTimeInMinute!)
                    let textStr = String(format: "Duration: %d hrs %d min", time.hours,time.leftMinutes)
                    self.setDuration(text: textStr)
                }
            }
        }*/
        
        
        if data.startAirport != nil{
            self.fromLabel.text = data.startAirport!
        }
        
        if data.endAirport != nil{
            self.toLabel.text = data.endAirport!
        }
        
        if data.startAirportInfo != nil{
            self.fromAddressLabel.text = data.startAirportInfo!
        }
        
        if data.endAirportInfo != nil{
            self.toAddressLabel.text = data.endAirportInfo!
        }
        
       /* if data.startDateTime != nil{
            
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.startDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLabel.text = dateStr
        }*/
    }
    
    func configuerConfirmPendingRequest(indexPath:IndexPath,data:CRlegDetailData){
        
        /*if data.EstimatedTimeInMinute != nil{
            if data.EstimatedTimeInMinute! > 0{
                let time = CommonFunction.minutesToHoursAndMinutes(data.EstimatedTimeInMinute!)
                let textStr = String(format: "Duration: %d hrs %d min", time.hours,time.leftMinutes)
                self.setDuration(text: textStr)
            }
        }*/
        
        if data.StartDisplayLine1 != nil{
            self.fromLabel.text = data.StartDisplayLine1!
        }
        
        if data.EndDisplayLine1 != nil{
            self.toLabel.text = data.EndDisplayLine1!
        }
        
        if data.StartDisplayLine2 != nil{
            self.fromAddressLabel.text = data.StartDisplayLine2!
        }
        
        if data.EndDisplayLine2 != nil{
            self.toAddressLabel.text = data.EndDisplayLine2!
        }
        
        /*if data.StartDateTime != nil{
            
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.StartDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLabel.text = dateStr
        }*/
    }
    
    func configuerConfirmedRequest(indexPath:IndexPath,data:CharterreResponse){
        
        
        if data.startAirportID != nil{
            self.fromLabel.text = data.startAirportID!
        }
        
        if data.endAirportID != nil{
            self.toLabel.text = data.endAirportID!
        }
        
        self.fromAddressLabel.text = ""
        self.toAddressLabel.text = ""
        
        
        if data.startDateTime != nil{
            
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.startDateTime!, format: formate2)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLabel.text = dateStr
        }
    }
    
    func configuerPastRequest(indexPath:IndexPath,data:CPRequestData){
        
        
        /*if data.startDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.startDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLabel.text = dateStr
        }*/
        
        if data.StartDisplayLine1 != nil{
            self.fromLabel.text = data.StartDisplayLine1!
        }
        
        if data.StartDisplayLine2 != nil{
            self.fromAddressLabel.text = data.StartDisplayLine2!
        }
        
//        if data.startstate != nil{
//            self.fromAddressLabel.text?.append(" ,\(data.startstate!)")
//        }
//
//        if data.startcountry != nil{
//            self.fromAddressLabel.text?.append(" ,\(data.startcountry!)")
//        }
        
        
        if data.EndDisplayLine1 != nil{
            self.toLabel.text = data.EndDisplayLine1!
        }
        
        if data.EndDisplayLine2 != nil{
            self.toAddressLabel.text = data.EndDisplayLine2!
        }
        
//        if data.endstate != nil{
//            self.toAddressLabel.text?.append(" ,\(data.endstate!)")
//        }
//
//        if data.endcountry != nil{
//            self.toAddressLabel.text?.append(" ,\(data.endcountry!)")
//        }
        
        if data.distance != nil{
            let distance = Double(data.distance!)
            self.distanceLabel.text = String(format: "%.0f miles", round(distance!))
        }
        
        if data.estimatedTimeInMinute != nil{
            
            let time = CommonFunction.minutesToHoursAndMinutes(data.estimatedTimeInMinute!)
            self.timeLabel.text = String(format: "%d hrs %d min", time.hours,time.leftMinutes)
        }
        
//        if data.endDateTime != nil{
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MMMM d, yyyy"
//            
//            let date = CommonFunction.getOriginalDateFromString(dateStr: data.endDateTime!, format: formate3)
//            
//            let dateStr = formatter.string(from: date)
//            
//            self.detailDateLabel.text = dateStr
//        }
        
//        if data.StartTime != nil{
//            self.detailTimeLabel.text = data.StartTime
//        }
        
        
        if data.paxCount != nil{
            self.passengersLabel.text = String(data.paxCount!)
        }
        
//        if data.ownerAircraft != nil{ //aircraft
//            self.aircraftLabel.text = data.ownerAircraft!
//        }
        
        if data.FinalAmount != nil{
            
            let amount = CommonFunction.getCurrencyValue(amt: Float(data.FinalAmount!), code: CURRENCY_CODE)
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
        
        /*if data.StartDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.StartDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLabel.text = dateStr
        }*/
        
        if data.StartAirportID != nil{
            self.fromLabel.text = data.StartAirportID!
        }
        
        if data.startcity != nil{
            self.fromAddressLabel.text = data.startcity!
        }
        
        if data.startstate != nil{
            self.fromAddressLabel.text?.append(" ,\(data.startstate!)")
        }
        
        if data.startcountry != nil{
            self.fromAddressLabel.text?.append(" ,\(data.startcountry!)")
        }
        
        
        if data.EndAirportID != nil{
            self.toLabel.text = data.EndAirportID!
        }
        
        if data.endcity != nil{
            self.toAddressLabel.text = data.endcity!
        }
        
        if data.endstate != nil{
            self.toAddressLabel.text?.append(" ,\(data.endstate!)")
        }
        
        if data.endcountry != nil{
            self.toAddressLabel.text?.append(" ,\(data.endcountry!)")
        }
        
        if data.Distance != nil{
            let distance = Double(data.Distance!)
            self.distanceLabel.text = String(format: "%.0f miles", round(distance!))
        }
        
        if data.EstimatedTimeInMinute != nil{
            
            let time = CommonFunction.minutesToHoursAndMinutes(data.EstimatedTimeInMinute!)
            self.timeLabel.text = String(format: "%d hrs %d min", time.hours,time.leftMinutes)
        }
        
//        if data.EndDateTime != nil{
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MMMM d, yyyy"
//            
//            let date = CommonFunction.getOriginalDateFromString(dateStr: data.EndDateTime!, format: formate3)
//            
//            let dateStr = formatter.string(from: date)
//            
//            self.detailDateLabel.text = dateStr
//        }
        
//        if data.StartTime != nil{
//            self.detailTimeLabel.text = data.StartTime
//        }
        
    
        if data.PaxCount != nil{
            self.passengersLabel.text = String(data.PaxCount!)
        }
        
//        if data.Aircraft != nil{ //Aircraft
//            self.aircraftLabel.text = data.OwnerAircraft!
//        }
        
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
                self.timeLabel.text = String(format: "%d hrs %d min", time.hours,time.leftMinutes)
            }else{
                self.timeLabel.text = ""
            }
        }
        
//        if data.endDateTime != nil{
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MMMM d, yyyy"
//            
//            let date = CommonFunction.getOriginalDateFromString(dateStr: data.endDateTime!, format: formate3)
//            
//            let dateStr = formatter.string(from: date)
//            
//            self.detailDateLabel.text = dateStr
//        }
        
//        if data.StartTime != nil{
//            self.detailTimeLabel.text = data.StartTime
//        }
        
        
        if data.paxCount != nil{
            self.passengersLabel.text = String(data.paxCount!)
        }
        
//        if data.ownerAircraft != nil{
//            self.aircraftLabel.text = data.ownerAircraft!
//        }
        
        if data.FinalAmount != nil{
            
            let amount = CommonFunction.getCurrencyValue(amt: Float(data.FinalAmount!), code: CURRENCY_CODE)
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
    
    func configuerMyTripCell(indexPath:IndexPath,data:MyTripData){
        
        /*if data.StartDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.StartDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLabel.text = dateStr
        }*/
        
        if data.StartAirportID != nil{
            self.fromLabel.text = data.StartAirportID!
        }
        
        if data.StartDisplayLine1 != nil{
            self.fromLabel.text = data.StartDisplayLine1!
        }
        
        if data.EndAirportID != nil{
            self.toLabel.text = data.EndAirportID!
        }
        
        if data.EndDisplayLine1 != nil{
            self.toLabel.text = data.EndDisplayLine1!
        }
        
        if data.Arrival != nil{
            self.fromAddressLabel.text = data.Arrival!
        }
        
        if data.StartDisplayLine2 != nil{
            self.fromAddressLabel.text = data.StartDisplayLine2!
        }
        
        if data.Destination != nil{
            self.toAddressLabel.text = data.Destination!
        }
        
        if data.EndDisplayLine2 != nil{
            self.toAddressLabel.text = data.EndDisplayLine2!
        }
        
    }
}
