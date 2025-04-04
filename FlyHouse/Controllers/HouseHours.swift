//
//  HouseHours.swift
//  FlyHouse
//
//  Created by Atul on 31/03/25.
//

import UIKit

class HouseHours: NavigationBarView,Storyboardable {
    
    static let storyboardName :StoryBoardName = .Home
    var userId : Int = 0
    var earningdata = [UserRoomKeyEarningsData]()
    var keyData = [UserRoomKeyData]()
    
    @IBOutlet weak var houseHoursTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setNavigationTitle(title: "House Hours")
        super.setBackButton(viewC: self)
        super.delegateNav = self
        // Do any additional setup after loading the view.
        
        self.houseHoursTableView.register(UINib(nibName: TableCells.HHMyKeyCell, bundle: nil), forCellReuseIdentifier: TableCells.HHMyKeyCell)
        self.houseHoursTableView.register(UINib(nibName: TableCells.HHMyEarningCell, bundle: nil), forCellReuseIdentifier: TableCells.HHMyEarningCell)
        
        if UserDefaults.standard.value(forKey: "UserLoginUserId") != nil{
            self.userId = (UserDefaults.standard.value(forKey: "UserLoginUserId") as! Int)
            self.getUserRoomKeyData(userId: self.userId)
        }
    }
    
    func getUserRoomKeyEarningsData(userId:Int){
        self.view.makeToastActivity(.center)
        
        //finalcode
        let urlStr = String(format: "%@/User/GetUserRoomKeyEarningsData?userid=%@", APIUrl.baseUrl,String(self.userId))

        APIUser.shared.getUserRoomKeyEarningsData(urlStr: urlStr) { response in
            self.view.hideToastActivity()
            if response.result?.lowercased() == "success"{
                
                if response.data != nil{
                    self.earningdata = response.data!
                    self.houseHoursTableView.reloadData()
                }
            }
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
            }
        }
    }
    
    func getUserRoomKeyData(userId:Int){
        self.view.makeToastActivity(.center)
        
        //finalcode
        let urlStr = String(format: "%@/User/GetUserRoomKeyData?userid=%@", APIUrl.baseUrl,String(self.userId))

        APIUser.shared.getUserRoomKeyData(urlStr: urlStr) { response in
            self.view.hideToastActivity()
            if response.result?.lowercased() == "success"{
                
                if response.data != nil{
                    self.houseHoursTableView.delegate = self
                    self.houseHoursTableView.dataSource = self
                    self.keyData = response.data!
                    self.houseHoursTableView.reloadData()
                    self.getUserRoomKeyEarningsData(userId: self.userId)
                }
            }
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
            }
        }
    }
}

extension HouseHours : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HouseHours : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.HHMyKeyCell) as! HHMyKeyCell
            let rowData = self.keyData[indexPath.row]
            cell.configureMyKeyCell(indexpath: indexPath, data: rowData)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.HHMyEarningCell) as! HHMyEarningCell
            cell.delegate = self
            cell.reloadtableData(data: self.earningdata)
            return cell
        }
        
    }
}

extension HouseHours : HHMyEarningCellDelegate{
    
    func redeemBtnTapped() {
        APP_DELEGATE.setHomeToRootViewController()
    }
}
