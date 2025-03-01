//
//  InstantBookViewCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 05/02/24.
//

import UIKit

@objc protocol InstantBookViewCellDelegate{
    
    @objc optional
    func bookFlightBtnPressed(atIndex:Int)
}

class InstantBookViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var borderView:UIView!
    @IBOutlet weak var detailView:UIView!
    @IBOutlet weak var bookingFlightBtn:UIButton!
    
    @IBOutlet weak var aircraftName:UILabel!
    @IBOutlet weak var startAircraft:UILabel!
    @IBOutlet weak var endAircraft:UILabel!
    @IBOutlet weak var startAircraftInfo:UILabel!
    @IBOutlet weak var endAircraftInfo:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    @IBOutlet weak var paxLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    
    var delegate:InstantBookViewCellDelegate?
    @IBOutlet var lableArr:[UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        CommonFunction.setRoundedViews(arrayB: [mainView,detailView], radius: 10, borderColorCode: "", borderW: 0, bgColor: THEME_COLOR_BLIGHT)
        CommonFunction.setRoundedViews(arrayB: [borderView], radius: 10, borderColorCode: "", borderW: 0, bgColor: THEME_COLOR_BORDER_COLOR)
        
        CommonFunction.setRoundedButtons(arrayB: [bookingFlightBtn], radius: self.bookingFlightBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: buttonBGColor, textColor: blackColorCode)
        
        for lbl in lableArr{
            lbl.layer.cornerRadius = 5
            lbl.layer.masksToBounds = true
        }
    }

    func configuerInstantBookFlightCell(indexPath:IndexPath,data:SearchFlightResponseData){
        
        self.bookingFlightBtn.tag = indexPath.row
        
        if data.Aircraft != nil{
            self.aircraftName.text = data.Aircraft!
        }
        
        if data.StartDisplayLine1 != nil{
            self.startAircraft.text = data.StartDisplayLine1!
        }
        
        if data.StartDisplayLine2 != nil{
            self.startAircraftInfo.text = data.StartDisplayLine2!
        }
        
//        var startAirportInfoStr = ""
//        if data.startcity != nil{
//            if data.startcity != ""{
//                startAirportInfoStr = data.startcity!
//            }
//        }
//        if data.startstate != nil{
//            if data.startstate != ""{
//                startAirportInfoStr = startAirportInfoStr.appending(",")
//                startAirportInfoStr = startAirportInfoStr.appending(data.startstate!)
//            }
//            
//        }
//        if data.startcountry != nil{
//            if data.startcountry != ""{
//                startAirportInfoStr = startAirportInfoStr.appending(",")
//                startAirportInfoStr = startAirportInfoStr.appending(data.startcountry!)
//            }
//            
//        }
//        self.startAircraftInfo.text = startAirportInfoStr
        
        if data.EndDisplayLine1 != nil{
            self.endAircraft.text = data.EndDisplayLine1!
        }
        
        if data.EndDisplayLine2 != nil{
            self.endAircraftInfo.text = data.EndDisplayLine2!
        }
        
//        var endAirportInfoStr = ""
//        if data.endcity != nil{
//            endAirportInfoStr = data.endcity!
//        }
//        if data.endstate != nil{
//            endAirportInfoStr = endAirportInfoStr.appending(",")
//            endAirportInfoStr = endAirportInfoStr.appending(data.endstate!)
//            
//        }
//        if data.endcountry != nil{
//            endAirportInfoStr = endAirportInfoStr.appending(",")
//            endAirportInfoStr = endAirportInfoStr.appending(data.endcountry!)
//            
//        }
//        self.endAircraftInfo.text = endAirportInfoStr
        
        
        if data.NoOfPassengers != nil{
            self.paxLabel.text = String(format: " Pax: %d ",data.NoOfPassengers!)
        }
        
        if data.FinalAmount != nil{
            let amount = CommonFunction.getCurrencyValue(amt: Float(data.FinalAmount!), code: CURRENCY_CODE)
            self.priceLabel.text = String(format: " Price: %@ ",amount)
        }
        
        if data.ExpectedTimeInMinutes != nil{
            if data.ExpectedTimeInMinutes! != "" && data.ExpectedTimeInMinutes! != "0.0"{
                
                let time = CommonFunction.minutesToHoursAndMinutes(Int(Double(data.ExpectedTimeInMinutes!)!))
                let textStr = String(format: " Time: %d hrs %d min ", time.hours,time.leftMinutes)
                self.timeLabel.text = textStr
            }else{
                self.timeLabel.text = " Time: 0 hrs "
            }
        }
    }
    
    @IBAction func bookFlightBtnClicked(_ sender:UIButton){
        self.delegate?.bookFlightBtnPressed?(atIndex: sender.tag)
    }
}
