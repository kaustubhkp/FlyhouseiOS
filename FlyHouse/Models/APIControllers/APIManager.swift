//
//  APIManager.swift
//  FlyHouse

import Foundation
import Alamofire

struct AppNotificationTokenResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[AircraftsData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

class APIManager{
    
    static let shared = APIManager()
    func observerModel<model:Codable>(url:String,
                                      method: HTTPMethod = .post,
                                      parameters: Parameters?,
                                      headers: [String: String]?,
                                      encoding: ParameterEncoding = JSONEncoding.default,
                                      success:@escaping(model)->Void,
                                      fail:@escaping(_ error: NSError)->Void) ->Void {
        
        
        
        print("Request URL : \(url)\n")
        if headers != nil{
            print("Header Token : \(headers!)")
        }
        //print("Request Param : \(parameters!)\n")
        // Convert to a string and print
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters!)
        if let JSONString = String(data: jsonData!, encoding: String.Encoding.utf8) {
           print("Request Param : \(JSONString)\n")
        }
        
        /*var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data,"Accept": "application/json"] as [String:String]
        }*/
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            if response.result.error == nil {
                if let responseData = response.result.value {
                    print("Response Data: \(responseData)")
                    let data = response.data
                    
                    do {
                        let responseObject = try JSONDecoder().decode(model.self, from: data!)
                        success(responseObject)
                    }catch {
                        print(error)
                        fail(error as NSError)
                    }
                }else{
                    print("Request failed with error: ",response.result.error ?? "Description not available")
                    fail(response.result.error! as NSError)
                }
            }else{
                print("Request failed with error: ",response.result.error ?? "Description not available")
                fail(response.result.error! as NSError)
            }
        }
    }
    
    func alamofirePostParam<model:Codable>(url:String,param:String,headers:HTTPHeaders,success:@escaping(model) -> Void,fail:@escaping (_ error : NSError) -> Void){
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = param.data(using: .utf8)
        request.allHTTPHeaderFields = headers

        Alamofire.request(request).responseJSON { response in
            if response.result.error == nil {
                if let responseData = response.result.value {
                    print("Response Data: \(responseData)")
                    let data = response.data
                    
                    do {
                        let responseObject = try JSONDecoder().decode(model.self, from: data!)
                        success(responseObject)
                    }catch {
                        print(error)
                        fail(error as NSError)
                    }
                }else{
                    print("Request failed with error: ",response.result.error ?? "Description not available")
                    fail(response.result.error! as NSError)
                }
            }else{
                print("Request failed with error: ",response.result.error ?? "Description not available")
                fail(response.result.error! as NSError)
            }
        }
    }
    
    func almofireParamEncoded<model:Codable>(url:String,param:String,headers:HTTPHeaders,success:@escaping(model) -> Void,fail:@escaping (_ error : NSError) -> Void){

        
        print("Request URL : \(url)\n")
        if headers != nil{
            print("Header Token : \(headers)")
        }
        print("Request Param : \(param)\n")
        
        let encoding = NoKeyParameterEncoding(parameters: param)

        
        Alamofire.request(url, method: .post, parameters:nil, encoding: encoding,headers: headers).responseJSON { response in
            if response.result.error == nil {
                if let responseData = response.result.value {
                    print("Response Data: \(responseData)")
                    let data = response.data
                    
                    do {
                        let responseObject = try JSONDecoder().decode(model.self, from: data!)
                        success(responseObject)
                    }catch {
                        print(error)
                        fail(error as NSError)
                    }
                }else{
                    print("Request failed with error: ",response.result.error ?? "Description not available")
                    fail(response.result.error! as NSError)
                }
            }else{
                print("Request failed with error: ",response.result.error ?? "Description not available")
                fail(response.result.error! as NSError)
            }
        }

    }
}

class AlmofireAPIManager: NSObject {
    
    class AlmofireAPIManager: NSObject {
        static let shared = AlmofireAPIManager()
    }
    
    class func AlmofireGetRequest(url:String,success:@escaping (_ data : AnyObject) -> Void,failure:@escaping (_ error : NSError) -> Void){
        
