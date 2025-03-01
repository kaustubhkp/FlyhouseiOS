//
//  InstantBookVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 04/02/24.
//

import UIKit

class InstantBookVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .InstantBook

    var titleStr:String! = ""
    @IBOutlet weak var instantBookTableView:UITableView!
    var tripTypeIndex:Int! = 0
    var tripTypeArr:Int! = 1
    var multiCityArr = NSMutableArray()
    var cityData = MultiCitys()
    var paymentSlpit:Int! = 0
    var cReqData = CharterReqData()
    var rStatus:String! = "0"
    var charteredReqId:Int! = 0
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
    var tollNumber:String! = ""
    var noOfPass:String! = ""
    var preferAircrafts:[String] = []
    var preferAircraftId:[String] = []
    var bookFlightArr = [SearchFlightResponseData]()
    var selectedAircraftData = AirCraft()
    var chartererRequestID:Int?
    var bookFlightResponseData:CharterreResponse!
    var instBookOwnderAircraftId:Int! = 0
    
    var departureDateTimeStemps:Double! = 0.0
    var returnDateTimeStemps:Double! = 0.0
    var isSwiped:Bool! = false
    var isNewAdded:Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.setNavigationTitle(title: titleStr)
        self.registerIBTableCell()
    }
    
    
    func registerIBTableCell(){
        
        self.instantBookTableView.delegate = self
        self.instantBookTableView.dataSource = self
        self.instantBookTableView.register(UINib(nibName: TableCells.RequestCell1, bundle: nil), forCellReuseIdentifier: TableCells.RequestCell1)
        self.instantBookTableView.register(UINib(nibName: TableCells.RequestCell2, bundle: nil), forCellReuseIdentifier: TableCells.RequestCell2)
        self.instantBookTableView.register(UINib(nibName: TableCells.RequestCell3, bundle: nil), forCellReuseIdentifier: TableCells.RequestCell3)
        self.instantBookTableView.register(UINib(nibName: TableCells.HeaderImageCell, bundle: nil), forCellReuseIdentifier: TableCells.HeaderImageCell)
        self.instantBookTableView.register(UINib(nibName: TableCells.MultiCityCell, bundle: nil), forCellReuseIdentifier: TableCells.MultiCityCell)
        
        self.instantBookTableView.register(UINib(nibName: TableCells.SplitPaymentCell, bundle: nil), forCellReuseIdentifier: TableCells.SplitPaymentCell)
        
        //For Get Price Button cell
        self.instantBookTableView.register(UINib(nibName: TableCells.CancelRequestCell, bundle: nil), forCellReuseIdentifier: TableCells.CancelRequestCell)
        
        //For Get Price Button cell
        self.instantBookTableView.register(UINib(nibName: TableCells.InstantBookViewCell, bundle: nil), forCellReuseIdentifier: TableCells.InstantBookViewCell)
        
        self.addNewSection1Data()
        self.instantBookTableView.reloadData()
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
        self.cityData.fromAdd = ""
        self.cityData.fromSubAdd = "" //ADDRESS_TITLE
        self.cityData.fromId = ""
        self.cityData.fromIcao = ""
        self.cityData.fromIata = ""
        self.cityData.fromIfaa = ""
        self.cityData.toAdd = ""
        self.cityData.toSubAdd = "" //ADDRESS_TITLE
        self.cityData.toId = ""
        self.cityData.toIcao = ""
        self.cityData.toIata = ""
        self.cityData.toIfaa = ""
        self.cityData.returnDate = ""
        self.cityData.returnTime = ""
        self.cityData.timeStamps = 0.0
        self.cityData.date = self.returnDisplayDateStr
        self.cityData.startTime = self.returnStartTime
        self.cityData.departureDisplayDate = nil
        self.multiCityArr.add(self.cityData)
    }
    
    func checkMultiCityFields() -> Bool{
        var isValid:Bool = true
        var firstTimeStamp:Double! = 0.0
        if self.multiCityArr.count > 0{
            firstTimeStamp = (self.multiCityArr[0] as! MultiCitys).timeStamps
        }
        
        for i in 0...self.multiCityArr.count - 1{
            let from =  (self.multiCityArr[i] as! MultiCitys).fromAdd
            let to = (self.multiCityArr[i] as! MultiCitys).toAdd
            let date = (self.multiCityArr[i] as! MultiCitys).date
            let timeStemp = (self.multiCityArr[i] as! MultiCitys).timeStamps
            
            //if i == 0{
                if from == "" || from == "From"{
                    CommonFunction.showToastMessage(msg: "Please select airport start point for \(i+1) city", controller: self)
                    isValid = false
                    break
                }
            //}
            
            if to == "" || to == "To"{
                CommonFunction.showToastMessage(msg: "Please select airport end point for \(i+1) city", controller: self)
                isValid = false
                break
            }
            
            if date == ""{
                CommonFunction.showToastMessage(msg: "Please select departure date for \(i+1) city", controller: self)
                isValid = false
                break
            }
            
            if firstTimeStamp <= timeStemp!{
                firstTimeStamp = timeStemp
            }else{
                CommonFunction.showToastMessage(msg: "Departure date is incorrect for \(i+1) city", controller: self)
                isValid = false
                break
            }
        }
        if isValid == true{
            if self.noOfPass == ""{
                CommonFunction.showToastMessage(msg: "Please enter no of passenger", controller: self)
                isValid = false
            }
        }
        
        if isValid == true{
//            if self.preferAircraftId.count == 0{
//                CommonFunction.showToastMessage(msg: "Please select preferred aircraft", controller: self)
//                isValid = false
//            }
            if self.price != ""{
                if Int(self.price)! < 5000{
                    CommonFunction.showToastMessage(msg: "Price must be greater than or equal to $5000", controller: self)
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
        
        let fromIcao = (self.multiCityArr[0] as! MultiCitys).fromIcao
        let fromIfaa = (self.multiCityArr[0] as! MultiCitys).fromIfaa
        let fromIata = (self.multiCityArr[0] as! MultiCitys).fromIata
        
        let toIcao = (self.multiCityArr[0] as! MultiCitys).toIcao
        let toIfaa = (self.multiCityArr[0] as! MultiCitys).toIfaa
        let toIata = (self.multiCityArr[0] as! MultiCitys).toIata
        
        let sDate = self.departuerSelDateString
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
        seq["StartAirportICAO"] = fromIcao
        seq["EndAirportICAO"] = toIcao
        seq["StartAirportIATA"] = fromIata
        seq["EndAirportIATA"] = toIata
        seq["StartAirportIFAA"] = fromIfaa
        seq["EndAirportIFAA"] = toIfaa
        
    
        let crleg = NSMutableArray()
        crleg.add(seq)
        
        let aircraftId =  self.preferAircraftId.joined(separator: ",")
        
        let parameters = ["ChartererRequestID": self.charteredReqId!,
                          "UserID":0,
                          "StartAirportID":fromAirportId!,
                          "EndAirportID":toAirportId!,
                          "StartDateTime":self.departuerSelDateString!,
                          "StartTime":sTime!,
                          "EndDateTime":self.departuerSelDateString!,
                          "Distance":"0",
                          "Note":"",
                          "InstantBookOwnerAircraftID":self.instBookOwnderAircraftId! ,
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
        
        let fromIcao = (self.multiCityArr[0] as! MultiCitys).fromIcao
        let fromIfaa = (self.multiCityArr[0] as! MultiCitys).fromIfaa
        let fromIata = (self.multiCityArr[0] as! MultiCitys).fromIata
        
        let toIcao = (self.multiCityArr[0] as! MultiCitys).toIcao
        let toIfaa = (self.multiCityArr[0] as! MultiCitys).toIfaa
        let toIata = (self.multiCityArr[0] as! MultiCitys).toIata
        
        for i in 0...1{
            let seq = NSMutableDictionary()
            seq["SequenceID"] = i + 1
            if i == 0{
                seq["StartAirport"] = fromAirportId
                seq["EndAirport"] = toAirportId
                seq["StartAirportInfo"] = fromAirportInfo
                seq["EndAirportInfo"] = toAirportInfo
                seq["StartDateTime"] = self.departuerSelDateString
                seq["StartTime"] = self.departuerStartTime
                seq["EndDateTime"] = self.departuerSelDateString
                seq["StartAirportICAO"] = fromIcao
                seq["EndAirportICAO"] = toIcao
                seq["StartAirportIATA"] = fromIata
                seq["EndAirportIATA"] = toIata
                seq["StartAirportIFAA"] = fromIfaa
                seq["EndAirportIFAA"] = toIfaa
            }else{
                seq["StartAirport"] = toAirportId
                seq["EndAirport"] = fromAirportId
                seq["StartAirportInfo"] = fromAirportInfo
                seq["EndAirportInfo"] = toAirportInfo
                seq["StartDateTime"] = self.returnSelDateString
                seq["StartTime"] = self.returnStartTime
                seq["EndDateTime"] = self.returnSelDateString
                seq["StartAirportICAO"] = fromIcao
                seq["EndAirportICAO"] = toIcao
                seq["StartAirportIATA"] = fromIata
                seq["EndAirportIATA"] = toIata
                seq["StartAirportIFAA"] = fromIfaa
                seq["EndAirportIFAA"] = toIfaa
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
                          "StartDateTime":self.departuerSelDateString!,
                          "StartTime":self.departuerStartTime!,
                          "EndDateTime":self.departuerSelDateString!,
                          "Distance":"0",
                          "Note":"",
                          "InstantBookOwnerAircraftID":self.instBookOwnderAircraftId! ,
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
            
            let fromIcao = (self.multiCityArr[i] as! MultiCitys).fromIcao
            let fromIfaa = (self.multiCityArr[i] as! MultiCitys).fromIfaa
            let fromIata = (self.multiCityArr[i] as! MultiCitys).fromIata
            
            let toIcao = (self.multiCityArr[i] as! MultiCitys).toIcao
            let toIfaa = (self.multiCityArr[i] as! MultiCitys).toIfaa
            let toIata = (self.multiCityArr[i] as! MultiCitys).toIata
            
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
            seq["StartAirportICAO"] = fromIcao
            seq["EndAirportICAO"] = toIcao
            seq["StartAirportIATA"] = fromIata
            seq["EndAirportIATA"] = toIata
            seq["StartAirportIFAA"] = fromIfaa
            seq["EndAirportIFAA"] = toIfaa
            
            crleg.add(seq)
        }
        let fromAirportId = (self.multiCityArr[0] as! MultiCitys).fromId
        let toAirportId = (self.multiCityArr[0] as! MultiCitys).toId
        let aircraftId =  self.preferAircraftId.joined(separator: ",")
        let parameters = ["ChartererRequestID": self.charteredReqId!,
                          "UserID":0,
                          "StartAirportID":fromAirportId!,
                          "EndAirportID":toAirportId!,
                          "StartDateTime":self.departuerSelDateString!,
                          "StartTime":self.departuerStartTime!,
                          "EndDateTime":sDate,
                          "Distance":"0",
                          "Note":"",
                          "InstantBookOwnerAircraftID":self.instBookOwnderAircraftId! ,
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
    
    func checkOneWayRoundTripFields() -> Bool{
        
        let fromAirportId = (self.multiCityArr[0] as! MultiCitys).fromAdd
        if fromAirportId == ""{
            CommonFunction.showToastMessage(msg: "Please select airport start point", controller: self)
            return false
        }
        
        
        let toAirportId = (self.multiCityArr[0] as! MultiCitys).toAdd
        if toAirportId == ""{
            CommonFunction.showToastMessage(msg: "Please select airport end point", controller: self)
            return false
        }
        
        if fromAirportId == toAirportId{
            CommonFunction.showToastMessage(msg: "Please select different airport start and end point", controller: self)
            return false
        }
        
        if self.departuerDateStr == ""{
            CommonFunction.showToastMessage(msg: "Please select departure date", controller: self)
            return false
        }
        
        if self.departuerStartTime == ""{
            CommonFunction.showToastMessage(msg: "Please select departure time", controller: self)
            return false
        }
        
        if self.tripTypeIndex == 1{
            
            if self.returnDisplayDateStr == ""{
                CommonFunction.showToastMessage(msg: "Please select return date", controller: self)
                return false
            }
            
            if self.returnStartTime == ""{
                CommonFunction.showToastMessage(msg: "Please select return departure time", controller: self)
                return false
            }
        }
        
        if self.noOfPass == ""{
            CommonFunction.showToastMessage(msg: "Please enter no of passenger", controller: self)
            return false
        }else{
            
            if Int(self.noOfPass)! > 18{
                CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: "Maximum passenger(s) allowed is 18", aViewController: self) { OkAction in
                    //
                }
                return false
            }
        }
        
        if self.price == ""{
            CommonFunction.showToastMessage(msg: "Price must be greater than or equal to $5000", controller: self)
            return false
        }else{
           
            if Double(self.price)! < 5000{
                CommonFunction.showToastMessage(msg: "Price must be greater than or equal to $5000", controller: self)
                return false
            }
        }
        return true
    }
    
    func APICharterRequestSearchFlightByTailNumber(parameters:[String:Any]){
        
        self.view.makeToastActivity(.center)
        let sAirport = parameters["StartAirportID"] as! String
        let eAirport = parameters["EndAirportID"] as! String
        let sDate = parameters["StartDateTime"] as! String
        let eDate = parameters["EndDateTime"] as! String
        //let nPass = self.noOfPass!
        //let trailNo = self.tollNumber!
        var crLegDataStr = ""
        do {
            let crLegData = try JSONSerialization.data(withJSONObject: parameters["CRleg"]!)
            crLegDataStr = String(data: crLegData, encoding: .utf8)!
            print(crLegDataStr)
        } catch {
            print("JSON serialization failed: ", error)
        }
        
        //GET /api/ChartererRequest/SearchFlightByTailNumber
        var prameterStr = String(format: "startairport=\(sAirport)&endairport=\(eAirport)&startdate=\(sDate)&enddate=\(eDate)&noofpassengers=\(self.noOfPass!)&tailno=\(self.tollNumber!)&crLegs=%@",crLegDataStr)

        prameterStr = self.encodeURLString(prameterStr)!
        let urlStr = String(format: "%@/ChartererRequest/SearchFlightByTailNumber?%@", APIUrl.baseUrl,prameterStr)
        /*let param:[String:Any] = ["startairport":sAirport,
                          "endairport":eAirport",
                          "startdate":sDate,
                          "enddate":eDate,
                          "noofpassengers":nPass,
                          "tailno":trailNo,
                          "crLegs":CRLegStr!]*/
        APIChartererRequest.shared.searchFlightChartererRequest(urlStr: urlStr) { response in
            
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.data != nil{
                    self.bookFlightArr = response.data!
                    DispatchQueue.main.async { [self] in
                        self.instantBookTableView.reloadData()
                        self.perform(#selector(self.scrrollTable), with: nil, afterDelay: 0.5)
                    }
                }
            }else{
                
                if response.description != nil{
                    CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: response.description!, aViewController: self) { OkAction in
                        
                    }
                }
            }
            
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    @objc func scrrollTable(){
        self.instantBookTableView.scrollRectToVisible(CGRect(x: 0, y: 1000, width: self.instantBookTableView.frame.size.width, height: self.instantBookTableView.frame.size.height), animated: true)
    }
    
    func encodeURLString(_ urlString: String) -> String? {
        // Attempt to encode the URL string
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        return encodedString
    }
    
    func APICharterRequestInstantBookCall(parameters:[String:Any]){
        self.view.makeToastActivity(.center)
       
        //POST /api/ChartererRequest/InstantBook
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/InstantBook", APIUrl.baseUrl)
        
        APIChartererRequest.shared.postChartererRequest(urlStr: urlStr, param: parameters) { response in
            
            if response.result == "success"{
                if response.data != nil{
                    let data = response.data!
                    if data.status == 0{
                        if data.crleg != nil{
                            if data.crleg?.count != 0{
                                self.bookFlightResponseData = data
                                
                                if data.chartererRequestID != nil{
                                    self.chartererRequestID = data.chartererRequestID!
                                    self.APIGetBestOption()
                                }
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
    
    
    func APIGetBestOption(){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetDecimalNew/%d", APIUrl.baseUrl,self.chartererRequestID!)
    
        APIChartererRequest.shared.getChartererRequest(urlStr: getAPIUrl) { response in
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.data != nil{
                    
                    let acceptVC = RequestAcceptDetailVC.storyboardViewController()
                    //acceptVC.postResponseData = self.bookFlightResponseData
                    //acceptVC.delegate = self
                    acceptVC.isSplit = self.paymentSlpit
                    acceptVC.pendingResponseData = response.data!
                    if response.data!.CRSegments != nil{
                        acceptVC.crLegDetailsData = response.data!.CRSegments
                    }
                    acceptVC.charterReqId = self.chartererRequestID
                    acceptVC.charterRequestGetData = response.data!
                    acceptVC.aircraftName = self.selectedAircraftData.name!
                    acceptVC.lowestPrice = Float(self.selectedAircraftData.finalPrice!)
                    acceptVC.ownerMaxPaxCount =  response.data!.OwnerMaxPaxCount
                    self.navigationController?.pushViewController(acceptVC, animated: true)
                    
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

extension InstantBookVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if section == 0{
            return 2
        }else if section == 1{
            if self.tripTypeIndex == 0 || self.tripTypeIndex == 1{
                return self.tripTypeArr //oneway or Roundtrip
            }else{
                return self.multiCityArr.count + 1 //Multicity
            }
        }else if section == 2{
            return 3 //Passengers, Tall Number and slpit payments
        }else if section == 3{ // Get Price Button
            return 1
        }else{
            return self.bookFlightArr.count //Booking Detail
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            if indexPath.row == 0{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.HeaderImageCell, for: indexPath) as! HeaderImageCell
                
                return cell
                
            }else{ //Oneway / Round trip / Multicity
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell3, for: indexPath) as! HomeCell3
                
                cell.delegate = self
                cell.configuerCell(indexPath: indexPath, tripType: self.tripTypeIndex)
                return cell
            }
            
        }else if indexPath.section == 1{ //Form
            
            if self.tripTypeIndex == 1{ // Round Trip
                
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell1, for: indexPath) as! HomeCell1
                    
                    let city = self.multiCityArr[indexPath.row] as! MultiCitys
                    cell.configuerHomeCell1(indexPath: indexPath,data:city,tripTypeIndex: self.tripTypeIndex,prevData: MultiCitys(),isSwipe: self.isSwiped,isNewAdded: self.isNewAdded)
                    cell.delegate = self
                    return cell
                }else if indexPath.row == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell2, for: indexPath) as! HomeCell2
                    
                    cell.delegate = self
                    cell.configuerReturnDateCell(indexPath: indexPath, dateStr: self.returnDisplayDateStr!)
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
                            cell.configuerHomeCell1(indexPath: indexPath,data:city,tripTypeIndex: self.tripTypeIndex,prevData: pCity,isSwipe: self.isSwiped,isNewAdded: self.isNewAdded)
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
        }else if indexPath.section == 2{// Passengers and Tall Number
            
            if indexPath.row < 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestCell2, for: indexPath) as! HomeCell2
                
                cell.delegate = self
                cell.configuerPassengerTollNumberCell(indexPath: indexPath,noOfPass:self.noOfPass,tollNo: self.tollNumber)
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
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.CancelRequestCell, for: indexPath) as! CancelRequestCell
            
            cell.cancelReqBtn.tag = 1
            cell.cancelReqBtn.setTitle("Get Price".uppercased(), for: .normal)
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.InstantBookViewCell, for: indexPath) as! InstantBookViewCell
            cell.delegate = self
            let rowData = self.bookFlightArr[indexPath.row]
            cell.configuerInstantBookFlightCell(indexPath: indexPath, data:rowData)
            return cell
        }
    }
    
    @objc func showHint(_ sender:UIButton){
        CommonFunction.showToastMesage(msg: "You can share your trip expenses with the friends traveling with you.", title: "", duration: 8.0, point: CGPoint(x: instantBookTableView.frame.origin.x+200,y: instantBookTableView.frame.size.height - 100), controller: self)
        
        /*CommonFunction.showAlertMessage(aStrTitle: "", aStrMessage: "You can share your trip expenses with the friends traveling with you.", aViewController: self) { OkAction in
            //
        }*/
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 4{
            return 10.0
        }else{
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 4{
            return 10.0
        }else{
            return 0.1
        }
    }
}

extension InstantBookVC : InstantBookViewCellDelegate{
    
    func bookFlightBtnPressed(atIndex: Int) {
        
        self.view.endEditing(true)
        
        if self.bookFlightArr.count > 0{
            let bookFligtData = self.bookFlightArr[atIndex]
            self.selectedAircraftData = AirCraft(name: bookFligtData.Aircraft!,finalPrice: Float(bookFligtData.FinalAmount!))
            self.instBookOwnderAircraftId = bookFligtData.OwnerAircraftID!
            self.price = String(describing: bookFligtData.PriceExpectation!)
        }
        
        var message = ""
        var parameters:[String:Any]
        if self.tripTypeIndex == 0 || self.tripTypeIndex == 1{

            if self.checkOneWayRoundTripFields() == true{
            
                let fromAirportId = (self.multiCityArr[0] as! MultiCitys).fromAdd
                let toAirportId = (self.multiCityArr[0] as! MultiCitys).toAdd
               
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
                
                CommonFunction.showAlertMessageWithTitle(aStrTitle: "Confirm", aStrMessage: message, Oktitle: "Confirm", CancelTitle: "Cancel", aViewController: self) { cancelAction in
                    
                } OKActionTap: { OkAction in
                    
                    // call Get Price API
                    self.APICharterRequestInstantBookCall(parameters: parameters)
                }
            }
        }else if self.tripTypeIndex == 2{
            
            if self.checkMultiCityFields() == true{
                
                var mCities = ""
                for i in 0...self.multiCityArr.count - 1{
                    let city = self.multiCityArr[i] as! MultiCitys
                    let fromAirportId = city.fromAdd!
                    let toAirportId = city.toAdd!
                    let date = city.date!
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
                 //message = "Please confirm your bid for multicity journey starting from \(fromAirportId!) to \(toAirportId!) on \(self.departuerDateStr!)"
                
                CommonFunction.showAlertMessageWithTitle(aStrTitle: "Confirm", aStrMessage: message, Oktitle: "Confirm", CancelTitle: "Cancel", aViewController: self) { cancelAction in
                    
                } OKActionTap: { OkAction in
                    
                    if self.charteredReqId == 0{
                        //Call API Get Request
                        self.APICharterRequestInstantBookCall(parameters: parameters)
                    }
                }
            }
        }
    }
}

extension InstantBookVC : HomeCell1Delegate{
    
    func dateBtnPressed(atIndex: Int) {
        
        ASPicker.selectDate { date in
            //print(date)
            
            self.departureDateTimeStemps = date.timeIntervalSince1970
            self.departuerSelDate = date
            let formatter = DateFormatter()
            
            formatter.dateFormat = formate8
            let dateStr = formatter.string(from: date)
            //print(dateStr)
            
            //Confirm alert Dispaly Date
            self.departuerDateStr = dateStr
            self.cityData = self.multiCityArr[atIndex] as! MultiCitys
            self.cityData.date = dateStr
            self.cityData.timeStamps = date.timeIntervalSince1970
            self.cityData.departureDisplayDate = dateStr
            self.cityData.returnDate = ""
            
            //For API Field
            formatter.dateFormat = formate3
            self.departuerSelDateString = formatter.string(from: date)
            
            //Dispaly Departure Time
            //formatter.dateFormat = TimeFormat
            
            //For API Field
            //self.departuerStartTime = formatter.string(from: date)
            
        
            self.multiCityArr.replaceObject(at: atIndex, with: self.cityData)
            self.instantBookTableView.reloadData()
        }
    }
    
    func timeBtnPressed(onIndex: Int) {
        
        ASPicker.selectOption(dataArray: CommonFunction.getDepartureTime()) { value, atIndex in
            
            self.cityData = self.multiCityArr[onIndex] as! MultiCitys
            
            //Dispaly Departure Time
            self.cityData.startTime = value
            self.cityData.returnTime = ""
            
            //For API Field
            self.departuerStartTime = value
            
            self.multiCityArr.replaceObject(at: onIndex, with: self.cityData)
            self.instantBookTableView.reloadData()
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
        
        if self.tripTypeIndex == 1 || self.tripTypeIndex == 2{
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
                
                swipeData.date = originData.date
                swipeData.departureDisplayDate = originData.departureDisplayDate
                swipeData.returnDate = originData.returnDate
                swipeData.returnTime = originData.returnTime
                swipeData.startTime = originData.startTime
                self.isSwiped = true
                self.multiCityArr.replaceObject(at: atIndex, with: swipeData)
                self.instantBookTableView.reloadData()
            }
        }
    }
}

extension InstantBookVC : HomeCell2Delegate{
    
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
            self.instantBookTableView.reloadData()
        }
    }
    
    func returnDateBtnPressed(onIndex:Int) {
        self.view.endEditing(true)
        ASPicker.selectDate { date in
            //print(date)
            
            self.returnDateTimeStemps = date.timeIntervalSince1970
            self.returnSelDate = date
            let formatter = DateFormatter()
            formatter.dateFormat = formate8
            let dateStr = formatter.string(from: date)
            //print(dateStr)
            self.cityData = self.multiCityArr[onIndex] as! MultiCitys
            self.cityData.returnDate = dateStr
            self.multiCityArr.replaceObject(at: onIndex, with: self.cityData)
            self.returnDisplayDateStr = dateStr
            
            formatter.dateFormat = formate3
            self.returnSelDateString = formatter.string(from: date)
            self.instantBookTableView.reloadData()
        }
    }
    
    func setPassenger(pax: String) {
        self.noOfPass = pax
        self.instantBookTableView.reloadData()
    }
    
    func setTollNumber(tno: String) {
        self.tollNumber = tno
        self.instantBookTableView.reloadData()
    }
    
}

extension InstantBookVC : AircraftListDelegate{
    
    func didSelectedAircraft(data: AircraftsData,aircrafts:[String], aircraftIds: [String]) {
        self.preferAircrafts = aircrafts
        self.preferAircraftId = aircraftIds
        print(self.preferAircrafts)
        print(self.preferAircraftId)
    }
    
    func doneBtnPressed() {
        self.instantBookTableView.reloadData()
    }
}

extension InstantBookVC : AirportListDelegate{
    
    func didSelectedAirport(data: AirportData, optionIndex: Int,atIndex:Int) {
        print(data)
        self.cityData = self.multiCityArr[atIndex] as! MultiCitys
        print(self.cityData)
        if optionIndex == 0{
            self.cityData.fromAdd = data.displayLine1!
            self.cityData.fromSubAdd = String(format: "%@", data.displayLine2!)
            self.cityData.fromId = data.code!
            self.cityData.fromIcao = data.icao!
            self.cityData.fromIata = data.iata!
            self.cityData.fromIfaa = data.ifaa!
        }else{
            self.cityData.toAdd = data.displayLine1!
            self.cityData.toSubAdd = String(format: "%@", data.displayLine2!)
            self.cityData.toId = data.code!
            self.cityData.toIcao = data.icao!
            self.cityData.toIata = data.iata!
            self.cityData.toIfaa = data.ifaa!
        }
        self.multiCityArr.replaceObject(at: atIndex, with: self.cityData)
        //print(self.multiCityArr[atIndex])
        
        if self.tripTypeIndex == 2{
            
            if self.multiCityArr.count > 1 && self.multiCityArr.count > (atIndex + 1){
                if optionIndex == 1{
                    self.cityData = self.multiCityArr[atIndex+1] as! MultiCitys
                    self.cityData.fromAdd = data.displayLine1!
                    self.cityData.fromSubAdd = String(format: "%@", data.displayLine2!)
                    self.cityData.fromId = data.code!
                    self.cityData.fromIcao = data.icao!
                    self.cityData.fromIata = data.iata!
                    self.cityData.fromIfaa = data.ifaa!
                    self.multiCityArr.replaceObject(at: atIndex+1, with: self.cityData)
                }
            }
        }
        
        self.instantBookTableView.reloadData()
    }
}

extension InstantBookVC : HomeCell3Delegate{
    
    func typeBtnPressed(button: UIButton) {
        //print(button.tag)
        
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
            self.tripTypeArr = 3
        }else{
            self.tripTypeArr = 2 //multicity not require now
        }
        self.bookFlightArr.removeAll()
        instantBookTableView.reloadData()
    }
}

extension InstantBookVC : CancelRequestCellDelegate{
    
    func getPriceBtnPressed(){
//        print(self.departuerDateStr)
//        print(self.departuerSelDateString)
//        print(self.departuerStartTime)
//        print(self.noOfPass)
//        print(self.tollNumber)
        
        self.view.endEditing(true)
        //var message = ""
        var parameters:[String:Any]
        if self.tripTypeIndex == 0 || self.tripTypeIndex == 1{

            if self.checkOneWayRoundTripFields() == true{
                if self.tripTypeIndex == 0{
                    parameters = self.getOnewayParam()
                }else {
                    if self.returnDisplayDateStr == ""{
                        CommonFunction.showToastMessage(msg: "Please select return date", controller: self)
                        return
                    }
                    
                    if self.departureDateTimeStemps > self.returnDateTimeStemps{
                        
                        CommonFunction.showToastMessage(msg: "Return date must be later than Departure date", controller: self)
                        return
                    }
                    parameters = self.getRoundTripParam()
                }
                self.APICharterRequestSearchFlightByTailNumber(parameters: parameters)
            }
        }else if self.tripTypeIndex == 2{
            
            if self.checkMultiCityFields() == true{
                let parameters = self.getMultiCityParam()
                self.APICharterRequestSearchFlightByTailNumber(parameters: parameters)
            }
        }
    }
}

extension InstantBookVC : MultiCityCellDelegate{
    
    func addNewLeg() {
        //
        self.addNewSection1Data()
        self.instantBookTableView.reloadData()
    }
    
    func removeLeg() {
        //
        if self.self.multiCityArr.count > 1{
            self.multiCityArr.removeLastObject()
            self.instantBookTableView.reloadData()
        }
    }
}

extension InstantBookVC : SplitPaymentCellDelegate{
    
    func splitBtnPressed(isSplit: Bool) {
        print(isSplit)
        
        if isSplit {
            self.paymentSlpit = 1
        }else{
            self.paymentSlpit = 0
        }
    }
}
