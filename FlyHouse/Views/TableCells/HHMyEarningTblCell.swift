//
//  HHMyEarningTblCell.swift
//  FlyHouse
//
//  Created by Atul on 04/04/25.
//

import UIKit

class HHMyEarningTblCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelValue:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    func configureCellWithData(indexpath:IndexPath,data:UserRoomKeyEarningsData){
        
        //print(data)
        if data.AirCraftType != nil {
            self.labelTitle.text = data.AirCraftType!
        }
        
        if data.HrsEarned != nil {
            self.labelValue.text = String(format: "%.2f Hrs", data.HrsEarned!)
        }
        
    }
}
