//
//  HHMyKeyCell.swift
//  FlyHouse
//
//  Created by Atul on 03/04/25.
//

import UIKit

let StartHrs = 0
let EndHrs = 250

class HHMyKeyCell: UITableViewCell {
    
    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet weak var roomkeyTitleLabel:UILabel!
    @IBOutlet weak var roomkeyValueLabel:UILabel!
    
    @IBOutlet weak var creationOnTitleLabel:UILabel!
    @IBOutlet weak var creationOnValueLabel:UILabel!
    
    @IBOutlet weak var progressBarTitleLabel:UILabel!
    @IBOutlet weak var startHrsValLabel:UILabel!
    @IBOutlet weak var endHrsValLabel:UILabel!
    
    @IBOutlet weak var bottomTextLabel:UILabel!
    
    @IBOutlet var progressView: CustomProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 10, borderColorCode: "", borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setLabelsFonts(lbls: [bottomTextLabel], type: .fReguler, size: 10)
        
        CommonFunction.setLabelsFonts(lbls: [progressBarTitleLabel], type: .fMedium, size: 18)
        // Customize the progress view if needed
        progressView.layer.cornerRadius = progressView.frame.height / 2
        
        
        self.startHrsValLabel.text = String(format: "%dHrs", StartHrs)
        self.endHrsValLabel.text = String(format: "%dHrs", EndHrs)
        
                
    }
    
    func configureMyKeyCell(indexpath:IndexPath,data:UserRoomKeyData){
        
        if data.RoomKey != nil{
            self.roomkeyValueLabel.text = data.RoomKey!
        }
        
        if data.FlightHoursInMinutes != nil{
            
            let hStr = Double(data.FlightHoursInMinutes!)/60
            self.bottomTextLabel.text = String(format: "You have completed %.2fHrs out of %.2fHrs", hStr, Double(EndHrs))
            progressView.progress = hStr
        }
        
        if data.CreationDate != nil{
            
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            
            let date = CommonFunction.getOriginalDateFromString(dateStr: data.CreationDate!, format: formate2)
            
            let dateStr = formatter.string(from: date)
            
            self.creationOnValueLabel.text = dateStr
        }
    }
}
