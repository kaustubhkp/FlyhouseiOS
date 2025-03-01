//
//  SplitPaymentCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol SplitPaymentCellDelegate{
    
    @objc optional
    func splitBtnPressed(isSplit:Bool)
    
    @objc optional
    func faqBtnPressed()
}

class SplitPaymentCell: UITableViewCell {
    
    var delegate: SplitPaymentCellDelegate?
    @IBOutlet weak var mainCellView:UIView!
    @IBOutlet weak var splitLabel:UILabel!
    @IBOutlet weak var yesBtn:UIButton!
    @IBOutlet weak var noBtn:UIButton!
    @IBOutlet weak var splitSwitch:UISwitch!
    @IBOutlet weak var hintButton:UIButton!
    @IBOutlet weak var faqButton:UIButton!
    @IBOutlet weak var frendShareSwitch:UISwitch!
    @IBOutlet var btnArr:[UIButton]!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        CommonFunction.setRoundedViews(arrayB: [mainCellView], radius: 5, borderColorCode: "", borderW: 0, bgColor: THEME_COLOR_BG)
        //noBtn.setImage(UIImage(named: "selected"), for: .normal)
        CommonFunction.setLabelsFonts(lbls: [splitLabel], type: .fReguler, size: 9)
        CommonFunction.setRoundedButtons(arrayB: [hintButton], radius: hintButton.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: "", textColor: blackColorCode)
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [faqButton], size: 10, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
        self.frendShareSwitch.isOn = false
        // Adding target action
        self.frendShareSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
    }
    
    @IBAction func faqBtnClicked(){
        self.delegate?.faqBtnPressed?()
    }
    
    @IBAction func splitBtnClicked(_ sender : UIButton){
        
        for btn in btnArr{
            btn.setImage(UIImage(named: "selected_not"), for: .normal)
        }
        sender.setImage(UIImage(named: "selected"), for: .normal)
        if sender.tag == 1{
            self.delegate?.splitBtnPressed?(isSplit: true)
        }else{
            self.delegate?.splitBtnPressed?(isSplit: false)
        }
    }
    
    @objc func switchToggled(_ sender : UISwitch){
        if sender.isOn {
            //frendShareSwitch.thumbTintColor = UIColor.black
            self.delegate?.splitBtnPressed?(isSplit: true)
        }else{
            //frendShareSwitch.thumbTintColor = UIColor.hexStringToUIColor(hex: "A09387")
            self.delegate?.splitBtnPressed?(isSplit: false)
        }
    }
    
    func configuerCell(indexPath:IndexPath,isSplit:Bool){
        
        if isSplit == true{
            self.splitBtnClicked(self.yesBtn)
        }else{
            self.splitBtnClicked(self.noBtn)
        }
    }
}
