//
//  EnumStruct.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 15/01/23.
//

import Foundation
import UIKit

enum StoryBoardName: String {
    case Main
    case Login
    case Home
    case AddressList
    case LeftMenuViewController
    case Profile
    case RequestList
    case RequestConfirm
    case PreviewOffer
    case ManageContacts
    case CurrentRequest
    case Verification
    case InstantBook
    case MyTrips
    case Privacy
    
}

struct TableCells{
    static let AddressListCell = "AddressListCell"
    static let SingleStringCell = "SingleStringCell"
    static let RequestListCell = "RequestListCell"
    static let RequestDetailCell = "RequestDetailCell"
    static let RequestCell1 = "HomeCell1"
    static let RequestCell2 = "HomeCell2"
    static let RequestCell3 = "HomeCell3"
    static let MultiCityCell = "MultiCityCell"
    static let RequestConfirmCell = "RequestConfirmCell"
    static let RequestBestOptionCell = "RequestBestOptionCell"
    static let RequestAcceptCell = "RequestAcceptCell"
    static let SplitPaymentCell = "SplitPaymentCell"
    static let PaymentSplitCell = "PaymentSplitCell"
    static let HeaderImageCell = "HeaderImageCell"
    static let ContactsHeaderCell = "ContactsHeaderCell"
    static let ContactsListCell = "ContactsListCell"
    static let ManageContactListCell = "ManageContactListCell"
    static let VerificationCodeCell = "VerificationCodeCell"
    static let CancelRequestCell = "CancelRequestCell"
    static let InstantBookViewCell = "InstantBookViewCell"
    static let FlagListViewCell = "FlagListViewCell"
    static let MyTripDetailCell = "MyTripDetailCell"
    static let MyTripDetailsCell = "MyTripDetailsCell"
    static let ConfirmationCodeCell = "ConfirmationCodeCell"
    static let CreateNewViewTblCell = "CreateNewViewTblCell"
    static let BestAndMoreOptionCell = "BestAndMoreOptionCell"
    static let SourceToDestHeaderCell = "SourceToDestHeaderCell"
    static let SubmitButtonCell = "SubmitButtonCell"
    static let SelectedAircraftCell = "SelectedAircraftCell"
    static let TransportInflightServiceCell = "TransportInflightServiceCell"
    static let PastRequestTblCell = "PastRequestTblCell"
    static let RequestListDetailCell = "RequestListDetailCell"
    static let EnhanceTblCell = "EnhanceTblCell"
    static let RequestAcceptListCell = "RequestAcceptListCell"
    static let CongratulationCell = "CongratulationCell"
}

struct CollectionViewCells{
    static let SafetyRatingCell = "SafetyRatingCell"
    static let legCollectionCell = "legCollectionCell"
}

struct APIUrl{
    //stage
    static let baseUrl = "https://stage.apiv2.flyhouse.us/api"
    //live
    //static let baseUrl = "https://app-api.flyhouse.us/api"
    //"https://fhapi.sycamoresol.com/api"
    static let previewBaseURL = String(format: "%@/flyhousemobile", CommonFunction.getValueFromForKey(key: "aircraftpreviewbaseurl"))
    //"https://charter.flyhouse.us/flyhousemobile"
    
    
    /*
     
     Stage FlyHoues APIv2:
     https://stage.apiv2.flyhouse.us/

     Live FlyHouse APIv2:
     https://apiv2.flyhouse.us
     
     */
}

struct APPUrls{
    
    static let termsCondNew = String(format: "%@", CommonFunction.getValueFromForKey(key: "termsandconditionsurl"))
    //"https://flyhouse.uuus/tos"
    
    static let imageBaseUrl = String(format: "%@", CommonFunction.getValueFromForKey(key: "countryimagesbaseurl"))
    //"https://charter.flyhouse.us/flyhousemobile/images/flags/"
    
    static let ratingImageBaseUrl = String(format: "%@", CommonFunction.getValueFromForKey(key: "ratingsimagesbaseurl"))
    //""
    
    static let privacyURL = String(format: "%@/", CommonFunction.getValueFromForKey(key: "privacycenterbaseurl"))
    //"https://privacycenter.flyhouse.us/flyhouseprivacycenter"
    
    static let fpwdURL = String(format: "%@", CommonFunction.getValueFromForKey(key: "forgotpasswordbaseurl"))
    //"https://charter.flyhouse.us/flyhousemobile/cVerifyCharterer?resetPassword=1&ismobile=1"
    
    static let termsandconditionsurlCR = String(format: "%@/", CommonFunction.getValueFromForKey(key: "termsandconditionsurlCR"))
   
    
}

struct UserDefaultsKeys{
    static let ChartererRequestID = "ChartererRequestID"
    static let CharterRequestTypeIndex = "TypeIndex"
    static let PostResponseData = "PostResponseData"
}


extension UIApplication {
     
    static var getVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "0.0"
    }
    static var getBuildVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "0"
    }
    
    static var getIdentifierName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String? ?? ""
    }
}
