//
//  RequestVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

let SOURCE_TITLE = "LAX"
let DESTINATION_TITLE = "JFK"
let ADDRESS_TITLE = "Airport or City"

let SOURCE_ADDRESS_TITLE = "From"
let DESTI_ADDRESS_TITLE = "To"

struct MultiCitys{
    var fromAdd:String?
    var fromSubAdd:String?
    var fromId:String?
    var fromIcao:String?
    var fromIata:String?
    var fromIfaa:String?
    var toAdd:String?
    var toSubAdd:String?
    var toId:String?
    var toIcao:String?
    var toIata:String?
    var toIfaa:String?
    var date:String?
    var returnDate:String?
    var returnTime:String?
    var departureDisplayDate:String?
    var startTime:String?
    var timeStamps:Double?
}

struct RequestingLog{
    var date:String?
    var time:String?
    var endDate:String?
    var endTime:String?
    var passengers:String?
    var bidPrice:String?
    var typeIndex:Int?
}

class RequestVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .Home
    
    @IBOutlet weak var termsBtn:UIButton!
    @IBOutlet weak var submitBtn:UIButton!
    @IBOutlet weak var requestTableView:UITableView!
    @IBOutlet weak var acceptTermsLabel:UILabel!
    var tripTypeIndex:Int! = 0
    var tripTypeArr:Int! = 1
    var charteredReqId:Int! = 0
    var rStatus:String! = "8"
    
    var departuerSelDate:Date!
    var departuerSelDateString:String! = ""
    var departuerDateStr:String! = ""
    var departuerStartTime:String! = ""
    
    var returnSelDate:Date!
    var returnSelDateString:String! = ""
    var returnDateStr:String! = ""
    var returnDisplayDateStr:String! = ""
    var returnStartTime:String! = ""
    
    var price:String! = "5000"
    var roomkey:String! = ""
    var IsRoomKeyRequest:Bool! = false
    var noOfPass:String! = ""
    var preferAircrafts:[String] = []
    var preferAircraftId:[String] = []
    
    var multiCityArr = NSMutableArray()
    var cityData = MultiCitys()
    var userData:RegisteredUserData!
    var paymentSlpit:Int! = 0
    var cReqData = CharterReqData()
    var isNewRequest:Bool! = false
    
    var departureDateTimeStemps:Double! = 0.0
    var returnDateTimeStemps:Double! = 0.0
    var isSwiped:Bool! = false
    var isNewAdded:Bool! = false
    
    var postReqData:CharterreResponse!
    @IBOutlet weak var shadowView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        APICallPN()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.showNavLogoImage()
        self.registerRequestTableCell()
        self.submitBtn.isEnabled = false
        CommonFunction.setLabelsFonts(lbls: [acceptTermsLabel], type: .fReguler, size: 10)
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [submitBtn], size: 11, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: blackColorCode))
        CommonFunction.setRoundedButtons(arrayB: [submitBtn], radius: self.submitBtn.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: lightGrayColorCode, textColor: blackColorCode)
        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.value(forKey:"UserLoginMobile") != nil && UserDefaults.standard.value(forKey: "UserLoginDisplayName") == nil{
            self.getUserDetails()
        }
        
        if self.isNewRequest == false{
            //if UserDefaults.standard.value(forKey: UserDefaultsKeys.ChartererRequestID) != nil{
                self.APIPostCOpenRequestCall()
            //}
        }
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
    
    func getUserDetails(){
        
        //self.view.makeToastActivity(.center)
        
        let mobile = UserDefaults.standard.value(forKey:"UserLoginMobile") as! String
        let urlStr = String(format: "%@/User/GetUserDetailsByMobile?mobilenumber=%@", APIUrl.baseUrl,mobile)
        
        APIUser.shared.getUser(urlStr: urlStr) { response in
            //self.view.hideToastActivity()
            if response.result?.lowercased() == "success"{
                if response.data != nil{
                    self.userData = response.data!
                    self.saveUserData()
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
    
    func saveUserData(){
        
        if self.userData.displayName != nil{
            UserDefaults.standard.set(self.userData.displayName!, forKey: "UserLoginDisplayName")
        }
        
        if self.userData.userID != nil{
            UserDefaults.standard.set(self.userData.userID!, forKey: "UserLoginUserId")
        }
        UserDefaults.standard.synchronize()
    }
    
    func registerRequestTableCell(){
        
        self.requestTableView.delegate = self
        self.requestTableView.dataSource = self
        self.requestTableView.register(UINib(nibName: TableCells.RequestCell1, bundle: nil), forCellReuseIdentifier: TableCells.RequestCell1)
        self.requestTableView.register(UINib(nibName: TableCells.RequestCell2, bundle: nil), forCellReuseIdentifier: TableCells.RequestCell2)
        self.requestTableView.register(UINib(nibName: TableCells.RequestCell3, bundle: nil), forCellReuseIdentifier: TableCells.RequestCell3)
        self.requestTableView.register(UINib(nibName: TableCells.MultiCityCell, bundle: nil), forCellReuseIdentifier: TableCells.MultiCityCell)
        
        self.requestTableView.register(UINib(nibName: TableCells.SplitPaymentCell, bundle: nil), forCellReuseIdentifier: TableCells.SplitPaymentCell)
        self.addNewSection1Data()
        self.requestTableView.reloadData()
    }
    
    func addNewSection1Data(){
        
        if self.tripTypeIndex == 2{
            
            if self.multiCityArr.count > 0{
                let data = self.multiCityArr[self.multiCityArr.count-1] as! MultiCitys
                self.cityData.fromAdd = data.toAdd!
                self.cityData.fromSubAdd = String(format: "%@", data.toSubAdd!)
                self.cityData.fromId = data.toId!
            }
        }else{
            self.cityData.fromAdd = ""
            self.cityData.fromSubAdd = "" //ADDRESS_TITLE
            self.cityData.fromId = ""
        }
        self.cityData.toAdd = ""
        self.cityData.toSubAdd = ""//ADDRESS_TITLE
        self.cityData.toId = ""
        self.cityData.returnDate = ""
        self.cityData.returnTime = ""
        self.cityData.timeStamps = 0.0
        self.cityData.date = self.returnDisplayDateStr
        self.cityData.startTime = self.returnStartTime
        self.cityData.departureDisplayDate = nil
        self.multiCityArr.add(self.cityData)
    }
    
    func APIPostRequestCharterCall(parameters:[String:Any]){
        self.view.makeToastActivity(.center)
       
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/PostNew", APIUrl.baseUrl)
        
        APIChartererRequest.shared.postChartererRequest(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
            
            if response.result == "success"{
                if response.data != nil{
                    let data = response.data!
                    
                    if UserDefaults.standard.object(forKey: "planAnimationLastPoint") != nil ||  UserDefaults.standard.object(forKey: "distance") != nil || UserDefaults.standard.object(forKey: "planAnimationSpeed") != nil{
                        UserDefaults.standard.removeObject(forKey: "planAnimationLastPoint")
                        UserDefaults.standard.removeObject(forKey: "distance")
                        UserDefaults.standard.removeObject(forKey:"planAnimationSpeed")
                        UserDefaults.standard.removeObject(forKey: "lastTimeSeconds")
                        UserDefaults.standard.synchronize()
                    }
                    
                    if data.modelState != nil {
                        if (data.modelState?.error!.count)! > 0{
                            let errorStr = data.modelState?.error![0]
                            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: errorStr!, aViewController: self) { OkAction in
                                return
                            }
                        }
                    }
                    
                    if data.status == 8 || data.status == 1 {
                        
                        if data.crleg != nil{
                            if data.crleg?.count != 0{
                                let detailVC = RequestDetailVC.storyboardViewController()
                                detailVC.delegate = self
                                //detailVC.logData = self.multiCityArr
                                self.postReqData = data
                                detailVC.postResponseData = data
                                detailVC.typeIndex = self.tripTypeIndex
                                //for next confirm call at next screen
                                if data.chartererRequestID != nil{
                                    self.charteredReqId = data.chartererRequestID!
                                    self.rStatus = "8"
                                }
                                
                                //detailVC.reqParameters = self.resetRequestAfterConfirm()
                                //End
                                //self.navigationController?.pushViewController(detailVC, animated: true)
                                detailVC.presentationController?.delegate = self
                                let navCont = UINavigationController(rootViewController: detailVC)
                                navCont.modalPresentationStyle = .pageSheet
                                navCont.isModalInPresentation = true
                                self.present(navCont, animated: true, completion: nil)
                                
                            }
                        }
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
    
    func APIEditRequestCharterCall(parameters:[String:Any]){
        self.view.makeToastActivity(.center)
       
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/Edit", APIUrl.baseUrl)
        
        APIChartererRequest.shared.editChartererRequest(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
            if response.result == "success"{
                
                if response.data != nil{
                    let detailVC = RequestDetailVC.storyboardViewController()
                    detailVC.delegate = self
                    //detailVC.logData = self.multiCityArr
                    detailVC.postResponseData = response.data!
                    detailVC.typeIndex = self.tripTypeIndex
                    //for next confirm call at next screen
                    if response.data!.chartererRequestID != nil{
                        self.charteredReqId = response.data!.chartererRequestID!
                        self.rStatus = "8"
                    }
                    //detailVC.reqParameters = self.resetRequestAfterConfirm()
                    //End
                    
//                    var lastCity = MultiCitys()
//                    let firstCity = self.multiCityArr.firstObject as! MultiCitys
//                    if self.multiCityArr.count > 0{
//                        lastCity = self.multiCityArr.lastObject as! MultiCitys
//                    }
                    //detailVC.requestedData = RequestingLog(date: firstCity.date!,time: firstCity.startTime!,endDate: lastCity.date!,endTime: lastCity.startTime!,passengers: self.noOfPass,bidPrice: self.price)
                    //self.navigationController?.pushViewController(detailVC, animated: true)
                    
                    detailVC.presentationController?.delegate = self
                    let navCont = UINavigationController(rootViewController: detailVC)
                    navCont.modalPresentationStyle = .pageSheet
                    navCont.isModalInPresentation = true
                    self.present(navCont, animated: true, completion: nil)
                    
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
    
    func APIPostCOpenRequestCall(){
        self.view.makeToastActivity(.center)
       
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/GetCurrentOpenRequest",APIUrl.baseUrl)
        
        //let urlStr = String(format: "%@/CharterreRequest", APIUrl.baseUrl)
        //let parameters = [String:Any]()
        
        APIChartererRequest.shared.getChartererOpenRequesDetails(urlStr: urlStr) { response in
                   
                   if response.result == "success"{
                       if response.data != nil{
                           
                           if response.data! > 0{
                               //self.APIPostCRequestPending()
                               self.APIGetChartererRequestCall(id: response.data!)
                           }else{
                               self.view.hideToastActivity()
                               UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.ChartererRequestID)
                               UserDefaults.standard.synchronize()
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
                               if ((response.description?.contains("log out")) != nil) {
                                   let domain = Bundle.main.bundleIdentifier!
                                   UserDefaults.standard.removePersistentDomain(forName: domain)
                                   UserDefaults.standard.synchronize()
                                   APP_DELEGATE.setMainController()
                               }
                           }
                       }
                   }
               
               } fail: { error in
                   self.view.hideToastActivity()
                   CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                       
                   }
               }
    }
    
    func APIGetChartererRequestCall(id:Int){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetDecimalNew/%d", APIUrl.baseUrl,id)
                
       // self.view.makeToastActivity(.center)
        APIChartererRequest.shared.getChartererRequest(urlStr: getAPIUrl) { response in
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.data != nil{
                    
                    if response.data!.CRSegments!.count > 0{
                        self.cReqData = response.data!
                        
                        if response.data!.Status != nil{
                            if response.data!.Status == 8{
                                
                                let detailVC = RequestDetailVC.storyboardViewController()
                                
                                if response.data!.RequestTypeID != nil{
                                    
                                    self.tripTypeIndex = response.data!.RequestTypeID! - 1
                                    if self.tripTypeIndex == 0{ //oneway
                                        self.tripTypeArr = 1
                                    }else if self.tripTypeIndex == 1 { //round trip
                                        self.tripTypeArr = 2
                                    }else{
                                        self.tripTypeArr = 2 //multicity not require now
                                    }
                                    detailVC.typeIndex = self.tripTypeIndex
                                }
                                
                                DispatchQueue.main.async {
                                    self.setEditData(data:response.data!,typeIndex: self.tripTypeIndex)
                                }
                                
                                var cRleg = [CRLegData]()
                                if response.data!.CRSegments != nil{
                                    if response.data!.CRSegments!.count > 0 {
                                        for cld in response.data!.CRSegments!{
                                            let crlegdata = CRLegData(
                                                distance: cld.Distance,
                                                endAirport:cld.EndAirport,
                                                endAirportInfo: cld.EndCityStateCountry,
                                                endDateTime: cld.EndDateTime,
                                                estimatedTimeInMinute:cld.EstimatedTimeInMinute,
                                                sequenceID:cld.SequenceID,
                                                startAirport: cld.StartAirport,
                                                startAirportInfo: cld.StartCityStateCountry,
                                                startDateTime: cld.StartDateTime,
                                                startTime: cld.StartTime)
                                            
                                            cRleg.append(crlegdata)
                                        }
                                    }
                                }
                                
                                let postData = CharterreResponse(chartererRequestID: response.data?.ChartererRequestID!,distance: response.data?.Distance,endAirportID: response.data?.EndAirportID,endDateTime: response.data?.EndDateTime,note: response.data!.Note,paxCount: response.data?.PaxCount,paxSegment: response.data!.PaxSegment,preferredAircraftIDCSV: response.data?.PreferredAircraftIDCSV,priceExpectation: response.data!.PriceExpectation,startAirportID: response.data!.StartAirportID,startDateTime: response.data!.StartDateTime,startTime:response.data!.StartTime,status: response.data!.Status,requestTypeID: response.data!.RequestTypeID,estimatedTimeInMinute: response.data?.EstimatedTimeInMinute,crleg: cRleg)
                                
                                detailVC.postResponseData = postData
                                detailVC.delegate = self
                                //for next confirm call at next screen
                                if response.data!.ChartererRequestID != nil{
                                    self.charteredReqId = response.data!.ChartererRequestID!
                                    self.rStatus = "8"
                                }
                                
                                //End
                                //self.navigationController?.pushViewController(detailVC, animated: true)
                                
                                let navCont = UINavigationController(rootViewController: detailVC)
                                navCont.presentationController?.delegate = self
                                navCont.modalPresentationStyle = .pageSheet
                                navCont.isModalInPresentation = true
                                
                                self.present(navCont, animated: true, completion: nil)
                                
                                
                            }else{
                                
                                if response.data!.ChartererAcceptanceTimeInSeconds != nil{
                                    
                                    if response.data!.ChartererAcceptanceTimeInSeconds != "" {
                                        if Int(response.data!.ChartererAcceptanceTimeInSeconds!)! > 0{
                                            
                                            let confirmVC = RequestConfirmDetailVC.storyboardViewController()
                                            confirmVC.pendingResponseData = self.cReqData
                                            confirmVC.ownerMaxPaxCount = response.data!.OwnerMaxPaxCount
                                            if response.data?.CRSegments != nil{
                                                
                                                if (response.data?.CRSegments!.count)! > 0 {
                                                    confirmVC.crLegDetailsData = (response.data?.CRSegments!)!
                                                }
                                            }
                                            
                                            if UserDefaults.standard.value(forKey: UserDefaultsKeys.CharterRequestTypeIndex) != nil{
                                                confirmVC.typeIndex = (UserDefaults.standard.value(forKey: UserDefaultsKeys.CharterRequestTypeIndex) as! Int)
                                            }else{
                                                confirmVC.typeIndex = self.tripTypeIndex
                                            }
                                            //self.navigationController?.pushViewController(confirmVC, animated: true)
                                            
                                            confirmVC.presentationController?.delegate = self
                                            let navCont = UINavigationController(rootViewController: confirmVC)
                                            navCont.modalPresentationStyle = .pageSheet
                                            navCont.isModalInPresentation = true
                                            self.present(navCont, animated: true, completion: nil)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        self.removeCharterRequestID()
                    }
                }else{
                    self.removeCharterRequestID()
                    if response.title != nil && response.description != nil{
                        CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                            //self.navigationController?.popToRootViewController(animated: false)
                            //APP_DELEGATE.createMenuView()
                            return
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
    
    func setEditData(data:CharterReqData,typeIndex:Int){
        
        if data.CRSegments != nil{
            let crSegment = data.CRSegments!
            
            
            if data.IsSplitPayment != nil{
                self.paymentSlpit = data.IsSplitPayment!
            }
            
            if typeIndex == 0 || typeIndex == 1{
                
                self.cityData = self.multiCityArr[0] as! MultiCitys
                
                let airportdata = crSegment[0]
                self.cityData.fromAdd = airportdata.StartDisplayLine1
                self.cityData.fromSubAdd = airportdata.StartDisplayLine2
                self.cityData.fromId = airportdata.StartAirport
                
                self.cityData.toAdd = airportdata.EndDisplayLine1
                self.cityData.toSubAdd = airportdata.EndDisplayLine2
                self.cityData.toId = airportdata.EndAirport
                
                let date = CommonFunction.getOriginalDateFromString(dateStr: airportdata.StartDateTime!, format: formate3)
                
                self.departuerSelDate = date
                let formatter = DateFormatter()
                formatter.dateFormat = formate10
                let dateStr = formatter.string(from: date)
                
                //Confirm alert Dispaly Date
                self.departuerDateStr = dateStr
                
                formatter.dateFormat = formate7
                self.cityData.date = formatter.string(from: date)
                self.cityData.timeStamps = date.timeIntervalSince1970
                self.cityData.departureDisplayDate = dateStr
                formatter.dateFormat = formate2
                self.departuerSelDateString = formatter.string(from: date)
                //Dispaly Departure Time
                self.cityData.startTime = airportdata.StartTime!
                //For API Field
                self.departuerStartTime = airportdata.StartTime!
                
                if typeIndex == 1{
                    
                    let airportdata = crSegment[1]
                    let returnDate = CommonFunction.getOriginalDateFromString(dateStr: airportdata.StartDateTime!, format: formate3)
                    
                    self.returnSelDate = returnDate
                    let formatter = DateFormatter()
                    formatter.dateFormat = formate10
                    let dateStr = formatter.string(from: returnDate)
                    
                    self.cityData.returnDate = dateStr
                    self.returnDisplayDateStr = dateStr
                    
                    formatter.dateFormat = formate9
                    self.returnSelDateString = formatter.string(from: returnDate)
                    
                    self.cityData.returnTime = airportdata.StartTime!
                    self.returnStartTime = airportdata.StartTime!
                }
                self.multiCityArr.replaceObject(at: 0, with: self.cityData)
            }else{
                
                self.multiCityArr.removeAllObjects()
                
                if crSegment.count > 0{
                    for i in 0...crSegment.count - 1{
                        
                        self.addNewSection1Data()
                        let airportdata = crSegment[i]
                        self.cityData.fromAdd = airportdata.StartDisplayLine1
                        self.cityData.fromSubAdd = airportdata.StartDisplayLine2
                        self.cityData.fromId = airportdata.StartAirport
                        
                        self.cityData.toAdd = airportdata.EndDisplayLine1
                        self.cityData.toSubAdd = airportdata.EndDisplayLine2
                        self.cityData.toId = airportdata.EndAirport
                        
                        let date = CommonFunction.getOriginalDateFromString(dateStr: airportdata.StartDateTime!, format: formate1)
                        
                        self.departuerSelDate = date
                        let formatter = DateFormatter()
                        formatter.dateFormat = formate8
                        let dateStr = formatter.string(from: date)
                        
                        //Confirm alert Dispaly Date
                        self.departuerDateStr = dateStr
                        formatter.dateFormat = formate7
                        self.cityData.date = formatter.string(from: date)
                        self.cityData.timeStamps = date.timeIntervalSince1970
                        self.cityData.departureDisplayDate = dateStr
                        formatter.dateFormat = formate2
                        self.departuerSelDateString = formatter.string(from: date)
                        //Dispaly Departure Time
                        self.cityData.startTime = airportdata.StartTime!
                        //For API Field
                        self.departuerStartTime = airportdata.StartTime!
                        
                        self.multiCityArr.replaceObject(at: i, with: self.cityData)
                        
                    }
                }
                
            }
            
            if data.PaxCount != nil{
                self.noOfPass = String(data.PaxCount!)
            }
            
            if data.PriceExpectation != nil{
                self.price = String(data.PriceExpectation!)
            }
            
            self.requestTableView.reloadData()
        }
    }
    func removeCharterRequestID(){
        self.view.hideToastActivity()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.ChartererRequestID)
        UserDefaults.standard.synchronize()
    }
    

    func resetNewRequest(){
        
        self.departuerDateStr = ""
        self.departuerSelDate = nil
        self.departuerSelDateString = ""
        self.returnDateStr = ""
        self.returnStartTime = ""
        self.returnSelDateString = ""
        self.returnSelDate = nil
        self.noOfPass = ""
        self.price = "5000"
        self.preferAircrafts = []
        self.preferAircraftId = []
        self.tripTypeIndex = 0
        self.tripTypeArr = 1
        self.charteredReqId = 0
        self.roomkey = ""
        self.IsRoomKeyRequest = false
        self.multiCityArr.removeAllObjects()
        self.addNewSection1Data()
        self.requestTableView.reloadData()
        self.termsBtnClicked(self.termsBtn)
    }
    
    func checkOneWayRoundTripFields() -> Bool{
        
        let fromAirportId = (self.multiCityArr[0] as! MultiCitys).fromAdd
        if fromAirportId == ""{
            //CommonFunction.showToastMessage(msg: "Please select airport start point.", controller: self)
            CommonFunction.showToastMesage(msg: "Please select airport start point.",controller: self, fontSize: 22)
            return false
        }
        
        
        let toAirportId = (self.multiCityArr[0] as! MultiCitys).toAdd
        if toAirportId == ""{
            //CommonFunction.showToastMessage(msg: "Please select airport end point.", controller: self)
            CommonFunction.showToastMesage(msg: "Please select airport end point.",controller: self, fontSize: 22)
            return false
        }
        
        if fromAirportId == toAirportId{
            //CommonFunction.showToastMessage(msg: "Please select different starting and destination airports.", controller: self)
            CommonFunction.showToastMesage(msg: "Please select different starting and destination airports.",controller: self, fontSize: 22)
            return false
        }
        
        if self.departuerDateStr == ""{
            //CommonFunction.showToastMessage(msg: "Please select departure date.", controller: self)
            CommonFunction.showToastMesage(msg: "Please select departure date.",controller: self, fontSize: 22)
            return false
        }
        
        if self.departuerStartTime == ""{
            //CommonFunction.showToastMessage(msg: "Please select departure time.", controller: self)
            CommonFunction.showToastMesage(msg: "Please select departure time.",controller: self, fontSize: 22)
            return false
        }
        
        if self.tripTypeIndex == 1{
            
            if self.returnDisplayDateStr == ""{
                //CommonFunction.showToastMessage(msg: "Please select return date.", controller: self)
                CommonFunction.showToastMesage(msg: "Please select return date.",controller: self, fontSize: 22)
                return false
            }
            
            if self.returnStartTime == ""{
                //CommonFunction.showToastMessage(msg: "Please select return departure time.", controller: self)
                CommonFunction.showToastMesage(msg: "Please select return departure time.",controller: self, fontSize: 22)
                return false
            }
        }
        
        if self.noOfPass == ""{
            //CommonFunction.showToastMessage(msg: "Please enter the number of passengers.", controller: self)
            CommonFunction.showToastMesage(msg: "Please enter the number of passengers.",controller: self, fontSize: 22)
            return false
        }else{
            
            if Int(self.noOfPass) != nil{
                if Int(self.noOfPass)! == 0{
                    //CommonFunction.showToastMessage(msg: "Maximum passenger(s) allowed is 1.", controller: self)
                    CommonFunction.showToastMesage(msg: "The number of passengers cannot be 0.",controller: self, fontSize: 22)
                    return false
                }
            }
        }
        
        if self.price == ""{
            //CommonFunction.showToastMessage(msg: "Price must be greater than or equal to $5000.", controller: self)
            CommonFunction.showToastMesage(msg: "Price must be greater than or equal to $5000.",controller: self, fontSize: 22)
            return false
        }else{
            
            if let floatValue = Float(self.price) {
                let intValue = Int(floatValue)
                if intValue < 5000{
                    //CommonFunction.showToastMessage(msg: "Price must be greater than or equal to $5000.", controller: self)
                    CommonFunction.showToastMesage(msg: "Price must be greater than or equal to $5000.",controller: self, fontSize: 22)
                    return false
                }
            }
           
        }
        return true
    }
    
    func checkMultiCityFields() -> Bool{
        var isValid:Bool = true
        var firstTimeStamp:Double! = 0.0
        if self.multiCityArr.count > 0{
            firstTimeStamp = (self.multiCityArr[0] as! MultiCitys).timeStamps!
        }
        
        for i in 0...self.multiCityArr.count - 1{
            let from =  (self.multiCityArr[i] as! MultiCitys).fromAdd
            let to = (self.multiCityArr[i] as! MultiCitys).toAdd
            let date = (self.multiCityArr[i] as! MultiCitys).date
            let timeStemp = (self.multiCityArr[i] as! MultiCitys).timeStamps!
            
            //if i == 0{
                if from == "" || from == "From"{
                    //CommonFunction.showToastMessage(msg: "Please select airport start point for \(i+1) city", controller: self)
                    CommonFunction.showToastMesage(msg: "Please select airport start point for \(i+1) city",controller: self, fontSize: 22)
                    isValid = false
                    break
                }
            //}
            
            if to == "" || to == "To"{
                //CommonFunction.showToastMessage(msg: "Please select airport end point for \(i+1) city", controller: self)
                CommonFunction.showToastMesage(msg: "Please select airport end point for \(i+1) city",controller: self, fontSize: 22)
                isValid = false
                break
            }
            
            if date == ""{
                //CommonFunction.showToastMessage(msg: "Please select departure date for \(i+1) city", controller: self)
                CommonFunction.showToastMesage(msg: "Please select departure date for \(i+1) city",controller: self, fontSize: 22)
                isValid = false
                break
            }
            
            if firstTimeStamp <= timeStemp{
                firstTimeStamp = timeStemp
            }else{
                //CommonFunction.showToastMessage(msg: "Departure date is incorrect for \(i+1) city", controller: self)
                CommonFunction.showToastMesage(msg: "Departure date is incorrect for \(i+1) city",controller: self, fontSize: 22)
                isValid = false
                break
            }
        }
        
        if isValid == true{
            if self.noOfPass == ""{
                //CommonFunction.showToastMessage(msg: "Please enter the number of passengers", controller: self)
                CommonFunction.showToastMesage(msg: "Please enter the number of passengers",controller: self, fontSize: 22)
                isValid = false
            }else{
                if Int(self.noOfPass) != nil{
                    if Int(self.noOfPass)! == 0{
                        //CommonFunction.showToastMessage(msg: "Maximum passenger(s) allowed is 1.", controller: self)
                        CommonFunction.showToastMesage(msg: "The number of passengers cannot be 0.",controller: self, fontSize: 22)
                        isValid = false
                    }
                }
            }
        }
        
        if isValid == true{
//            if self.preferAircraftId.count == 0{
//                CommonFunction.showToastMessage(msg: "Please select preferred aircraft", controller: self)
//                isValid = false
//            }
            if self.price != ""{
                if (Double(self.price) ?? 0) < 5000{
                    //CommonFunction.showToastMessage(msg: "Price must be greater than or equal to $5000", controller: self)
                    CommonFunction.showToastMesage(msg: "Price must be greater than or equal to $5000",controller: self, fontSize: 22)
                    return false
                }
            }
        }
        
        return isValid
    }
    
    func getOnewayParam() -> [String:Any]{
        
        let fromAirportId = (self.multiCityArr[0] as! MultiCitys).fromId
        let toAirportId = (self.multiCityArr[0] as! MultiCitys).toId
        let fromAirportInfo = (self.multiCityArr[0] as! MultiCitys).fromSubAdd
        let toAirportIdInfo = (self.multiCityArr[0] as! MultiCitys).toSubAdd
        let sDate = (self.multiCityArr[0] as! MultiCitys).date
        let sTime = (self.multiCityArr[0] as! MultiCitys).startTime
        
        let seq = NSMutableDictionary()
        seq["SequenceID"] = self.tripTypeIndex + 1
        seq["StartAirport"] = fromAirportId
        seq["EndAirport"] = toAirportId
        seq["StartAirportInfo"] = fromAirportInfo
        seq["EndAirportInfo"] = toAirportIdInfo
        seq["StartDateTime"] = sDate
        seq["StartTime"] = sTime
        seq["EndDateTime"] = sDate
        seq["Distance"] = "0"
        seq["EstimatedTimeInMinute"] = 0
    
        let crleg = NSMutableArray()
        crleg.add(seq)
        
        let aircraftId =  self.preferAircraftId.joined(separator: ",")
        
        let parameters = ["ChartererRequestID": self.charteredReqId!,
                          "UserID":0,
                          "StartAirportID":fromAirportId!,
                          "EndAirportID":toAirportId!,
                          "StartDateTime":sDate!,
                          "StartTime":sTime!,
                          "EndDateTime":sDate!,
                          "Distance":"0",
                          "Note":"",
                          "RoomKey":self.roomkey!,
                          "IsRoomKeyRequest":(self.IsRoomKeyRequest! == true) ? "1" : "0",
                          "Status":self.rStatus!,
                          "PaxCount": self.noOfPass!,
                          "PaxSegment":"N/A",
                          "IsSplitPayment":self.paymentSlpit!,
                          "PriceExpectation":self.price!,
                          "PreferredAircraftIDCSV":aircraftId,
                          "PreferredAircraftTypeIDCSV":aircraftId,
                          "RequestTypeID": self.tripTypeIndex+1,"CRleg":crleg] as [String: Any]
        
        return parameters
    }
    
    func getRoundTripParam() -> [String:Any]{
        
        let crleg = NSMutableArray()
        let fromAirportId = (self.multiCityArr[0] as! MultiCitys).fromId
        let toAirportId = (self.multiCityArr[0] as! MultiCitys).toId
        let fromAirportInfo = (self.multiCityArr[0] as! MultiCitys).fromSubAdd
        let toAirportInfo = (self.multiCityArr[0] as! MultiCitys).toSubAdd
        let sDate = (self.multiCityArr[0] as! MultiCitys).date
        
        for i in 0...1{
            let seq = NSMutableDictionary()
            seq["SequenceID"] = i + 1
            if i == 0{
                seq["StartAirport"] = fromAirportId
                seq["EndAirport"] = toAirportId
                seq["StartAirportInfo"] = fromAirportInfo
                seq["EndAirportInfo"] = toAirportInfo
                seq["StartDateTime"] = sDate
                seq["StartTime"] = self.departuerStartTime
                seq["EndDateTime"] = sDate
            }else{
                seq["StartAirport"] = toAirportId
                seq["EndAirport"] = fromAirportId
                seq["StartAirportInfo"] = fromAirportInfo
                seq["EndAirportInfo"] = toAirportInfo
                seq["StartDateTime"] = self.returnSelDateString
                seq["StartTime"] = self.returnStartTime
                seq["EndDateTime"] = self.returnSelDateString
            }
            seq["Distance"] = "0"
            seq["EstimatedTimeInMinute"] = 0
            crleg.add(seq)
        }
        let aircraftId =  self.preferAircraftId.joined(separator: ",")
        let parameters = ["ChartererRequestID": self.charteredReqId!,
                          "UserID":0,
                          "StartAirportID":fromAirportId!,
                          "EndAirportID":toAirportId!,
                          "StartDateTime":sDate!,
                          "StartTime":self.departuerStartTime!,
                          "EndDateTime":sDate!,
                          "Distance":"0",
                          "Note":"",
                          "RoomKey":self.roomkey!,
                          "IsRoomKeyRequest":(self.IsRoomKeyRequest! == true) ? "1" : "0",
                          "Status":self.rStatus!,
                          "PaxCount": self.noOfPass!,
                          "PaxSegment":"N/A",
                          "IsSplitPayment":self.paymentSlpit!,
                          "PriceExpectation":self.price!,
                          "PreferredAircraftIDCSV":aircraftId,
                          "PreferredAircraftTypeIDCSV":aircraftId,
                          "RequestTypeID": self.tripTypeIndex+1,"CRleg":crleg] as [String: Any]
        
        return parameters
    }
    
    func getMultiCityParam()-> [String:Any]{
        
        let crleg = NSMutableArray()
        var sDate = ""
        for i in 0...self.multiCityArr.count - 1{
            let fromAirportId = (self.multiCityArr[i] as! MultiCitys).fromId
            let toAirportId = (self.multiCityArr[i] as! MultiCitys).toId
            sDate = (self.multiCityArr[i] as! MultiCitys).date!
            let sTime = (self.multiCityArr[i] as! MultiCitys).startTime
            let seq = NSMutableDictionary()
            seq["SequenceID"] = i + 1
            seq["StartAirport"] = fromAirportId
            seq["EndAirport"] = toAirportId
            seq["StartDateTime"] = sDate
            seq["StartTime"] = sTime
            seq["EndDateTime"] = sDate
            seq["Distance"] = "0"
            seq["EstimatedTimeInMinute"] = 0
            crleg.add(seq)
        }
        let fromAirportId = (self.multiCityArr[0] as! MultiCitys).fromId
        let toAirportId = (self.multiCityArr[0] as! MultiCitys).toId
        let aircraftId =  self.preferAircraftId.joined(separator: ",")
        let parameters = ["ChartererRequestID": self.charteredReqId!,
                          "UserID":0,
                          "StartAirportID":fromAirportId!,
                          "EndAirportID":toAirportId!,
                          "StartDateTime":sDate,
                          "StartTime":self.departuerStartTime!,
                          "EndDateTime":sDate,
                          "Distance":"0",
                          "Note":"",
                          "RoomKey":self.roomkey!,
                          "IsRoomKeyRequest":(self.IsRoomKeyRequest! == true) ? "1" : "0",
                          "Status":self.rStatus!,
                          "PaxCount": self.noOfPass!,
                          "PaxSegment":"N/A",
                          "IsSplitPayment":self.paymentSlpit!,
                          "PriceExpectation":self.price!,
                          "PreferredAircraftIDCSV":aircraftId,
                          "PreferredAircraftTypeIDCSV":aircraftId,
                          "RequestTypeID": self.tripTypeIndex+1,"CRleg":crleg] as [String: Any]
        return parameters
        
    }
    
    func resetRequestAfterConfirm() -> [String:Any]{
        
        if self.tripTypeIndex == 0 || self.tripTypeIndex == 1{
            
            if self.tripTypeIndex == 0{
                return self.getOnewayParam()
            }else{
                return self.getRoundTripParam()
            }
        }else if self.tripTypeIndex == 2{
            return self.getMultiCityParam()
        }else{
            return [String:Any]()
        }
    }
    
    func APICallPN(){
        
        let urlStr = String(format: "%@/UserDevice/AddEditAppNotificationToken", APIUrl.baseUrl)
        let deviceModel = UIDevice.current.model
        let deviceManufacturer = "Apple"
        let device = "\(deviceModel) \(deviceManufacturer)"

        var deviceIDString = ""
        if let uuidStr = UIDevice.current.identifierForVendor?.uuidString {
            deviceIDString = uuidStr
            print("iOS ID: \(deviceIDString)")
        }
        
        var userIdStr = 0
        if UserDefaults.standard.value(forKey: "UserLoginUserId") != nil{
            userIdStr = (UserDefaults.standard.value(forKey: "UserLoginUserId") as! Int)
        }
        
        var fmctoken = ""
        if UserDefaults.standard.value(forKey: "fcmTokenStr") != nil{
            fmctoken = (UserDefaults.standard.value(forKey: "fcmTokenStr") as! String)
        }
        
        let param: [String: Any] = ["deviceToken":fmctoken,
                                    "id":0,
                                    "deviceOS":device,
                                    "deviceId":deviceIDString,
                                    "userId":userIdStr]
        
        APIAddEditAppNotificationToken.shared.saveAppNotificationToken(urlStr: urlStr, param: param) { response in
            //
            
        } fail: { error in
            //
        }
    }
    
    @IBAction func submitBtnClicked(_ sender : UIButton){
        
        self.view.endEditing(true)
        var message = ""
        var parameters:[String:Any]
        if self.tripTypeIndex == 0 || self.tripTypeIndex == 1{

            if self.checkOneWayRoundTripFields() == true{
            
                let fromAirportId = (self.multiCityArr[0] as! MultiCitys).fromAdd
                let toAirportId = (self.multiCityArr[0] as! MultiCitys).toAdd
                
                let dateStr = (self.multiCityArr[0] as! MultiCitys).date!
                 
                 let mdate = CommonFunction.getOriginalDateFromString(dateStr: dateStr, format: formate7)
                 let formatter = DateFormatter()
                 formatter.dateFormat = formate8
                 self.departuerDateStr = formatter.string(from: mdate)
               
                if self.self.departuerStartTime == "TBD"{
                    message = "Please confirm your bid for\n \(fromAirportId!) to \(toAirportId!) on\n \(self.departuerDateStr!)"
                }else{
                    message = "Please confirm your bid for\n \(fromAirportId!) to \(toAirportId!) on\n \(self.departuerDateStr!) at \(self.self.departuerStartTime!)"
                }
                
                
                if self.tripTypeIndex == 0{
                    parameters = self.getOnewayParam()
                }else {
                    if self.returnDisplayDateStr == ""{
                        CommonFunction.showToastMessage(msg: "Please select return date", controller: self)
                        return
                    }
                    
                    if self.multiCityArr.count > 0{
                        self.departureDateTimeStemps = (self.multiCityArr[0] as! MultiCitys).timeStamps!
                        
                       let dateStr = (self.multiCityArr[0] as! MultiCitys).date!
                        
                        let mdate = CommonFunction.getOriginalDateFromString(dateStr: dateStr, format: formate7)
                        let formatter = DateFormatter()
                        formatter.dateFormat = formate8
                        self.departuerDateStr = formatter.string(from: mdate)
                    }
                    
                    if self.departureDateTimeStemps > self.returnDateTimeStemps{
                        
                        CommonFunction.showToastMessage(msg: "Return date must be later than Departure date", controller: self)
                        return
                    }
                    
                    parameters = self.getRoundTripParam()
                    if self.departuerStartTime == "TBD" && self.returnStartTime == "TBD"{
                        message = "Please confirm your bid for \(fromAirportId!) to \(toAirportId!) on\n \(self.departuerDateStr!)\nand return on\n\(self.returnDisplayDateStr!)"
                    }else if self.departuerStartTime == "TBD" && self.returnStartTime != "TBD"{
                        message = "Please confirm your bid for \(fromAirportId!) to \(toAirportId!) on\n \(self.departuerDateStr!)\nand return on\n\(self.returnDisplayDateStr!) at \(self.returnStartTime!)"
                    }else if self.departuerStartTime != "TBD" && self.returnStartTime == "TBD"{
                        message = "Please confirm your bid for \(fromAirportId!) to \(toAirportId!) on\n \(self.departuerDateStr!) at \(self.departuerStartTime!)\nand return on\n\(self.returnDisplayDateStr!)"
                    }else{
                        message = "Please confirm your bid for \(fromAirportId!) to \(toAirportId!) on\n \(self.departuerDateStr!) at \(self.departuerStartTime!) \nand return on\n\(self.returnDisplayDateStr!) at \(self.returnStartTime!)"
                    }
                }
                print(message)
                if self.charteredReqId == 0{
                    self.APIPostRequestCharterCall(parameters:parameters)
                }else{
                    self.APIEditRequestCharterCall(parameters: parameters)
                }
                
            }
        }else if self.tripTypeIndex == 2{
            
            if self.checkMultiCityFields() == true{
                
                var mCities = ""
                for i in 0...self.multiCityArr.count - 1{
                    let city = self.multiCityArr[i] as! MultiCitys
                    let fromAirportId = city.fromAdd!
                    let toAirportId = city.toAdd!
                    
                    
                    let mdate = CommonFunction.getOriginalDateFromString(dateStr: city.date!, format: formate7)
                    let formatter = DateFormatter()
                    formatter.dateFormat = formate8
                    let date = formatter.string(from: mdate)
                    let time = city.startTime!
                    //let parameters = self.getMultiCityParam()
                    mCities.append("\n")
                    if time == "TBD"{
                        mCities.append("\(fromAirportId) to \(toAirportId) on \(date)")
                    }else{
                        mCities.append("\(fromAirportId) to \(toAirportId) on \(date) at \(time)")
                    }
                }
                //let fromAirportId = (self.multiCityArr.firstObject as! MultiCitys).fromAdd
                //let toAirportId = (self.multiCityArr.lastObject as! MultiCitys).toAdd
                
                let message = String(format: "Please confirm your bid for multicity journey starting from %@", mCities)
                let parameters = self.getMultiCityParam()
                 
                print(message)
                if self.charteredReqId == 0{
                    self.APIPostRequestCharterCall(parameters:parameters)
                }else{
                    self.APIEditRequestCharterCall(parameters: parameters)
                }
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
    
    @IBAction func termsConditionBtnClicked(_ sender:UIButton){
        
        let previewVC = PreviewOfferVC.storyboardViewController()
        previewVC.prevUrlStr = APPUrls.termsandconditionsurlCR
        previewVC.titleStr = "Terms & Conditions"
        previewVC.isFromTermsAndCond = true
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
}

extension RequestVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if section == 0{
            return 1
        }else if section == 1{
            if self.tripTypeIndex == 0 || self.tripTypeIndex == 1{
                return self.tripTypeArr //oneway or Roundtrip
            }else{
                return self.multiCityArr.count + 1 //Multicity
            }
        }else{
            return 3 //Passengers, remove 1 and slpit payments
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            //Oneway / Round trip / Multicity
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell3, for: indexPath) as! HomeCell3
                
            cell.delegate = self
            cell.configuerCell(indexPath: indexPath, tripType: self.tripTypeIndex)
            return cell
            
        }else if indexPath.section == 1{ //Form
            
            if self.tripTypeIndex == 1{ // Round Trip
                
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell1, for: indexPath) as! HomeCell1
                    
                    let city = self.multiCityArr[indexPath.row] as! MultiCitys
                    cell.configuerHomeCell1(indexPath: indexPath,data:city,tripTypeIndex: self.tripTypeIndex,prevData: MultiCitys(),isSwipe:self.isSwiped,isNewAdded: self.isNewAdded)
                    cell.delegate = self
                    return cell
                }else if indexPath.row == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell2, for: indexPath) as! HomeCell2
                    
                    cell.delegate = self
                    cell.cofigureReturnDateTimeCell(indexPath: indexPath, dateStr: self.returnDisplayDateStr!, timeStr: self.returnStartTime!)
                    //cell.configuerReturnDateCell(indexPath: indexPath, dateStr: self.returnDisplayDateStr!)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell2, for: indexPath) as! HomeCell2
                    
                    cell.delegate = self
                    cell.configuerReturnTimeCell(indexPath: indexPath, timeStr: self.returnStartTime)
                    return cell
                }
            }else if self.tripTypeIndex == 2{ //Multi City
                
                if indexPath.row == self.multiCityArr.count{
                    let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.MultiCityCell, for: indexPath) as! MultiCityCell
                    
                    cell.delegate = self
                    cell.configuerMultiCityCell(count: self.multiCityArr.count)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell1, for: indexPath) as! HomeCell1
                    
                    let city = multiCityArr[indexPath.row] as! MultiCitys
                    
                    
                    if self.multiCityArr.count >= 2 && indexPath.row != 0{
                        if let pCity = multiCityArr[indexPath.row - 1] as? MultiCitys{
                            cell.configuerHomeCell1(indexPath: indexPath,data:city,tripTypeIndex: self.tripTypeIndex,prevData: pCity,isSwipe:self.isSwiped,isNewAdded: self.isNewAdded)
                        }else{
                            cell.configuerHomeCell1(indexPath: indexPath,data:city,tripTypeIndex: self.tripTypeIndex,prevData: MultiCitys(),isSwipe: self.isSwiped,isNewAdded: self.isNewAdded)
                        }
                    }else{
                        cell.configuerHomeCell1(indexPath: indexPath,data:city,tripTypeIndex: self.tripTypeIndex,prevData: MultiCitys(),isSwipe: self.isSwiped,isNewAdded: self.isNewAdded)
                    }
                    cell.delegate = self
                    return cell
                }
            }else{ // Oneway trip
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell1, for: indexPath) as! HomeCell1
                
                let city = multiCityArr[indexPath.row] as! MultiCitys
                cell.configuerHomeCell1(indexPath: indexPath,data:city,tripTypeIndex: self.tripTypeIndex,prevData: MultiCitys(),isSwipe: self.isSwiped,isNewAdded: self.isNewAdded)
                cell.delegate = self
                return cell
            }
        }else{// Passengers and Price || indexPath.row == 1
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell2, for: indexPath) as! HomeCell2
                
                cell.delegate = self
                cell.configuerOtherCell(indexPath: indexPath,noOfPass:self.noOfPass,roomkey:self.roomkey,aircrafts:self.preferAircrafts)
                return cell
            }else if indexPath.row == 1{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell2, for: indexPath) as! HomeCell2
                
                cell.delegate = self
                cell.configuerOtherCell(indexPath: indexPath,noOfPass:self.noOfPass,roomkey:self.roomkey,aircrafts:self.preferAircrafts)
                return cell
            }else{
               let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.SplitPaymentCell, for: indexPath) as! SplitPaymentCell
                
                cell.hintButton.addTarget(self, action: #selector(showHint(_:)), for: .touchUpInside)
                cell.delegate = self
                
                if self.paymentSlpit == 1{
                    cell.configuerCell(indexPath: indexPath, isSplit:true)
                }
                return cell
            }
        }
    }
    
    @objc func showHint(_ sender:UIButton){
        
        // Get the cell containing the button
        guard let cell = sender.superview?.superview?.superview as? SplitPaymentCell,
              let indexPath = requestTableView.indexPath(for: cell) else {
            return
        }
        // Convert the button's frame to the main view's coordinate space
        let buttonFrameInTable = sender.convert(sender.bounds, to: requestTableView)
        let buttonFrameInView = requestTableView.convert(buttonFrameInTable, to: view)
        
        CommonFunction.showToastMesage(msg: "You can share your trip expenses with the friends traveling with you.", title: "", duration: 8.0, point: CGPoint(x: buttonFrameInView.maxX+70,y: buttonFrameInView.maxY+50), controller: self)
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension RequestVC : HomeCell2Delegate{
    
    func aircraftBtnPressed(text: String) {
        self.view.endEditing(true)
        self.navigationController?.navigationBar.isHidden = false
        let aircraftListVC = AircraftListVC.storyboardViewController()
        aircraftListVC.delegate = self
        aircraftListVC.selectedIds = self.preferAircraftId
        aircraftListVC.selectedAircrafts = self.preferAircrafts
        self.navigationController?.pushViewController(aircraftListVC, animated: true)
    }
    
    func returnTimeBtnPressed(onIndex:Int) {
        self.view.endEditing(true)
        
        ASPicker.selectOption(dataArray: CommonFunction.getDepartureTime()) { value, atIndex in
            
            self.cityData = self.multiCityArr[onIndex] as! MultiCitys
            self.cityData.returnTime = value
            self.multiCityArr.replaceObject(at: onIndex, with: self.cityData)
            
            self.returnStartTime = value
            self.requestTableView.reloadData()
        }
    }
    
    func returnDateBtnPressed(onIndex:Int) {
        self.view.endEditing(true)
        ASPicker.selectDate(minDate: self.departuerSelDate) { date in
            //print(date)
            
            self.returnDateTimeStemps = date.timeIntervalSince1970
            self.returnSelDate = date
            let formatter = DateFormatter()
            formatter.dateFormat = formate10
            let dateStr = formatter.string(from: date)
            //print(dateStr)
            self.cityData = self.multiCityArr[onIndex] as! MultiCitys
            self.cityData.returnDate = dateStr
            self.multiCityArr.replaceObject(at: onIndex, with: self.cityData)
            self.returnDisplayDateStr = dateStr
            
            formatter.dateFormat = formate7
            self.returnSelDateString = formatter.string(from: date)
            self.requestTableView.reloadData()
        }
    }
    
    func setPassenger(pax: String) {
        self.noOfPass = pax
        self.requestTableView.reloadData()
    }
    
    func setPrice(price: String) {
        self.price = price
        self.requestTableView.reloadData()
    }
    
    func setRoomkey(key: String) {
        self.roomkey = key
        if key.count > 0 {
            self.IsRoomKeyRequest = true
        }else{
            self.IsRoomKeyRequest = false
        }
        
        print(self.roomkey!)
        print(self.IsRoomKeyRequest!)
        self.requestTableView.reloadData()
    }
    
}

extension RequestVC : HomeCell3Delegate{
    
    func typeBtnPressed(button: UIButton) {
        //print(button.tag)
        self.returnStartTime = ""
        self.returnDisplayDateStr = ""
        self.view.endEditing(true)
        if self.multiCityArr.count > 0 && button.tag != 1 {
            self.cityData = multiCityArr[0] as! MultiCitys
            self.cityData.returnTime = ""
            self.cityData.returnDate = ""
            self.returnStartTime = ""
            self.returnDisplayDateStr = ""
            self.multiCityArr.replaceObject(at: 0, with: self.cityData)
        }
        
        self.tripTypeIndex = button.tag
        if self.tripTypeIndex == 0{ //oneway
            self.tripTypeArr = 1
        }else if self.tripTypeIndex == 1 { //round trip
            self.tripTypeArr = 2
        }else{
            self.tripTypeArr = 2 //multicity not require now
        }
        requestTableView.reloadData()
    }
}

extension RequestVC : AircraftListDelegate{
    
    func didSelectedAircraft(data: AircraftsData,aircrafts:[String], aircraftIds: [String]) {
        self.preferAircrafts = aircrafts
        self.preferAircraftId = aircraftIds
        print(self.preferAircrafts)
        print(self.preferAircraftId)
    }
    
    func doneBtnPressed() {
        self.requestTableView.reloadData()
    }
}

extension RequestVC : HomeCell1Delegate{
    
    func dateBtnPressed(atIndex: Int) {
        
        self.view.endEditing(true)
        ASPicker.selectDate { date in
            //print(date)
            self.returnSelDate = nil

            self.departureDateTimeStemps = date.timeIntervalSince1970
            self.departuerSelDate = date
            let formatter = DateFormatter()
            
            formatter.dateFormat = formate10
            let dateStr = formatter.string(from: date)
            //print(dateStr)
            
            //Confirm alert Dispaly Date
            self.departuerDateStr = dateStr
            self.cityData = self.multiCityArr[atIndex] as! MultiCitys
            
            formatter.dateFormat = formate7
            self.cityData.date = formatter.string(from: date)
            self.cityData.timeStamps = date.timeIntervalSince1970
            self.cityData.departureDisplayDate = dateStr
            self.cityData.returnDate = ""
            
            //For API Field OneWay,RoundTrip
            formatter.dateFormat = formate7
            self.departuerSelDateString = formatter.string(from: date)
            
            //Dispaly Departure Time
            //formatter.dateFormat = TimeFormat
            
            //For API Field
            //self.departuerStartTime = formatter.string(from: date)
            
        
            self.multiCityArr.replaceObject(at: atIndex, with: self.cityData)
            self.requestTableView.reloadData()
        }
    }
    
    func timeBtnPressed(onIndex: Int) {
        
        self.view.endEditing(true)
        ASPicker.selectOption(dataArray: CommonFunction.getDepartureTime()) { value, atIndex in
            
            self.cityData = self.multiCityArr[onIndex] as! MultiCitys
            
            //Dispaly Departure Time
            self.cityData.startTime = value
            self.cityData.returnTime = ""
            
            //For API Field
            self.departuerStartTime = value
            
            self.multiCityArr.replaceObject(at: onIndex, with: self.cityData)
            self.requestTableView.reloadData()
        }
    }
    
    func fromAddressBtnPressed(atIndex: Int) {
        let addressListVC = AddressListVC.storyboardViewController()
        addressListVC.optionIndex = 0
        addressListVC.selectAddAtIndex = atIndex
        addressListVC.delegate = self
        self.navigationController?.pushViewController(addressListVC, animated: true)
    }
    
    func toAddressBtnPressed(atIndex: Int) {
        let addressListVC = AddressListVC.storyboardViewController()
        addressListVC.optionIndex = 1
        addressListVC.selectAddAtIndex = atIndex
        addressListVC.delegate = self
        self.navigationController?.pushViewController(addressListVC, animated: true)
    }
    
    func swipeLocation(atIndex: Int) {
        
        self.isNewAdded = false
        if self.tripTypeIndex == 0 || self.tripTypeIndex == 1 || self.tripTypeIndex == 2{
            let originData = self.multiCityArr[atIndex] as! MultiCitys
            var swipeData = MultiCitys()
            if originData.toAdd != "" && originData.fromAdd != ""{
                swipeData.fromAdd = originData.toAdd
                swipeData.fromSubAdd = originData.toSubAdd
                swipeData.fromId = originData.toId
                swipeData.fromIata = originData.toIata
                swipeData.fromIcao = originData.toIcao
                swipeData.fromIfaa = originData.toIfaa
                
                swipeData.toAdd = originData.fromAdd
                swipeData.toSubAdd = originData.fromSubAdd
                swipeData.toId = originData.fromId
                swipeData.toIata = originData.fromIata
                swipeData.toIcao = originData.fromIcao
                swipeData.toIfaa = originData.fromIfaa
                
                if originData.date != nil && originData.date != ""{
                    swipeData.date = originData.date
                    
                    let date = CommonFunction.getOriginalDateFromString(dateStr: originData.date!, format: formate7)
                    
                    swipeData.timeStamps = date.timeIntervalSince1970
                }else{
                    swipeData.date = ""
                }
                swipeData.departureDisplayDate = originData.departureDisplayDate
                
                if originData.returnDate != nil{
                    swipeData.returnDate = originData.returnDate
                }else{
                    swipeData.returnDate = ""
                }
                swipeData.returnTime = originData.returnTime
                swipeData.startTime = originData.startTime
                
                self.isSwiped = true
                self.multiCityArr.replaceObject(at: atIndex, with: swipeData)
                self.requestTableView.reloadData()
            }
        }
    }
}

extension RequestVC : AirportListDelegate{
    
    func didSelectedAirport(data: AirportData, optionIndex: Int,atIndex:Int) {
        self.cityData = self.multiCityArr[atIndex] as! MultiCitys
        print(self.cityData)
        if optionIndex == 0{
            self.cityData.fromAdd = data.displayLine1!
            self.cityData.fromSubAdd = String(format: "%@", data.displayLine2!)
            self.cityData.fromId = data.code!
        }else{
            self.cityData.toAdd = data.displayLine1!
            self.cityData.toSubAdd = String(format: "%@", data.displayLine2!)
            self.cityData.toId = data.code!
        }
        self.multiCityArr.replaceObject(at: atIndex, with: self.cityData)
        //print(self.multiCityArr[atIndex])
        
        if self.tripTypeIndex == 2{
            self.isNewAdded = false
            /*if self.multiCityArr.count > 1 && self.multiCityArr.count > (atIndex + 1){
                if optionIndex == 1{
                    self.cityData = self.multiCityArr[atIndex+1] as! MultiCitys
                    self.cityData.fromAdd = data.displayLine1!
                    self.cityData.fromSubAdd = String(format: "%@", data.displayLine2!)
                    self.cityData.fromId = data.code!
                    self.multiCityArr.replaceObject(at: atIndex+1, with: self.cityData)
                }
            }*/
        }
        
        self.requestTableView.reloadData()
    }
}

extension RequestVC : MultiCityCellDelegate{
    
    func addNewLeg() {
        //
        self.isNewAdded = true
        self.addNewSection1Data()
        self.requestTableView.reloadData()
    }
    
    func removeLeg() {
        //
        if self.self.multiCityArr.count > 1{
            self.multiCityArr.removeLastObject()
            self.requestTableView.reloadData()
        }
    }
}

extension RequestVC : RequestDetailVCDelegate{
    
    func backBtnPressed() {
        self.resetNewRequest()
    }
    
    func editBtnPressed(typeIndex: Int, getData: CharterReqData) {
        
    
        self.tripTypeIndex = typeIndex
        if self.tripTypeIndex == 0{ //oneway
            self.tripTypeArr = 1
        }else if self.tripTypeIndex == 1 { //round trip
            self.tripTypeArr = 2
        }else{
            self.tripTypeArr = 2 //multicity not require now
        }
        
        self.setEditData(data:getData,typeIndex: self.tripTypeIndex)
        self.requestTableView.reloadData()
    }
    
    func calltoConfirmedRequestVC() {
        
        if self.postReqData != nil{
            self.perform(#selector(openConfrimedRequest), with: nil, afterDelay: 0.2)
        }
    }
    
    @objc func openConfrimedRequest(){
        let confirmVC = RequestConfirmDetailVC.storyboardViewController()
        confirmVC.postResponseData = self.postReqData
        //confirmVC.ownerMaxPaxCount = self.ownerMaxPaxCount
        confirmVC.delegate = self
        confirmVC.typeIndex = self.tripTypeIndex
        confirmVC.presentationController?.delegate = self
        let navCont = UINavigationController(rootViewController: confirmVC)
        navCont.modalPresentationStyle = .pageSheet
        navCont.isModalInPresentation = true
        self.present(navCont, animated: true, completion: nil)
    }
}

extension RequestVC : RequestConfirmDetailVCDelegate{
    
    func cancelRequest() {
        
        if UserDefaults.standard.object(forKey: "planAnimationLastPoint") != nil ||  UserDefaults.standard.object(forKey: "distance") != nil || UserDefaults.standard.object(forKey: "planAnimationSpeed") != nil{
            UserDefaults.standard.removeObject(forKey: "planAnimationLastPoint")
            UserDefaults.standard.removeObject(forKey: "distance")
            UserDefaults.standard.removeObject(forKey:"planAnimationSpeed")
            UserDefaults.standard.removeObject(forKey: "lastTimeSeconds")
            UserDefaults.standard.synchronize()
        }
        
        self.APICancelCharterRequestCall()
        
    }
    
    func APICancelCharterRequestCall(){
        
        self.view.makeToastActivity(.center)
       
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/UpdateCharterRequestStatus?chartererrequestid=%d&statusid=7", APIUrl.baseUrl,self.charteredReqId!)
        
        let parameters = ["chartererrequestid":self.charteredReqId!,"statusid":7] as [String: Any]
    
        APIChartererRequest.shared.updateChartererRequest(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
           // if response.data != nil{
            
            if response.result == "success"{
    
                self.resetNewRequest()
                
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

extension RequestVC : SplitPaymentCellDelegate{
    
    func splitBtnPressed(isSplit: Bool) {
        print(isSplit)
        
        if isSplit {
            self.paymentSlpit = 1
        }else{
            self.paymentSlpit = 0
        }
    }
    
    func faqBtnPressed() {
        let faqvc = FaqVC.storyboardViewController()
        faqvc.modalPresentationStyle = .pageSheet
        self.navigationController?.present(faqvc, animated: true)
    }
}

extension RequestVC : UIAdaptivePresentationControllerDelegate{
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            // Return false to prevent manual dismissal
            return false
    }
    
    // Detect when the modal is about to be dismissed
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            print("Modal will dismiss")
            CommonFunction.showAlertMessageWithTitle(aStrTitle: "", aStrMessage: "Your current request is going on, Do you want to cancel this request?", Oktitle: "Yes", CancelTitle: "No", aViewController: self) { cancelAction in
                
            } OKActionTap: { OkAction in
                //self.APICancelCharterRequestCall()
            }
        }

        // Detect when the modal has been dismissed
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            print("Modal did dismiss")
        }
}

import UIKit
import WebKit

class FaqVC: UIViewController,Storyboardable {
    
    @IBOutlet weak var faqWkView:WKWebView!
    
    static let storyboardName :StoryBoardName = .RequestList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        faqWkView.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        let urlStr = CommonFunction.getValueFromForKey(key: "FAQ")
        print(urlStr)
        // Load a URL
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            faqWkView.load(request)
        }
        
        CommonFunction.setBottomGradientShadowToView(vC: self)
    }
}



        
