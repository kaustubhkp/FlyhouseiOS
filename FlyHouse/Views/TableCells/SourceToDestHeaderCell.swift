//
//  SourceToDestHeaderCell.swift
//  FlyHouse
//
//  Created by Atul on 30/08/24.
//

import UIKit

class SourceToDestHeaderCell: UITableViewCell {
    
    @IBOutlet weak var titleStrLabel:UILabel!
    @IBOutlet weak var borderLabel:UILabel!
    @IBOutlet weak var plusMinusLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CommonFunction.setLabelsFonts(lbls: [titleStrLabel], type: .fMedium, size: 18)
        self.titleStrLabel.textColor = UIColor.hexStringToUIColor(hex: buttonBGColor)
    }
}
