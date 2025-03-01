//
//  ConfirmationCodeCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 06/05/24.
//

import UIKit

class ConfirmationCodeCell: UITableViewCell {
    
    @IBOutlet weak var confirmationCodeLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        self.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        CommonFunction.setLabelsFonts(lbls: [confirmationCodeLabel], type: .fReguler, size: 15)
        confirmationCodeLabel.textColor = UIColor.black
    }
    
}
