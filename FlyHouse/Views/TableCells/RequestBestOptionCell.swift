//
//  RequestBestOptionCell.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

@objc protocol RequestBestOptionCellDelegate{
    
    @objc optional
    func previewBtnPressed(sender:UIButton,section:Int)
    
    @objc optional
    func acceptBtnPressed(sender:UIButton,section:Int)
}

class RequestBestOptionCell: UITableViewCell {
    
    var delegate:RequestBestOptionCellDelegate?
    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var detailView:UIView!
    @IBOutlet weak var detailValView:UIView!
    @IBOutlet weak var headerTitleLabel:UILabel!
    
    @IBOutlet weak var detailTitlelabel:UILabel!
    @IBOutlet weak var aircraftTitleLabel:UILabel!
    @IBOutlet weak var aircraftNameLabel:UILabel!
    
    @IBOutlet weak var priceTitleLabel:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    
    @IBOutlet weak var headerTitleView:UIView!
    @IBOutlet var detailViewToTopHeaderViewConst:NSLayoutConstraint!
    @IBOutlet var detailViewToTopSuperviewConst:NSLayoutConstraint!
    
    @IBOutlet weak var prevIndexLabel:UILabel!
    @IBOutlet weak var previewBtn:UIButton!
    
    @IBOutlet weak var acceptIndexLabel:UILabel!
    @IBOutlet weak var tapToAcceptBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 5, borderColorCode: "", borderW: 0, bgColor: blackColorCode)
        
        CommonFunction.setRoundedViews(arrayB: [detailValView], radius: 5, borderColorCode: "", borderW: 0, bgColor: THEME_COLOR_BLIGHT)
        
        CommonFunction.setRoundedViews(arrayB: [detailView], radius: 10, borderColorCode: THEME_COLOR_BORDER_GREEN, borderW: 1, bgColor: THEME_COLOR_LIGHT)
        
        CommonFunction.setRoundedButtons(arrayB: [previewBtn,tapToAcceptBtn], radius: 10, borderColorCode: "", borderW: 0, bgColor: whiteColorCode, textColor: blackColorCode)
    }
    
    func configuerBestOptionCell(indexPath:IndexPath,data:CharterReqData){
        
        self.prevIndexLabel.tag = indexPath.section
        self.previewBtn.tag = indexPath.row
        
        self.acceptIndexLabel.tag = indexPath.section
        self.tapToAcceptBtn.tag = indexPath.row
        
        self.headerTitleLabel.text = "BEST PRICE OPTION".uppercased()
        
        if indexPath.row == 0{
            self.detailViewToTopSuperviewConst.priority = UILayoutPriority(250)
            self.detailViewToTopHeaderViewConst.priority = UILayoutPriority(999)
            self.headerTitleView.isHidden = false
        }else{
            
            self.detailViewToTopSuperviewConst.priority = UILayoutPriority(999)
            self.detailViewToTopHeaderViewConst.priority = UILayoutPriority(250)
            self.headerTitleView.isHidden = true
        }
        
        if data.LowestPreferredAircraftType != nil{
            self.detailTitlelabel.text = data.OwnerAircraft! //data.LowestPreferredAircraftType!.capitalized
        }
        
        if data.OwnerAircraft != nil{
            self.aircraftNameLabel.text = data.LowestPreferredAircraftType!.capitalized //data.OwnerAircraft!.capitalized
        }
        if data.FinalAmount != nil{
            let amount = CommonFunction.getCurrencyValue(amt: Float(data.FinalAmount!), code: CURRENCY_CODE)
            self.priceLabel.text = amount
        }
    }
    
    func configuerMoreOptionCell(indexPath:IndexPath,data:CharterReqData){
        
        self.prevIndexLabel.tag = indexPath.section
        self.previewBtn.tag = indexPath.row
        
        self.acceptIndexLabel.tag = indexPath.section
        self.tapToAcceptBtn.tag = indexPath.row
        
        self.headerTitleLabel.text = "MORE OPTIONS".uppercased()
    
        if indexPath.row == 0{
            self.detailViewToTopSuperviewConst.priority = UILayoutPriority(250)
            self.detailViewToTopHeaderViewConst.priority = UILayoutPriority(999)
            self.headerTitleView.isHidden = false
        }else{
            
            self.detailViewToTopSuperviewConst.priority = UILayoutPriority(999)
            self.detailViewToTopHeaderViewConst.priority = UILayoutPriority(250)
            self.headerTitleView.isHidden = true
        }
        
        if data.PreferredAircraftType != nil{
            self.detailTitlelabel.text = data.PreferredAircraft! //data.PreferredAircraftType!.capitalized
        }
        
        if data.PreferredAircraft != nil{
            self.aircraftNameLabel.text = data.PreferredAircraftType!.capitalized //data.PreferredAircraft!.capitalized
        }
        if data.LowestAmount != nil{
            let amount = CommonFunction.getCurrencyValue(amt: Float(data.LowestAmount!), code: CURRENCY_CODE)
            self.priceLabel.text = amount
        }
    }
    
    @IBAction func previewButtonClicked(_ sender:UIButton){
        self.delegate?.previewBtnPressed?(sender: sender,section:self.prevIndexLabel.tag)
    }
    
    @IBAction func acceptButtonClicked(_ sender:UIButton){
        self.delegate?.acceptBtnPressed?(sender: sender,section:self.acceptIndexLabel.tag)
    }
}
