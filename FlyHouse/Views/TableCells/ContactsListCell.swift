//
//  ContactsListCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol ContactsListCellDelegate{
    
    @objc optional
    func checkBtnPressed(atIndex:Int)
    
    @objc optional
    func editBtnPressed(atIndex:Int)
    
}

class ContactsListCell: UITableViewCell {
    
    var delegate : ContactsListCellDelegate?
    @IBOutlet weak var cellListView:UIView!
    @IBOutlet weak var checkBtn:UIButton!
    @IBOutlet weak var editBtn:UIButton!
    
    @IBOutlet weak var nameLable:UILabel!
    @IBOutlet weak var mobileValueLabel:UILabel!
    @IBOutlet weak var emailValueLabel:UILabel!
    @IBOutlet weak var mobileTitleLabel:UILabel!
    @IBOutlet weak var emailTitleLabel:UILabel!
    
    @IBOutlet var labelArr:[UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        CommonFunction.setLabelsFonts(lbls: [nameLable], type: .fReguler, size: 15)
        
        CommonFunction.setLabelsFonts(lbls: [mobileTitleLabel,emailTitleLabel], type: .fReguler, size: 13)
        
        CommonFunction.setLabelsFonts(lbls: [mobileValueLabel,emailValueLabel], type: .fReguler, size: 13)
        
        CommonFunction.setRoundedViews(arrayB: [cellListView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setRoundedButtons(arrayB: [editBtn], radius: self.editBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: lightGrayColorCode, textColor: blackColorCode)
    }
    
    func configerContactLitCell(indexPath:IndexPath,data:SplitContacts){
        
        self.checkBtn.tag = indexPath.row
        self.editBtn.tag  = indexPath.row
        
        var nameStr:String = ""
        if data.firstName != nil{
            nameStr = data.firstName!
        }
        
        if data.lastName != nil && nameStr != ""{
            self.nameLable.text = String(format: "%@ %@", nameStr,data.lastName!)
        }else{
            self.nameLable.text = nameStr
        }
        
        if data.mobile != nil{
            self.mobileValueLabel.text = data.mobile!
        }
        
        if data.email != nil{
            self.emailValueLabel.text = data.email!
        }
    }
    
    @IBAction func checkBtnClicked(_ sender:UIButton){
        self.delegate?.checkBtnPressed?(atIndex: sender.tag)
    }

    @IBAction func editBtnClicked(_ sender: UIButton){
        self.delegate?.editBtnPressed?(atIndex: sender.tag)
    }
}
