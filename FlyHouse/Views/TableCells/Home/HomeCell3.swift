//
//  HomeCell3.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol HomeCell3Delegate{
    
    @objc optional
    func typeBtnPressed(button:UIButton)
}


class HomeCell3: UITableViewCell {
    
    var delegate:HomeCell3Delegate?
    @IBOutlet weak var onewayBtn:UIButton!
    @IBOutlet weak var roundTripBtn:UIButton!
    @IBOutlet weak var multiCityBtn:UIButton!
    
    @IBOutlet var buttonArr:[UIButton]!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.configButton(sender: self.onewayBtn)
        //self.onewayBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "909090"), for: .normal)
    }
    
    func configuerCell(indexPath:IndexPath,tripType:Int){
        
        if tripType == 0{ //oneway
            self.configButton(sender: onewayBtn)
        }else if tripType == 1{ //round trip , multi city
            self.configButton(sender: roundTripBtn)
        }else{
            self.configButton(sender: multiCityBtn)
        }
    }
    
    @IBAction func typeButtonClicked(_ sender:UIButton){
        self.delegate?.typeBtnPressed?(button: sender)
        self.configButton(sender: sender)
        sender.setTitleColor(UIColor.hexStringToUIColor(hex: "909090"), for: .normal)
    }
    
    func configButton(sender:UIButton){
        
        for btn in buttonArr{
            btn.setTitleColor(UIColor.hexStringToUIColor(hex: blackColorCode), for: .normal)
            CommonFunction.setRoundedButtons(arrayB: [btn], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR, textColor: blackColorCode)
            
        }
        CommonFunction.setRoundedButtons(arrayB: [sender], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUTF_BORDER_COLOR, textColor: blackColorCode)
    }
}
