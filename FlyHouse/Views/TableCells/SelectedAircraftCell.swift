//
//  SelectedAircraftCell.swift
//  FlyHouse
//
//  Created by Atul on 01/09/24.
//

import UIKit

class SelectedAircraftCell: UITableViewCell {
    
    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var detailView:UIView!
    @IBOutlet weak var detailValView:UIView!
    @IBOutlet weak var headerTitleLabel:UILabel!
    
    @IBOutlet weak var detailTitlelabel:UILabel!
    @IBOutlet weak var aircraftTitleLabel:UILabel!
    @IBOutlet weak var aircraftNameLabel:UILabel!
    
    @IBOutlet weak var priceTitleLabel:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    
    @IBOutlet weak var headerView:UIView!
    @IBOutlet var cellMainviewTopToHeaderView:NSLayoutConstraint!
    @IBOutlet var cellMainviewTopToSuperview:NSLayoutConstraint!
    
    @IBOutlet weak var headerTitleView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 5, borderColorCode: "", borderW: 0, bgColor: blackColorCode)
        
        CommonFunction.setRoundedViews(arrayB: [detailValView], radius: 5, borderColorCode: "", borderW: 0, bgColor: THEME_COLOR_BLIGHT)
        
        
        CommonFunction.setRoundedViews(arrayB: [detailView], radius: 10, borderColorCode: THEME_COLOR_BORDER_GREEN, borderW: 1, bgColor: THEME_COLOR_LIGHT)
        self.detailView.layer.borderColor = UIColor.hexStringToUIColor(hex: "ebe5df").cgColor
        self.detailView.layer.borderWidth = 1
    }

    func configuerOptionCell(indexPath:IndexPath,data:GetSelectedBestAndMoreData){
        
        if indexPath.row == 0{
            self.cellMainviewTopToSuperview.priority = UILayoutPriority(250)
            self.cellMainviewTopToHeaderView.priority = UILayoutPriority(999)
            self.headerView.isHidden = false
        }else{
            self.cellMainviewTopToSuperview.priority = UILayoutPriority(999)
            self.cellMainviewTopToHeaderView.priority = UILayoutPriority(250)
            self.headerView.isHidden = true
        }
    
        self.headerTitleLabel.text = String(format: "%@ to %@", data.StartAirportID!,data.EndAirportID!)

        if data.OwnerAircraft != nil{
            self.detailTitlelabel.text = data.OwnerAircraft! //data.LowestPreferredAircraftType!.capitalized
        }
        
        if data.AircraftType != nil{
            self.aircraftNameLabel.text = data.AircraftType!.uppercased() //data.OwnerAircraft!.capitalized
        }
        if data.FinalAmount != nil{
            let amount = CommonFunction.getCurrencyValue2(amt: Float(data.FinalAmount!), code: CURRENCY_CODE)
            self.priceLabel.text = amount
        }
    }
}
