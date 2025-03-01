//
//  BestAndMoreOptionCell.swift
//  FlyHouse
//
//  Created by Atul on 29/08/24.
//

import UIKit
import Alamofire

@objc protocol BestAndMoreOptionCellDelegate{
    
    @objc optional
    func previewBtnPressed(sender:UIButton,section:Int)
    
    @objc optional
    func acceptBtnPressed(sender:UIButton,section:Int)
    
    @objc optional
    func selectBtnPressed(sender:UIButton,section:Int)
    
    @objc optional
    func didSelectRatingAtIndex(rateImage:String)
}

class BestAndMoreOptionCell: UITableViewCell {
    
    var delegate:BestAndMoreOptionCellDelegate?
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
    
    @IBOutlet weak var selectIndexLabel:UILabel!
    @IBOutlet weak var selectPriceBtn:UIButton!
    
    //Rating
    @IBOutlet weak var safetyRatingMainView:UIView!
    @IBOutlet var detailToSafetyRatingTop:NSLayoutConstraint!
    @IBOutlet var detailToSuperviewTop:NSLayoutConstraint!
    @IBOutlet weak var ratingView:UIView!
    @IBOutlet weak var ratingCollectionview:UICollectionView!
    @IBOutlet weak var rateTitleLabel:UILabel!
    @IBOutlet weak var label1:UILabel!
    @IBOutlet weak var label2:UILabel!
    @IBOutlet weak var label3:UILabel!
    @IBOutlet weak var label4:UILabel!
    @IBOutlet weak var label5:UILabel!
    var ratings:[PartnerProfileRatingsData]!
    var recData:[MoreOptionsData]!
    
    @IBOutlet var previewBtnToBottomSuperview:NSLayoutConstraint!
    @IBOutlet var previewBtnToBottomSelectBtn:NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        self.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        
        CommonFunction.setRoundedViews(arrayB: [headerTitleView], radius: 5, borderColorCode: "", borderW: 0, bgColor: blackColorCode)
        
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        //CommonFunction.setRoundedViews(arrayB: [detailValView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: "")
        
        CommonFunction.setRoundedViews(arrayB: [detailView], radius: 10, borderColorCode: "", borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        //self.detailView.layer.borderColor = UIColor.hexStringToUIColor(hex: "ebe5df").cgColor
        //self.detailView.layer.borderWidth = 1
        
        CommonFunction.setRoundedButtons(arrayB: [previewBtn], radius: previewBtn.frame.size.height/2, borderColorCode: blackColorCode, borderW: 1, bgColor: "", textColor: blackColorCode)
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [previewBtn], size: 9, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
        CommonFunction.setRoundedButtons(arrayB: [selectPriceBtn], radius: selectPriceBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: blackColorCode, textColor: whiteColorCode)
        
        
        CommonFunction.setLabelsFonts(lbls: [label1,label2,label3,label4,label5], type: .fReguler, size: 9)
        
        CommonFunction.setLabelsFonts(lbls: [headerTitleLabel], type: .fReguler, size: 8)
        
        CommonFunction.setLabelsFonts(lbls: [aircraftNameLabel], type: .fMedium, size: 11)
        CommonFunction.setLabelsFonts(lbls: [detailTitlelabel,priceTitleLabel,priceLabel], type: .fReguler, size: 9)
        
        ratingCollectionview.register(UINib(nibName: CollectionViewCells.SafetyRatingCell, bundle: nil), forCellWithReuseIdentifier: CollectionViewCells.SafetyRatingCell)
        
    }
    
