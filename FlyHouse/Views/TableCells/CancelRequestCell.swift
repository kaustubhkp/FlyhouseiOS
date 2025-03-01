//
//  CancelRequestCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 10/01/24.
//

import UIKit

@objc protocol CancelRequestCellDelegate{
    
    @objc optional
    func cancelRequestBtnPressed()
    
    @objc optional
    func getPriceBtnPressed()
}


class CancelRequestCell: UITableViewCell {
    
    var delegate:CancelRequestCellDelegate?
    @IBOutlet weak var cancelReqBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        self.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [cancelReqBtn], size: 15, type: .fBold, textColor: UIColor.black)
        CommonFunction.setRoundedButtons(arrayB: [cancelReqBtn], radius: self.cancelReqBtn.frame.size.height/2, borderColorCode: blackColorCode, borderW: 1, bgColor: "", textColor: blackColorCode)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cancelRequestBtnClicked(_ sender : UIButton){
        
        if sender.tag == 0{
            self.delegate?.cancelRequestBtnPressed?()
        }else if sender.tag == 1{
            self.delegate?.getPriceBtnPressed?()
        }
    }
    
}
