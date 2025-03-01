//
//  HomeVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

class HomeVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .Home
    
    @IBOutlet weak var submitButton:UIButton!
    @IBOutlet var viewArr:[UIView]!
    @IBOutlet weak var fromAddressLabel1:UILabel!
    @IBOutlet weak var fromAddressLabel2:UILabel!
    var fromAirportId:String! = ""
    
    @IBOutlet weak var toAddressLabel1:UILabel!
    @IBOutlet weak var toAddressLabel2:UILabel!
    var toAirportId:String! = ""
    
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var noofpassLabel:UILabel!
    @IBOutlet weak var priceTF:UITextField!
    @IBOutlet weak var preferAircraftLbl:UILabel!
    var preferAircraftId:[String]! = []
    var selectedDate:Date!
    var selectedDateString:String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetData()
        super.setNavigationTitle(title: "New Request")
        
        CommonFunction.setRoundedViews(arrayB: viewArr, radius: 5, borderColorCode: buttonBGColor, borderW: 1, bgColor: "E1F1F7")
        // Do any additional setup after loading the view.
        CommonFunction.setRoundedButtons(arrayB: [submitButton], radius: 10, borderColorCode: "", borderW: 0, bgColor: buttonBGColor, textColor: blackColorCode)
        
    }

    
    func resetData(){
        self.fromAddressLabel1.text = SOURCE_TITLE
        self.fromAddressLabel2.text = "Start Address"
        self.fromAirportId = ""
        
        self.toAddressLabel1.text = DESTINATION_TITLE
        self.toAddressLabel2.text = "End Address"
        self.toAirportId = ""
        
        self.dateLabel.text = ""
        self.noofpassLabel.text = ""
        self.priceTF.text = ""
        self.preferAircraftId = []
        self.preferAircraftLbl.text = ""
    }
    
    func postRequestCharter(){
        self.view.makeToastActivity(.center)
       
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/Post", APIUrl.baseUrl)
        
        //let urlStr = String(format: "%@/CharterreRequest", APIUrl.baseUrl)
        
        let parameters = ["ChartererRequestID": 0,
                          "StartAirportID":self.fromAirportId!,
                          "EndAirportID":self.toAirportId!,
                          "StartDateTime":self.selectedDateString!,
                          "Distance":"",
                          "Note":"",
                          "Status":"0",
                          "PaxCount":self.noofpassLabel.text!,
                          "PaxSegment":"N/A",
                          "PriceExpectation":self.priceTF.text!.trimmingCharacters(in: .whitespaces),
                          "PreferredAircraftIDCSV":self.preferAircraftId!] as [String: Any]
        
        APIChartererRequest.shared.postChartererRequest(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
            if response.status == 1{
                
                self.resetData()
                let detailVC = RequestDetailVC.storyboardViewController()
                detailVC.postResponseData = response
                self.navigationController?.pushViewController(detailVC, animated: true)
            }else{
                
            }
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    @IBAction func addressBtnClicked(_ sender : UIButton){
        if sender.tag == 0{
            let addressListVC = AddressListVC.storyboardViewController()
            addressListVC.optionIndex = 0
            addressListVC.delegate = self
            self.navigationController?.pushViewController(addressListVC, animated: true)
        }else{
            let addressListVC = AddressListVC.storyboardViewController()
            addressListVC.optionIndex = 1
            addressListVC.delegate = self
            self.navigationController?.pushViewController(addressListVC, animated: true)
        }
    }
    
    @IBAction func noOfpassengerBtnClciked(_ sender : UIButton){
        
        ASPicker.selectOption(dataArray: ["1","2","3","4","5"]) { value, atIndex in
            self.noofpassLabel.text = value
        }
    }
    
    @IBAction func dateBtnClicked(_ sender : UIButton){
        
        ASPicker.selectDate { date in
            //print(date)
            self.selectedDate = date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm a"
            
            let dateStr = formatter.string(from: date)
            //print(dateStr)
            self.dateLabel.text = dateStr
            
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS Z"
            self.selectedDateString = formatter.string(from: date)
        }
    }
    
    @IBAction func aircraftBtnClicked(_ sender : UIButton){
        
        self.navigationController?.navigationBar.isHidden = false
        let aircraftListVC = AircraftListVC.storyboardViewController()
        aircraftListVC.delegate = self
        self.navigationController?.pushViewController(aircraftListVC, animated: true)
    }
    
    @IBAction func submitBtnClicked(_ sender : UIButton){
        
        if self.fromAirportId == ""{
            CommonFunction.showToastMessage(msg: "Please select airport start point", controller: self)
            return
        }
        
        if self.toAirportId == ""{
            CommonFunction.showToastMessage(msg: "Please select airport end point", controller: self)
            return
        }
        
        if self.fromAirportId == self.toAirportId{
            CommonFunction.showToastMessage(msg: "Please select different airport start and end point", controller: self)
            return
        }
        
        if self.selectedDateString == ""{
            CommonFunction.showToastMessage(msg: "Please select departure date", controller: self)
            return
        }
        
        if self.noofpassLabel.text! == ""{
            CommonFunction.showToastMessage(msg: "Please select no of passengers", controller: self)
            return
        }
        
        if self.priceTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            
            if Int(self.priceTF.text!)! < 5000{
                CommonFunction.showToastMessage(msg: "Price must be greater than or equal to $5000", controller: self)
            }
            return
        }
        
        CommonFunction.showAlertMessageWithTitle(aStrTitle: "Confirm", aStrMessage: "Please confirm your request for \(self.fromAirportId!) to \(self.toAirportId!) on \(self.dateLabel.text!)", Oktitle: "Confirm", CancelTitle: "Cancel", aViewController: self) { cancelAction in
            
        } OKActionTap: { OkAction in
            //self.postRequestCharter()
        }
    }
}

extension HomeVC : AircraftListDelegate{
    
    func didSelectedAircraft(data: AircraftsData,aircrafts:[String], aircraftIds: [String]) {
        self.preferAircraftLbl.text = data.aircraft
        self.preferAircraftId = aircraftIds
    }
    
    func doneBtnPressed() {
        //
    }
}

extension HomeVC : AirportListDelegate{
    
    func didSelectedAirport(data: AirportData, optionIndex: Int,atIndex:Int) {
        if optionIndex == 0{
            self.fromAddressLabel1.text = data.code
            self.fromAddressLabel2.text = String(format: "%@ %@", data.city!,data.country!)
            self.fromAirportId = data.code!
        }else{
            self.toAddressLabel1.text = data.code
            self.toAddressLabel2.text = String(format: "%@ %@", data.city!,data.country!)
            self.toAirportId = data.code!
        }
    }
}
