//
//  AircraftListVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

protocol AircraftListDelegate {
    func didSelectedAircraft(data:AircraftsData,aircrafts:[String],aircraftIds:[String])
    func doneBtnPressed()
}

class AircraftListVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .AddressList

    var delegate:AircraftListDelegate?
    @IBOutlet weak var aircraftTableView:UITableView!
    var aircraftList = [AircraftsData]()
    var selectedIndex:IndexPath!
    var selectedIds = [String]()
    var selectedAircrafts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        self.getAircrafts()
        super.setBackButton(viewC: self)
        super.setRightButton(viewC: self, imageName: "", title: "Done")
        super.delegateNav = self
        self.setNavigationTitle(title: "Preferred Aircraft")
        // Do any additional setup after loading the view.
        aircraftTableView.delegate = self
        aircraftTableView.dataSource = self
        aircraftTableView.register(UINib(nibName: TableCells.SingleStringCell, bundle: nil), forCellReuseIdentifier: TableCells.SingleStringCell)
    }
    
    func getAircrafts(){
        self.view.makeToastActivity(.center)
        
        //finalcode
        let urlStr = String(format: "%@/Aircrafts/GetAircrafts", APIUrl.baseUrl)
        
        //let urlStr = String(format: "%@/getaircraft", APIUrl.baseUrl)
        
        
        APIHome.shared.getAircrafts(urlStr: urlStr) { response in
            self.view.hideToastActivity()
            if response.result?.lowercased() == "success"{
                if response.data != nil{
                    self.aircraftList = response.data!
                    self.aircraftTableView.reloadData()
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

extension AircraftListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aircraftList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.SingleStringCell, for: indexPath) as! SingleStringCell
        
        let rowData = self.aircraftList[indexPath.row]
        let id = String(rowData.aircraftID!)
        if self.selectedIds.contains(id){
            cell.imageV.image = UIImage(named: "selected")
        }else{
            cell.imageV.image = UIImage(named: "selected_not")
        }
        cell.titleLabel.text = rowData.aircraft!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
       
        let rowData = self.aircraftList[indexPath.row]
        let id = String(rowData.aircraftID!)
        if !self.selectedIds.contains(id){
            self.selectedIds.append(id)
            selectedAircrafts.append(rowData.aircraft!)
        }else{
            for i in 0...self.selectedIds.count - 1{
                let cid = self.selectedIds[i]
                if id == cid{
                    self.selectedIds.remove(at: i)
                    self.selectedAircrafts.remove(at: i)
                    break
                }
            }
        }
        
        self.delegate?.didSelectedAircraft(data: rowData,aircrafts:selectedAircrafts, aircraftIds: self.selectedIds)
        self.aircraftTableView.reloadData()
        //self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
}

extension AircraftListVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onRightButtonClick(sender: NavigationBarView, button: UIButton) {
        //let rData = self.aircraftList[indexPath.row]
        //self.delegate?.didSelectedAircraft(data: rData)
        self.delegate?.doneBtnPressed()
        self.navigationController?.popViewController(animated: true)
    }
}
