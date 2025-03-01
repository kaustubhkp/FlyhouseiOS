//
//  MyTripDetailCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 11/02/24.
//

import UIKit

class MyTripDetailCell: UITableViewCell {
    
    @IBOutlet weak var mainCellView:UIView!
    @IBOutlet weak var paymentView:UIView!
    
    @IBOutlet weak var distanceLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var tripNumberLabel:UILabel!
    @IBOutlet weak var confirmCodeLabel:UILabel!
    @IBOutlet weak var detailDateLabel:UILabel!
    @IBOutlet weak var detailTimeLabel:UILabel!
    @IBOutlet weak var passengersLabel:UILabel!
    @IBOutlet weak var aircraftLabel:UILabel!
    @IBOutlet weak var amountLabel:UILabel!
    @IBOutlet weak var insightServicesLabel:UILabel!
    @IBOutlet weak var transportLabel:UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var processingFeesLabel:UILabel!
    @IBOutlet weak var passengerSegfeesLabel:UILabel!
    @IBOutlet weak var fatLabel:UILabel!
    @IBOutlet weak var cancellationFeesLabel:UILabel!
    @IBOutlet weak var totalAmtLabel:UILabel!
    
    @IBOutlet weak var transactionNoLabel:UILabel!
    @IBOutlet weak var AmtPaidLabel:UILabel!
    @IBOutlet weak var paidByLabel:UILabel!
    @IBOutlet weak var dueAmtLabel:UILabel!
    
    @IBOutlet var titleLabelArr:[UILabel]!
    @IBOutlet var valueLabelArr:[UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        CommonFunction.setRoundedViews(arrayB: [mainCellView,paymentView], radius: 10, borderColorCode: "", borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        self.mainCellView.layer.borderColor = UIColor.hexStringToUIColor(hex: "ebe5df").cgColor
        self.mainCellView.layer.borderWidth = 1
        self.paymentView.layer.borderColor = UIColor.hexStringToUIColor(hex: "ebe5df").cgColor
        self.paymentView.layer.borderWidth = 1
        
        CommonFunction.setLabelsFonts(lbls: titleLabelArr, type: .fReguler, size: 11)
        CommonFunction.setLabelsFonts(lbls: valueLabelArr, type: .fReguler, size: 11)
    }
    
    func confugurationPaymentDetailCell(indexPath:IndexPath,data:PaymentData,tripData:MyTripData){
        
        if tripData.EstimatedTimeInMinute != nil{
            if tripData.EstimatedTimeInMinute! > 0{
                
                let time = CommonFunction.minutesToHoursAndMinutes(tripData.EstimatedTimeInMinute!)
                let textStr = String(format: "%d hrs %d min", time.hours,time.leftMinutes)
                self.timeLabel.text = textStr
            }else{
                self.timeLabel.text = "0 hrs"
            }
        }
        
        if tripData.Distance != nil{
            self.distanceLabel.text = String(format: "%dmi",tripData.Distance!)
        }
        
        /*if tripData.TripID != nil{
            self.tripNumberLabel.text = String(tripData.TripID!)
        }
        
        if data.ConfirmationCode != nil{
            self.confirmCodeLabel.text = data.ConfirmationCode!
        }*/
        
        
        if tripData.PaxCount != nil{
            self.passengersLabel.text = String(tripData.PaxCount!)
        }
        
        /*if tripData.StartDateTime != nil{
            
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: tripData.StartDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.detailDateLabel.text = dateStr
        }
        
        if tripData.StartTime != nil{
            self.detailTimeLabel.text = tripData.StartTime!
        }
        
        if tripData.Aircraft != nil{
            self.aircraftLabel.text = tripData.Aircraft!
        }*/
        
        if tripData.IsTransportNeeded != nil{
            
            if tripData.IsTransportNeeded! == 0{
                self.transportLabel.text = "No"
            }else{
                self.transportLabel.text = "Yes"
            }
                
        }
        
        if tripData.IsInflightServiceNeeded != nil{
            if tripData.IsInflightServiceNeeded! == 0{
                self.insightServicesLabel.text = "No"
            }else{
                self.insightServicesLabel.text = "Yes"
            }
              
        }
        
       /* if tripData.DocuSignStatus != nil{
            if tripData.DocuSignStatus != ""{
                self.statusLabel.text = tripData.DocuSignStatus!
            }
        }
        
        if data.Amount != nil{
            let amount = CommonFunction.getCurrencyValue(amt: Float(data.Amount!), code: CURRENCY_CODE)
            self.amountLabel.text =   amount
        }
        
        if data.FHCharges != nil{
            
            let amount = CommonFunction.getCurrencyValue(amt: Float(data.FHCharges!), code: CURRENCY_CODE)
            self.processingFeesLabel.text =   amount
        }
        
        if data.FETCharges != nil{
            
            let amount = CommonFunction.getCurrencyValue(amt: Float(data.FETCharges!), code: CURRENCY_CODE)
            self.fatLabel.text =   amount
        }
        
        if data.TotalPassengerSegmentFees != nil{
            
            let amount = CommonFunction.getCurrencyValue(amt: Float(data.TotalPassengerSegmentFees!), code: CURRENCY_CODE)
            self.passengerSegfeesLabel.text =   amount
        }*/
        
        if data.CancellationFees != nil{
//            if data.CancellationFees == 0{
//                self.cancellationFeesLabel.text =   "No"
//            }else{
//                self.cancellationFeesLabel.text =   "Yes"
//            }
            
            
            //let amount = CommonFunction.getCurrencyValueDouble(amt: Double(data.CancellationFees!), code: CURRENCY_CODE)
            //self.cancellationFeesLabel.text =   amount
        }
        
        if data.FinalAmount != nil{
            
            let amount = CommonFunction.getCurrencyValueDouble(amt: Double(data.FinalAmount!), code: CURRENCY_CODE)
            self.totalAmtLabel.text =   amount
        }
        
        
        //Last Payment Details
//        if data.TransactionNumber != nil{
//            self.transactionNoLabel.text = data.TransactionNumber!
//        }
        
        if data.AmountPaid != nil{
            let amount = CommonFunction.getCurrencyValueDouble(amt: Double(data.AmountPaid!), code: CURRENCY_CODE)
            self.AmtPaidLabel.text = amount
        }
        
//        if data.PaymentType != nil{
//            self.paidByLabel.text = data.PaymentType!
//        }
        
        if data.AmountDue != nil{
            let amount = CommonFunction.getCurrencyValueDouble(amt: Double(data.AmountDue!), code: CURRENCY_CODE)
            self.dueAmtLabel.text = amount
        }
    }
}
