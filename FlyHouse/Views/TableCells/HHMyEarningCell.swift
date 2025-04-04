//
//  HHMyEarningCell.swift
//  FlyHouse
//
//  Created by Atul on 03/04/25.
//

import UIKit

@objc protocol HHMyEarningCellDelegate {
    
    func redeemBtnTapped()
}

class HHMyEarningCell: UITableViewCell {
    
    var delegate : HHMyEarningCellDelegate?
    @IBOutlet weak var cellMainView:UIView!
    @IBOutlet weak var redeemBtn:UIButton!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var earningTableView:UITableView!
    var myearningData = [UserRoomKeyEarningsData]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        CommonFunction.setRoundedViews(arrayB: [cellMainView], radius: 10, borderColorCode: "", borderW: 0, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setRoundedButtons(arrayB: [redeemBtn], radius: redeemBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: whiteColorCode, textColor: blackColorCode)
        
    }
    
    func reloadtableData(data: [UserRoomKeyEarningsData]){
        
        myearningData = data
        
        earningTableView.register(UINib(nibName: TableCells.HHMyEarningTblCell, bundle: nil), forCellReuseIdentifier: TableCells.HHMyEarningTblCell)
        earningTableView.delegate = self
        earningTableView.dataSource = self
        earningTableView.reloadData()
    }
    
    @IBAction func redeedBtnClicked(_ sender : UIButton){
        self.delegate?.redeemBtnTapped()
    }
    
}

extension HHMyEarningCell : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myearningData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.HHMyEarningTblCell) as! HHMyEarningTblCell
        
        let rowData = self.myearningData[indexPath.row]
        cell.configureCellWithData(indexpath: indexPath, data: rowData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