    func configuerBestOptionCell(indexPath:IndexPath,data:CharterReqData){
        
        self.prevIndexLabel.tag = indexPath.section
        self.previewBtn.tag = indexPath.row
        
        self.acceptIndexLabel.tag = indexPath.section
        self.tapToAcceptBtn.tag = indexPath.row
        
        self.headerTitleLabel.text = "Best Price"
        
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
            self.aircraftNameLabel.text = data.LowestPreferredAircraftType!.uppercased() //data.OwnerAircraft!.capitalized
        }
        if data.FinalAmount != nil{
            let amount = CommonFunction.getCurrencyValue(amt: Float(data.FinalAmount!), code: CURRENCY_CODE)
            self.priceLabel.text = amount
        }
    }
    
    func reloadRatingCollectionView(){
        ratingCollectionview.delegate = self
        ratingCollectionview.dataSource = self
        self.ratingCollectionview.reloadData()
    }
    
    func configureRatingData(ratingData:[PartnerProfileRatingsData]){
        self.ratings = ratingData
        self.reloadRatingCollectionView()
    }
    
    func configuerMoreOptionCell(indexPath:IndexPath,sectionLeg:Int,data:MoreOptionsData,isSelectedPrice:Bool){
        
        self.prevIndexLabel.tag = sectionLeg
        self.previewBtn.tag = indexPath.row
        
        
        //self.acceptIndexLabel.tag = indexPath.section
        //self.tapToAcceptBtn.tag = indexPath.row

        //self.selectIndexLabel.tag = indexPath.section
        self.selectPriceBtn.tag = indexPath.row
        
        if indexPath.row == 0{
            if isSelectedPrice == true{
                self.detailViewToTopSuperviewConst.priority = UILayoutPriority(999)
                self.detailViewToTopHeaderViewConst.priority = UILayoutPriority(250)
                self.headerTitleLabel.text = ""
                self.headerTitleView.isHidden = true
            }else{
                self.detailViewToTopSuperviewConst.priority = UILayoutPriority(250)
                self.detailViewToTopHeaderViewConst.priority = UILayoutPriority(999)
                self.headerTitleLabel.text = "Best Price Option"
                self.headerTitleView.isHidden = false
            }
        }else{
            self.detailViewToTopSuperviewConst.priority = UILayoutPriority(999)
            self.detailViewToTopHeaderViewConst.priority = UILayoutPriority(250)
            self.headerTitleLabel.text = ""
            self.headerTitleView.isHidden = true
        }
        
        if data.PreferredAircraftType != nil{
            self.detailTitlelabel.text = data.PreferredAircraft! //data.PreferredAircraftType!.capitalized
        }
        
        if data.PreferredAircraft != nil{
            self.aircraftNameLabel.text = data.PreferredAircraftType!.uppercased() //data.PreferredAircraft!.capitalized
        }
        if data.FinalAmount != nil{
            let amount = CommonFunction.getCurrencyValue2(amt: Float(data.FinalAmount!), code: CURRENCY_CODE)
            self.priceLabel.text = amount
        }
        
        if data.PartnerProfileRatings!.count > 0{
            self.safetyRatingMainView.isHidden = false
            self.detailToSuperviewTop.priority = UILayoutPriority(250)
            self.detailToSafetyRatingTop.priority = UILayoutPriority(999)
            self.configureRatingData(ratingData: data.PartnerProfileRatings!)
            
            if data.PartnerProfileRatings!.count > 0{
                let rData0 = data.PartnerProfileRatings![0]
                self.label1.text = String(format: "%@:%@", rData0.PartnerProfileQualicationType!,rData0.Rating!.capitalized)
                self.label2.text = ""
                self.label3.text = ""
                self.label4.text = ""
                self.label5.text = ""
                
                if data.PartnerProfileRatings!.count > 1{
                    let rData1 = data.PartnerProfileRatings![1]
                    self.label2.text = String(format: "%@:%@", rData1.PartnerProfileQualicationType!,rData1.Rating!.capitalized)
                    self.label3.text = ""
                    self.label4.text = ""
                    self.label5.text = ""
                }
                
                if data.PartnerProfileRatings!.count > 2{
                    let rData2 = data.PartnerProfileRatings![2]
                    self.label3.text = String(format: "%@:%@", rData2.PartnerProfileQualicationType!,rData2.Rating!.capitalized)
                    self.label4.text = ""
                    self.label5.text = ""
                }
                
                if data.PartnerProfileRatings!.count > 3{
                    let rData3 = data.PartnerProfileRatings![3]
                    self.label4.text = String(format: "%@:%@", rData3.PartnerProfileQualicationType!,rData3.Rating!.capitalized)
                    self.label5.text = ""
                }
                
                if data.PartnerProfileRatings!.count > 4{
                    let rData4 = data.PartnerProfileRatings![4]
                    self.label5.text = String(format: "%@:%@", rData4.PartnerProfileQualicationType!,rData4.Rating!.capitalized)
                }
            }
            
        }else{
            self.safetyRatingMainView.isHidden = true
            self.detailToSuperviewTop.priority = UILayoutPriority(999)
            self.detailToSafetyRatingTop.priority = UILayoutPriority(250)
            self.ratings = nil
        }
    }
    
    func showSelectBtn(){
        
        self.previewBtnToBottomSuperview.priority = UILayoutPriority(rawValue: 250)
        self.previewBtnToBottomSelectBtn.priority = UILayoutPriority(rawValue: 999)
        self.selectPriceBtn.isHidden = false
    }
    
    func hideSelectBtn(){
        
        self.previewBtnToBottomSuperview.priority = UILayoutPriority(rawValue: 999)
        self.previewBtnToBottomSelectBtn.priority = UILayoutPriority(rawValue: 250)
        self.selectPriceBtn.isHidden = true
    }
    
    @IBAction func previewButtonClicked(_ sender:UIButton){
        self.delegate?.previewBtnPressed?(sender: sender,section:self.prevIndexLabel.tag)
    }
    
    @IBAction func acceptButtonClicked(_ sender:UIButton){
        self.delegate?.acceptBtnPressed?(sender: sender,section:self.acceptIndexLabel.tag)
    }
    
    @IBAction func selectPriceBtnClicked(_ sender: UIButton){
        self.delegate?.selectBtnPressed?(sender: sender, section: self.selectIndexLabel.tag)
    }
}

extension BestAndMoreOptionCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ratings.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCells.SafetyRatingCell, for: indexPath) as! SafetyRatingCell
        
        //cell.rateImage.backgroundColor = UIColor.red
        let data = self.ratings[indexPath.row]
        let urlStr = String(format: "%@%@",APPUrls.ratingImageBaseUrl,data.ImagePath!)
                
        print("--------->\n")
        print(urlStr)
        print(data)
        print("\n--------->")
        //cell.rateImage.isHidden = false
        cell.configure(with: urlStr)
        return cell
    }
    
    // CollectionView Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(((collectionView.frame.width / 5) - 15))
        return CGSize(width: ((collectionView.frame.width / 5) - 10), height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.ratings != nil{
            if self.ratings.count > 0{
                if let data = self.ratings[indexPath.item].ImagePath{
                    self.delegate?.didSelectRatingAtIndex!(rateImage:data)
                }
            }
        }
    }
    
}
