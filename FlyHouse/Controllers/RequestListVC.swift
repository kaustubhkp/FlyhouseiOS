//
//  RequestListVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class RequestListVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .RequestList

    @IBOutlet weak var nodataLabel:UILabel!
    @IBOutlet weak var requestListTable:UITableView!
    var titleStr:String! = ""
    var selectedIndex:IndexPath!
    var reqListArr = [CPRequestData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.showNavLogoImage()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        self.setNavigationTitle(title: titleStr)
        // Do any additional setup after loading the view.
        
        CommonFunction.setLabelsFonts(lbls: [nodataLabel], type: .fMedium, size: 15)
        
        requestListTable.register(UINib(nibName: TableCells.RequestListCell, bundle: nil), forCellReuseIdentifier: TableCells.RequestListCell)
        
        requestListTable.register(UINib(nibName: TableCells.PastRequestTblCell, bundle: nil), forCellReuseIdentifier: TableCells.PastRequestTblCell)
        
        requestListTable.delegate = self
        requestListTable.dataSource = self
        self.setupPullToRefresh()
        
        self.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.makeToastActivity(.center)
        self.getChartererPastRequests()
    }
    
    func setupPullToRefresh(){
        
        // Create a UIRefreshControl instance
        let refreshControl = UIRefreshControl()
                
        // Assign an action to the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
                
        // Add the refresh control to the tableView
        requestListTable.refreshControl = refreshControl
                
        // Optionally, customize the appearance of the refresh control
        refreshControl.tintColor = .black
    }
    
    // The function that is called when the refresh action is triggered
    @objc func refreshData() {
        // Here you can perform your data reloading process, like making a network request
        self.getChartererPastRequests()
    }
    
    func getChartererPastRequests(){
        
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/GetChartererPastRequestsDecimal", APIUrl.baseUrl)
        
       // let urlStr = String(format: "%@/GetChartererPastRequests", APIUrl.baseUrl)
        
        APIRequest.shared.getPastRequest(urlStr: urlStr) { response in
            self.view.hideToastActivity()
            // End the refreshing animation
            self.requestListTable.refreshControl?.endRefreshing()
            
            if response.result == "success"{
                if response.data != nil{
                    self.reqListArr = response.data!
                }else{
                    if response.title != nil && response.description != nil{
                        CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                            
                        }
                    }
                }
                self.showTableData()
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
    
    func showTableData(){
        
        if self.reqListArr.count > 0{
            self.nodataLabel.text = ""
            self.requestListTable.reloadData()
        }else{
            self.nodataLabel.text = "No data available"
            CommonFunction.showToastMessage(msg: "No data available", controller: self)
        }
    }
}

extension RequestListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reqListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.PastRequestTblCell, for: indexPath) as! PastRequestTblCell
        cell.showRightSidePlan()
        let rowData = self.reqListArr[indexPath.row]
        cell.configuerPastRequest(indexPath: indexPath, data: rowData)
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        let detailVC = RequestListDetailVC.storyboardViewController()
         let rowData = self.reqListArr[indexPath.row]
        detailVC.requestListData = rowData
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        /*if self.selectedIndex == indexPath{
            self.selectedIndex = nil
        }else{
            self.selectedIndex = indexPath
        }
        self.requestListTable.reloadData()*/
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}

