//
//  MyTripsVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 07/02/24.
//

import UIKit

class MyTripsVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .MyTrips

    var titleStr:String! = ""
    @IBOutlet weak var nodataLabel:UILabel!
    @IBOutlet weak var myTripTableView:UITableView!
    var myTripDataArr = [MyTripData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        //super.setNavigationTitle(title: titleStr)
        super.showNavLogoImage()
        CommonFunction.setLabelsFonts(lbls: [nodataLabel], type: .fMedium, size: 15)
        myTripTableView.delegate = self
        myTripTableView.dataSource = self
        //myTripTableView.register(UINib(nibName: TableCells.HeaderImageCell, bundle: nil), forCellReuseIdentifier: TableCells.HeaderImageCell)
        myTripTableView.register(UINib(nibName: TableCells.PastRequestTblCell, bundle: nil), forCellReuseIdentifier: TableCells.PastRequestTblCell)
        self.setupPullToRefresh()
        self.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.makeToastActivity(.center)
        self.getMyTrip()
    }
    
    func setupPullToRefresh(){
        
        // Create a UIRefreshControl instance
        let refreshControl = UIRefreshControl()
                
        // Assign an action to the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
                
        // Add the refresh control to the tableView
        myTripTableView.refreshControl = refreshControl
                
        // Optionally, customize the appearance of the refresh control
        refreshControl.tintColor = .black
    }
    
    // The function that is called when the refresh action is triggered
    @objc func refreshData() {
        // Here you can perform your data reloading process, like making a network request
        self.getMyTrip()
    }
    
    func getMyTrip(){
        var userId = 0
        if UserDefaults.standard.value(forKey: "UserLoginUserId") != nil{
            userId = (UserDefaults.standard.value(forKey: "UserLoginUserId") as! Int)
        }
        
        //finalcode
        let urlStr = String(format: "%@/Trip/GetChartererTrips?chartereruserid=%d", APIUrl.baseUrl,userId)
        
        APITrip.shared.getMyTripRequest(urlStr: urlStr) { response in
            self.view.hideToastActivity()
            // End the refreshing animation
            self.myTripTableView.refreshControl?.endRefreshing()
            
            if response.result == "success"{
                if response.data != nil{
                    self.myTripDataArr = response.data!
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

        if self.myTripDataArr.count > 0{
            self.nodataLabel.text = ""
            self.nodataLabel.isHidden = true
            self.myTripTableView.reloadData()
        }else{
            self.nodataLabel.isHidden = false
            self.nodataLabel.text = "No data available"
            CommonFunction.showToastMessage(msg: "No data available", controller: self)
        }
    }
    
    
}

extension MyTripsVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myTripDataArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.PastRequestTblCell, for: indexPath) as! PastRequestTblCell
            cell.showRightSidePlan()
            let rowData = self.myTripDataArr[indexPath.row]
           
            cell.configuerMyTripCell(indexPath: indexPath, data: rowData)
            //cell.confirmBtnHeightConst.constant = 50
            //cell.confirmBtn.setImage(UIImage(named: "accept"), for: .normal)
        
        cell.showDateTimeLable()
        cell.layoutSubviews()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = MyTripDetailVC.storyboardViewController()
        let trip = self.myTripDataArr[indexPath.row]
        detailVC.myTripData = trip
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1//5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1//5
    }
}

