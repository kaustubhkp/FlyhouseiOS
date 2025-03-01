//
//  SplitContacts.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import Foundation

//Get All Contacts
struct GetAllContactResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[SplitContacts]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct SplitContacts:Codable{
    var splitPaymentContactID:Int?
    var firstName:String?
    var lastName:String?
    var email:String?
    var mobile:String?
    var userID:Int?
    var isCharterer:Int?
    var noOfPassenger:Int?
          
    enum CodingKeys: String, CodingKey {
        case splitPaymentContactID = "SplitPaymentContactID"
        case firstName = "FirstName"
        case lastName = "LastName"
        case email = "Email"
        case mobile = "Phone"
        case userID = "UserID"
        case isCharterer = "IsCharterer"
        case noOfPassenger = "NoOfPassengers"
    }
}


//Add Edit Contacts
struct AddEditContactResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:Int?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct GetSplitContactDetailResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[GetSplitPaymentDetails]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct GetSplitPaymentDetails:Codable{
    var SplitPaymentID:Int?
    var CharterRequestID:Int?
    var SplitPaymentContactID:Int?
    var SplitPaymentContactIDCSV:String?
    var NoOfPassengers:Int?
    var CostPerPerson:Int?
    var Amount:Int?
    var IsCharterer:Int?
    var FHPercentage:Int?
    var FHCharges:Int?
    var FETPercentage:Double?
    var FETCharges:Int?
    var PassengerSegmentFeesPerPerson:Double?
    var TotalPassengerSegmentFees:Double?
    var IsCancellationOpted:Int?
    var CancellationPercentage:Int?
    var CancellationFees:Int?
    var FinalAmount:Int?
    var EncodedValue:String?
    var ChartereSplitPaymentContact:SplitContacts?
    
          
    enum CodingKeys: String, CodingKey {
        case SplitPaymentID
        case CharterRequestID
        case SplitPaymentContactID
        case SplitPaymentContactIDCSV
        case NoOfPassengers
        case CostPerPerson
        case Amount
        case IsCharterer
        case FHPercentage
        case FHCharges
        case FETPercentage
        case FETCharges
        case PassengerSegmentFeesPerPerson
        case TotalPassengerSegmentFees
        case IsCancellationOpted
        case CancellationPercentage
        case CancellationFees
        case FinalAmount
        case EncodedValue
        case ChartereSplitPaymentContact
    }
}


//Add Edit Contacts
struct SplitPaymentContactDetailResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:Bool?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}


struct GetSelectedBestAndMoreOptionsResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[GetSelectedBestAndMoreData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct GetSelectedBestAndMoreData:Codable{
    var CharterRequestID:Int?
    var StartAirportID:String?
    var EndAirportID:String?
    var AircraftType:String?
    var OwnerAircraft:String?
    var FinalAmount:Double?
    var IsPartnerAircraft:Int?
    var RatingImageCSV:String?
    var IsChildRequest:Int?
    var ParentRequestID:Int?
    
          
    enum CodingKeys: String, CodingKey {
        case CharterRequestID
        case StartAirportID
        case EndAirportID
        case AircraftType
        case OwnerAircraft
        case FinalAmount
        case IsPartnerAircraft
        case RatingImageCSV
        case IsChildRequest
        case ParentRequestID
    }
}
