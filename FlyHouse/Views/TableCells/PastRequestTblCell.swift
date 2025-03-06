//
//  PastRequestTblCell.swift
//  FlyHouse
//
//  Created by Atul on 22/01/25.
//

import UIKit

class PastRequestTblCell: UITableViewCell {
    
    //UI View
    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var s_routeRoundedView:UIView!
    @IBOutlet weak var d_routeRoundedView:UIView!
    
    @IBOutlet weak var dottedBorderLable:UILabel!
    @IBOutlet weak var planImageview:UIImageView!
    
    @IBOutlet weak var fromAddressLabel:UILabel!
    @IBOutlet weak var fromLabel:UILabel!
    
    @IBOutlet weak var toAddressLabel:UILabel!
    @IBOutlet weak var toLabel:UILabel!
    
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var dateLable:UILabel!
    
    @IBOutlet var planImageViewToSuperviewLeading:NSLayoutConstraint!
    @IBOutlet var planImageViewToSuperviewTrailing:NSLayoutConstraint!
    @IBOutlet var planImageViewToSuperviewMiddle:NSLayoutConstraint!
    

    @IBOutlet var topBorderViewToTopSuperview:NSLayoutConstraint!
    @IBOutlet var topBorderViewToDateLable:NSLayoutConstraint!
    
    var timer: Timer?
    var planePositionX: CGFloat = 0 // Initial position of the plane
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.planImageview.isHidden = true
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.timeLabel.text = ""
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setLabelsFonts(lbls: [dateLable,timeLabel], type: .fReguler, size: 9.0)
        
        CommonFunction.setLabelsFonts(lbls: [fromLabel,toLabel], type: .fSemiBold, size: 18.0)
        
        CommonFunction.setLabelsFonts(lbls: [fromAddressLabel,toAddressLabel], type: .fReguler, size: 12.0)
        
