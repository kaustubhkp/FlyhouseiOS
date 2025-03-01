//
//  SingleStringCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class SingleStringCell: UITableViewCell {
    
    @IBOutlet weak var imageV:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet var labelViewToLeadingSuperview:NSLayoutConstraint!
    @IBOutlet var labelViewToLeadingImageV:NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    func hideImage(){
        
        self.labelViewToLeadingSuperview.priority = UILayoutPriority(999)
        self.labelViewToLeadingImageV.priority = UILayoutPriority(250)
        self.imageV.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
