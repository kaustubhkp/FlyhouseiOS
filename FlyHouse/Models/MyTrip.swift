//
//  MyTrip.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 11/02/24.
//

import Foundation

struct MyTripResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[MyTripData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct MyTripData:Codable{
    var TripID:Int?
    var ChartererRequestID:Int?
    var SchedAeroTripID:String?
    var UserID:Int?
    var StartAirportID:String?
    var StartDisplayLine1:String?
    var StartDisplayLine2:String?
    var Arrival:String?
    var EndAirportID:String?
    var EndDisplayLine1:String?
    var EndDisplayLine2:String?
    var Destination:String?
    var StartDateTime:String?
    var StartTime:String?
    var EndDateTime: String?
    var Status: Int?
    var PaxCount:Int?
    var PaxSegment: String?
    var Distance:Int?
    var Note: String?
    var IsTransportNeeded: Int?
    var IsInflightServiceNeeded:Int?
    var OwnerID: Int?
    var AircraftID:Int?
    var Price:String?
    var EstimatedTimeInMinute:Int?
    var OwnerAircraftID:Int?
    var AircraftImage: String?
    var Aircraft: String?
    var PaymentID:Int?
    var DocuSignStatus:String?
    
          
    enum CodingKeys: String, CodingKey {
        case TripID
        case ChartererRequestID
        case SchedAeroTripID
        case UserID
        case StartAirportID
        case StartDisplayLine1
        case StartDisplayLine2
        case EndDisplayLine1
        case EndDisplayLine2
        case Arrival
        case EndAirportID
        case Destination
        case StartDateTime
        case StartTime
        case EndDateTime
        case Status
        case PaxCount
        case PaxSegment
        case Distance
        case Note
        case IsTransportNeeded
        case IsInflightServiceNeeded
        case OwnerID
        case AircraftID
        case Price
        case EstimatedTimeInMinute
        case OwnerAircraftID
        case AircraftImage
        case Aircraft
        case PaymentID
        case DocuSignStatus
    }
}

struct PaymentDetailResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:PaymentData?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct PaymentData:Codable{
    var PaymentID:Int?
    var ChartererRequestID: Int?
    var PaymentTypeID:Int?
    var ConfirmationCode:String?
    var CreditCardID: Int?
    var ACHID: Int?
    var AgainstUserID: Int?
    var InitiatorTypeID: Int?
    var PaymentStatusID: Int?
    var TransactionNumber:String?
    var ResponseJson: String?
    var AddedBy:Int?
    var PaymentType: String?
    var InitiatorType:String?
    var PaymentStatus: String?
    var AmountPaid:Double?
    var PaymentDate:String?
    var Amount:Double?
    var FHPercentage: Double?
    var FHCharges: Double?
    var FETPercentage:Double?
    var FETCharges:Double?
    var PassengerSegmentFeesPerPerson:Double?
    var TotalPassengerSegmentFees:Double?
    var IsCancellationOpted:Int?
    var CancellationPercentage:Int?
    var CancellationFees:Int?
    var FinalAmount:Double?
    var AmountDue:Double?
    var PaymentTripID:Int?
    var SplitPaymentID:Int?
    var SplitPaymentContactID:Int?
    var ActualPaymentMade:Double?
    var IsExternalPayment:Int?
    
          
    enum CodingKeys: String, CodingKey {
        case PaymentID
        case ChartererRequestID
        case PaymentTypeID
        case ConfirmationCode
        case CreditCardID
        case ACHID
        case AgainstUserID
        case InitiatorTypeID
        case PaymentStatusID
        case TransactionNumber
        case ResponseJson
        case AddedBy
        case PaymentType
        case InitiatorType
        case PaymentStatus
        case AmountPaid
        case PaymentDate
        case Amount
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
        case AmountDue
        case PaymentTripID
        case SplitPaymentID
        case SplitPaymentContactID
        case ActualPaymentMade
        case IsExternalPayment
    }
}


struct TripDetailsResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[TripDetailsData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct TripDetailsData : Codable{
    var TripID:Int?
    var ChartererRequestID:Int?
    var SchedAeroTripID:String?
    var UserID:Int?
    var StartAirportID:String?
    var EndAirportID:String?
    var Arrival:String?
    var Destination:String?
    var StartDateTime:String?
    var StartTime: String?
    var EndDateTime: String?
    var Status:Int?
    var PaxCount:Int?
    var PaxSegment:String?
    var Distance:Int?
    var Note:String?
    var IsTransportNeeded: Int?
    var IsInflightServiceNeeded:Int?
    var OwnerID: Int?
    var AircraftID: Int?
    var Price:String?
    var EstimatedTimeInMinute: Int?
    var OwnerAircraftID: Int?
    var AircraftImage: String?
    var Aircraft: String?
    var PaymentID:Int?
    var DocuSignStatus:String?
    var StartDisplayLine1: String?
    var StartDisplayLine2: String?
    var EndDisplayLine1: String?
    var EndDisplayLine2:String?
    var ConfirmationCode: String?
    
    
    enum CodingKeys: String, CodingKey {
        case TripID
        case ChartererRequestID
        case SchedAeroTripID
        case UserID
        case StartAirportID
        case EndAirportID
        case Arrival
        case Destination
        case StartDateTime
        case StartTime
        case EndDateTime
        case Status
        case PaxCount
        case PaxSegment
        case Distance
        case Note
        case IsTransportNeeded
        case IsInflightServiceNeeded
        case OwnerID
        case AircraftID
        case Price
        case EstimatedTimeInMinute
        case OwnerAircraftID
        case AircraftImage
        case Aircraft
        case PaymentID
        case DocuSignStatus
        case StartDisplayLine1
        case StartDisplayLine2
        case EndDisplayLine1
        case EndDisplayLine2
        case ConfirmationCode
        
    }
    
}
