//
//  FlagListViewCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 08/02/24.
//

import UIKit

class FlagListViewCell: UITableViewCell {
    
    @IBOutlet weak var flagImage:UIImageView!
    @IBOutlet weak var countryName:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.selectionStyle = .none
    }
    
}