        CommonFunction.setRoundedViews(arrayB: [s_routeRoundedView,d_routeRoundedView], radius: s_routeRoundedView.frame.size.height/2, borderColorCode: INPUTF_BORDER_COLOR, borderW: 2, bgColor: THEME_COLOR_BG)
        
    }
    
    func resetPlanePosition() {
        self.planImageview.isHidden = false
        self.planImageViewToSuperviewMiddle.constant = 0
    }
    
    func animatePlane(sec:Int){
    
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveLinear], animations: {
            // Move the plane image to the right
            
            if UserDefaults.standard.object(forKey: "planAnimationLastPoint") != nil {
                self.planePositionX = UserDefaults.standard.object(forKey: "planAnimationLastPoint") as! CGFloat
            }
            self.planePositionX += 4
            self.planImageview.frame.origin.x = self.planePositionX
            UserDefaults.standard.set(self.planePositionX, forKey: "planAnimationLastPoint")
            UserDefaults.standard.synchronize()
            print("Plan Position:\(self.planImageview.frame.origin.x)")
        }, completion: { finished in
            if finished {
                // Reset plane position and start the animation again for looping effect
                self.resetPlanePosition()
                self.planImageViewToSuperviewMiddle.constant = self.frame.width/2
            }
        })
    }
    
    func updatePlanePosition(seconds:Int) {
        // 4. Update the X position of the plane
        if  self.planePositionX == 0{
            if UserDefaults.standard.object(forKey: "planAnimationLastPoint") == nil {
                self.resetPlanePosition()
            }
        }
        self.animatePlane(sec:seconds)
    }
    
    func showMiddlePlane(){
        
        self.planImageViewToSuperviewMiddle.priority = UILayoutPriority(rawValue: 999)
        self.planImageViewToSuperviewTrailing.priority = UILayoutPriority(rawValue: 250);
        self.planImageViewToSuperviewLeading.priority = UILayoutPriority(rawValue: 250)
        self.planImageview.isHidden = false
        self.d_routeRoundedView.isHidden = false
    }
    
    func showPlaneWithTimerAnimation(){
        
        self.planImageViewToSuperviewMiddle.priority = UILayoutPriority(rawValue: 999)
        self.planImageViewToSuperviewTrailing.priority = UILayoutPriority(rawValue: 250);
        self.planImageViewToSuperviewLeading.priority = UILayoutPriority(rawValue: 250)
        self.planImageview.isHidden = false
        self.d_routeRoundedView.isHidden = false
    }
    
    func showRightSidePlan(){
        
        self.planImageViewToSuperviewMiddle.priority = UILayoutPriority(rawValue: 250)
        self.planImageViewToSuperviewTrailing.priority = UILayoutPriority(rawValue: 999);
        self.planImageViewToSuperviewLeading.priority = UILayoutPriority(rawValue: 250)
        self.planImageview.isHidden = false
        self.d_routeRoundedView.isHidden = true
    }
    
    func showLeftSidePlan(){
        
        self.planImageViewToSuperviewMiddle.priority = UILayoutPriority(rawValue: 250)
        self.planImageViewToSuperviewTrailing.priority = UILayoutPriority(rawValue: 250);
        self.planImageViewToSuperviewLeading.priority = UILayoutPriority(rawValue: 999)
        self.planImageview.isHidden = false
        self.d_routeRoundedView.isHidden = false
    }
    
    func showDateTimeLable(){
        self.topBorderViewToDateLable.priority = UILayoutPriority(rawValue: 999)
        self.topBorderViewToTopSuperview.priority = UILayoutPriority(rawValue: 250)
        self.dateLable.isHidden = false
        self.timeLabel.isHidden = false
    }
    
    
    func hideDateTimeLable(){
        self.topBorderViewToDateLable.priority = UILayoutPriority(rawValue: 250)
        self.topBorderViewToTopSuperview.priority = UILayoutPriority(rawValue: 999)
        self.dateLable.isHidden = true
        self.timeLabel.isHidden = true
    }
    
    func configuerPastRequest(indexPath:IndexPath,data:CPRequestData){
        
        
        if data.startDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.startDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            //formatter.dateFormat = formate11
            //let boldString = formatter.string(from: date)
            
            self.dateLable.text = dateStr
            
            
            //self.dateLable.attributedText = CommonFunction.makeSubstringBoldWithCustomFontAndColor(fullText: dateStr, boldText: boldString, fullTextFont: UIFont.RegularWithSize(size: 10), fullTextColor: UIColor.hexStringToUIColor(hex: "#838383"), boldFont: UIFont.BoldWithSize(size: 10), boldTextColor: UIColor.black)
            //self.dateLable.attributedText = CommonFunction.makeSubstringBoldWithCustomFont(fullText: dateStr, boldText: boldString, fullTextFont: UIFont.RegularWithSize(size: 10), boldFont: UIFont.BoldWithSize(size: 10))
        }
        
        
        if data.StartDisplayLine1 != nil{
            self.fromLabel.text = data.StartDisplayLine1!
        }
        
        if data.StartDisplayLine2 != nil{
            self.fromAddressLabel.text = data.StartDisplayLine2!
        }
        
        if data.EndDisplayLine1 != nil{
            self.toLabel.text = data.EndDisplayLine1!
        }
        
        if data.EndDisplayLine2 != nil{
            self.toAddressLabel.text = data.EndDisplayLine2!
        }
    }
    
    func configuerConfirmPendingRequest(indexPath:IndexPath,data:CRlegDetailData){
        
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        
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
        
        if data.StartDateTime != nil{
            
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.StartDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            self.dateLable.text = dateStr
        }
        
        if data.StartTime != nil{
            self.timeLabel.text = data.StartTime!
        }
    }
    
    func configuerConfirmRequest(indexPath:IndexPath,data:CRLegData,fromVC:String){
        
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
        
        if data.startDateTime != nil{
            
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.startDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLable.text = dateStr
            //formatter.dateFormat = formate11
            //let boldString = formatter.string(from: date)
            
            //self.dateLable.attributedText = CommonFunction.makeSubstringBoldWithCustomFontAndColor(fullText: dateStr, boldText: boldString, fullTextFont: UIFont.RegularWithSize(size: 10), fullTextColor: UIColor.hexStringToUIColor(hex: "#838383"), boldFont: UIFont.BoldWithSize(size: 10), boldTextColor: UIColor.black)
        }
        
        if data.startTime != nil{
            self.timeLabel.text = data.startTime!
        }
    }
    
    func configuerMyTripCell(indexPath:IndexPath,data:MyTripData){
        
        if data.StartDateTime != nil{
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.StartDateTime!, format: formate3)
            
            let dateStr = formatter.string(from: date)
            
            self.dateLable.text = dateStr
        }
        
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