        print("Request URL : \(url)\n")
        /*var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }*/
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            
            if let responseData = response.result.value {
                print("Response Data: \(responseData)")
                success(responseData as AnyObject)
            }else{
                print("Request failed with error: ",response.result.error ?? "Description not available")
                failure(response.result.error! as NSError)
            }
        }
    }
    
    class func GetRequest<model:Codable>(url:String,headers:[String:String]?,success:@escaping (model) -> Void,failure:@escaping (_ error : NSError) -> Void){
        
        print("Request URL : \(url)\n")
        
        if headers != nil{
            print("Header Token : \(headers!)")
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let responseData = response.result.value {
                print("Response Data: \(responseData)")
                let data = response.data
                do {
                    let responseObject = try JSONDecoder().decode(model.self, from: data!)
                    success(responseObject)
                }catch {
                    print(error)
                    failure(error as NSError)
                }
            }else{
                print("Request failed with error: ",response.result.error ?? "Description not available")
                failure(response.result.error! as NSError)
            }
        }
    }
    
    class func PutRequest<model:Codable>(url:String,param:[String:Any],headers:[String:String]?,success:@escaping (model) -> Void,failure:@escaping (_ error : NSError) -> Void){
        
        print("Request URL : \(url)\n")
        if headers != nil{
            print("Header Token : \(headers!)")
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: param)
        if let JSONString = String(data: jsonData!, encoding: String.Encoding.utf8) {
           print("Request Param : \(JSONString)\n")
        }
        
        Alamofire.request(url, method: .put, parameters: param, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let responseData = response.result.value {
                print("Response Data: \(responseData)")
                let data = response.data
                do {
                    let responseObject = try JSONDecoder().decode(model.self, from: data!)
                    success(responseObject)
                }catch {
                    print(error)
                    failure(error as NSError)
                }
            }else{
                print("Request failed with error: ",response.result.error ?? "Description not available")
                failure(response.result.error! as NSError)
            }
        }
    }
    
    class func AlmofirePostRequest(url:String,param:[String:Any],headers:HTTPHeaders,success:@escaping (_ data : AnyObject) -> Void,failure:@escaping (_ error : NSError) -> Void){
        
        print("Request URL : \(url)\n")
        if headers != nil{
            print("Header Token : \(headers)")
        }
        
        Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            
            if response.result.error == nil {
                if let responseData = response.result.value {
                    print("Response Data: \(responseData)")
                    success(responseData as AnyObject)
                }else{
                    print("Request failed with error: ",response.result.error ?? "Description not available")
                    failure(response.result.error! as NSError)
                }
            }else{
                print("Request failed with error: ",response.result.error ?? "Description not available")
                failure(response.result.error! as NSError)
            }
        }
    }
}

struct NoKeyParameterEncoding: ParameterEncoding {
    let parameters: String

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = self.parameters.data(using: .utf8)
        return request
    }
}

/* =================== =================== =======================*/
class APILogin {
    
    static let shared = APILogin()
    
