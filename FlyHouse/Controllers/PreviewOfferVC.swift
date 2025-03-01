//
//  PreviewOfferVC.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit
import WebKit

@objc protocol PreviewOfferVCDelegate{
    
    @objc optional
    func proccedBtnPressed()
    
    @objc optional
    func preBackBtnPressed()
    
}

class PreviewOfferVC: NavigationBarView,Storyboardable {
    static let storyboardName :StoryBoardName = .PreviewOffer
    
    var delegate:PreviewOfferVCDelegate?
    @IBOutlet var webWk:WKWebView!
    var prevUrlStr:String! = ""
    var titleStr:String! = "Preview"
    var returnUrl:String! = ""
    var isFromTermsAndCond:Bool! = false
    var isFromForgotPWd:Bool! = false
    var viewController:UIViewController!
    var isExpandList:Bool! = false
    
    //var logData = NSMutableArray()
    var postResponseData:CharterreResponse!
    var crLegDetailsData = [CRlegDetailData]()
    var pendingResponseData:CharterReqData!
    var charterRequestGetData = CharterReqData()
    var aircraftName:String! = ""
    var lowestPrice:Float! = 0
    var isFinishLoad:Bool! = false
    var urlString:URL!
    var isFrom:String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
        super.setNavigationTitle(title: titleStr)
        
        if self.isFromForgotPWd == false{
            super.setBackButton(viewC: self)
            super.delegateNav = self
        }else{
            super.navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.prevUrlStr != nil{
            if self.prevUrlStr != ""{
                print(self.prevUrlStr!)
                self.view.makeToastActivity(.center)
                let urlString = URL (string: self.prevUrlStr.trimmingCharacters(in: .whitespaces))
                if urlString != nil{
                    let request = URLRequest(url: urlString!)
                    self.webWk.load(request)
                    self.webWk.navigationDelegate = self
                    self.webWk.backgroundColor = UIColor.hexStringToUIColor(hex: THEME_COLOR_BG)
                }
                
            }
        }
    }
    
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        
        webView.evaluateJavaScript("document.getElementsByTagName('input')[0].click()") { response, error in
            
        }
    }
}

extension PreviewOfferVC: WKNavigationDelegate {
    

   func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       self.isFinishLoad = true
       self.view.hideToastActivity()
   }
    
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        //
        if self.isFromTermsAndCond == true{
            return WKNavigationActionPolicy(rawValue: 1)!
        }
        
//        if navigationAction.request.url! == URL(string: self.prevUrlStr) && self.isFrom == "TripDetails"{
//            self.navigationController?.popViewController(animated: true)
//        }
        let navActionUrl = String(format: "%@/flyhousemobile/cSignIn?q=2", CommonFunction.getValueFromForKey(key: "websitebaseurl"))
        if self.isFinishLoad == true{
            if navigationAction.request.url! == URL(string: returnUrl){
                self.delegate?.preBackBtnPressed?()
                self.navigationController?.popViewController(animated: true)
            }else if isFrom == "TripDetails"{
                return WKNavigationActionPolicy(rawValue: 1)!
                //self.navigationController?.popViewController(animated: true)
            }else if navigationAction.request.url! == URL(string:navActionUrl){
                self.delegate?.preBackBtnPressed?()
                self.navigationController?.popViewController(animated: true)
                
            }else{
                self.isFinishLoad = false
                //self.delegate?.proccedBtnPressed?()
                //self.navigationController?.popViewController(animated: false)
                
                
            
                let acceptVC = RequestAcceptDetailVC.storyboardViewController()
                
                acceptVC.charterRequestGetData = self.charterRequestGetData
                if self.crLegDetailsData.count > 0 {
                    
                    if self.pendingResponseData != nil{
                        acceptVC.charterReqId = self.pendingResponseData.ChartererRequestID!
                        acceptVC.pendingResponseData = self.pendingResponseData
                    }
                    acceptVC.crLegDetailsData = self.crLegDetailsData
                    
                }else{
                    acceptVC.postResponseData = self.postResponseData
                    acceptVC.charterReqId = self.postResponseData.chartererRequestID!
                }
                acceptVC.delegate = self.viewController as? RequestConfirmDetailVC
                acceptVC.aircraftName = self.aircraftName
                acceptVC.lowestPrice = self.lowestPrice
                acceptVC.isFromPreview = true
                self.navigationController?.pushViewController(acceptVC, animated: true)
            }
        }
        return WKNavigationActionPolicy(rawValue: 1)!
    }
}

extension PreviewOfferVC : NavigationBarViewDelegate{
    
    func onBackButtonClick(sender: NavigationBarView) {
        self.delegate?.preBackBtnPressed?()
        self.navigationController?.popViewController(animated: true)
    }
}
