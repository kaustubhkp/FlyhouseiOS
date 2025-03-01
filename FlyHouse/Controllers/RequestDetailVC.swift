//
//  RequestDetailVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

 protocol RequestDetailVCDelegate {
    
    func backBtnPressed()
    
    func editBtnPressed(typeIndex:Int,getData:CharterReqData)
     
    func calltoConfirmedRequestVC()
}

class RequestDetailVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .RequestList

    var delegate:RequestDetailVCDelegate?
    @IBOutlet weak var requestDetailTable:UITableView!
    var postResponseData:CharterreResponse!
    var typeIndex:Int! = 0
    var ownerMaxPaxCount:Int! = 0
    var cReqestGetData:CharterReqData!

    
    @IBOutlet weak var editBtn:UIButton!
    @IBOutlet weak var confirmBtn:UIButton!
    @IBOutlet weak var cancelReqBtn:UIButton!
    
    @IBOutlet weak var enhanceView:UIView!
    @IBOutlet weak var enhanceTitleLbl:UILabel!
    @IBOutlet weak var enhanceSubTitleLbl:UILabel!
    @IBOutlet weak var enhanceEmailBtn:UIButton!
    @IBOutlet weak var enhanceCallBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setBackButton(viewC: self)
        super.delegateNav = self
        
        if self.typeIndex == 0{
            super.setNavigationTitle(title: "Confirm Flight")
        }else if self.typeIndex == 1{
            super.setNavigationTitle(title: "Confirm Round Trip Flight")
        }else{
            super.setNavigationTitle(title: "Confirm Multi City Flight")
        }
        
        // Do any additional setup after loading the view.
        
        if self.postResponseData != nil{
            if self.postResponseData.chartererRequestID != nil{
                self.APIGetChartererRequestCall(id: self.postResponseData.chartererRequestID!)
            }
        }
        
        requestDetailTable.register(UINib(nibName: TableCells.PastRequestTblCell, bundle: nil), forCellReuseIdentifier: TableCells.PastRequestTblCell)
        
        requestDetailTable.register(UINib(nibName: TableCells.RequestConfirmCell, bundle: nil), forCellReuseIdentifier: TableCells.RequestConfirmCell)
        
        //requestDetailTable.register(UINib(nibName: TableCells.EnhanceTblCell, bundle: nil), forCellReuseIdentifier: TableCells.EnhanceTblCell)
        
        
        CommonFunction.setRoundedButtons(arrayB: [confirmBtn], radius: confirmBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: blackColorCode, textColor: whiteColorCode)
        
        CommonFunction.setRoundedButtons(arrayB: [editBtn], radius: editBtn.frame.size.height/2, borderColorCode: blackColorCode, borderW: 1, bgColor: "", textColor: blackColorCode)
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [confirmBtn], size: 13, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: whiteColorCode))
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [editBtn], size: 13, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        
        CommonFunction.setRoundedViews(arrayB: [enhanceView], radius: 5, borderColorCode: INPUTF_BORDER_COLOR, borderW: 1, bgColor: INPUT_VIEW_BG_COLOR)
        
        CommonFunction.setRoundedButtons(arrayB: [enhanceEmailBtn], radius: enhanceEmailBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: INPUTF_BORDER_COLOR, textColor: blackColorCode)
        
        CommonFunction.setRoundedButtons(arrayB: [enhanceCallBtn], radius: enhanceCallBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: INPUTF_BORDER_COLOR, textColor: blackColorCode)
        
        CommonFunction.setLabelsFonts(lbls: [enhanceTitleLbl], type: .fSemiBold, size: 12)
        
        CommonFunction.setLabelsFonts(lbls: [enhanceSubTitleLbl], type: .fReguler, size: 9)
        
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    
    func APIGetChartererRequestCall(id:Int){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetDecimalNew/%d", APIUrl.baseUrl,id)
                
        self.view.makeToastActivity(.center)
        APIChartererRequest.shared.getChartererRequest(urlStr: getAPIUrl) { response in
            
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.data != nil{
                  
                    self.cReqestGetData = response.data!
                    self.ownerMaxPaxCount = response.data!.OwnerMaxPaxCount
                    var cRleg = [CRLegData]()
                    if response.data!.CRSegments != nil{
                        if response.data!.CRSegments!.count > 0 {
                            for cld in response.data!.CRSegments!{
                                let crlegdata = CRLegData(
                                    distance: cld.Distance,
                                    endAirport:cld.EndDisplayLine1,
                                    endAirportInfo: cld.EndDisplayLine2,
                                    endDateTime: cld.EndDateTime,
                                    estimatedTimeInMinute:cld.EstimatedTimeInMinute,
                                    sequenceID:cld.SequenceID,
                                    startAirport: cld.StartDisplayLine1,
                                    startAirportInfo: cld.StartDisplayLine2,
                                    startDateTime: cld.StartDateTime,
                                    startTime: cld.StartTime)
                                
                                cRleg.append(crlegdata)
                            }
                        }
                    }
                    
                    let postData = CharterreResponse(chartererRequestID: response.data?.ChartererRequestID!,distance: response.data?.Distance,endAirportID: response.data?.EndAirportID,endDateTime: response.data?.EndDateTime,note: response.data!.Note,paxCount: response.data?.PaxCount,paxSegment: response.data!.PaxSegment,preferredAircraftIDCSV: response.data?.PreferredAircraftIDCSV,priceExpectation: response.data!.PriceExpectation,startAirportID: response.data!.StartAirportID,startDateTime: response.data!.StartDateTime, startTime:response.data!.StartTime,status: response.data!.Status,requestTypeID: response.data!.RequestTypeID,estimatedTimeInMinute: response.data?.EstimatedTimeInMinute,crleg: cRleg)
                    
                    self.postResponseData = postData
                    
                    self.requestDetailTable.delegate = self
                    self.requestDetailTable.dataSource = self
                    self.requestDetailTable.reloadData()
                }else{
                    if response.title != nil && response.description != nil{
                        CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                            //self.navigationController?.popToRootViewController(animated: false)
                            APP_DELEGATE.createMenuView()
                            return
                        }
                    }
                }
            } else{
                if response.title != nil && response.description != nil{
                    CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                        //self.navigationController?.popToRootViewController(animated: false)
                        APP_DELEGATE.createMenuView()
                        return
                    }
                }
            }
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    func sendEmailUsingMailto() {
        let email = "booking@goflyhouse.com"
        let subject = ""
        let body = ""
        
        // Encode subject and body to handle spaces and special characters
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let emailURL = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL)
            } else {
                print("Cannot open Mail app")
            }
        }
    }
    
    func callPhoneNumber() {
        if let phoneURL = URL(string: "tel://888-413-8480") { // Replace with actual phone number
                if UIApplication.shared.canOpenURL(phoneURL) {
                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                    print("Cannot open phone URL")
            }
        }
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        sendEmailUsingMailto()
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        self.callPhoneNumber()
    }
    
    @IBAction func editBtnclicked(_ sender: UIButton) {
        self.delegate?.editBtnPressed(typeIndex: self.typeIndex,getData:self.cReqestGetData)
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmBtnclicked(_ sender : UIButton) {
            
        if self.postResponseData.chartererRequestID != nil{
            self.APIUpdateCharterRequestStatusCall()
            //self.APICheckCharterRequestStatusCall()
        }
    }
}

