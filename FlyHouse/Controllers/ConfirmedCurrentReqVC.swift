//
//  ConfirmedCurrentReqVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 16/01/24.
//

import UIKit

class ConfirmedCurrentReqVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .RequestConfirm
    
    @IBOutlet weak var confirmReqTable:UITableView!
    var postResponseData:CharterreResponse!
    var pendingResponseData:CharterReqData!
    var crLegDetailsData:[CRlegDetailData]?
    var charterRequestGetData = CharterReqData()
    var chartedReqID:Int!
    @IBOutlet weak var pastReqBtn:UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.APIGetChartererRequestCall()
        super.setNavigationTitle(title: "")
        // Do any additional setup after loading the view.
        super.setBackButton(viewC: self)
        super.delegateNav = self
        
        CommonFunction.setRoundedButtons(arrayB: [pastReqBtn], radius: pastReqBtn.frame.size.height/2, borderColorCode: blackColorCode, borderW: 1, bgColor: "", textColor: blackColorCode)
        
        confirmReqTable.register(UINib(nibName: TableCells.RequestListCell, bundle: nil), forCellReuseIdentifier: TableCells.RequestListCell)
        confirmReqTable.register(UINib(nibName: TableCells.PastRequestTblCell, bundle: nil), forCellReuseIdentifier: TableCells.PastRequestTblCell)
       // confirmReqTable.register(UINib(nibName: TableCells.CancelRequestCell, bundle: nil), forCellReuseIdentifier: TableCells.CancelRequestCell)
        self.confirmReqTable.delegate = self
        self.confirmReqTable.dataSource = self
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    
    func APIGetChartererRequestCall(){
        
        //let chartererRequestID = self.charterRequestGetData.ChartererRequestID!
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetDecimalNew/%d", APIUrl.baseUrl,self.chartedReqID)
        
        // self.view.makeToastActivity(.center)
        APIChartererRequest.shared.getChartererRequest(urlStr: getAPIUrl) { response in
            
            if response.result == "success"{
                if response.data != nil{
                    
                    self.charterRequestGetData = response.data!
                    DispatchQueue.main.async {
                        self.confirmReqTable.reloadData()
                    }
                }else{
                    if response.title != nil && response.description != nil{
                        CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                            
                        }
                    }
                }
            }else{
                if response.title != nil && response.description != nil{
                    CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                        
                    }
                }
            }
        }fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    @IBAction func pastRequtBtnClicked(_ sender:UIButton){
        APP_DELEGATE.setMyTripTabWithIndex(atIndex: 1,optionIndex: 1)
    }

}

extension ConfirmedCurrentReqVC : NavigationBarViewDelegate {
    
    func onBackButtonClick(sender: NavigationBarView) {
        APP_DELEGATE.setHomeToRootViewController()
    }
}

extension ConfirmedCurrentReqVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return self.charterRequestGetData.CRSegments!.count
        }else if section == 2{
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = UITableViewCell()
            
            if indexPath.row == 0{
                cell.textLabel!.text = "Congratulations on booking your flight. You will soon receive the booking documents and advance payment links in email from booking@goflyhouse.com"
                cell.textLabel?.textAlignment = .left
                cell.textLabel!.textColor = UIColor.darkGray
            }
            CommonFunction.setLabelsFonts(lbls: [cell.textLabel!], type: .fReguler, size: 14)
            cell.textLabel!.numberOfLines = 0
            cell.backgroundColor = UIColor.clear
            return cell
            
        }else if indexPath.section == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.PastRequestTblCell, for: indexPath) as! PastRequestTblCell
            //cell.hideDetailView()
            cell.showMiddlePlane()
            cell.showDateTimeLable()
            
            let data = self.charterRequestGetData.CRSegments![indexPath.row]
            cell.configuerConfirmPendingRequest(indexPath: indexPath,data: data)
            
            return cell
            
        }else if indexPath.section == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestListCell, for: indexPath) as! RequestListCell
            cell.showDetailViewAndHideTop()
            cell.configuerRequestConfrimCell(indexPath: indexPath, data:self.charterRequestGetData)
            
            cell.transportViewToBottomStatusView.priority = UILayoutPriority(250)
            cell.transportViewToBottomSuperview.priority = UILayoutPriority(999)
            cell.statusView.isHidden = true
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.CancelRequestCell, for: indexPath) as! CancelRequestCell
            
            cell.cancelReqBtn.setTitle("PAST REQUESTS", for: .normal)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension ConfirmedCurrentReqVC : CancelRequestCellDelegate{
    
    func cancelRequestBtnPressed() {
        
        APP_DELEGATE.setMyTripTabWithIndex(atIndex: 1,optionIndex: 1)
        
       // let reqVC = RequestListVC.storyboardViewController()
        //reqVC.titleStr = "Past Requests"
        //let navController = UINavigationController(rootViewController: reqVC)
       // self.slideMenuController()?.changeMainViewController(navController, close: true)
    }
}
