//
//  MyTripDetailVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 11/02/24.
//

import UIKit

class MyTripDetailVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .MyTrips

    
    @IBOutlet weak var myTripDetailTableView:UITableView!
    @IBOutlet weak var tripDetailsBtn:UIButton!
    @IBOutlet weak var tripNotesBtn:UIButton!
    var myTripData:MyTripData!
    var crLegDetailsData = [TripDetailsData]()
    var paymentDetail:PaymentData!
    var pUrl:String! = APIUrl.previewBaseURL
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        //self.getPrivacyBaseUrl()
        // Do any additional setup after loading the view.
        super.setNavigationTitle(title: "My Trip Details")
        super.setBackButton(viewC: self)
        super.delegateNav = self
        myTripDetailTableView.isHidden = true
        
        myTripDetailTableView.register(UINib(nibName: TableCells.HeaderImageCell, bundle: nil), forCellReuseIdentifier: TableCells.HeaderImageCell)
        
        myTripDetailTableView.register(UINib(nibName: TableCells.MyTripDetailCell, bundle: nil), forCellReuseIdentifier: TableCells.MyTripDetailCell)
        
        myTripDetailTableView.register(UINib(nibName: TableCells.MyTripDetailsCell, bundle: nil), forCellReuseIdentifier: TableCells.MyTripDetailsCell)
        
        myTripDetailTableView.register(UINib(nibName: TableCells.ConfirmationCodeCell, bundle: nil), forCellReuseIdentifier: TableCells.ConfirmationCodeCell)
        
        if self.myTripData != nil{
           
            if myTripData.ChartererRequestID != nil{
                self.APIGetMyTripDetailsCall(cid: self.myTripData.ChartererRequestID!)
            }
            
            if myTripData.PaymentID != nil{
                self.APIGetPaymentDetails(pid: self.myTripData.PaymentID!)
            }else{
                self.myTripDetailTableView.delegate = self
                self.myTripDetailTableView.dataSource = self
                self.myTripDetailTableView.reloadData()
                self.myTripDetailTableView.isHidden = false
            }
        }
        
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    func APIGetMyTripDetailsCall(cid:Int){
        
        self.view.makeToastActivity(.center)
        let getAPIUrl = String(format: "%@/Trip/GetMyTripDetails?chartererRequestID=%d&tripID=0&userid=0", APIUrl.baseUrl,cid)
        
        APITrip.shared.getMyTripDetails(urlStr: getAPIUrl) { response in
            self.view.hideToastActivity()
            if response.result == "success" {
                if response.data != nil{
                    //set list
                    self.crLegDetailsData = response.data!
                    
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
    
    /*func APIGetChartererCRLegDetailsCall(id:Int){
        //finalcode
        self.view.makeToastActivity(.center)
        let getAPIUrl = String(format: "%@/ChartererRequest/GetCRLegDetails?charterRequestID=%d", APIUrl.baseUrl,id)
                
        APIChartererRequest.shared.getChartererCRLegDetails(urlStr: getAPIUrl) { response in

            self.view.hideToastActivity()
            if response.result == "success" {
                if response.data != nil{
                    //set list
                    self.crLegDetailsData = response.data!
                    self.myTripDetailTableView.reloadData()
                }
            }
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }*/
    
    func APIGetPaymentDetails(pid:Int){
        //finalcode
        //PaymentAPI/GetPaymentDetails?paymentid=
        self.view.makeToastActivity(.center)
        let getAPIUrl = String(format: "%@/PaymentAPI/GetPaymentDetails?paymentid=%d", APIUrl.baseUrl,pid)
                
        APIPayment.shared.getPaymentDetailequest(urlStr: getAPIUrl) { response in

            self.view.hideToastActivity()
            if response.result == "success" {
                if response.data != nil{
                    self.paymentDetail = response.data!
                    
                    DispatchQueue.main.async {
                        self.myTripDetailTableView.delegate = self
                        self.myTripDetailTableView.dataSource = self
                        self.myTripDetailTableView.reloadData()
                        self.myTripDetailTableView.isHidden = false
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
    
    @IBAction func tripNotesBtnClicked(_ sender : UIButton){
        
    }

}

extension MyTripDetailVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyTripDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if (self.crLegDetailsData.count <= 1) {
                return self.crLegDetailsData.count
            }
            return 1
        }else if section == 1{
            return self.crLegDetailsData.count
        }else{
            return 1 // detail
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.ConfirmationCodeCell, for: indexPath) as! ConfirmationCodeCell
            let rowData = crLegDetailsData[indexPath.row]
            
            cell.confirmationCodeLabel.text = String(format: "Confirmation Code: %@", rowData.ConfirmationCode!)
            return cell
            
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.MyTripDetailsCell, for: indexPath) as! MyTripDetailsCell
            
            let rowData = crLegDetailsData[indexPath.row]
            cell.configuerMyTrip(indexPath: indexPath, data: rowData)
            cell.delegate = self
            cell.layoutSubviews()
            return cell
        }else{ // trip detail
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.MyTripDetailCell, for: indexPath) as! MyTripDetailCell
            
            cell.confugurationPaymentDetailCell(indexPath: indexPath, data: self.paymentDetail,tripData: self.myTripData)
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

extension MyTripDetailVC : MyTripDetailsCellDelegate{
    
    func tripDetailsBtnPressed(){
        let detailVC = MyTripsDetailsVC.storyboardViewController()
        detailVC.myTripData = self.myTripData
        detailVC.paymentDetail = self.paymentDetail
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func getPrivacyBaseUrl(){
       
        let urlStr = String(format: "%@/UserDevice/GetChatBaseURL", APIUrl.baseUrl)
        
        APILogin.shared.getBaseURL(urlStr: urlStr) { response in
            
            if response.result == "success"{
                if response.data != nil{
                    self.pUrl = response.data!
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
    
    func tripNoteBtnPressed(onIndex:Int) {
        
        let data = crLegDetailsData[onIndex]
        if data.TripID != nil{
            let previewVC = PreviewOfferVC.storyboardViewController()
            var token:String! = ""
            if UserDefaults.standard.value(forKey: "Authorization") != nil{
                token = (UserDefaults.standard.value(forKey: "Authorization") as! String)
            }
            let url = String(format: "%@/flyhousemobile/cTripNotesDetail?id=%d&uid=%D&token=%@", self.pUrl!,data.TripID!,self.myTripData.UserID!,token)
            previewVC.prevUrlStr = url
            previewVC.titleStr = "Trip Notes"
            previewVC.isFromTermsAndCond = false
            previewVC.isFrom = "TripDetails"
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
}
