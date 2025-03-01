//
//  MyTripDetailsCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 06/05/24.
//

import UIKit

@objc protocol MyTripDetailsCellDelegate {
    
    func tripDetailsBtnPressed()
    
    func tripNoteBtnPressed(onIndex:Int)
}

class MyTripDetailsCell: UITableViewCell {

    var delegate:MyTripDetailsCellDelegate?
    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var s_routeRoundedView:UIView!
    @IBOutlet weak var d_routeRoundedView:UIView!
    
    @IBOutlet weak var dottedBorderLable:UILabel!
    @IBOutlet weak var planImageview:UIImageView!
    
    @IBOutlet weak var fromAddressLabel:UILabel!
    @IBOutlet weak var fromLabel:UILabel!
    
    @IBOutlet weak var toAddressLabel:UILabel!
    @IBOutlet weak var toLabel:UILabel!

    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var durationLabel:UILabel!
    @IBOutlet weak var durationLineLabel:UILabel!
    
    @IBOutlet weak var tripDetailsBtn:UIButton!
    @IBOutlet weak var tripNotesBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        self.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setLabelsFonts(lbls: [dateLabel], type: .fReguler, size: 9.0)
        
        CommonFunction.setLabelsFonts(lbls: [fromLabel,toLabel], type: .fSemiBold, size: 18.0)
        
        CommonFunction.setLabelsFonts(lbls: [fromAddressLabel,toAddressLabel], type: .fReguler, size: 12.0)
        
        CommonFunction.setRoundedViews(arrayB: [s_routeRoundedView,d_routeRoundedView], radius: s_routeRoundedView.frame.size.height/2, borderColorCode: INPUTF_BORDER_COLOR, borderW: 2, bgColor: THEME_COLOR_BG)
        
        //CommonFunction.setRoundedButtons(arrayB: [tripNotesBtn,tripDetailsBtn], radius: self.tripDetailsBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: buttonBGColor, textColor: blackColorCode)
        //tripDetailsBtn.tintColor = UIColor.black
        //tripNotesBtn.tintColor = UIColor.black
        //CommonFunction.setButtonFontsTypeWithSize(arrayB: [tripDetailsBtn,tripNotesBtn], size: 17, type: .fBold, textColor: UIColor.black)
    }

    func setDuration(text:String){
        self.durationLineLabel.backgroundColor = UIColor.white
        self.durationLabel.text = text
    }
    
    func configuerMyTrip(indexPath:IndexPath,data:TripDetailsData){
        
        //self.tripNotesBtn.tag = indexPath.row
        
        //self.durationLabel.text = ""
//        if data.EstimatedTimeInMinute != nil{
//            if data.EstimatedTimeInMinute! > 0{
//                let time = CommonFunction.minutesToHoursAndMinutes(data.EstimatedTimeInMinute!)
//                let textStr = String(format: "Duration: %d hrs %d min", time.hours,time.leftMinutes)
//                //self.setDuration(text: textStr)
//            }
//        }
        
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
        
        if data.StartDateTime != nil{
            
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.StartDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLabel.text = dateStr
        }
    }
    
    @IBAction func tripDetailBtnClicked(_ sender :UIButton){
        self.delegate?.tripDetailsBtnPressed()
    }
    
    @IBAction func tripNoteBtnClicked(_ sender :UIButton){
        self.delegate?.tripNoteBtnPressed(onIndex: sender.tag)
    }
}
