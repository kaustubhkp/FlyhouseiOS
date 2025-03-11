//
//  RequestAcceptDetailVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

struct Transport{
    var selectedOption:String?
    var flagVal:Int?
}

struct Inflight{
    var selectedOption:String?
    var flagVal:Int?
}

@objc protocol RequestAcceptDetailVCDelegate{
    
    @objc optional
    func backBtnPressed()
    
}

class RequestAcceptDetailVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .RequestConfirm
    
    var delegate :RequestAcceptDetailVCDelegate?
    @IBOutlet weak var requestAcceptDetailTable:UITableView!
    var postResponseData:CharterreResponse!
    var pendingResponseData:CharterReqData!
    var crLegDetailsData:[CRlegDetailData]?
    var type:String! = ""
    var requestedData = RequestingLog()
    @IBOutlet weak var termsBtn:UIButton!
    @IBOutlet weak var submitBtn:UIButton!
    @IBOutlet weak var backBtn:UIButton!
    var isFromPreview:Bool! = false
    @IBOutlet weak var errorPaxView:UIView!
    @IBOutlet weak var errorPaxMsgLabel:UILabel!
    @IBOutlet weak var acceptTermsLabel:UILabel!
    var transport = Transport(selectedOption: "No",flagVal:0)
    var inflight = Inflight(selectedOption: "No",flagVal:0)
    var charterReqId:Int! = 0
    var ownerMaxPaxCount:Int! = 0
    
    var aircraftName:String! = ""
    var lowestPrice:Float! = 0
    var selectedSplitContacts = [SplitContacts]()
    var splitContactIDCSV = NSMutableArray()
    var totalPax:Int! = 0
    var totalMainPax:Int! = 0
    var totalSPax:Int! = 0
    var totalAmount:Float! = 0
    var isSplit:Int! = 0
    var splitAmount:Float! = 0
    var totalSplitPax:Int! = 0
    var totalRemainPax:Int! = 0
    var totalTripAmount:Double! = 0.00
    var saveSplitPaymentDetail = NSMutableArray()
    var pDetail = NSMutableDictionary()
    var charterRequestGetData = CharterReqData()
    var splitContIDCSV = NSMutableArray()
    var splitContatsData:[SplitContacts]?
    
    var selectedAircrafts = [GetSelectedBestAndMoreData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        // Do any additional setup after loading the view.
        super.setNavigationTitle(title: "Accepted Request")
        super.setBackButton(viewC: self)
        super.delegateNav = self
        
        self.submitBtn.isEnabled = false
        
        CommonFunction.setLabelsFonts(lbls: [acceptTermsLabel], type: .fReguler, size: 12)
        CommonFunction.setRoundedButtons(arrayB: [submitBtn], radius: self.submitBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: lightGrayColorCode, textColor: blackColorCode)
        
        self.backBtn.isEnabled = true
        CommonFunction.setRoundedButtons(arrayB: [backBtn], radius: self.backBtn.frame.size.height/2, borderColorCode: blackColorCode, borderW: 1, bgColor: "", textColor: blackColorCode)
        
        requestAcceptDetailTable.register(UINib(nibName: TableCells.RequestAcceptListCell, bundle: nil), forCellReuseIdentifier: TableCells.RequestAcceptListCell)
        
        requestAcceptDetailTable.register(UINib(nibName: TableCells.RequestAcceptCell, bundle: nil), forCellReuseIdentifier: TableCells.RequestAcceptCell)
        
        requestAcceptDetailTable.register(UINib(nibName: TableCells.TransportInflightServiceCell, bundle: nil), forCellReuseIdentifier: TableCells.TransportInflightServiceCell)
        
        requestAcceptDetailTable.register(UINib(nibName: TableCells.PaymentSplitCell, bundle: nil), forCellReuseIdentifier: TableCells.PaymentSplitCell)
        
        requestAcceptDetailTable.register(UINib(nibName: TableCells.ManageContactListCell, bundle: nil), forCellReuseIdentifier: TableCells.ManageContactListCell)
        
        //requestAcceptDetailTable.register(UINib(nibName: TableCells.SelectedAircraftCell, bundle: nil), forCellReuseIdentifier: TableCells.SelectedAircraftCell)
    
        self.errorPaxView.isHidden = true
        self.errorPaxMsgLabel.text = "Please review passenger count, the total number of passengers cannot exceed \(self.totalPax!)"
        
        self.setUpViewData()
        if self.charterReqId != nil{
            if self.isSplit == 1 {
                //self.getSplitPaymentDetails()
            }
            self.APIGetChartererRequestDecimalCall()
        }
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setUpViewData() {
        if self.postResponseData != nil{
            self.totalPax = self.postResponseData.paxCount!
            self.totalAmount = self.lowestPrice
        }else{
            self.totalPax = self.pendingResponseData.PaxCount!
            self.totalAmount = self.lowestPrice
        }
        self.splitAmount = self.lowestPrice/Float(self.totalPax!)
        self.totalMainPax = self.totalPax
    }
    
    func relaodTableView(){
        requestAcceptDetailTable.delegate = self
        requestAcceptDetailTable.dataSource = self
        
        DispatchQueue.main.async {
            self.requestAcceptDetailTable.reloadData()
        }
    }
    
    func APIUpdateCharterRequestPaymentConfirmStatusCall(){
    
        self.view.makeToastActivity(.center)
       
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/UpdateCharterRequestStatus?chartererrequestid=%d&statusid=4", APIUrl.baseUrl,self.charterReqId!)
        
        let parameters = ["chartererrequestid":self.charterReqId!,"statusid":4] as [String: Any]
    
        APIChartererRequest.shared.updateChartererRequest(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
           // if response.data != nil{
            if response.result == "success" || response.data == true{
                
//                CommonFunction.showAlertMessage(aStrTitle: "", aStrMessage: "Congratulations on booking your flight. You will soon receive the booking documents and advance payment links in email from booking@flyhouse.us", aViewController: self) { OkAction in
                    
                    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.ChartererRequestID)
                    UserDefaults.standard.synchronize()
                    //APP_DELEGATE.createNewRequestView()
                    
                    let confirmedReqVC = ConfirmedCurrentReqVC.storyboardViewController()
                    confirmedReqVC.charterRequestGetData = self.charterRequestGetData
                    //confirmedReqVC.postResponseData = self.postResponseData
                    //confirmedReqVC.crLegDetailsData = self.crLegDetailsData
                    //confirmedReqVC.pendingResponseData = self.pendingResponseData
                    confirmedReqVC.chartedReqID = self.charterReqId!
                    self.navigationController?.pushViewController(confirmedReqVC, animated: true)
                    
                //}
                
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
    
    func APIGetChartererRequestDecimalCall(){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetDecimalNew/%d", APIUrl.baseUrl,self.charterReqId!)
        
        // self.view.makeToastActivity(.center)
        APIChartererRequest.shared.getChartererRequest(urlStr: getAPIUrl) { response in
            
            if response.result == "success"{
                if response.data != nil{
                    self.ownerMaxPaxCount =  response.data!.OwnerMaxPaxCount
                    self.isSplit = response.data!.IsSplitPayment
                    self.getSelectedBestAndMoreOptions()
                    //self.relaodTableView()
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
    
    func getSelectedBestAndMoreOptions(){
        self.view.makeToastActivity(.center)
        
        let urlStr = String(format: "%@/ChartererRequest/GetSelectedBestAndMoreOptions/%d", APIUrl.baseUrl,self.charterReqId!)
    
        APISplitPayment.shared.getSelectedBestAndMoreOptions(urlStr: urlStr) { response in
            self.view.hideToastActivity()
            
            if response.result == "success"{
                if response.data != nil{
                    if response.data!.count > 0{
                        self.selectedAircrafts = response.data!
                        
                        for aircraft in self.selectedAircrafts{
                            self.lowestPrice +=   Float(aircraft.FinalAmount!)
                            self.totalTripAmount = Double(self.lowestPrice)
                        }
                    }
                    self.relaodTableView()
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
    
    func checkExistingSplitContactDetails(data:SplitContacts)->Int{
        
        if let updatedContacts = splitContatsData {
           if let updatedContact = updatedContacts.first(where: { $0.splitPaymentContactID == data.splitPaymentContactID }) {
                    if data.noOfPassenger != updatedContact.noOfPassenger {
                        print("Updated contact: \(data.firstName ?? "") \(data.lastName ?? "") - Old NoOfPassenger: \(data.noOfPassenger ?? 1), New NoOfPassenger: \(updatedContact.noOfPassenger ?? 1)")
                        return updatedContact.noOfPassenger ?? 1
                    }
                }
            }
        return 1
    }
    
    func getExistingSplitContactNoOfPassengers(splitPaymentContactID:Int)->Int{
        
        if let updatedContacts = splitContatsData {
           if let updatedContact = updatedContacts.first(where: { $0.splitPaymentContactID == splitPaymentContactID }) {
               print("Updated contact: \(updatedContact.firstName ?? "") \(updatedContact.lastName ?? ""), New NoOfPassenger: \(updatedContact.noOfPassenger ?? 1)")
                    return updatedContact.noOfPassenger ?? 1
           }else{
               return 1
           }
        }
        return 1
    }
    
    func getSplitPaymentDetails(){
    
        self.view.makeToastActivity(.center)
        
        //finalcode
        let urlStr = String(format: "%@/SplitPayment/GetSplitPaymentDetails?charterrequestid=%d", APIUrl.baseUrl,self.charterReqId!)
    
        APISplitPayment.shared.getSplitContactDetails(urlStr: urlStr) { response in
            self.view.hideToastActivity()
        
            if response.result == "success"{
                
                if response.data != nil{
                    
                    if response.data!.count > 0{
                        
                        self.totalSPax = 0
                        for i in 0...response.data!.count - 1{
                            
                            
                            if response.data![i].IsCharterer == 0{
                                
                                if response.data![i].ChartereSplitPaymentContact != nil{
                                    
                                    
                                    var splitContact = SplitContacts()
                                    
                                    splitContact.splitPaymentContactID = response.data![i].SplitPaymentContactID!
                                    
                                    splitContact.isCharterer = response.data![i].IsCharterer!
                                   
                                    let noofPax = self.checkExistingSplitContactDetails(data: splitContact)
                                    splitContact.noOfPassenger = noofPax
                                    
                                    self.totalSPax += noofPax
                                    splitContact.lastName = response.data![i].ChartereSplitPaymentContact!.lastName!
                                    
                                    splitContact.firstName = response.data![i].ChartereSplitPaymentContact!.firstName!
                                    
                                    self.selectedSplitContacts.append(splitContact)
                                    self.splitContactIDCSV.add(response.data![i].ChartereSplitPaymentContact!.splitPaymentContactID!)
                                    
                                    
                                    //New Added Split contact into Main
                                    self.pDetail = NSMutableDictionary()
                                    let pax = self.getExistingSplitContactNoOfPassengers(splitPaymentContactID: response.data![i].SplitPaymentContactID!)
                                    
                                    let splitAmt = self.lowestPrice/Float(self.totalPax!)
                                    //print("Lowest Price :\(self.lowestPrice!)")
                                    //print("Total Pax :\(self.totalPax!)")
                                    //print("///Split Amt :\(splitAmt)")
                                    
                                    self.pDetail["NoOfPassengers"] = pax
                                    self.pDetail["CostPerPerson"] = splitAmt
                                    self.pDetail["SplitPaymentID"] = response.data![i].SplitPaymentID!
                                    self.pDetail["SplitPaymentContactID"] = response.data![i].SplitPaymentContactID!
                                    self.pDetail["CharterRequestID"] = response.data![i].CharterRequestID!
                                    self.pDetail["Amount"] = (splitAmt * Float(pax))
                                    self.pDetail["IsCharterer"] = response.data![i].IsCharterer!
                                    
                                    //adding self main contacts if not available
                                    if !self.saveSplitPaymentDetail.contains(self.pDetail){
                                        self.saveSplitPaymentDetail.add(self.pDetail)
                                    }
                                    //End add
                                    
                                }
                            }else{
                                
                                self.pDetail = NSMutableDictionary()
                                //self.pDetail["NoOfPassengers"] = response.data![i].NoOfPassengers!
                                var pax = 1
                                if response.data![i].IsCharterer == 1{
                                    pax = self.totalMainPax
                                }else{
                                    pax = self.getExistingSplitContactNoOfPassengers(splitPaymentContactID: response.data![i].SplitPaymentContactID!)
                                }
                                
                                let splitAmt = self.lowestPrice/Float(self.totalPax!)
                                print("No Of Pax :\(pax)")
                                print("Lowest Price :\(self.lowestPrice!)")
                                print("Total Pax :\(self.totalPax!)")
                                print("Split Amt :\(splitAmt)")
                                
                                self.pDetail["NoOfPassengers"] = pax
                                self.pDetail["CostPerPerson"] = splitAmt
                                self.pDetail["SplitPaymentID"] = response.data![i].SplitPaymentID!
                                self.pDetail["SplitPaymentContactID"] = response.data![i].SplitPaymentContactID!
                                self.pDetail["CharterRequestID"] = response.data![i].CharterRequestID!
                                self.pDetail["Amount"] = (splitAmt * Float(pax))
                                self.pDetail["IsCharterer"] = response.data![i].IsCharterer!
                                
                                if !self.saveSplitPaymentDetail.contains(self.pDetail){
                                    self.saveSplitPaymentDetail.add(self.pDetail)
                                }
                            }
                        }
                        
                        //print("Total Split Pax :\(self.totalSPax!)")
                        print(self.saveSplitPaymentDetail)
                        self.totalMainPax = (self.totalPax - self.totalSPax)
                        //print("Total Main Remaining Pax :\(self.totalMainPax!)")
                        
                        if self.isSplit == 0{
                            self.errorPaxView.isHidden = true
                            self.errorPaxMsgLabel.text = ""
                        }
                        
                        if response.data!.count == 1{
                            self.selectedSplitContacts.removeAll()
                        }
                        
                        self.splitAmount = self.lowestPrice/Float(self.totalPax! + self.totalSPax)
                       
                        self.totalAmount = (self.lowestPrice! - (self.splitAmount * Float(self.splitContactIDCSV.count)))
                            
                        self.relaodTableView()
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
    
    @IBAction func termsBtnClicked(_ sender : UIButton){
        
        sender.isSelected = !sender.isSelected
        self.termsBtn.tintColor = UIColor.clear
        self.termsBtn.backgroundColor = UIColor.clear
        if sender.isSelected == true{
            self.termsBtn.setImage(UIImage(named: "selected"), for: .selected)
            self.submitBtn.isEnabled = true
            CommonFunction.setRoundedButtons(arrayB: [submitBtn], radius: self.submitBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: blackColorCode, textColor: whiteColorCode)
        }else{
            self.termsBtn.setImage(UIImage(named: "selected_not"), for: .normal)
            CommonFunction.setRoundedButtons(arrayB: [submitBtn], radius: self.submitBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: lightGrayColorCode, textColor: blackColorCode)
            self.submitBtn.isEnabled = false
        }
    }
    
    @IBAction func backBtnClicked(_ sender:UIButton){
        
        self.delegate?.backBtnPressed?()
        if self.isFromPreview == true{
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: RequestConfirmDetailVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func bookBtnClicked(_ sender:UIButton){
        
        if self.charterReqId != nil && self.charterReqId != 0{
            self.APIUpdateCharterRequestAdditionalFieldsCall()
            //self.APIUpdateCharterRequestPaymentConfirmStatusCall()
        }
    }
    
    @IBAction func termsConditionBtnClicked(_ sender: Any) {
        let previewVC = PreviewOfferVC.storyboardViewController()
               previewVC.prevUrlStr = APPUrls.termsandconditionsurlCR
               previewVC.titleStr = "Terms & Conditions"
               previewVC.isFromTermsAndCond = true
               self.navigationController?.pushViewController(previewVC, animated: true)
    }
}

extension RequestAcceptDetailVC : NavigationBarViewDelegate {
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.delegate?.backBtnPressed?()
        if self.isFromPreview == true{
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: RequestConfirmDetailVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension RequestAcceptDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            if self.postResponseData != nil{
                return self.postResponseData.crleg!.count
            }else{
                return self.crLegDetailsData!.count
            }
        }else if section == 1{
            if self.pendingResponseData != nil{
                if self.pendingResponseData.RequestTypeID == 2{
                    return 1
                }
            }else if self.postResponseData != nil{
                if self.postResponseData.requestTypeID == 2{
                    return 1
                }
            }else{
                return 0
            }
            return 0
        }else if section == 2{
            return 2
        }else{
            if self.isSplit == 1{
                return self.selectedSplitContacts.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.splitAmount = self.lowestPrice / Float((self.totalMainPax + self.totalSPax))
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestAcceptListCell, for: indexPath) as! RequestAcceptListCell
            if self.postResponseData != nil{
                let data = self.postResponseData.crleg![indexPath.row]
                //for same date and time only single aircraft so single data
                if self.postResponseData.requestTypeID == 2{
                    if self.selectedAircrafts.count == 1{
                        
                        let dataSel = self.selectedAircrafts[0]
                        self.totalTripAmount = dataSel.FinalAmount!
                        cell.configuerConfirmRequestAcceptDetailCell(indexPath: indexPath, data: data,fromVC:"RequestAcceptDetailVC", data2: dataSel,requestTypeId: self.postResponseData.requestTypeToUseID!)
                    }else{
                        let dataSel = self.selectedAircrafts[indexPath.row]
                        cell.configuerConfirmRequestAcceptDetailCell(indexPath: indexPath, data: data,fromVC:"RequestAcceptDetailVC", data2: dataSel,requestTypeId: self.postResponseData.requestTypeToUseID!)
                    }
                }else{
                    
                    let dataSel = self.selectedAircrafts[indexPath.row]
                    cell.configuerConfirmRequestAcceptDetailCell(indexPath: indexPath, data: data,fromVC:"RequestAcceptDetailVC", data2: dataSel,requestTypeId: self.postResponseData.requestTypeToUseID!)
                }
                
            }else{
                
                if self.pendingResponseData.RequestTypeID == 2{
                    if self.selectedAircrafts.count == 1{
                        
                        let data = self.crLegDetailsData![indexPath.row]
                        let dataSel = self.selectedAircrafts[0]
                        self.totalTripAmount = dataSel.FinalAmount!
                        cell.configuerConfirmPendingRequestAcceptDetailCell(indexPath: indexPath, data: data,data2: dataSel,requestTypeID:  self.pendingResponseData.RequestTypeToUseID!)
                    }else{
                        let data = self.crLegDetailsData![indexPath.row]
                        let dataSel = self.selectedAircrafts[indexPath.row]
                        cell.configuerConfirmPendingRequestAcceptDetailCell(indexPath: indexPath, data: data,data2: dataSel,requestTypeID:  self.pendingResponseData.RequestTypeToUseID!)
                    }
                }else{
                    let data = self.crLegDetailsData![indexPath.row]
                    let dataSel = self.selectedAircrafts[indexPath.row]
                    cell.configuerConfirmPendingRequestAcceptDetailCell(indexPath: indexPath, data: data,data2: dataSel,requestTypeID:  self.pendingResponseData.RequestTypeToUseID!)
                }
            }
            return cell
        }else if indexPath.section == 1{
            let cell = UITableViewCell()
            let amount = CommonFunction.getCurrencyValue2(amt: Float(self.totalTripAmount), code: CURRENCY_CODE)
            let totalAmtStr = String(format: "Total : %@",amount)
            cell.textLabel?.textAlignment = .right
            cell.textLabel?.attributedText =  CommonFunction.makeSubstringBoldWithCustomFontAndColor(fullText: totalAmtStr, boldText: "Total", fullTextFont: UIFont.RegularWithSize(size: 18), fullTextColor: UIColor.hexStringToUIColor(hex: blackColorCode), boldFont: UIFont.BoldWithSize(size: 17), boldTextColor: UIColor.black)
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        }else if indexPath.section == 2{
            
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.TransportInflightServiceCell, for: indexPath) as! TransportInflightServiceCell
                
                cell.delegate = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.PaymentSplitCell, for: indexPath) as! PaymentSplitCell
                
                cell.delegate = self
                cell.configureCell(indexPath: indexPath, tpax: self.totalMainPax,splitPax: self.totalSPax, amount: self.splitAmount,isSPlit: self.isSplit)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.ManageContactListCell, for: indexPath) as! ManageContactListCell
            
            cell.delegate = self
            let rowData = self.selectedSplitContacts[indexPath.row]
            if self.postResponseData != nil{
                cell.configuerManageContacts(indexPath: indexPath, data: rowData, amount: self.splitAmount,totalPass: self.totalMainPax)
            }else{
                cell.configuerManageContacts(indexPath: indexPath, data: rowData, amount: self.splitAmount,totalPass: self.totalMainPax)
            }
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

/*extension RequestAcceptDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            if self.postResponseData != nil{
                return self.postResponseData.crleg!.count
            }else{
                return self.crLegDetailsData!.count
            }
        }else if section == 1 || section == 3 || section == 4{
            return 1
        }else if section == 2{
            return self.selectedAircrafts.count
        }else{
            if self.isSplit == 1{
                return self.selectedSplitContacts.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.splitAmount = self.lowestPrice / Float((self.totalMainPax + self.totalSPax))
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestListCell, for: indexPath) as! RequestListCell
            cell.hideDetailView()
           
            if self.postResponseData != nil{
                let data = self.postResponseData.crleg![indexPath.row]
                cell.configuerConfirmRequest(indexPath: indexPath, data: data,fromVC:"RequestAcceptDetailVC")
            }else{
                let data = self.crLegDetailsData![indexPath.row]
                cell.configuerConfirmPendingRequest(indexPath: indexPath, data: data)
            }
            return cell
            
        }else if indexPath.section == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestAcceptCell, for: indexPath) as! RequestAcceptCell
            
            if self.postResponseData != nil{
                cell.configuerAcceptedRequestDetail(indexPath: indexPath, data: self.postResponseData)
            }else{
                cell.configuerAcceptedPendingRequestDetail(indexPath: indexPath, data: self.pendingResponseData)
            }
            
            cell.setAircraftAndPrice(name: self.aircraftName, price: self.lowestPrice)
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.SelectedAircraftCell, for: indexPath) as! SelectedAircraftCell
            
            let rowData = self.selectedAircrafts[indexPath.row]
            cell.configuerOptionCell(indexPath: indexPath, data: rowData)
            return cell
            
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.TransportInflightServiceCell, for: indexPath) as! TransportInflightServiceCell
            
            cell.delegate = self
            return cell
            
        }else if indexPath.section == 4{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.PaymentSplitCell, for: indexPath) as! PaymentSplitCell
            
            cell.delegate = self
            
            cell.configureCell(indexPath: indexPath, tpax: self.totalMainPax,splitPax: self.totalSplitPax, amount: self.splitAmount,isSPlit: self.isSplit)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.ManageContactListCell, for: indexPath) as! ManageContactListCell
            
            cell.delegate = self
            let rowData = self.selectedSplitContacts[indexPath.row]
            if self.postResponseData != nil{
                cell.configuerManageContacts(indexPath: indexPath, data: rowData, amount: self.splitAmount,totalPass: self.totalMainPax)
            }else{
                cell.configuerManageContacts(indexPath: indexPath, data: rowData, amount: self.splitAmount,totalPass: self.totalMainPax)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}*/


extension RequestAcceptDetailVC : TransportInflightServiceCellDelegate{
    
    func transportBtnPressed(option: String,value:Int) {
        //print(option)
        self.transport = Transport(selectedOption: option,flagVal:value)
        //self.APIUpdateCharterRequestAdditionalFieldsCall()
    }
    
    func inflightServiceBtnPressed(option: String,value:Int) {
        //print(option)
        self.inflight = Inflight(selectedOption: option,flagVal: value)
        //self.APIUpdateCharterRequestAdditionalFieldsCall()
    }
    
    func APIUpdateCharterRequestAdditionalFieldsCall(){
        
        self.view.makeToastActivity(.center)
        let parameters = ["chartererrequestid": self.charterReqId!,"istransportationneeded":transport.flagVal!,"isinflightserviceneeded":inflight.flagVal!, "Issplitpayment" : isSplit as Any,
                        "cateringnotes":"testcateringnotes",
                        "inflightservicenotes":"testinflightservice"] as [String: Any]
        
        /*
         https://stage.apiv2.flyhouse.us/api/ChartererRequest/UpdateCharterRequestAdditionalFields?chartererrequestid=5081&istransportationneeded=1&isinflightserviceneeded=1&Issplitpayment=0&cateringnotes=testcateringnotes&inflightservicenotes=testinflightservice
         */
        
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/UpdateCharterRequestAdditionalFields?chartererrequestid=%d&istransportationneeded=%d&isinflightserviceneeded=%d&cateringnotes=testcateringnotes&inflightservicenotes=testinflightservice", APIUrl.baseUrl,self.charterReqId!,transport.flagVal!,inflight.flagVal!)
        
        APIChartererRequest.shared.updateCharterRequestAdditionalFields(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
            if response.result == "success"{
                
                //added on 28-09-2023
                self.saveChartererSplitPaymentContactDetails()
                //self.APIUpdateCharterRequestPaymentConfirmStatusCall()
                
//                if response.data != nil{
//                    if response.data == true{
//                        CommonFunction.showToastMessage(msg: response.description!, controller: self)
//                    }
//                }
            }
            
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    func saveChartererSplitPaymentContactDetails(){
        
        //finalcode
        let urlStr = String(format: "%@/SplitPayment/SaveChartererSplitPaymentContactDetails", APIUrl.baseUrl)
        
        let parameters = ["chartersplitpaymentslist":self.saveSplitPaymentDetail] as [String: Any]

        APISplitPayment.shared.saveChartererSplitPaymentContactDetails(urlStr: urlStr, param: parameters) { response in
            
            if response.result == "success"{
                self.APIUpdateCharterRequestPaymentConfirmStatusCall()
            }
            
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
}

extension RequestAcceptDetailVC : PaymentSplitCellDelegate{
    
    func manageBtnPressed() {
        let manageContactVC = ManageContactsVC.storyboardViewController()
        manageContactVC.delegate = self
        manageContactVC.savedSplitPaymentDetail = self.saveSplitPaymentDetail
        manageContactVC.requestedPaxCount = self.totalPax
        if self.postResponseData != nil{
            manageContactVC.charterRequestID = self.postResponseData.chartererRequestID!
        }else{
            manageContactVC.charterRequestID = self.pendingResponseData.ChartererRequestID!
        }
        manageContactVC.splitCharReIDCSV = self.splitContactIDCSV
        manageContactVC.totalSplitPax = self.totalSPax
    
        self.navigationController?.pushViewController(manageContactVC, animated: true)
    }
    
    func splitBtnPressed(isSplit: Bool) {
        if isSplit{
            self.isSplit = 1
        }else{
            self.isSplit = 0
        }
        if self.postResponseData != nil{
            self.totalPax = self.postResponseData.paxCount!
            self.totalAmount = self.lowestPrice
        }else{
            self.totalPax = self.pendingResponseData.PaxCount!
            self.totalAmount = self.lowestPrice
        }
        self.splitAmount = self.lowestPrice/Float(self.totalPax!)
        self.splitContactIDCSV.removeAllObjects()
        self.selectedSplitContacts.removeAll()
        self.requestAcceptDetailTable.reloadData()
        
        self.getSplitPaymentDetails()
    }
    
    func didNoOfPassengerChange(pax: Int) {
        
        var totalSPax = 0
        
        if self.selectedSplitContacts.count > 0{
            for i in 0...self.selectedSplitContacts.count - 1{
                let contact = self.selectedSplitContacts[i]
                totalSPax += contact.noOfPassenger!
            }
        }
        // 9 = 10 - 1
        
        self.totalMainPax = pax
        self.totalRemainPax = self.totalPax! - (self.totalMainPax + totalSPax)
        
        if self.postResponseData != nil{
            self.totalPax = self.postResponseData.paxCount!
            
        }else{
            self.totalPax = self.pendingResponseData.PaxCount!
        }
        
        if totalSPax > self.totalPax {
            self.errorPaxMsgLabel.text = "Please review passenger count, the total number of passengers cannot exceed \(self.totalPax!)"
            self.errorPaxView.isHidden = false
            if self.termsBtn.isSelected{
                self.termsBtnClicked(self.termsBtn)
            }
        }else{
            self.errorPaxView.isHidden = true
        }
        
        self.requestAcceptDetailTable.reloadData()
        //print(self.saveSplitPaymentDetail)
        
        if self.saveSplitPaymentDetail.count > 0{
            for i in 0...self.saveSplitPaymentDetail.count - 1{
                let splitContact = self.saveSplitPaymentDetail[i] as! NSMutableDictionary
                if splitContact["IsCharterer"] as! Int == 1{
                    splitContact["NoOfPassengers"] = pax
                    let costPerPax = Int(Double(round(Double(self.lowestPrice)/Double(self.totalPax!))))
                    splitContact["CostPerPerson"] = costPerPax
                    splitContact["Amount"] = costPerPax * pax
                    self.saveSplitPaymentDetail.replaceObject(at: i, with: splitContact)
                }
            }
        }
        //print(self.saveSplitPaymentDetail)
    }
}

extension RequestAcceptDetailVC : ManageContactsVCDelegate{
    
    func didSelectContacts(contacts:[SplitContacts],splitContactIDCSV:NSMutableArray){
        
        var totNoOfpax = 0
        if contacts.isEmpty {
            // Handle the case where the array is empty
            print("No contacts available.")
            totNoOfpax = 0
        } else {
            self.splitContatsData = contacts
            for i in 0..<contacts.count {
                // Make sure the array index is within bounds
                if i < contacts.count {
                    let contact = contacts[i]
                    print(contact)
                    if let noOfPassenger = contact.noOfPassenger {
                        totNoOfpax += noOfPassenger
                    }
                }
            }
        }
 
        if self.postResponseData != nil{
            self.totalPax = self.postResponseData.paxCount!
        }else{
            self.totalPax = self.pendingResponseData.PaxCount!
        }
        self.totalSPax = totNoOfpax
        self.totalMainPax  = self.totalPax - self.totalSPax
        
        if self.totalSPax >= self.totalPax {
            self.errorPaxMsgLabel.text = "Please review passenger count, the total number of passengers cannot exceed \(self.totalPax!)"
            self.errorPaxView.isHidden = false
            return
        }else{
            self.errorPaxView.isHidden = true
        }
        
        self.splitContactIDCSV.removeAllObjects()
        self.selectedSplitContacts.removeAll()
        
        if self.saveSplitPaymentDetail.count > 0{
            self.saveSplitPaymentDetail.removeAllObjects()
        }
        
        if contacts.count == 0{
            self.selectedSplitContacts.removeAll()
            self.requestAcceptDetailTable.reloadData()
        }
        
        self.getSplitPaymentDetails()
        
    }
}

extension RequestAcceptDetailVC : ManageContactListCellDelegate{
    
    
    func removeBtnPressed(atIndex: Int) {
        
        
        self.splitContatsData = self.selectedSplitContacts
        self.totalSPax = 0
        if self.selectedSplitContacts.count > 1{
            self.selectedSplitContacts.remove(at: atIndex)
            
            for i in 0...selectedSplitContacts.count - 1{
                let data = selectedSplitContacts[i]
                self.totalSPax += data.noOfPassenger!
            }
        }else{
            self.selectedSplitContacts.removeAll()
        }
        
        self.totalMainPax = self.totalPax - self.totalSPax
        self.saveChartererSplitPaymentContactIDCSV(contactIDCSV: self.selectedSplitContacts)
        
        
        if self.totalSPax >= self.totalPax {
            self.errorPaxMsgLabel.text = "Please review passenger count, the total number of passengers cannot exceed \(self.totalPax!)"
            self.errorPaxView.isHidden = false
            return
        }else{
            self.errorPaxView.isHidden = true
        }
        //self.perform(#selector(getManageContacts), with: nil, afterDelay: 1.0)
    }
    
    @objc func getManageContacts(){
        self.getSplitPaymentDetails()
    }
    
    func saveChartererSplitPaymentContactIDCSV(contactIDCSV:[SplitContacts]){
        
        self.view.makeToastActivity(.center)
        
        var ids = "0"
        if contactIDCSV.count > 0{
            for i in 0...contactIDCSV.count - 1{
                if i == 0{
                    ids = String(format: "%d",contactIDCSV[i].splitPaymentContactID!)
                }else{
                    ids.append(String(format: ",%d",contactIDCSV[i].splitPaymentContactID!))
                }
            }
        }
        //finalcode
        let urlStr = String(format: "%@/SplitPayment/SaveChartererSplitPaymentContactIDCSV?chartererRequestID=%d&splitPaymentContactIDCSV=%@", APIUrl.baseUrl,self.charterReqId,ids)
        
        let parameters = ["chartererRequestID":self.charterReqId!,"splitPaymentContactIDCSV":ids] as! [String:Any]
        
        APISplitPayment.shared.saveSplitPaymentContactIDCSV(urlStr: urlStr, param: parameters) { response in
            
            self.splitContactIDCSV.removeAllObjects()
            self.selectedSplitContacts.removeAll()
            self.saveSplitPaymentDetail.removeAllObjects()
            
            
            self.getSplitPaymentDetails()
    
            
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    func didChangeNoOfPassenger(pax: Int,atIndex:Int) {
        
        if self.postResponseData != nil{
            self.totalPax = self.postResponseData.paxCount!
        }else{
            self.totalPax = self.pendingResponseData.PaxCount!
        }
        
        var contacts = [SplitContacts]()
        contacts.append(contentsOf: self.selectedSplitContacts)
        self.splitContatsData = contacts
        self.selectedSplitContacts.removeAll()
        var totalSPax = 0
        for i in 0...contacts.count - 1{
            var contact = contacts[i]
            if i == atIndex{
                contact.noOfPassenger = pax
                totalSPax += pax
            }else{
                totalSPax += contact.noOfPassenger!
            }
            self.selectedSplitContacts.append(contact)
        }
        
        //Total splited passengers
        self.totalSPax = totalSPax
        self.totalMainPax  = self.totalPax - self.totalSPax
        
        //update pax on selected
        if self.saveSplitPaymentDetail.count > 0{
            for i in 0...self.saveSplitPaymentDetail.count - 1{
                let splitContact = self.saveSplitPaymentDetail[i] as! NSMutableDictionary
                if i == 0 && splitContact["IsCharterer"] as! Int == 1{
                    splitContact["NoOfPassengers"] = self.totalMainPax
                    let costPerPax = Double(self.lowestPrice/Float(self.totalPax!))
                    splitContact["CostPerPerson"] = costPerPax
                    splitContact["Amount"] = costPerPax * Double(pax)
                    self.saveSplitPaymentDetail.replaceObject(at: i, with: splitContact)
                }else{
                    
                    if (atIndex + 1) == i {
                        splitContact["NoOfPassengers"] = pax
                        let costPerPax = Double(self.lowestPrice/Float(self.totalPax!))
                        splitContact["CostPerPerson"] = costPerPax
                        splitContact["Amount"] = costPerPax * Double(pax)
                        self.saveSplitPaymentDetail.replaceObject(at: i, with: splitContact)
                    }
                }
            }
        }
        
        self.splitAmount = self.lowestPrice/Float(self.totalPax!)
        self.totalAmount = self.lowestPrice! - (self.splitAmount * Float(totalSPax))
        
        if self.selectedSplitContacts.count > 0{
            self.requestAcceptDetailTable.reloadData()
        }
        
        if self.totalMainPax <= 0  {
            self.errorPaxMsgLabel.text = "Please review passenger count, the total number of passengers cannot exceed \(self.totalPax!)"
            self.errorPaxView.isHidden = false
            if self.termsBtn.isSelected{
                self.termsBtnClicked(self.termsBtn)
            }
            return
        }else if pax == 0{
            self.errorPaxMsgLabel.text = "The number of passengers cannot be 0.  Please enter at least 1 passenger."
            self.errorPaxView.isHidden = false
            if self.termsBtn.isSelected{
                self.termsBtnClicked(self.termsBtn)
            }
            return
        }else{
            self.errorPaxView.isHidden = true
        }
    }

}
