//
//  MultiCityCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol MultiCityCellDelegate{
    
    @objc optional
    func addNewLeg()
    
    @objc optional
    func removeLeg()
}

class MultiCityCell: UITableViewCell {
    
    var delegate:MultiCityCellDelegate?
    @IBOutlet weak var cellMainView:UIView!
    
    @IBOutlet weak var addBtn:UIButton!
    @IBOutlet weak var removeBtn:UIButton!
    
    @IBOutlet var addBtnToSuperview:NSLayoutConstraint!
    @IBOutlet var addBtnToRemoveBtn:NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        
        
        //CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 5, borderColorCode: ThemeBorderColor, borderW: 1, bgColor: THEME_COLOR_BLIGHT)
        
        CommonFunction.setButtonsFontsSizeAndColor(arrayB: [addBtn,removeBtn], size: 12, textColor: blackColorCode, bgColor: "")
        
        CommonFunction.setRoundedButtons(arrayB: [addBtn,removeBtn], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR, textColor: blackColorCode)
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [addBtn,removeBtn], size: 10, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
        self.hideRemoveBtn()
    }
    
    func showRemoveBtn(){
        self.addBtnToRemoveBtn.priority = UILayoutPriority(999)
        self.addBtnToSuperview.priority = UILayoutPriority(250)
        self.removeBtn.isHidden = false
    }
    
    func hideRemoveBtn(){
        self.addBtnToRemoveBtn.priority = UILayoutPriority(250)
        self.addBtnToSuperview.priority = UILayoutPriority(999)
        self.removeBtn.isHidden = true
    }
    
    func configuerMultiCityCell(count:Int){
        
        //if count == 1{
           // self.hideRemoveBtn()
       // }else{
            self.showRemoveBtn()
       // }
    }
    
    @IBAction func addBtnClicked(_ sender: UIButton){
        self.delegate?.addNewLeg?()
    }
    
    @IBAction func removeBtnClicked(_ sender : UIButton){
        self.delegate?.removeLeg?()
    }
}
