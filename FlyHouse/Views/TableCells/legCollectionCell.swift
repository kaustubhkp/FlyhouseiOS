//
//  legCollectionCell.swift
//  FlyHouse
//
//  Created by Atul on 30/01/25.
//

import UIKit

class legCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mainCellView:UIView!
    @IBOutlet weak var titleLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        CommonFunction.setRoundedViews(arrayB: [mainCellView], radius: mainCellView.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: whiteColorCode)
        
        CommonFunction.setLabelsFonts(lbls: [titleLabel], type: .fReguler, size: 13)
    }

}
