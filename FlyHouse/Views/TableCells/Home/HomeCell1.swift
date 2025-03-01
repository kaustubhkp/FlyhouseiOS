//
//  HomeCell1.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol HomeCell1Delegate{
    
    @objc optional
    func dateBtnPressed(atIndex:Int)
    
    @objc optional
    func timeBtnPressed(onIndex:Int)
    
    @objc optional
    func fromAddressBtnPressed(atIndex:Int)
    
    @objc optional
    func toAddressBtnPressed(atIndex:Int)
    
    @objc optional
    func swipeLocation(atIndex:Int)
}

class HomeCell1: UITableViewCell {
    
    var delegate:HomeCell1Delegate?
    @IBOutlet weak var cellMainView1:UIView!
    @IBOutlet weak var cellMainView2:UIView!
    @IBOutlet weak var cellMainView21:UIView!
    @IBOutlet weak var cellMainView22:UIView!
    @IBOutlet weak var fromView:UIView!
    @IBOutlet weak var toView:UIView!
    
    @IBOutlet weak var tripTypeImageView:UIImageView!
    @IBOutlet weak var wayImageBtn:UIButton!
    @IBOutlet weak var wayImageView:UIImageView!
    @IBOutlet weak var fieldImageV:UIImageView!
    @IBOutlet weak var dateBtn:UIButton!
    @IBOutlet weak var dateTitleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    
    @IBOutlet weak var timeBtn:UIButton!
    @IBOutlet weak var timeTitleLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    
    @IBOutlet weak var fromAddTF:UITextField!
    @IBOutlet weak var toAddTF:UITextField!
    @IBOutlet weak var fromAdd:UILabel!
    @IBOutlet weak var fromSubAdd:UILabel!
    @IBOutlet weak var fromBtnAdd:UIButton!
    
    @IBOutlet weak var toAdd:UILabel!
    @IBOutlet weak var toSubAdd:UILabel!
    @IBOutlet weak var toBtnAdd:UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        CommonFunction.setLabelsFonts(lbls: [self.dateTitleLabel,dateLabel,timeTitleLabel,timeLabel], type: .fReguler, size: 12)
        
        CommonFunction.setRoundedViews(arrayB: [cellMainView1], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUTF_BORDER_COLOR)
        CommonFunction.setRoundedViews(arrayB: [fromView,toView], radius: 0, borderColorCode: "", borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        CommonFunction.setRoundedViews(arrayB: [cellMainView2], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUTF_BORDER_COLOR)
        CommonFunction.setRoundedViews(arrayB: [cellMainView21,cellMainView22], radius: 0, borderColorCode: "", borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        
        self.fromAdd.isHidden = true
        self.toAdd.isHidden = true
        self.fromAddTF.isUserInteractionEnabled = false
        self.toAddTF.isUserInteractionEnabled = false
       // self.wayImageView.layer.cornerRadius = self.wayImageView.frame.size.height/2
        //self.wayImageView.layer.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BLIGHT).cgColor
        
        CommonFunction.setTextFieldFontsTypeWithSize(arrayT: [fromAddTF,toAddTF], size: 11, type: .fReguler)
        
        CommonFunction.setTextFieldPlaceHolder(txtF: fromAddTF, pholderText: SOURCE_ADDRESS_TITLE,size: 11,color: UIColor.hexStringToUIColor(hex: placeHolderColorCode),tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        
        CommonFunction.setTextFieldPlaceHolder(txtF: toAddTF, pholderText: DESTI_ADDRESS_TITLE,size: 11,color: UIColor.hexStringToUIColor(hex: placeHolderColorCode),tColor: UIColor.hexStringToUIColor(hex: placeHolderColorCode))
        
        
//        let attributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
//            NSAttributedString.Key.font : UIFont.BoldWithSize(size: 22) // Note the !
//        ]
        //fromAddTF.attributedPlaceholder = NSAttributedString(string: SOURCE_TITLE, attributes:attributes)
        
        //toAddTF.attributedPlaceholder = NSAttributedString(string: DESTINATION_TITLE, attributes:attributes)
    }
    
    func configuerHomeCell1(indexPath:IndexPath,data:MultiCitys,tripTypeIndex:Int,prevData:MultiCitys,isSwipe:Bool,isNewAdded:Bool){
        
        self.wayImageBtn.tag = indexPath.row
        
        self.fromBtnAdd.tag = indexPath.row
        self.toBtnAdd.tag = indexPath.row
        self.dateBtn.tag = indexPath.row
        self.timeBtn.tag = indexPath.row
        self.fromBtnAdd.isEnabled = true
        if tripTypeIndex == 2 && indexPath.row != 0 && isNewAdded == true{
            
            var fromText:String = ""
            if prevData.toAdd != nil{
                //self.fromAddTF.text = prevData.toAdd!
                fromText = prevData.toAdd!
            }
                
            if prevData.toSubAdd != nil && fromText != ""{
                //self.fromSubAdd.text = prevData.toSubAdd!
                fromText += ", \(prevData.toSubAdd!)"
            }
            self.fromAddTF.text = fromText
            
        }else{
            
            var fromText:String = ""
            if data.fromAdd != nil{
                //self.fromAddTF.text = data.fromAdd!
                fromText = data.fromAdd!
            }
            
            //self.fromSubAdd.text = ADDRESS_TITLE
            if data.fromSubAdd != nil && fromText != "" {
                //self.fromSubAdd.text = data.fromSubAdd!
                fromText += ", \(data.fromSubAdd!)"
            }
            self.fromAddTF.text = fromText
        }
        
        var toText:String = ""
        if data.toAdd != nil{
            //self.toAddTF.text = data.toAdd!
            toText = data.toAdd!
        }
        
        //self.toSubAdd.text = ADDRESS_TITLE
        if data.toSubAdd != nil && toText != ""{
            //self.toSubAdd.text = data.toSubAdd!
            toText += ", \(data.toSubAdd!)"
        }
        self.toAddTF.text = toText
        
        self.dateTitleLabel.text = "Date"
        self.dateLabel.text = ""
        if data.departureDisplayDate != nil{
            self.dateLabel.text = data.departureDisplayDate!
            self.dateTitleLabel.text = ""
        }
        self.fieldImageV.image = UIImage(named: "calendar")
        
        
        self.timeTitleLabel.text = "Time"
        self.timeLabel.text = ""
        if data.startTime != nil{
            if data.startTime != ""{
                self.timeLabel.text = data.startTime!
                self.timeTitleLabel.text = ""
            }
        }
        
//        if tripTypeIndex == 0{
//            self.tripTypeImageView.image = UIImage(named:"right_arrow")
//        }else{
//            self.tripTypeImageView.image = UIImage(named:"roundTrip")
//        }
        
    }
    
    @IBAction func fromAddBtnClicked(_ sender:UIButton){
        self.delegate?.fromAddressBtnPressed?(atIndex: sender.tag)
    }
    
    @IBAction func toAddBtnClicked(_ sender:UIButton){
        self.delegate?.toAddressBtnPressed?(atIndex: sender.tag)
    }
    
    @IBAction func dateBtnClicked(_ sender:UIButton){
        self.delegate?.dateBtnPressed?(atIndex: sender.tag)
    }
    
    @IBAction func timeBtnClicked(_ sender:UIButton){
        self.delegate?.timeBtnPressed?(onIndex: sender.tag)
    }
    
    @IBAction func swipeBtnClicked(_ sender:UIButton){
        self.delegate?.swipeLocation?(atIndex: sender.tag)
    }
}
