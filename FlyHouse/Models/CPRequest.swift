//
//  CPRequest.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import Foundation


struct CPRequestResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[CPRequestData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}


struct CPRequestData : Codable{
    var activeUserID:String?
    var aircraft:String?
    var aircraftID:Int?
    var auctionEndTime:String?
    var auctionStartTime:String?
    var auctionTimeInMinutes:Int?
    var chartererRequestID:Int?
    var createdOn:String?
    var currentDateTime:String?
    var distance:String?
    var endAirportID:String?
    var EndDisplayLine1:String?
    var EndDisplayLine2:String?
    var endDateTime:String?
    var StartTime: String?
    var estimatedTimeInMinute:Int?
    var id:Int?
    var isInflightServiceNeeded:Int?
    var isTransportNeeded:Int?
    var lowestAmount:Int?
    var note:String?
    var ownerAircraft:String?
    var ownerAircraftID:Int?
    var ownerID:Int?
    var paxCount:Int?
    var paxSegment:String?
    var preferredAircraft:String?
    var preferredAircraftID:Int?
    var FinalAmount:Double?
    var preferredAircraftIDCSV:String?
    var priceExpectation:Double?
    var requestStatus:String?
    var startAirportID:String?
    var StartDisplayLine1:String?
    var StartDisplayLine2:String?
    var startDateTime:String?
    var status:Int?
    var travelTimeHHMM:String?
    var userID:Int?
    var winningPrice:Double?
    var endcity:String?
    var endcountry:String?
    var endstate:String?
    var startcity:String?
    var startcountry:String?
    var startstate:String?
    
    enum CodingKeys: String, CodingKey {
        case activeUserID = "ActiveUserID"
        case aircraft = "Aircraft"
        case aircraftID = "AircraftID"
        case auctionEndTime = "AuctionEndTime"
        case auctionStartTime = "AuctionStartTime"
        case auctionTimeInMinutes = "AuctionTimeInMinutes"
        case chartererRequestID = "ChartererRequestID"
        case createdOn = "CreatedOn"
        case currentDateTime = "CurrentDateTime"
        case distance = "Distance"
        case endAirportID = "EndAirportID"
        case EndDisplayLine1
        case EndDisplayLine2
        case endDateTime = "EndDateTime"
        case estimatedTimeInMinute = "EstimatedTimeInMinute"
        case id = "ID"
        case isInflightServiceNeeded = "IsInflightServiceNeeded"
        case isTransportNeeded = "IsTransportNeeded"
        case lowestAmount = "LowestAmount"
        case note = "Note"
        case ownerAircraft = "OwnerAircraft"
        case ownerAircraftID = "OwnerAircraftID"
        case ownerID = "OwnerID"
        case paxCount = "PaxCount"
        case paxSegment = "PaxSegment"
        case preferredAircraft = "PreferredAircraft"
        case preferredAircraftID = "PreferredAircraftID"
        case preferredAircraftIDCSV = "PreferredAircraftIDCSV"
        case priceExpectation = "PriceExpectation"
        case requestStatus = "RequestStatus"
        case startAirportID = "StartAirportID"
        case StartDisplayLine1
        case StartDisplayLine2
        case startDateTime = "StartDateTime"
        case status = "Status"
        case travelTimeHHMM = "TravelTimeHHMM"
        case userID = "UserID"
        case winningPrice = "WinningPrice"
        case endcity = "endcity"
        case endcountry = "endcountry"
        case endstate = "endstate"
        case startcity = "startcity"
        case startcountry = "startcountry"
        case startstate = "startstate"
        case StartTime = "StartTime"
        case FinalAmount = "FinalAmount"
    }
}


struct CRAuctionTimeResponse : Codable{
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

struct CRBestAndMoreOptionResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[BestAndMoreOptionData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct BestAndMoreOptionData : Codable{
    var aircraftID:Int?
    var aircraftType:String?
    var crMoreOptionsPricing:[MoreOptionsData]?
    var chartererRequestID:Int?
    var startAirportID:String?
    var endAirportID:String?
    var finalAmount:Double?
    var isChildRequest:Int?
    var isPartnerAircraft:Int?
    var ownerAircraft:String?
    var ownerAircraftID:Int?
    var parentRequestID:Int?
    var requestTypeID: Int?
    var ratingImageCSV:String?
    var requestTypeToUseID :Int?
    var ownerID:Int?
    var partnerProfileRatings:[PartnerProfileRatingsData]?
    
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case aircraftID = "AircraftID"
        case aircraftType = "AircraftType"
        case crMoreOptionsPricing = "CRMoreOptionsPricing"
        case chartererRequestID = "ChartererRequestID"
        case startAirportID = "StartAirportID"
        case endAirportID = "EndAirportID"
        case finalAmount = "FinalAmount"
        case isChildRequest = "IsChildRequest"
        case isPartnerAircraft = "IsPartnerAircraft"
        case ownerAircraft = "OwnerAircraft"
        case ownerAircraftID = "OwnerAircraftID"
        case parentRequestID = "ParentRequestID"
        case requestTypeID = "RequestTypeID"
        case ratingImageCSV = "RatingImageCSV"
        case requestTypeToUseID = "RequestTypeToUseID"
        case ownerID = "OwnerID"
        case partnerProfileRatings = "PartnerProfileRatings"
    }
}

struct MoreOptionsData :Codable{
    var ID:Int?
    var ChartererRequestID:Int?
    var StartAirportID:String?
    var StartDateTime:String?
    var EndAirportID:String?
    var EndDateTime:String?
    var EstimatedTimeInMinute:Int?
    var FinalAmount:Double?
    var IsChildRequest:Int?
    var IsPartnerAircraft:Int?
    var OwnerAircraftID:Int?
    var OwnerID:Int?
    var ParentRequestID:Int?
    var PreferredAircraft:String?
    var PreferredAircraftID:Int?
    var PreferredAircraftType:String?
    var RatingImageCSV:String?
    var RequestTypeID:Int?
    var RequestTypeToUseID:Int?
    var WinningPrice:Double?
    var PartnerProfileRatings:[PartnerProfileRatingsData]?
    
    enum CodingKeys: String, CodingKey {
        case ID
        case ChartererRequestID
        case StartAirportID
        case StartDateTime
        case EndAirportID
        case EndDateTime
        case EstimatedTimeInMinute
        case FinalAmount
        case IsChildRequest
        case IsPartnerAircraft
        case OwnerAircraftID
        case OwnerID
        case ParentRequestID
        case PreferredAircraft
        case PreferredAircraftID
        case PreferredAircraftType
        case RatingImageCSV
        case RequestTypeID
        case RequestTypeToUseID
        case WinningPrice
        case PartnerProfileRatings
    }
}

struct PartnerProfileRatingsData:Codable{
    var ImagePath:String?
    var PartnerProfileQualicationType:String?
    var PartnerProfileQualificationTypeID:Int?
    var Rating:String?
    
    enum CodingKeys: String, CodingKey {
        case ImagePath
        case PartnerProfileQualicationType
        case PartnerProfileQualificationTypeID
        case Rating
    }
}