extension RequestDetailVC : NavigationBarViewDelegate {
    
    func onBackButtonClick(sender: NavigationBarView) {
        CommonFunction.showAlertMessageWithTitle(aStrTitle: "", aStrMessage: "You have a flight in progress. Do you want to cancel this request and start over?", Oktitle: "Yes", CancelTitle: "No", aViewController: self) { cancelAction in
            
        } OKActionTap: { OkAction in
            self.APICancelCharterRequestCall()
        }
    }
}

extension RequestDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return self.postResponseData.crleg!.count
        }else if section == 1{
            return 0
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
        
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.PastRequestTblCell, for: indexPath) as! PastRequestTblCell
            
            cell.showMiddlePlane()
            //cell.showDateTimeLable()
            let data = self.postResponseData.crleg![indexPath.row]
            cell.configuerConfirmRequest(indexPath: indexPath, data: data,fromVC:"RequestDetailVC")
            return cell
            
        }else if indexPath.section == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestConfirmCell, for: indexPath) as! RequestConfirmCell
            
            cell.delegate = self
            cell.configuerConfirmRequestDetail(indexPath: indexPath, data: self.postResponseData,typeIndex: self.typeIndex)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.EnhanceTblCell, for: indexPath) as! EnhanceTblCell
            
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

extension RequestDetailVC : RequestConfirmCellDelegate{
    
//    func editBtnPressed() {
//        self.delegate?.editBtnPressed(typeIndex: self.typeIndex,getData:self.cReqestGetData)
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    func confirmBtnPressed() {
//            
//        if self.postResponseData.chartererRequestID != nil{
//            self.APIUpdateCharterRequestStatusCall()
//            //self.APICheckCharterRequestStatusCall()
//        }
//    }
//    
//    func cancelRequestBtnPressed() {
//    
//        CommonFunction.showAlertMessageWithTitle(aStrTitle: "", aStrMessage: "Do you want to cancel current request?", Oktitle: "Yes", CancelTitle: "No", aViewController: self) { cancelAction in
//            
//        } OKActionTap: { okAction in
//            self.APICancelCharterRequestCall()
//        }
//    }
    
    func APICancelCharterRequestCall(){
        
        self.view.makeToastActivity(.center)
       
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/UpdateCharterRequestStatus?chartererrequestid=%d&statusid=7", APIUrl.baseUrl,self.postResponseData.chartererRequestID!)
        
        let parameters = ["chartererrequestid":self.postResponseData.chartererRequestID!,"statusid":7] as [String: Any]
    
        APIChartererRequest.shared.updateChartererRequest(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
            if response.result == "success"{
                
                
                self.delegate?.backBtnPressed()
                self.dismiss(animated: true)
                //let homeVC = RequestVC.storyboardViewController()
                //let menuSelectedVC = UINavigationController(rootViewController: homeVC)
                //self.slideMenuController()?.changeMainViewController(menuSelectedVC, close: true)
                
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
    
    func APIUpdateCharterRequestStatusCall(){
        
        self.view.makeToastActivity(.center)
       
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/UpdateCharterRequestStatus?chartererrequestid=%d&statusid=0", APIUrl.baseUrl,self.postResponseData.chartererRequestID!)
        
        let parameters = ["chartererrequestid":self.postResponseData.chartererRequestID!,"statusid":"0"] as [String: Any]
    
        APIChartererRequest.shared.updateChartererRequest(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
            if response.result == "success" || response.data == true{
                
                UserDefaults.standard.set(self.postResponseData.chartererRequestID!, forKey: UserDefaultsKeys.ChartererRequestID)
                UserDefaults.standard.set(self.typeIndex, forKey: UserDefaultsKeys.CharterRequestTypeIndex)
                
                UserDefaults.standard.synchronize()
                
                //let confirmVC = RequestConfirmDetailVC.storyboardViewController()
                //confirmVC.postResponseData = self.postResponseData
                //confirmVC.ownerMaxPaxCount = self.ownerMaxPaxCount
                //confirmVC.typeIndex = self.typeIndex
                //self.navigationController?.pushViewController(confirmVC, animated: true)
                
                self.dismiss(animated: false) {
                    self.delegate?.calltoConfirmedRequestVC()
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


