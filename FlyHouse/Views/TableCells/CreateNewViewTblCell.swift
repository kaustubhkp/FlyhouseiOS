//
//  CreateNewViewTblCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 11/05/24.
//

import UIKit

class CreateNewViewTblCell: UITableViewCell {
    
    @IBOutlet weak var hintLabel:UILabel!
    @IBOutlet weak var createNewBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CommonFunction.setLabelsFonts(lbls: [hintLabel], type: .fReguler, size: 12)
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [createNewBtn], size: 17, type: .fBold, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        //hintLabel.textColor = UIColor.hexStringToUIColor(hex: buttonBGColor)
        //CommonFunction.setButtonFontsTypeWithSize(arrayB: [createNewBtn], size: 17, type: .fBold, textColor: UIColor.hexStringToUIColor(hex: "4BD6DB"))
    }

}
