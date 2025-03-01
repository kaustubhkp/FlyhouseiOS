//
//  RequestListDetailVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class RequestListDetailVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .RequestList
    
    
    @IBOutlet weak var requestListDetailTable:UITableView!
    var requestListData:CPRequestData!
    var crLegDetailsData = [CRlegDetailData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        super.setNavigationTitle(title: "View Past Request")
        self.setBackButton(viewC: self)
        self.delegateNav = self
        // Do any additional setup after loading the view.
        
        if requestListData.chartererRequestID != nil{
            print(self.requestListData!)
            self.APIGetChartererCRLegDetailsCall(id: requestListData.chartererRequestID!)
        }
        requestListDetailTable.register(UINib(nibName: TableCells.PastRequestTblCell, bundle: nil), forCellReuseIdentifier: TableCells.PastRequestTblCell)
        
        requestListDetailTable.register(UINib(nibName: TableCells.RequestListDetailCell, bundle: nil), forCellReuseIdentifier: TableCells.RequestListDetailCell)
        
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    func APIGetChartererCRLegDetailsCall(id:Int){
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetCRLegDetails?charterRequestID=%d", APIUrl.baseUrl,id)
                
        APIChartererRequest.shared.getChartererCRLegDetails(urlStr: getAPIUrl) { response in

            self.view.hideToastActivity()
            if response.result == "success" {
                if response.data != nil{
                    
                    //set list
                    self.crLegDetailsData = response.data!
                    
                    DispatchQueue.main.async {
                        self.requestListDetailTable.delegate = self
                        self.requestListDetailTable.dataSource = self
                        self.requestListDetailTable.reloadData()
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
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
}

extension RequestListDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return self.crLegDetailsData.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.PastRequestTblCell, for: indexPath) as! PastRequestTblCell
            cell.showRightSidePlan()
            let data = self.crLegDetailsData[indexPath.row]
            cell.configuerConfirmPendingRequest(indexPath: indexPath, data: data)
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestListDetailCell, for: indexPath) as! RequestListDetailCell
            cell.configuerViewPastRequestDetailCell(indexPath: indexPath, data: self.requestListData)
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

extension RequestListDetailVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
}
