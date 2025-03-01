//
//  SubmitButtonCell.swift
//  FlyHouse
//
//  Created by Atul on 01/09/24.
//

import UIKit

@objc protocol SubmitButtonCellDelegate{
    
    @objc optional
    func submitBtnPressed()

}


class SubmitButtonCell: UITableViewCell {
    
    @IBOutlet weak var submitBtn:UIButton!
    var delegate:SubmitButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [submitBtn], size: 15, type: .fBold, textColor: UIColor.black)
        CommonFunction.setRoundedButtons(arrayB: [submitBtn], radius: self.submitBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: buttonBGColor, textColor: blackColorCode)
    }
    
    @IBAction func submitBtnClicked(_ sender : UIButton){
        self.delegate?.submitBtnPressed?()
    }
    
}
