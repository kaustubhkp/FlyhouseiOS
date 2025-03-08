//
//  RequestConfirmDetailVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

let OFFER_TIME = 90
let ACCEPT_TIME = 1800

struct AirCraft{
    var name:String?
    var finalPrice:Float?
}

struct BestMoreOptions {
    var title: String
    var records:[MoreOptionsData] //[CharterReqData]
    var selected:[Int]
    var isExpanded: Bool
}

// Define the structure that matches the JSON objects you want to send
struct SaveSelectedOption: Codable {
    let ChartererRequestID: Int
    let Section: String
    let PrefID: Int
    let OwnerAircraftID: Int
}

protocol RequestConfirmDetailVCDelegate {
   
   func cancelRequest()
}

class RequestConfirmDetailVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .RequestConfirm

    var delegate:RequestConfirmDetailVCDelegate?
    var titleStr:String! = "Confirmed Request"
    var isFrom:String! = "Request"
    
    @IBOutlet weak var cancelBtn:UIButton!
    @IBOutlet weak var noCurrentDataLabel:UILabel!
    @IBOutlet weak var createNewBtn:UIButton!
    @IBOutlet weak var noCurrentDataView:UIView!
    @IBOutlet var imageToNoCurrentDataView:NSLayoutConstraint!
    @IBOutlet var imageToTableView:NSLayoutConstraint!
    
    @IBOutlet weak var legCollectionView:UICollectionView!
    @IBOutlet weak var requestConfDetailTable:UITableView!
    @IBOutlet weak var bottomBorder:UILabel!
    var legSelectedIndex:Int! = 0
    @IBOutlet var tableViewTopConstraintToSuperview:NSLayoutConstraint!
    @IBOutlet var tableViewTopToLegColloeectionView:NSLayoutConstraint!
    
    @IBOutlet weak var tableViewToBottomSuperview:NSLayoutConstraint!
    @IBOutlet weak var tableViewToBottomButtonView:NSLayoutConstraint!
    @IBOutlet weak var bottomButtonView:UIView!
    
    @IBOutlet weak var selectAnotherPriceBtn:UIButton!
    @IBOutlet weak var nextButton:UIButton!
    var currentSelectPriceData = NSMutableArray()
    var selectedThisPriceIndexArr = NSMutableArray()
    var isSelectedThisPrice:Bool! = false
    
    var postResponseData:CharterreResponse!
    var pendingResponseData:CharterReqData!
    var crLegDetailsData = [CRlegDetailData]()
    var typeIndex:Int! = 0
    var logData = NSMutableArray()
    var bestOptions = [CharterReqData]()
    var moreOptions = [CharterReqData]()
    var requestedData = RequestingLog()
    var noBidMessageStr:String! = ""
    var bestOption = CharterReqData()
    
    var timeSecond : Int = 0 // in seconds
    var timerOffer:Timer!
    var callAPISeconds:Int! = 0
    
    var getReadyTime:Int = 0
    var timeStr:String! = "GET READY"
    var timeAcceptLabelString:String! = ""
    var currentOfferPrice:String! = "--"
    
    var acceptTimeSecond : Int = 0 // second
    var acceptTimer:Timer!
    var acceptTimerStr:String! = "Fetching..."
    
    var selectedAircraftData = AirCraft()
    var chartererRequestID:Int?
    var isSPlitPayment:Int! = 0
    var isCalledAPI:Bool! = false
    var ownerMaxPaxCount:Int! = 0
    
    var crBestMoreOptionsData = [BestAndMoreOptionData]()
    var bestMoreOptions = [BestMoreOptions]()
    var moreOption = CharterReqData() //[MoreOptionsData]()
    var selectedIndexPaths = NSMutableArray()
    var selectedIndexesData = NSMutableArray()
    var isExpnadedAndPreview:Bool! = false
    var expandedIndexPath:IndexPath!
    var totalRoutWayPathSections:Int! = 0
    var totalFlightAmt:Double! = 0.00
    
    var minBidPrice:Double! = 0.0
    var maxBidPrice:Double! = 0.0
    
    @IBOutlet weak var cancelReqBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        // Do any additional setup after loading the view.
        super.setNavigationTitle(title: titleStr)
        
        if self.isFrom == "Request"{
            super.setBackButton(viewC: self)
            super.delegateNav = self
        }
        
        CommonFunction.setRoundedButtons(arrayB: [cancelBtn], radius: cancelBtn.frame.size.height/2, borderColorCode: blackColorCode, borderW: 1, bgColor: "", textColor: blackColorCode)
        
        CommonFunction.setRoundedButtons(arrayB: [selectAnotherPriceBtn], radius: self.selectAnotherPriceBtn.frame.size.height/2, borderColorCode: blackColorCode, borderW: 1, bgColor: "", textColor: blackColorCode)
        
        CommonFunction.setRoundedButtons(arrayB: [nextButton], radius: self.nextButton.frame.size.height/2, borderColorCode: "", borderW: 0, bgColor: blackColorCode, textColor: whiteColorCode)
        
        CommonFunction.setLabelsFonts(lbls: [noCurrentDataLabel], type: .fReguler, size: 11)
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [createNewBtn,selectAnotherPriceBtn], size: 11, type: .fReguler, textColor: UIColor.black)
        
        CommonFunction.setButtonFontsTypeWithSize(arrayB: [nextButton], size: 11, type: .fReguler, textColor: UIColor.hexStringToUIColor(hex: whiteColorCode))
        
        
        legCollectionView.register(UINib(nibName: CollectionViewCells.legCollectionCell, bundle: nil), forCellWithReuseIdentifier: CollectionViewCells.legCollectionCell)
        self.hideLegCollectionView()
        self.hideNoCurrentDataView()
        
        requestConfDetailTable.register(UINib(nibName: TableCells.PastRequestTblCell, bundle: nil), forCellReuseIdentifier: TableCells.PastRequestTblCell)
        
        requestConfDetailTable.register(UINib(nibName: TableCells.RequestDetailCell, bundle: nil), forCellReuseIdentifier: TableCells.RequestDetailCell)
        
        requestConfDetailTable.register(UINib(nibName: TableCells.RequestBestOptionCell, bundle: nil), forCellReuseIdentifier: TableCells.RequestBestOptionCell)
        
        requestConfDetailTable.register(UINib(nibName: TableCells.CancelRequestCell, bundle: nil), forCellReuseIdentifier: TableCells.CancelRequestCell)
        
        requestConfDetailTable.register(UINib(nibName: TableCells.SubmitButtonCell, bundle: nil), forCellReuseIdentifier: TableCells.SubmitButtonCell)
        
        requestConfDetailTable.register(UINib(nibName: TableCells.SourceToDestHeaderCell, bundle: nil), forCellReuseIdentifier: TableCells.SourceToDestHeaderCell)
        
        requestConfDetailTable.register(UINib(nibName: TableCells.BestAndMoreOptionCell, bundle: nil), forCellReuseIdentifier: TableCells.BestAndMoreOptionCell)
        
        CommonFunction.setBottomGradientShadowToView(vC: self)
        self.hideSubmitButtonView()
        //self.setupDynamicMoreOptionData(cData: [BestAndMoreOptionData]())
        if self.postResponseData != nil{
            if self.postResponseData.chartererRequestID != nil{
                self.chartererRequestID = self.postResponseData.chartererRequestID!
                self.APIGetChartererRequestCall()
            }
            
        }else if self.pendingResponseData != nil{
            self.timeStr = "Fetching..."
            
            self.chartererRequestID = self.pendingResponseData.ChartererRequestID!
            print(self.pendingResponseData.IsSplitPayment!)
            
            self.getReadyTimerAPI(id: self.chartererRequestID!)
            //self.getCharterdReqAuctionTime(id: self.chartererRequestID!)
            
            if UserDefaults.standard.object(forKey: "planAnimationLastPoint") != nil {
                var point = UserDefaults.standard.object(forKey: "planAnimationLastPoint") as! CGFloat
                point += 4
                UserDefaults.standard.set(point, forKey: "planAnimationLastPoint")
            }
            
        }else{
            self.APIPostCOpenRequestCall()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        if self.timerOffer != nil{
            self.timerOffer.invalidate()
            self.timerOffer = nil
        }
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func setTableDelegateAndDataSource(){
        requestConfDetailTable.delegate = self
        requestConfDetailTable.dataSource = self
    }
    
    func showNoCurrentDataView(){
        
        self.hideSubmitButtonView()
        self.cancelBtn.isHidden = true
        self.hideLegCollectionView()
        self.requestConfDetailTable.isHidden = true
        //self.imageToNoCurrentDataView.priority = UILayoutPriority(999)
        //self.imageToTableView.priority = UILayoutPriority(250)
        self.noCurrentDataView.isHidden = false
    }
    
    func showSubmitButtonView(){
        
        self.tableViewToBottomSuperview.priority = UILayoutPriority(250)
        self.tableViewToBottomButtonView.priority = UILayoutPriority(999)
        self.bottomButtonView.isHidden = false
        self.cancelBtn.isHidden = true
    }
    
    func hideSubmitButtonView(){
        
        self.tableViewToBottomSuperview.priority = UILayoutPriority(999)
        self.tableViewToBottomButtonView.priority = UILayoutPriority(250)
        self.bottomButtonView.isHidden = true
        self.cancelBtn.isHidden = false
    }
    
    func hideNoCurrentDataView(){
        
        //self.requestConfDetailTable.isHidden = false
        //self.imageToNoCurrentDataView.priority = UILayoutPriority(250)
        //self.imageToTableView.priority = UILayoutPriority(999)
        self.noCurrentDataView.isHidden = true
    }
    
    func showLegCollectionView(){
        
        self.bottomBorder.isHidden = false
        self.legCollectionView.isHidden = false
        self.tableViewTopConstraintToSuperview.priority = UILayoutPriority(250)
        self.tableViewTopToLegColloeectionView.priority = UILayoutPriority(999)
    }
    
    func hideLegCollectionView(){
        
        self.bottomBorder.isHidden = true
        self.legCollectionView.isHidden = true
        self.tableViewTopConstraintToSuperview.priority = UILayoutPriority(999)
        self.tableViewTopToLegColloeectionView.priority = UILayoutPriority(250)
    }
    
    func APIGetCurrentBidPrice(){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetCurrentBidPrice/%d", APIUrl.baseUrl,self.chartererRequestID!)
        
        APIChartererRequest.shared.getCurrentBidPrice(urlStr: getAPIUrl) { response in
            
            //if self.timeSecond == OFFER_TIME{
               // self.showTimer()
            //}
            if response.result == "success"{
                if response.data != nil{
                    if response.data! != 0{
                        let amount = CommonFunction.getCurrencyValue(amt: Float((response.data!)), code: CURRENCY_CODE)
                        self.currentOfferPrice = amount
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
            //CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in}
        }

        
    }
    
    func APIGetChartererRequestCall(){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetDecimalNew/%d", APIUrl.baseUrl,self.chartererRequestID!)
                
       // self.view.makeToastActivity(.center)
        APIChartererRequest.shared.getChartererRequest(urlStr: getAPIUrl) { response in
            
            if response.result == "failed" {
                
                if response.title != nil && response.description != nil{
                    CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                        
                    }
                }
                return
            }
            
            if response.data != nil {
                
                self.getReadyTimerAPI(id: self.chartererRequestID!)
                
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
                
                
                let postData = CharterreResponse(chartererRequestID: response.data?.ChartererRequestID!,distance: response.data?.Distance,endAirportID: response.data?.EndAirportID,endDateTime: response.data?.EndDateTime,note: response.data!.Note,paxCount: response.data?.PaxCount,paxSegment: response.data!.PaxSegment,preferredAircraftIDCSV: response.data?.PreferredAircraftIDCSV,priceExpectation: response.data!.PriceExpectation,startAirportID: response.data!.StartAirportID,startDateTime: response.data!.StartDateTime, startTime:response.data!.StartTime,status: response.data!.Status,requestTypeID: response.data!.RequestTypeID,requestTypeToUseID: response.data!.RequestTypeToUseID,estimatedTimeInMinute: response.data!.EstimatedTimeInMinute,crleg: cRleg)
                
                self.postResponseData = postData
                
                if response.data!.MinBidPrice != nil{
                    self.minBidPrice = response.data!.MinBidPrice!
                }
                
                if response.data!.MaxBidPrice != nil{
                    self.maxBidPrice = response.data!.MaxBidPrice!
                }
                
                if response.data!.OwnerMaxPaxCount != nil{
                    self.ownerMaxPaxCount = response.data?.OwnerMaxPaxCount
                }
                DispatchQueue.main.async {
                    self.requestConfDetailTable.reloadData()
                }
                
                if response.data?.CurrentBidAmount != 0.0{
                    let amount = CommonFunction.getCurrencyValue(amt: Float((response.data?.CurrentBidAmount!)!), code: CURRENCY_CODE)
                    self.currentOfferPrice = amount
                }
            } else {
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
    //More Option Price
    /*func APIGetMoreOptions(){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetPreferredBids/%d", APIUrl.baseUrl,self.chartererRequestID!)
        
        APIChartererRequest.shared.getPreferredBidsChartererRequest(urlStr: getAPIUrl) { response in
            
            if response.result == "success" {
                if response.data != nil{
                    if response.data!.count > 0{
                        self.moreOptions = response.data!
                        self.bestMoreOptions.removeAll()
                        self.setupDynamicMoreOptionData(cData: response.data!)
                        DispatchQueue.main.async {
                            self.requestConfDetailTable.reloadData()
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
    }*/
    
    
    /*func setupDynamicMoreOptionData(cData:[CharterReqData]){
        
        let section0 = BestMoreOptions(title: "", records: [], isExpanded: true)
        let section1 = BestMoreOptions(title: "", records: [], isExpanded: true)
        self.bestMoreOptions.append(section0)
        self.bestMoreOptions.append(section1)
        if cData.count > 0{
            for i in 0...cData.count - 1{
                
                self.moreOption = self.moreOptions[i]
                
                let titleStr = String(format: "%@ to %@", self.moreOption.StartAirportID!,self.moreOption.EndAirportID!)
                let bestMoreOption = BestMoreOptions(title: titleStr, records: cData, isExpanded: false)
                self.bestMoreOptions.append(bestMoreOption)
            }
        }
        let sectionLast = BestMoreOptions(title: "", records: [], isExpanded: true)
        self.bestMoreOptions.append(sectionLast)
        DispatchQueue.main.async {
            self.requestConfDetailTable.reloadData()
        }
    }*/
    
    func setupDynamicMoreOptionData(cData:[BestAndMoreOptionData]){
        self.totalRoutWayPathSections = 0
        
        //let section0 = BestMoreOptions(title: "", records: [],selected: [], isExpanded: true)
        //let section1 = BestMoreOptions(title: "", records: [],selected: [], isExpanded: true)
        //self.bestMoreOptions.append(section0)
        //self.bestMoreOptions.append(section1)
        if cData.count > 0{
            for i in 0...cData.count - 1{
                var bestRecord = [MoreOptionsData]()
                var selectedVal = [Int]()
                //Best Option
                let bestOption = cData[i]
                self.totalFlightAmt += bestOption.finalAmount!
                if bestOption.requestTypeToUseID != 4{
                    self.totalRoutWayPathSections += 1
                    let titleStr = String(format: "%@ to %@", bestOption.startAirportID!,bestOption.endAirportID!)
                    let bestOpt = MoreOptionsData(ID:0,ChartererRequestID:bestOption.chartererRequestID,StartAirportID: bestOption.startAirportID, StartDateTime: "", EndAirportID: bestOption.endAirportID,EndDateTime:"",EstimatedTimeInMinute:0,FinalAmount: bestOption.finalAmount,IsChildRequest: bestOption.isChildRequest,IsPartnerAircraft: bestOption.isPartnerAircraft,OwnerAircraftID: bestOption.ownerAircraftID,OwnerID: bestOption.ownerID,ParentRequestID: bestOption.parentRequestID, PreferredAircraft: bestOption.ownerAircraft, PreferredAircraftID: 0, PreferredAircraftType:bestOption.aircraftType, RatingImageCSV: bestOption.ratingImageCSV, RequestTypeID: bestOption.requestTypeID, RequestTypeToUseID: bestOption.requestTypeToUseID, WinningPrice:0,PartnerProfileRatings: bestOption.partnerProfileRatings)
                    bestRecord.append(bestOpt)
                    selectedVal.append(0)
                    //More Options
                    if cData[i].crMoreOptionsPricing != nil{
                        let crMoreDatas = cData[i].crMoreOptionsPricing!
                        for j in 0...crMoreDatas.count - 1{
                            bestRecord.append(crMoreDatas[j])
                            selectedVal.append(0)
                        }
                    }
                    if bestOption.requestTypeToUseID == 2{
                        let mOption = BestMoreOptions(title: titleStr, records: bestRecord,selected: selectedVal, isExpanded: true)
                        self.bestMoreOptions.append(mOption)
                    }else{
                        let mOption = BestMoreOptions(title: titleStr, records: bestRecord,selected: selectedVal, isExpanded: false)
                        self.bestMoreOptions.append(mOption)
                    }
                }
            }
        }
        
        if self.bestMoreOptions.count > 1{
            legCollectionView.delegate = self
            legCollectionView.dataSource = self
            legCollectionView.reloadData()
            self.showLegCollectionView()
        }else{
            self.hideLegCollectionView()
        }
        //let submitBtnSec = BestMoreOptions(title: "", records: [],selected: [], isExpanded: true)
        //self.bestMoreOptions.append(submitBtnSec)
        //let cancelBtnSec = BestMoreOptions(title: "", records: [],selected: [], isExpanded: true)
        //self.bestMoreOptions.append(cancelBtnSec)
        DispatchQueue.main.async {
            self.requestConfDetailTable.reloadData()
        }
    }
    
    //More Options
    func APIGetBestOption(){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetDecimalNew/%d", APIUrl.baseUrl,self.chartererRequestID!)
        
        // self.view.makeToastActivity(.center)
        APIChartererRequest.shared.getChartererRequest(urlStr: getAPIUrl) { response in
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.data != nil{
                    
                    if response.data!.Status != nil{
                        //if response.data!.Status != 3 && response.data!.FinalAmount! > 0 {
                            //self.APIGetMoreOptions()
                            
                        if self.isExpnadedAndPreview == false{
                            self.getBestAndMoreOptions(id: self.chartererRequestID!)
                        }
                            self.showAcceptTimer()
                            self.setTableDelegateAndDataSource()
                            
                            if response.data?.IsSplitPayment != nil{
                                self.isSPlitPayment = response.data!.IsSplitPayment!
                            }
                            self.ownerMaxPaxCount =  response.data!.OwnerMaxPaxCount
                            
                            let amount = CommonFunction.getCurrencyValue(amt: Float((response.data?.CurrentBidAmount!)!), code: CURRENCY_CODE)
                            self.currentOfferPrice = amount
                            
                            self.bestOption = response.data!
                            self.bestOptions.removeAll()
                            self.bestOptions.append(self.bestOption)
//                        }else{
//                            let noAircraftMsgVC = CurrentRequestVC.storyboardViewController()
//                            self.navigationController?.pushViewController(noAircraftMsgVC, animated: false)
//                        }
                    }
                    
                }else {
                    if response.title != nil && response.description != nil{
                        CommonFunction.showAlertMessage(aStrTitle: response.title!, aStrMessage: response.description!, aViewController: self) { OkAction in
                            //self.navigationController?.popToRootViewController(animated: false)
                            APP_DELEGATE.createMenuView()
                            return
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.requestConfDetailTable.reloadData()
                }
            }
            
        } fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    func APICharterUpdatePreferredWinningBidCall(id:Int){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/UpdatePreferredWinningBid?choosenpreferredid=%d", APIUrl.baseUrl,id)
        
        let parameters = ["choosenpreferredid":id] as [String: Any]
                
        self.view.makeToastActivity(.center)
        APIChartererRequest.shared.updatePreferredWinningBid(urlStr: getAPIUrl,param: parameters) { response in
            
            self.view.hideToastActivity()
            
                if response.result == "success"{
                    if response.data == true{
                        let acceptVC = RequestAcceptDetailVC.storyboardViewController()
                        
                        //for last confrim screen
                        acceptVC.ownerMaxPaxCount = self.ownerMaxPaxCount
                        acceptVC.charterRequestGetData = self.bestOption
                        
                        if self.postResponseData != nil{
                            acceptVC.postResponseData = self.postResponseData
            
                        }else{
                            
                            acceptVC.crLegDetailsData = self.crLegDetailsData
                            acceptVC.pendingResponseData = self.pendingResponseData
                            
                        }
                        acceptVC.delegate = self
                        acceptVC.isSplit = self.isSPlitPayment
                        acceptVC.charterReqId = self.chartererRequestID!
                        acceptVC.aircraftName = self.selectedAircraftData.name!
                        acceptVC.lowestPrice = Float(self.selectedAircraftData.finalPrice!)
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
    
    /*===========Current Request APIs========*/
    
    func fetchAcceptionTime(){
        if self.acceptTimer != nil{
            self.acceptTimerStr = "Fetching..."
            self.acceptTimer.invalidate()
            self.acceptTimer = nil
            self.setRemainingTimerAPI(id: self.chartererRequestID!)
        }
    }
    
    func fetchOfferTime(){
        if self.timerOffer != nil{
            self.timeStr = "Fetching..."
            self.timerOffer.invalidate()
            self.timerOffer = nil
            //self.getCurrentRequest()
            self.getCharterdReqAuctionTime(id:self.chartererRequestID!)
        }
    }
    
    @objc func applicationDidBecomeActive(_ notification: NotificationCenter){
        
        if isCalledAPI == false{
            //self.requestConfDetailTable.isHidden = true
            if self.timeSecond > 0{
                self.fetchOfferTime()
            }else if acceptTimeSecond > 0{
                self.fetchAcceptionTime()
            }else{
                self.timeStr = "GET READY"
                self.getReadyTimerAPI(id: self.chartererRequestID!)
            }
            self.isCalledAPI = true
            self.requestConfDetailTable.reloadData()
        }
    }
    
    @objc func applicationDidEnterBackground(_ notification: NotificationCenter){
        self.isCalledAPI = false
        if self.pendingResponseData != nil{
            UserDefaults.standard.set(self.pendingResponseData.ChartererAcceptanceTimeMilliseconds!, forKey: "ChartererAcceptanceTimeMilliseconds")
            UserDefaults.standard.synchronize()
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
                        self.timeUpHideTable()
                        self.removeCharterRequestID()
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
    
    func APIGetChartererRequestCall(id:Int){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetDecimalNew/%d", APIUrl.baseUrl,id)
                
       // self.view.makeToastActivity(.center)
        APIChartererRequest.shared.getChartererRequest(urlStr: getAPIUrl) { response in
            
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.data != nil{
                    
                    
                    if  response.data!.ChartererAcceptanceTimeInSeconds != nil{
                        
                        
                        if response.data!.ChartererAcceptanceTimeInSeconds! != ""{
                            if Int(response.data!.ChartererAcceptanceTimeInSeconds!)! > 0{
                                
                                
                                
                                self.pendingResponseData = response.data!
                                self.chartererRequestID = response.data!.ChartererRequestID!
                                
                                if self.pendingResponseData.ChartererAcceptanceTimeMilliseconds != nil{
                                    
                                    if Int(self.pendingResponseData.ChartererAcceptanceTimeMilliseconds!)! > 0{
                                        if Int(self.pendingResponseData.ChartererAcceptanceTimeMilliseconds!) == 9000000{
                                            
                                            self.APIGetBestOption()
                                            //self.APIGetMoreOptions()
                                            self.getBestAndMoreOptions(id: self.chartererRequestID!)
                                            self.timeSecond = 0
                                            self.acceptTimeSecond = 0
                                            print("TIME UP!")
                                        }else{
                                            
                                            
                                            self.getReadyTimerAPI(id: response.data!.ChartererRequestID!)
                                            //self.getCharterdReqAuctionTime(id:response.data!.ChartererRequestID!)
                                        }
                                    }else{
                                        self.APIGetBestOption()
                                        //self.APIGetMoreOptions()
                                        self.getBestAndMoreOptions(id: self.chartererRequestID!)
                                        self.timeSecond = 0
                                        self.acceptTimeSecond = 0
                                        print("TIME UP!")
                                    }
                                }
                                
                                if response.data!.CRSegments != nil{
                                    //set list
                                    self.crLegDetailsData = response.data!.CRSegments!
                                    
                                    DispatchQueue.main.async {
                                        self.requestConfDetailTable.reloadData()
                                    }
                                }
                            }else{
                                self.timeUpHideTable()
                                self.removeCharterRequestID()
                            }
                        }else{
                            self.timeUpHideTable()
                            self.removeCharterRequestID()
                        }
                    }else{
                        self.timeUpHideTable()
                        self.removeCharterRequestID()
                    }
                    
                }else{
                    self.timeUpHideTable()
                    self.removeCharterRequestID()
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
    
    func removeCharterRequestID(){
        self.view.hideToastActivity()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.ChartererRequestID)
        UserDefaults.standard.synchronize()
    }
    
    func setRemainingTimerAPI(id:Int){
        
        self.view.makeToastActivity(.center)
        let urlStr = String(format: "%@/ChartererRequest/GetChartererAcceptanceTime?chartererrequestid=%d",APIUrl.baseUrl,id)
    
        APIChartererRequest.shared.getChartererReqAuctionRemTime(urlStr: urlStr) { response in
            
            if response.result == "success" {
                //Set Timer
                if response.data != nil{
                    if response.data! > 0{
                        
                        self.acceptTimeSecond = response.data!
                        self.timeStr = "Getting results"
                        self.requestConfDetailTable.reloadData()
                        let seconds = 5.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            self.APIGetBestOption()
                        }
                        
                    }else{
                        self.view.hideToastActivity()
                        self.acceptTimeSecond = 0
                        self.perform(#selector(self.timeUpHideTable), with: nil, afterDelay: 3.0)
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
        
        /*var TimeMilliseconds = "0"
        if UserDefaults.standard.value(forKey: "ChartererAcceptanceTimeMilliseconds") != nil{
            TimeMilliseconds = (UserDefaults.standard.value(forKey: "ChartererAcceptanceTimeMilliseconds") as! String)
        }else{
            TimeMilliseconds = self.pendingResponseData.ChartererAcceptanceTimeMilliseconds!
        }
        let AcceptTimerMin = Int(TimeMilliseconds)!/1000
        //print("Time to Accept Min :\(AcceptTimerMin)")
        //let firstTimerTime = auctionEndTime! - currTime!
        if AcceptTimerMin <= 1800{
            
            self.timeSecond = 0
            // 5 min timer stop and start for 30 min timer
            //calculate minutes from miliseconds
            if AcceptTimerMin <= 1800 && AcceptTimerMin > 0 {
                
                self.acceptTimeSecond = AcceptTimerMin
                self.APIGetBestOption()
                self.APIGetMoreOptions()
                self.showAcceptTimer()
                
            }else{
                self.acceptTimeSecond = 0
                //Time Up Message
            }
        }else{
            self.startGetReadyTimer()
        }*/
    }
    
    func getReadyTimerAPI(id:Int){
        
        self.view.makeToastActivity(.center)
        let urlStr = String(format: "%@/ChartererRequest/GetReadyTimer?chartererrequestid=%d",APIUrl.baseUrl,id)
        
        APIChartererRequest.shared.getReadyTime(urlStr: urlStr) { response in
            self.view.hideToastActivity()
            if response.result == "success" {
                //Set Timer
                if response.data != nil{
                    if response.data! > 0{
                        
                        self.timeSecond = 0
                        self.getReadyTime = response.data!
                        self.showGetReadyTimer()
                        self.setTableDelegateAndDataSource()
                    }else{
                        self.getReadyTime = 0
                        self.getCharterdReqAuctionTime(id:self.chartererRequestID!)
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
            
        }fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    func startGetReadyTimer(){
        
        let cDate = CommonFunction.getOriginalDateFromString(dateStr: self.pendingResponseData.CurrentDateTime!, format: formate3)
        
        let eDate = CommonFunction.getOriginalDateFromString(dateStr: self.pendingResponseData.AuctionEndTime!, format: formate3)
        
        self.timeSecond = CommonFunction.getSecondsFromDate(sDate: cDate,eDate: eDate)
        self.showTimer()
    }
    
    func APICheckCharterRequestStatusCall(){
        
        self.view.makeToastActivity(.center)
       
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/CheckCharterRequestStatus?charterrequestid=%d",APIUrl.baseUrl,self.postResponseData.chartererRequestID!)
        
        APIChartererRequest.shared.checkChartererRequestStatus(urlStr: urlStr) { response in
            
            self.view.hideToastActivity()
            if response.result == "success" && response.data == 0{
                self.view.hideToastActivity()
                
                if response.description != nil{
                    self.noCurrentDataLabel.text = response.description!
                }
                self.timeUpHideTable()
                self.removeCharterRequestID()
                
            }else if response.result == "success" && response.data == 1{
                
                    self.timeSecond = OFFER_TIME
                    self.showTimer()
                
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

    func getCharterdReqAuctionTime(id:Int){
        
        self.view.makeToastActivity(.center)
        let urlStr = String(format: "%@/ChartererRequest/GetChartererAuctionRemainingTime?chartererrequestid=%d",APIUrl.baseUrl,id)
    
        APIChartererRequest.shared.getChartererReqAuctionRemTime(urlStr: urlStr) { response in
            
            self.view.hideToastActivity()
            if response.result == "success" {
                //Set Timer
                if response.data != nil{
                    if response.data! > 0{
                        
                        self.timeStr = ""
                        self.timeSecond = response.data!
                        
                        if UserDefaults.standard.object(forKey: "planAnimationLastPoint") != nil {
                            
                            let speed = UserDefaults.standard.object(forKey: "planAnimationSpeed") as! CGFloat
                            let point = ((CGFloat(OFFER_TIME) - CGFloat(self.timeSecond)) * speed)
                            UserDefaults.standard.set(point, forKey: "planAnimationLastPoint")
                            UserDefaults.standard.synchronize()
                        }
                        self.showTimer()
                        self.setTableDelegateAndDataSource()

                    }else{
                        
                        self.timeSecond = 0
                        self.setRemainingTimerAPI(id:self.chartererRequestID!)
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
    
    func getBestAndMoreOptions(id:Int){
        
        //finalcode
        let getAPIUrl = String(format: "%@/ChartererRequest/GetBestAndMoreOptions?charterRequestID=%d", APIUrl.baseUrl,self.chartererRequestID!)
        
        self.view.makeToastActivity(.center)
        APIChartererRequest.shared.getBestAndMoreOptions(urlStr: getAPIUrl) { response in
            self.view.hideToastActivity()
            self.bestMoreOptions.removeAll()
            if response.result == "success"{
                if response.data != nil{
                    
                    if response.data!.count > 0{
                        self.crBestMoreOptionsData = response.data!
                        if self.crBestMoreOptionsData.count > 0{
                            self.setupDynamicMoreOptionData(cData: self.crBestMoreOptionsData)
                        }
                    }else{
                                        
                        //self.timeUpHideTable()
                        
                        //self.removeCharterRequestID()
//                        let noAircraftMsgVC = CurrentRequestVC.storyboardViewController()
//                        self.navigationController?.pushViewController(noAircraftMsgVC, animated: false)
                        
                        CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: "There is no available aircraft for this request, please try another.", aViewController: self) { OkAction in
                            
                            if self.timerOffer != nil{
                                self.timerOffer.invalidate()
                                self.timerOffer = nil
                                self.timeSecond = OFFER_TIME
                            }
                            
                            self.acceptTimeSecond = 0
                            if self.acceptTimer != nil{
                                self.acceptTimer.invalidate()
                                self.acceptTimer = nil
                            }
                            self.APICancelCharterRequestCall()
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
            
        }fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    func parseLargeJSONAsync(jsonString: String, completion: @escaping ([String: Any]?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            completion(jsonObject)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error parsing large JSON string: \(error)")
                        completion(nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    print("Error converting JSON string to Data")
                    completion(nil)
                }
            }
        }
    }
    
    /*===========End Current Request API ==========*/
    
    func showGetReadyTimer(){
        if self.timerOffer == nil{
            self.timerOffer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateGetReadyTime), userInfo: nil, repeats: true)
        }
    }
    
    func showTimer(){
        if self.timerOffer == nil{
            self.timerOffer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        }
    }
    
    func showAcceptTimer(){
        if self.acceptTimer == nil{
            self.acceptTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateAcceptTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateGetReadyTime(){
        
        if self.getReadyTime > 0{
            //Finalizing Route
            //Finding Aircraft
            //Generating Auction
            //Get Ready
            self.timeStr = "Get Ready"
            self.getReadyTime = self.getReadyTime - 1
            
            if self.getReadyTime <= 25 && self.getReadyTime > 19 {
                self.timeStr = "Finding Aircraft"
            }else if self.getReadyTime <= 19 && self.getReadyTime > 11{
                self.timeStr = "Generating Auction"
            }else if self.getReadyTime <= 11{
                self.timeStr = "Get Ready"
            }else if self.getReadyTime <= 6{
                self.timeStr = "Finalizing Route"
            }else{
                self.timeStr = "Fetching..."
            }
            self.requestConfDetailTable.reloadData()
        }else{
            self.timeStr = "Fecthing..."
            self.getReadyTime = 0
            if self.timerOffer != nil{
                self.timerOffer.invalidate()
                self.timerOffer = nil
                self.APICheckCharterRequestStatusCall()
            }
        }
    }
    
    @objc func updateTime(){
        
        if self.timeSecond > 0{
            //let time = printSecondsToHoursMinutesSeconds(seconds: timeSecond)
            let time = printSeconds(seconds: timeSecond)
            let timeStr = String(format: "%@",time)
            if timeSecond != 0{
                self.timeStr = timeStr
                
                if callAPISeconds == 5{
                    self.callAPISeconds = 0
                    
                    let remdomAmt = Double.random(in: self.minBidPrice...self.maxBidPrice)
                    let amount = CommonFunction.getCurrencyValue2(amt: Float(remdomAmt), code: CURRENCY_CODE)
                    self.currentOfferPrice = amount
                    //self.APIGetCurrentBidPrice()
                }
                self.requestConfDetailTable.reloadData()
                self.callAPISeconds = self.callAPISeconds + 1
            }
            self.timeSecond = self.timeSecond - 1
            
        }else{
            self.timeStr = "Getting results"
            self.timeSecond = 0
            if self.timerOffer != nil{
                self.timerOffer.invalidate()
                self.timerOffer = nil
                self.setRemainingTimerAPI(id:self.chartererRequestID!)
            }
        }
    }
    
    @objc func updateAcceptTime(){
        
        if self.acceptTimeSecond > 0{
            let time = printSecondsToHoursMinutesSeconds(seconds: acceptTimeSecond)
            let timeStr = String(format: "%@",time)
            self.timeAcceptLabelString = "Time Remaining"
            if acceptTimeSecond != 0{
                self.acceptTimerStr = timeStr
            }
            self.requestConfDetailTable.reloadData()
            //self.requestConfDetailTable.reloadSections(IndexSet(integer: 1), with: .none)
            self.acceptTimeSecond = self.acceptTimeSecond - 1
        }else{
            self.acceptTimerStr = "TIME UP!"
            self.acceptTimeSecond = 0
            //self.requestConfDetailTable.reloadData()
            self.requestConfDetailTable.reloadSections(IndexSet(integer: 1), with: .none)
            self.perform(#selector(timeUpHideTable), with: nil, afterDelay: 3.0)
            if self.acceptTimer != nil{
                self.acceptTimer.invalidate()
                self.acceptTimer = nil
            }
        }
    }
    
    @objc func timeUpHideTable(){
        self.view.hideToastActivity()
        self.showNoCurrentDataView()
        self.setTableDelegateAndDataSource()
        self.requestConfDetailTable.reloadData()
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func printSecondsToHoursMinutesSeconds(seconds:Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
        //print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
        var time = ""
        if h > 0{
            time = String(format: "%02d:", h)
        }
        time.append(String(format: "%02d:", m))
        time.append(String(format: "%02d", s))
        
        return time
    }
    
    func printSeconds(seconds:Int)-> String {
        return String(format: "%02d seconds", seconds)
    }
    
    func APICancelCharterRequestCall(){
        
        self.view.makeToastActivity(.center)
       
        //finalcode
        let urlStr = String(format: "%@/ChartererRequest/UpdateCharterRequestStatus?chartererrequestid=%d&statusid=7", APIUrl.baseUrl,self.chartererRequestID!)
        
        let parameters = ["chartererrequestid":self.chartererRequestID!,"statusid":7] as [String: Any]
    
        APIChartererRequest.shared.updateChartererRequest(urlStr: urlStr, param: parameters) { response in
            
            self.view.hideToastActivity()
           // if response.data != nil{
            
            if response.result == "success"{
                
                self.delegate?.cancelRequest()
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
    
    func APISaveSelectedOptionOnSubmitCall(){
        
        self.view.makeToastActivity(.center)
        ///api/ChartererRequest/SaveSelectedBestMoreOptionsData/{id}

        //finalcode
         let urlStr = String(format: "%@/ChartererRequest/SaveSelectedBestMoreOptionsData/%d", APIUrl.baseUrl,self.chartererRequestID!)
        
        let bodyParam = self.convertInJSONString(arr:self.selectedIndexesData)
        
        APIChartererRequest.shared.saveSelectedBestMoreOptionsData(urlStr: urlStr, param: bodyParam) { response in
            self.view.hideToastActivity()
            if response.result == "success"{
                if response.data != nil{
                    if response.data == true{
                        self.isExpnadedAndPreview = true
                        let acceptVC = RequestAcceptDetailVC.storyboardViewController()
                        
                        //for last confrim screen
                        acceptVC.ownerMaxPaxCount = self.ownerMaxPaxCount
                        acceptVC.charterRequestGetData = self.bestOption
                        
                        if self.postResponseData != nil{
                            acceptVC.postResponseData = self.postResponseData
            
                        }else{
                            
                            acceptVC.crLegDetailsData = self.crLegDetailsData
                            acceptVC.pendingResponseData = self.pendingResponseData
                            
                        }
                        acceptVC.delegate = self
                        acceptVC.isSplit = self.isSPlitPayment
                        acceptVC.charterReqId = self.chartererRequestID!
                        //acceptVC.aircraftName = self.selectedAircraftData.name!
                        //acceptVC.lowestPrice = Float(self.selectedAircraftData.finalPrice!)
                        self.navigationController?.pushViewController(acceptVC, animated: true)
                        
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
            
        }fail: { error in
            self.view.hideToastActivity()
            CommonFunction.showAlertMessage(aStrTitle: "Error", aStrMessage: error.localizedDescription, aViewController: self) { OkAction in
                
            }
        }
    }
    
    @IBAction func createBtnClicked(_ sender: UIButton){
        //APP_DELEGATE.createNewRequestView()
        self.APICancelCharterRequestCall()
        APP_DELEGATE.setHomeToRootViewController()
    }
    
    @IBAction func cancelRequestBtnClicked(_ sender: UIButton){
        CommonFunction.showAlertMessageWithTitle(aStrTitle: "", aStrMessage: "Do you want to cancel current request?", Oktitle: "Yes", CancelTitle: "No", aViewController: self) { cancelAction in
            
        } OKActionTap: { okAction in
            
            if self.timerOffer != nil{
                self.timerOffer.invalidate()
                self.timerOffer = nil
            }
            
            self.acceptTimeSecond = 0
            if self.acceptTimer != nil{
                self.acceptTimer.invalidate()
                self.acceptTimer = nil
            }
            self.APICancelCharterRequestCall()
        }
    }
    
    @IBAction func selectAnotherPriceBtnClicked(_ sender: UIButton){
        self.view.makeToastActivity(.center)
        self.hideLegCollectionView()
        self.isSelectedThisPrice =  false
        //self.currentSelectPriceData.removeObject(at: self.legSelectedIndex!)
        self.hideSubmitButtonView()
        self.requestConfDetailTable.reloadSections(IndexSet(integer: 2), with: .none)
        self.requestConfDetailTable.isHidden = true
        self.perform(#selector(reloadTableAfterSelectPrice), with: nil, afterDelay: 1.0)
    }
    
    @IBAction func submitBtnClicked(_ sender :UIButton) {
        self.perform(#selector(selectNextLeg), with: nil, afterDelay: 0.2)
    }
}

extension RequestConfirmDetailVC : NavigationBarViewDelegate {
    
    func onBackButtonClick(sender: NavigationBarView) {
    
        if self.timeSecond == 0 && self.getReadyTime == 0 && self.acceptTimeSecond == 0{
            APP_DELEGATE.setHomeToRootViewController()
        }else{
            CommonFunction.showAlertMessageWithTitle(aStrTitle: "", aStrMessage: "Do you want to cancel current request?", Oktitle: "Yes", CancelTitle: "No", aViewController: self) { cancelAction in
                
            } OKActionTap: { okAction in
                self.APICancelCharterRequestCall()
            }
        }
        
        /*CommonFunction.showAlertMessageWithTitle(aStrTitle: "", aStrMessage: "Your current request is going on, Do you want to create new request?", Oktitle: "Yes", CancelTitle: "No", aViewController: self) { cancelAction in
            
        } OKActionTap: { OkAction in
            APP_DELEGATE.createNewRequestView()
        }*/
    }
}

extension RequestConfirmDetailVC : BestAndMoreOptionCellDelegate{
    
    /*func selectBtnPressed(sender: UIButton, section: Int) {
        
        if self.selectedIndexesData.count > 0{
            self.selectedIndexesData.removeAllObjects()
        }
        print(sender.tag)
        let secData = self.bestMoreOptions[self.legSelectedIndex!]
        let rowData = secData.records[sender.tag]
        let section = self.getSection(index: sender.tag)
        
        //For Best Option  = 0, for others ID
        let prefId = ((sender.tag) == 0) ? 0 : rowData.PreferredAircraftID!
        
        print("###### \(section) ######")
        print("###### \(prefId) ######")
        let data = SaveSelectedOption(ChartererRequestID: rowData.ChartererRequestID!, Section:section, PrefID: prefId, OwnerAircraftID: rowData.OwnerAircraftID!)
        self.selectedIndexesData.add(data)
        self.APISaveSelectedOptionOnSubmitCall()
    }*/
    
    func selectBtnPressed(sender: UIButton, section: Int) {
        
        let selectPriceIndexPath = IndexPath(row: sender.tag, section: section)
        print(selectPriceIndexPath)
        
        self.isSelectedThisPrice = true
        
        if self.selectedIndexPaths.count > 0{
            var isExistIndex:Bool! = false
            var atIndex:Int!
            for i in 0...self.selectedIndexPaths.count - 1{
                let indexD = self.selectedIndexPaths[i] as! IndexPath
                print(indexD)
                if indexD.section == self.legSelectedIndex!{
                    isExistIndex  = true
                    atIndex = i
                    break
                }else{
                    isExistIndex  = false
                }
            }
            
            if isExistIndex == true{
                let secData = self.bestMoreOptions[self.legSelectedIndex!]
                let rowData = secData.records[sender.tag]
                //print(rowData)
                if selectedIndexPaths.contains(selectPriceIndexPath){
                    selectedIndexPaths.removeObject(at:atIndex)
                    self.selectedIndexesData.removeObject(at: atIndex)
                }else{
                    selectedIndexPaths.removeObject(at:atIndex)
                    selectedIndexPaths.add(selectPriceIndexPath)
                    
                    self.selectedIndexesData.removeObject(at: atIndex)
                    let section = self.getSection(index: sender.tag)
                    let prefId = ((sender.tag) == 0) ? 0 : rowData.PreferredAircraftID!
                    let data = SaveSelectedOption(ChartererRequestID: rowData.ChartererRequestID!, Section:section, PrefID: prefId, OwnerAircraftID: rowData.OwnerAircraftID!)
                    self.selectedIndexesData.add(data)
                    
                   // self.currentSelectPriceData.add(rowData)
                }
            }else{
                selectedIndexPaths.add(selectPriceIndexPath)
                let secData = self.bestMoreOptions[self.legSelectedIndex!]
                let rowData = secData.records[sender.tag]
                //print(rowData)
                let section = self.getSection(index: sender.tag)
                let prefId = ((sender.tag) == 0) ? 0 : rowData.PreferredAircraftID!
                let data = SaveSelectedOption(ChartererRequestID: rowData.ChartererRequestID!, Section: section, PrefID: prefId, OwnerAircraftID: rowData.OwnerAircraftID!)
                self.selectedIndexesData.add(data)
                //self.currentSelectPriceData.add(rowData)
            }
        }else{
            let secData = self.bestMoreOptions[self.legSelectedIndex!]
            let rowData = secData.records[sender.tag]
            //print(rowData)
            let section = self.getSection(index: sender.tag)
            let prefId = ((sender.tag) == 0) ? 0 : rowData.PreferredAircraftID!
            let data = SaveSelectedOption(ChartererRequestID: rowData.ChartererRequestID!, Section: section, PrefID: prefId, OwnerAircraftID: rowData.OwnerAircraftID!)
            self.selectedIndexesData.add(data)
            self.selectedIndexPaths.add(selectPriceIndexPath)
            //self.currentSelectPriceData.add(rowData)
        }
        //print(selectedIndexesData)
        //print(selectPriceIndexPath)
        //self.perform(#selector(selectNextLeg), with: nil, afterDelay: 0.5)
        
        if self.typeIndex == 0{
            self.showSubmitButtonView()
            self.nextButton.setTitle("Submit", for: .normal)
        }else{
            if self.bestMoreOptions.count-1 == self.legSelectedIndex{
                self.nextButton.setTitle("Submit", for: .normal)
            }else{
                self.nextButton.setTitle("Next", for: .normal)
            }
            self.showSubmitButtonView()
        }
        self.hideLegCollectionView()
        self.requestConfDetailTable.isHidden = true
        self.requestConfDetailTable.reloadSections(IndexSet(integer: 2), with: .none)
        self.view.makeToastActivity(.center)
        self.perform(#selector(reloadTableAfterSelectPrice), with: nil, afterDelay: 1.0)
        //self.requestConfDetailTable.reloadSections(IndexSet(integer: 2), with: .none)
        
    }
    
    @objc func reloadTableAfterSelectPrice(){
        self.requestConfDetailTable.isHidden = false
        self.view.hideToastActivity()
        
        if self.bestMoreOptions.count > 1{
            self.showLegCollectionView()
        }else{
            self.hideLegCollectionView()
        }
    }
    
    @objc func selectNextLeg(){
        
        if self.bestMoreOptions.count != self.selectedIndexPaths.count && self.nextButton.titleLabel?.text == "Submit"{
            CommonFunction.showToastMesage(msg: "Please select all leg's price.",controller: self, fontSize: 22)
            
        }else if self.bestMoreOptions.count == self.selectedIndexPaths.count && self.nextButton.titleLabel?.text == "Next"{
            self.legSelectedIndex += 1
            self.isSelectedThisPrice = true
            self.legCollectionView.reloadData()
            self.requestConfDetailTable.reloadSections(IndexSet(integer: 2), with: .none)
            self.nextButton.setTitle("Submit", for: .normal)
            
        }else if (self.bestMoreOptions.count == self.selectedIndexPaths.count) && self.nextButton.titleLabel?.text == "Submit"{
            self.APISaveSelectedOptionOnSubmitCall()
        }else{
            
            self.legSelectedIndex += 1
            for i in 0..<self.selectedIndexPaths.count{
                let indPath = self.selectedIndexPaths[i] as! IndexPath
                if indPath.section == self.legSelectedIndex!{
                    self.isSelectedThisPrice = true
                    self.showSubmitButtonView()
                    if self.bestMoreOptions.count-1 == self.legSelectedIndex{
                        self.nextButton.setTitle("Submit", for: .normal)
                    }else{
                        self.nextButton.setTitle("Next", for: .normal)
                    }
                    break
                }else{
                    self.isSelectedThisPrice = false
                    self.requestConfDetailTable.isHidden = true
                    self.hideSubmitButtonView()
                }
            }
            self.legCollectionView.reloadData()
            self.requestConfDetailTable.reloadSections(IndexSet(integer: 2), with: .none)
            self.perform(#selector(reloadTableAfterSelectPrice), with: nil, afterDelay: 1.0)
        }
    }
    
    func getSection(index:Int)->String{
        var sect = ""
        if index == 0{
            sect  = "best"
        }else{
            sect = "more"
        }
        return sect
    }
    
    func convertInJSONString(arr:NSMutableArray)->String{
        // Array to hold dictionaries
        var dictionaryArray: [[String: Any]] = []

        // Convert each RequestBody object in NSMutableArray to a dictionary
        for item in selectedIndexesData {
            if let requestBody = item as? SaveSelectedOption {
                if let jsonData = try? JSONEncoder().encode(requestBody),
                   let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                    dictionaryArray.append(jsonObject)
                }
            }
        }

        // Convert the array of dictionaries to JSON data
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryArray, options: .prettyPrinted) {
            // Convert JSON data to a string if needed, for display
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
    
    func didSelectRatingAtIndex(rateImage: String) {
        
        let ratingView = RatingImageViewController.storyboardViewController()
        ratingView.modalPresentationStyle = .overCurrentContext
        ratingView.modalTransitionStyle = .crossDissolve
        ratingView.rateImageType = rateImage
        self.present(ratingView, animated: true)
        
    }
  
}

extension RequestConfirmDetailVC : RequestBestOptionCellDelegate{
    
    func previewBtnPressed(sender: UIButton,section:Int) {
        
        var prevUrl = ""
        var returnUrl = ""
        if  section == 2{
            
            //let optionData = self.bestOptions[sender.tag]
            if self.bestMoreOptions.count > 0{
                let optionData = self.bestMoreOptions[0].records[sender.tag]
                //print(optionData)
                let winningPrice = CommonFunction.getCurrencyValue(amt: Float(Int(round(optionData.FinalAmount!))), code: CURRENCY_CODE)
                
                self.selectedAircraftData = AirCraft(name: optionData.PreferredAircraft!,finalPrice: Float(optionData.FinalAmount!))
                
                prevUrl = "\(APIUrl.previewBaseURL)/cAircraftDetails?owneraircraftid=\(optionData.OwnerAircraftID!)&prefid=\(optionData.ID!)&crid=\(optionData.ChartererRequestID!)&c=\(winningPrice)&returnurl=\(APIUrl.previewBaseURL)/cCurrentRequest?id=\(optionData.ChartererRequestID!)"
                
                returnUrl = "\(APIUrl.previewBaseURL)/cCurrentRequest?id=\(optionData.ChartererRequestID!)"
                
                //print(prevUrl)
            }
            
        }else{
            
            if self.selectedIndexPaths.count > 0 && self.isSelectedThisPrice == true{
                for i in 0..<self.selectedIndexPaths.count{
                    let indPath = self.selectedIndexPaths[i] as! IndexPath
                    if indPath.section == self.legSelectedIndex!{
                        let optionData = self.bestMoreOptions[self.legSelectedIndex!].records[indPath.row]
                        //print(optionData)
                        self.selectedAircraftData = AirCraft(name: optionData.PreferredAircraft!,finalPrice: Float(optionData.FinalAmount!))
                        let finalAmount = CommonFunction.getCurrencyValue2(amt: Float(optionData.FinalAmount!), code: CURRENCY_CODE)
                        prevUrl = "\(APIUrl.previewBaseURL)/cAircraftDetails?owneraircraftid=\(optionData.OwnerAircraftID!)&prefid=\(optionData.ID!)&crid=\(optionData.ChartererRequestID!)&c=\(finalAmount)&returnurl=\(APIUrl.previewBaseURL)/cCurrentRequest?id=\(optionData.ChartererRequestID!)"
                        
                        returnUrl = "\(APIUrl.previewBaseURL)/cCurrentRequest?id=\(optionData.ChartererRequestID!)"
                    }
                }
                
            }else{
                if self.bestMoreOptions.count > 0{
                    // let optionData = self.moreOptions[sender.tag]
                    let optionData = self.bestMoreOptions[section].records[sender.tag]
                    //print(optionData)
                    self.selectedAircraftData = AirCraft(name: optionData.PreferredAircraft!,finalPrice: Float(optionData.FinalAmount!))
                    let finalAmount = CommonFunction.getCurrencyValue2(amt: Float(optionData.FinalAmount!), code: CURRENCY_CODE)
                    prevUrl = "\(APIUrl.previewBaseURL)/cAircraftDetails?owneraircraftid=\(optionData.OwnerAircraftID!)&prefid=\(optionData.ID!)&crid=\(optionData.ChartererRequestID!)&c=\(finalAmount)&returnurl=\(APIUrl.previewBaseURL)/cCurrentRequest?id=\(optionData.ChartererRequestID!)"
                    
                    returnUrl = "\(APIUrl.previewBaseURL)/cCurrentRequest?id=\(optionData.ChartererRequestID!)"
                }
            }
        }
        
        self.isExpnadedAndPreview = true
        let previewVC = PreviewOfferVC.storyboardViewController()
        previewVC.prevUrlStr = prevUrl
        previewVC.returnUrl = returnUrl
        previewVC.viewController = self
        previewVC.delegate = self
        previewVC.postResponseData = self.postResponseData
        previewVC.crLegDetailsData = self.crLegDetailsData
        previewVC.pendingResponseData = self.pendingResponseData
        previewVC.charterRequestGetData = self.bestOption
        //previewVC.logData = self.logData
        previewVC.aircraftName = self.selectedAircraftData.name!
        previewVC.lowestPrice = self.selectedAircraftData.finalPrice!
        self.navigationController?.pushViewController(previewVC, animated: true)
        
        //self.APIGetOwnerAircraftCall(ownerId: "", aircraftId: "")
    }
    
    func acceptBtnPressed(sender: UIButton,section:Int) {
        
        if  section == 2{
            let optionData = self.bestOptions[sender.tag]
            //print(optionData)
            self.selectedAircraftData = AirCraft(name: optionData.OwnerAircraft!,finalPrice: Float(optionData.FinalAmount!))
            self.APICharterUpdatePreferredWinningBidCall(id:optionData.ID!)
        }else{
            let optionData = self.moreOptions[sender.tag]
            //print(optionData)
            self.selectedAircraftData = AirCraft(name: optionData.PreferredAircraft!,finalPrice: Float(optionData.FinalAmount!))
            self.APICharterUpdatePreferredWinningBidCall(id:optionData.ID!)
        }
    }
}

extension RequestConfirmDetailVC : PreviewOfferVCDelegate{
    
    func proccedBtnPressed() {
        let acceptVC = RequestAcceptDetailVC.storyboardViewController()
        acceptVC.postResponseData = self.postResponseData
        acceptVC.ownerMaxPaxCount = self.ownerMaxPaxCount
        acceptVC.aircraftName = self.selectedAircraftData.name!
        acceptVC.lowestPrice = self.selectedAircraftData.finalPrice!
        self.navigationController?.pushViewController(acceptVC, animated: true)
    }
    
    func preBackBtnPressed() {
        self.fetchAcceptionTime()
        //self.perform(#selector(expandTable), with: nil, afterDelay: 6.5)
    }
    
    @objc func expandTable(){
        self.expandTableList(indexpath: self.expandedIndexPath)
    }
    
    
}

extension RequestConfirmDetailVC : RequestAcceptDetailVCDelegate{
    
    func backBtnPressed() {
        self.fetchAcceptionTime()
    }
}

extension RequestConfirmDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.bestMoreOptions.count > 0{
            return 3
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var secRow : Int = 0
        if section == 0{ //Listing Section
            if self.postResponseData != nil{
                secRow =  self.postResponseData.crleg!.count
            }else{
                secRow =  self.crLegDetailsData.count
            }
        }else if section == 1{ //Detail
            if self.postResponseData != nil{
                secRow =  1
            }else if self.pendingResponseData != nil{
                secRow = 1
            }
        }else{
            
            if self.selectedIndexPaths.count > 0 && self.isSelectedThisPrice == true{
                return 1
            }else{
                if self.bestMoreOptions.count > 0{
                    
                    let noOfRow = self.bestMoreOptions[self.legSelectedIndex!].records.count
                    return noOfRow
                }else{
                    return 0
                }
            }
        }
        return secRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        if indexPath.section == 0{// Lisiting
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.PastRequestTblCell, for: indexPath) as! PastRequestTblCell
            //cell.hideDetailView()
            
            if UserDefaults.standard.object(forKey: "planAnimationLastPoint") == nil {
                cell.showLeftSidePlan()
            }else{
                cell.planImageview.isHidden = false
            }
            if self.timeSecond != 0{
                cell.updatePlanePosition(seconds: self.timeSecond)
            }else{
                
                if self.timeSecond == 0 && self.acceptTimeSecond != 0{
                    cell.showMiddlePlane()
                }else{
                    cell.resetPlanePosition()
                }
            }
            cell.showDateTimeLable()
            if self.postResponseData != nil{
                let data = self.postResponseData.crleg![indexPath.row]
                cell.configuerConfirmRequest(indexPath: indexPath,data: data,fromVC:"RequestConfirmDetailVC")
            }else{
                let data = self.crLegDetailsData[indexPath.row]
                cell.configuerConfirmPendingRequest(indexPath: indexPath, data: data)
            }
            return cell
            
        }else if indexPath.section == 1{ // Detail
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestDetailCell, for: indexPath) as! RequestDetailCell
            
            cell.timerLbel.text  = self.timeStr
            
            if self.currentOfferPrice != "--"{
                cell.currentBidLabel.text = String(format: "%@", self.currentOfferPrice)
            }else{
                cell.currentBidLabel.text = String(format: "%@", self.currentOfferPrice)
            }
            
            if ((self.timeSecond != 0 && self.acceptTimeSecond == 0) || (self.getReadyTime != 0 && self.acceptTimeSecond == 0 && self.timeSecond == 0)){
                cell.acceptTimerTitleLabel.text = ""
                cell.showTimerView()
            }else if self.acceptTimeSecond != 0 && self.timeSecond == 0 && self.getReadyTime == 0 {
                cell.hideTimerView()
                cell.acceptTimerTitleLabel.text = "Time Remaining"
                cell.acceptTimerLabel.text = self.acceptTimerStr
                cell.acceptTimerLabel.textColor = UIColor.black
            }else{
                print("calling for fetching............>")
                print(self.timeSecond)
                print(self.getReadyTime)
                //cell.hideTimerView()
                //cell.acceptTimerTitleLabel.text = self.acceptTimerStr
                if self.bestOptions.count == 0 && self.acceptTimeSecond == 0{
                    cell.acceptTimerLabel.text = self.noBidMessageStr
                    cell.acceptTimerLabel.textColor = UIColor.red
                }else{
            
                    cell.acceptTimerLabel.text = self.acceptTimerStr
                    cell.acceptTimerLabel.textColor = UIColor.black
                }
            }
            
            if self.postResponseData != nil{
                cell.configuerConfirmRequestDetail(indexPath: indexPath, data: self.postResponseData,typeIndex: self.typeIndex)
            }else{
                cell.configuerConfirmPendingRequestDetail(indexPath: indexPath, data: self.pendingResponseData)
            }
            return cell
        }else{ // Best And More Options
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.BestAndMoreOptionCell, for: indexPath) as! BestAndMoreOptionCell
            
            cell.delegate = self
            
            if self.selectedIndexPaths.count > 0 && self.isSelectedThisPrice == true{
                for i in 0..<self.selectedIndexPaths.count{
                    let indPath = self.selectedIndexPaths[i] as! IndexPath
                    if indPath.section == self.legSelectedIndex!{
                        let rowData = self.bestMoreOptions[self.legSelectedIndex!].records[indPath.row]
                        cell.configuerMoreOptionCell(indexPath: indexPath,sectionLeg: self.legSelectedIndex, data: rowData,isSelectedPrice:true)
                        cell.hideSelectBtn()
                        break
                    }
                }
                //let rowData = self.currentSelectPriceData[self.legSelectedIndex!] as! MoreOptionsData
            }else{
                cell.showSelectBtn()
                cell.selectIndexLabel.tag = self.legSelectedIndex!
                if self.bestMoreOptions.count > 0{
                    let rowData = self.bestMoreOptions[self.legSelectedIndex!].records[indexPath.row]
                    
//                    if self.selectedIndexPaths.count > 0{
//                        if self.selectedIndexPaths.contains(indexPath){
//                            //cell.selectPriceBtn.setImage(UIImage(named: "selected"), for: .normal)
//                        }else{
//                            //cell.selectPriceBtn.setImage(UIImage(named: "selected_not"), for: .normal)
//                        }
//                    }else{
//                        //cell.selectPriceBtn.setImage(UIImage(named: "selected_not"), for: .normal)
//                    }
                    cell.configuerMoreOptionCell(indexPath: indexPath,sectionLeg: self.legSelectedIndex, data: rowData,isSelectedPrice:false)
                    return cell
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 && indexPath.section >= 2 {
//            self.expandedIndexPath = indexPath
//            //self.bestMoreOptions[indexPath.section].isExpanded.toggle()
//            tableView.reloadSections([indexPath.section], with: .automatic)
//        }
    }
    
    @objc func expandTableList(indexpath:IndexPath){
        
        print(self.bestMoreOptions[indexpath.section].isExpanded)
        self.bestMoreOptions[indexpath.section].isExpanded.toggle()
        self.requestConfDetailTable.reloadSections([indexpath.section], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}


/*extension RequestConfirmDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.bestMoreOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section < 2 || section == self.bestMoreOptions.count - 2{
            if section == 0{
                if self.postResponseData != nil{
                    return self.postResponseData.crleg!.count
                }else{
                    return self.crLegDetailsData.count
                }
            }
            if section == 1{
                if self.postResponseData != nil{
                    return 1
                }else if self.pendingResponseData != nil{
                    return 1
                }else{
                    return 0
                }
            }
            if section == self.bestMoreOptions.count - 1 {
                return 1 //Cancel Request Cell
            }
            if section == self.bestMoreOptions.count - 2 {
                if self.crBestMoreOptionsData.count > 0{
                    return 1 //Submit Button Cell
                }else{
                    return 0
                }
            }
        }else{
            
            return self.bestMoreOptions[section].isExpanded ? self.bestMoreOptions[section].records.count + 1 : 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestListCell, for: indexPath) as! RequestListCell
            cell.hideDetailView()
            
            if self.postResponseData != nil{
                let data = self.postResponseData.crleg![indexPath.row]
                cell.configuerConfirmRequest(indexPath: indexPath,data: data,fromVC:"RequestConfirmDetailVC")
            }else{
                let data = self.crLegDetailsData[indexPath.row]
                cell.configuerConfirmPendingRequest(indexPath: indexPath, data: data)
            }
            return cell
            
        }else if indexPath.section == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.RequestDetailCell, for: indexPath) as! RequestDetailCell
            
            
            cell.timerLbel.text  = self.timeStr
            
            if self.currentOfferPrice != "--"{
                cell.currentBidLabel.text = String(format: "%@", self.currentOfferPrice)
            }else{
                cell.currentBidLabel.text = String(format: "%@", self.currentOfferPrice)
            }
            
            if ((self.timeSecond != 0 && self.acceptTimeSecond == 0) || (self.getReadyTime != 0 && self.acceptTimeSecond == 0 && self.timeSecond == 0)){
                cell.acceptTimerTitleLabel.text = ""
                cell.showTimerView()
            }else if self.acceptTimeSecond != 0 && self.timeSecond == 0 && self.getReadyTime == 0 {
                cell.hideTimerView()
                cell.acceptTimerTitleLabel.text = "Time to Accept"
                cell.acceptTimerLabel.text = self.acceptTimerStr
                cell.acceptTimerTitleLabel.textColor = UIColor.white
                cell.acceptTimerLabel.textColor = UIColor.white
            }else{
                print("calling for fetching............>")
                print(self.timeSecond)
                print(self.getReadyTime)
                //cell.hideTimerView()
                //cell.acceptTimerTitleLabel.text = self.acceptTimerStr
                if self.bestOptions.count == 0 && self.acceptTimeSecond == 0{
                    cell.acceptTimerLabel.text = self.noBidMessageStr
                    cell.acceptTimerLabel.textColor = UIColor.red
                }else{
            
                    cell.acceptTimerLabel.text = self.acceptTimerStr
                    cell.acceptTimerLabel.textColor = UIColor.white
                }
            }
            
            if self.postResponseData != nil{
                cell.configuerConfirmRequestDetail(indexPath: indexPath, data: self.postResponseData,typeIndex: self.typeIndex)
            }else{
                cell.configuerConfirmPendingRequestDetail(indexPath: indexPath, data: self.pendingResponseData)
            }
            return cell
        }else if indexPath.section == self.bestMoreOptions.count - 1 { //Cancel Button
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.CancelRequestCell, for: indexPath) as! CancelRequestCell
            cell.delegate = self
            return cell
            
        }else if indexPath.section == self.bestMoreOptions.count - 2 { //Submit Button
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.SubmitButtonCell, for: indexPath) as! SubmitButtonCell
            cell.delegate = self
            return cell
            
        }else{ // Best And More Options
            
            let rowData = self.bestMoreOptions[indexPath.section]
            
            if indexPath.row == 0{
                let rowData = self.bestMoreOptions[indexPath.section]
                let data = rowData.records[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.SourceToDestHeaderCell, for: indexPath) as! SourceToDestHeaderCell
                
                cell.plusMinusLabel.textColor = UIColor.hexStringToUIColor(hex: "#EBE5DF")
                cell.borderLabel.backgroundColor = UIColor.hexStringToUIColor(hex: "#EBE5DF")
                if data.RequestTypeToUseID == 2{
                    cell.titleStrLabel.text = ""
                    cell.plusMinusLabel.text = ""
                    cell.borderLabel.backgroundColor = UIColor.clear
                }else{
                    // Title cell
                    cell.titleStrLabel.text = rowData.title
                    if rowData.isExpanded == true{
                        cell.plusMinusLabel.text = " - "
                    }else{
                        cell.plusMinusLabel.text = " + "
                    }
                }
                return cell
                
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: TableCells.BestAndMoreOptionCell, for: indexPath) as! BestAndMoreOptionCell
                cell.delegate = self
                
                let datar = rowData.records[indexPath.row - 1]
                
                if self.selectedIndexPaths.count > 0{
                    if self.selectedIndexPaths.contains(indexPath){
                        cell.selectPriceBtn.setImage(UIImage(named: "selected"), for: .normal)
                    }else{
                        cell.selectPriceBtn.setImage(UIImage(named: "selected_not"), for: .normal)
                    }
                }else{
                    cell.selectPriceBtn.setImage(UIImage(named: "selected_not"), for: .normal)
                }
                cell.configuerMoreOptionCell(indexPath: indexPath, data: datar)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section >= 2 {
            self.expandedIndexPath = indexPath
            self.bestMoreOptions[indexPath.section].isExpanded.toggle()
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
    }
    
    @objc func expandTableList(indexpath:IndexPath){
        
        print(self.bestMoreOptions[indexpath.section].isExpanded)
        self.bestMoreOptions[indexpath.section].isExpanded.toggle()
        self.requestConfDetailTable.reloadSections([indexpath.section], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}*/

extension RequestConfirmDetailVC : CancelRequestCellDelegate{
    
    func cancelRequestBtnPressed() {
        CommonFunction.showAlertMessageWithTitle(aStrTitle: "", aStrMessage: "Do you want to cancel current request?", Oktitle: "Yes", CancelTitle: "No", aViewController: self) { cancelAction in
            
        } OKActionTap: { okAction in
            if self.timerOffer != nil{
                self.timerOffer.invalidate()
                self.timerOffer = nil
                self.timeSecond = OFFER_TIME
            }
            
            self.acceptTimeSecond = 0
            if self.acceptTimer != nil{
                self.acceptTimer.invalidate()
                self.acceptTimer = nil
            }
            self.APICancelCharterRequestCall()
        }
    }
}

extension RequestConfirmDetailVC : SubmitButtonCellDelegate{
    
    func submitBtnPressed() {
        
        if self.selectedIndexesData.count > 0{
            
            if self.selectedIndexesData.count != self.totalRoutWayPathSections{
                CommonFunction.showAlertMessage(aStrTitle: "", aStrMessage: "Please select option from other route.", aViewController: self) { OkAction in
                    
                }
                return
            }
            
            self.APISaveSelectedOptionOnSubmitCall()
        }else{
            CommonFunction.showAlertMessage(aStrTitle: "", aStrMessage: "Please select atleast one option.", aViewController: self) { OkAction in
                
            }
        }
    }
}

extension RequestConfirmDetailVC : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.bestMoreOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCells.legCollectionCell, for: indexPath) as! legCollectionCell
        
        if self.legSelectedIndex == indexPath.section{
            cell.mainCellView.layer.borderColor = UIColor.black.cgColor
            cell.mainCellView.layer.borderWidth = 1
        }else{
            cell.mainCellView.layer.borderColor = UIColor.clear.cgColor
            cell.mainCellView.layer.borderWidth = 0
        }
        cell.titleLabel.text = String(format: "LEG %d", indexPath.section+1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.legSelectedIndex = indexPath.section
        
        if self.selectedIndexPaths.count == 0{
            self.isSelectedThisPrice = false
            self.hideSubmitButtonView()
        }else{
            for i in 0..<self.selectedIndexPaths.count{
                let indPath = self.selectedIndexPaths[i] as! IndexPath
                if indPath.section == self.legSelectedIndex!{
                    self.isSelectedThisPrice = true
                    break
                }else{
                    self.isSelectedThisPrice = false
                }
            }
            
            if self.bestMoreOptions.count-1 == self.legSelectedIndex{
                self.nextButton.setTitle("Submit", for: .normal)
            }else{
                self.nextButton.setTitle("Next", for: .normal)
            }
            self.showSubmitButtonView()
        }
                
//                let indPath = self.selectedIndexPaths[indexPath.section] as! IndexPath
//                if indPath.section == indexPath.section && self.bestMoreOptions.count == self.selectedIndexPaths.count{
//                    print("###############")
//                    print("Row :\(indPath.row)")
//                    print("Section :\(indPath.section)")
//                    print("###############")
//                    self.isSelectedThisPrice = true
//                }else if indPath.section == self.legSelectedIndex{
//                    self.isSelectedThisPrice = true
//                }else{
//                    self.isSelectedThisPrice = false
//                }
//
        self.legCollectionView.reloadData()
        self.requestConfDetailTable.reloadData()
        //self.requestConfDetailTable.reloadSections(IndexSet(integer: 2), with: .none)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 200, height: 50)
        return cellSize
    }
}