    func login(urlStr:String,success:@escaping(LoginResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: nil) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func loginWithEmail(urlStr:String,success:@escaping(RegistrationResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: nil) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func loginAuthenticate(urlStr:String,param:[String:Any],success:@escaping(LoginAuthResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
    
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: nil) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func verifyMobileEmailCode(urlStr:String,param:[String:Any],success:@escaping(VerifyMobileEmailResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
    
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: nil) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func resendVerificationCode(urlStr:String,param:[String:Any],success:@escaping(VerifyMobileEmailResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: nil) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func registrationUser(urlStr:String,param:[String:Any],success:@escaping(RegistrationResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
    
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data,"Accept": "application/json"] as [String:String]
        }
        
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func checkAppVersion(urlStr:String,success:@escaping(CheckAppVersionResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: nil) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func getAppAllUrls(urlStr:String,success:@escaping(GetAppAllUrlsResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: nil) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func getBaseURL(urlStr:String,success:@escaping(getBaseURLResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: nil) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
}

class APIUser {
    
    static let shared = APIUser()
    
    func getUser(urlStr:String,success:@escaping(RegistrationResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        //let parameters = [:] as [String: Any]
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func putUser(urlStr:String,param:[String:Any],success:@escaping(RegistrationResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        //let parameters = [:] as [String: Any]
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.PutRequest(url: urlStr, param: param, headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func updateUser(urlStr:String,param:[String:Any],success:@escaping(UpdateUserResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        //let parameters = [:] as [String: Any]
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
}

class APIHome {
    
    static let shared = APIHome()
    
    func getAircrafts(urlStr:String,success:@escaping(AircraftsResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        //let parameters = [:] as [String: Any]
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func getAirports(urlStr:String,success:@escaping(AirportResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        //let parameters = [:] as [String: Any]
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        print(headers as Any)
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    
}

class APIRequest {
    
    static let shared = APIRequest()
    
    func getPastRequest(urlStr:String,success:@escaping(CPRequestResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
}

class APIChartererRequest {
    
    static let shared = APIChartererRequest()
    
    func getChartererRequest(urlStr:String,success:@escaping(GetCharterResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func getPreferredBidsChartererRequest(urlStr:String,success:@escaping(GetPreferredBidsResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func getChartererCRLegDetails(urlStr:String,success:@escaping(GetCRLegDetailsResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func postChartererRequest(urlStr:String,param:[String:Any],success:@escaping(PostCharterRequestResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data,"Accept": "application/json"] as [String:String]
        }
        
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func postChartererRequestPendingCount(urlStr:String,param:[String:Any],success:@escaping(CRequestPendingCntResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data,"Accept": "application/json"] as [String:String]
        }
        
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func getChartererOpenRequesDetails(urlStr:String,success:@escaping(CRequestPendingCntResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func editChartererRequest(urlStr:String,param:[String:Any],success:@escaping(PostCharterRequestResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data,"Accept": "application/json"] as [String:String]
        }
        
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func updateChartererRequest(urlStr:String,param:[String:Any],success:@escaping(CharterUpdateStatusResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data,"Accept": "application/json"] as [String:String]
        }
        
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func checkChartererRequestStatus(urlStr:String,success:@escaping(CRequestPendingCntResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data,"Accept": "application/json"] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func updatePreferredWinningBid(urlStr:String,param:[String:Any],success:@escaping(CharterUpdateStatusResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data,"Accept": "application/json"] as [String:String]
        }
        
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func updateCharterRequestAdditionalFields(urlStr:String,param:[String:Any],success:@escaping(CharterUpdateStatusResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
    
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func getBestAndMoreOptions(urlStr:String,success:@escaping(CRBestAndMoreOptionResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
    
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func saveSelectedBestMoreOptionsData(urlStr:String,param:String,success:@escaping(CharterUpdateStatusResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
    
        APIManager.shared.alamofirePostParam(url: urlStr, param: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
        
    }
    
    func getChartererReqAuctionRemTime(urlStr:String,success:@escaping(CRAuctionTimeResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func getReadyTime(urlStr:String,success:@escaping(CRAuctionTimeResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func getCurrentBidPrice(urlStr:String,success:@escaping(CurrentBidPriceResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func searchFlightChartererRequest(urlStr:String,success:@escaping(SearchFlightResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data,"Accept": "application/json"] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
}

class APIOwnerAircraft {
    
    static let shared = APIOwnerAircraft()
    
    
    func getOwnerAircraft(urlStr:String,success:@escaping(GetOwnerAircraftResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
}

class APISplitPayment {
    
    static let shared = APISplitPayment()
    
    func saveSplitPaymentContactIDCSV(urlStr:String,param:[String:Any],success:@escaping(AddEditContactResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
    
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func getSplitContactDetails(urlStr:String,success:@escaping(GetSplitContactDetailResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func getSelectedBestAndMoreOptions(urlStr:String,success:@escaping(GetSelectedBestAndMoreOptionsResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func saveChartererSplitPaymentContactDetails(urlStr:String,param:[String:Any],success:@escaping(SplitPaymentContactDetailResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
    
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
}

class APISplitContacts {
    
    static let shared = APISplitContacts()
    
    func addContact(urlStr:String,param:[String:Any],success:@escaping(AddEditContactResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
    
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
    
    func getAllContacts(urlStr:String,success:@escaping(GetAllContactResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
}
    
class APICountry {
    
    static let shared = APICountry()
    
    func getAllCountry(urlStr:String,success:@escaping(CountryResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
}
    
class APITrip {
    
    static let shared = APITrip()
    
    func getMyTripRequest(urlStr:String,success:@escaping(MyTripResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
    
    func getMyTripDetails(urlStr:String,success:@escaping(TripDetailsResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
}

class APIPayment {
    
    static let shared = APIPayment()
    
    func getPaymentDetailequest(urlStr:String,success:@escaping(PaymentDetailResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
        
        AlmofireAPIManager.GetRequest(url: urlStr,headers: headers) { response in
            success(response)
        } failure: { error in
            fail(error)
        }
    }
}

class APIAddEditAppNotificationToken {
    
    static let shared = APIAddEditAppNotificationToken()
    
    func saveAppNotificationToken(urlStr:String,param:[String:Any],success:@escaping(AppNotificationTokenResponse)-> Void,fail:@escaping(_ error: NSError)-> Void){
        
        var headers:HTTPHeaders!
        if UserDefaults.standard.value(forKey: "Authorization") != nil{
            let data = UserDefaults.standard.value(forKey: "Authorization") as! String
            headers = ["Authorization":data] as [String:String]
        }
    
        APIManager.shared.observerModel(url: urlStr, parameters: param, headers: headers) { response in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
}
