//
//  ManageContactListCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol ManageContactListCellDelegate{
    
    func didChangeNoOfPassenger(pax:Int,atIndex:Int)
    
    func removeBtnPressed(atIndex:Int)
}

class ManageContactListCell: UITableViewCell {
    
    var delegate:ManageContactListCellDelegate?
    @IBOutlet weak var cellMainView:UIView!
    
    @IBOutlet weak var nameTitleLabel:UILabel!
    @IBOutlet weak var paxTitleLabel:UILabel!
    @IBOutlet weak var amtTitleLabel:UILabel!
    
    @IBOutlet weak var nameTF:UITextField!
    @IBOutlet weak var paxTF:UITextField!
    @IBOutlet weak var amtTF:UITextField!
    
    @IBOutlet weak var removeBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: "")
        
        paxTF.delegate = self
    }
    
    func configuerManageContacts(indexPath:IndexPath,data:SplitContacts,amount:Float,totalPass:Int){
        
        self.removeBtn.tag = indexPath.row
        self.paxTF.tag = indexPath.row
        
        self.nameTF.text = String(format: "%@ %@", data.firstName!,data.lastName!)
        
        var amt = ""
        if data.noOfPassenger != nil{
            self.paxTF.text = String(data.noOfPassenger!)
            amt = CommonFunction.getCurrencyValue2(amt:amount * Float(data.noOfPassenger!), code: CURRENCY_CODE)
        }else{
            amt  = CommonFunction.getCurrencyValue2(amt:amount, code: CURRENCY_CODE)
        }
        
        self.amtTitleLabel.text = String(format: "%@'s Share", data.firstName!)
        self.amtTF.text = amt
        
    }
    
    @IBAction func removeBtnClicked(_ sender:UIButton){
        self.delegate?.removeBtnPressed(atIndex: sender.tag)
    }

}

extension ManageContactListCell : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != ""{
            self.delegate?.didChangeNoOfPassenger(pax: Int(textField.text!)!,atIndex: textField.tag)
        }
    }
}
