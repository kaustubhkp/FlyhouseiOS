//
//  CongratulationCell.swift
//  FlyHouse
//
//  Created by Atul on 07/03/25.
//

import UIKit

class CongratulationCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        CommonFunction.setLabelsFonts(lbls: [titleLabel,subTitleLabel], type: .fReguler, size: 14)
    }
    
}
