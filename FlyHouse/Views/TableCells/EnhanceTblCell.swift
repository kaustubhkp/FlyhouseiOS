//
//  EnhanceTblCell.swift
//  FlyHouse
//
//  Created by Atul on 24/01/25.
//

import UIKit

class EnhanceTblCell: UITableViewCell {

    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var subTitleLabel:UILabel!
    @IBOutlet weak var emailBtn:UIButton!
    @IBOutlet weak var callBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setRoundedButtons(arrayB: [emailBtn], radius: emailBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: INPUTF_BORDER_COLOR, textColor: blackColorCode)
        
        CommonFunction.setRoundedButtons(arrayB: [callBtn], radius: callBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: INPUTF_BORDER_COLOR, textColor: blackColorCode)
        
        CommonFunction.setLabelsFonts(lbls: [titleLabel], type: .fSemiBold, size: 13)
        
        CommonFunction.setLabelsFonts(lbls: [subTitleLabel], type: .fReguler, size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
