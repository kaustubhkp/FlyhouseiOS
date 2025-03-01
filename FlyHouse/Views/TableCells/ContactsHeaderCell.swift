//
//  ContactsHeaderCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol ContactsHeaderCellDelegate{
    
    @objc optional
    func addBtnPressed()
    
    @objc optional
    func addSelectedPressed()
}

class ContactsHeaderCell: UITableViewCell {
    
    var delegate:ContactsHeaderCellDelegate?
    @IBOutlet weak var addBtn:UIButton!
    @IBOutlet weak var addSelectedBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        CommonFunction.setRoundedButtons(arrayB: [addBtn,addSelectedBtn], radius: 10, borderColorCode: "", borderW: 0, bgColor: buttonBGColor, textColor: blackColorCode)
    }
    
    @IBAction func addBtnClicked(_ sender: UIButton){
        self.delegate?.addBtnPressed?()
    }
    
    @IBAction func addSelectedBtnClicked(_ sender: UIButton){
        self.delegate?.addSelectedPressed?()
    }

}
