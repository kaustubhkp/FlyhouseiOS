//
//  Home.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import Foundation

struct AircraftsResponse : Codable{
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

struct AircraftsData : Codable{
    var aircraftID:Int?
    var aircraftTypeID:Int?
    var aircraftType:String?
    var aircraft:String?
    var aircraftText:String?
    var passengerCapacity:String?
    var range:String?
    var rangeKm:Int?
    var baggageCapacity:String?
    var facilities:String?
    var aircraftImg:String?
    
    enum CodingKeys: String, CodingKey {
        case aircraftID = "AircraftID"
        case aircraftTypeID = "AircraftTypeID"
        case aircraftType = "AircraftType"
        case aircraft = "Aircraft"
        case aircraftText = "AircraftText"
        case passengerCapacity = "PassengerCapacity"
        case range = "Range"
        case rangeKm = "RangeKm"
        case baggageCapacity = "BaggageCapacity"
        case facilities = "Facilities"
        case aircraftImg = "AircraftImg"
    }
}

struct AirportResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[AirportData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}


struct AirportData : Codable{
    var airportID:Int?
    var displayLine1:String?
    var displayLine2:String?
    var code:String?
    var lat:String?
    var long:String?
    var name:String?
    var city:String?
    var state:String?
    var country:String?
    var woeid:String?
    var tz:String?
    var phone:String?
    var type:String?
    var email:String?
    var url:String?
    var runway_length:String?
    var elev:String?
    var icao:String?
    var direct_flights:String?
    var carriers:String?
    var ifaa:String?
    var iata:String?
    
    enum CodingKeys: String, CodingKey {
        case airportID = "AirportID"
        case displayLine1 = "DisplayLine1"
        case displayLine2 = "DisplayLine2"
        case code = "code"
        case lat = "lat"
        case long = "lon"
        case name = "name"
        case city = "city"
        case state = "state"
        case country = "country"
        case woeid = "woeid"
        case tz = "tz"
        case phone = "phone"
        case type = "type"
        case email = "email"
        case url = "url"
        case runway_length = "runway_length"
        case elev = "elev"
        case icao = "icao"
        case direct_flights = "direct_flights"
        case carriers = "carriers"
        case ifaa
        case iata
    }
}

struct PostCharterRequestResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:CharterreResponse?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}
struct CharterreResponse : Codable{
    var chartererRequestID:Int?
    var distance:String?
    var endAirportID:String?
    var endDateTime:String?
    var note:String?
    var paxCount:Int?
    var paxSegment:String?
    var preferredAircraftIDCSV:String?
    var priceExpectation:Double?
    var startAirportID:String?
    var startDateTime:String?
    var startTime:String?
    var status:Int?
    var requestTypeID:Int?
    var requestTypeToUseID:Int?
    var estimatedTimeInMinute:Int?
    var crleg:[CRLegData]?
    var modelState:ModelData?
    
    enum CodingKeys: String, CodingKey {
        case chartererRequestID = "ChartererRequestID"
        case distance = "Distance"
        case endAirportID = "EndAirportID"
        case endDateTime = "EndDateTime"
        case note = "Note"
        case paxCount = "PaxCount"
        case paxSegment = "PaxSegment"
        case preferredAircraftIDCSV = "PreferredAircraftIDCSV"
        case priceExpectation = "PriceExpectation"
        case startAirportID = "StartAirportID"
        case startDateTime = "StartDateTime"
        case status = "Status"
        case startTime = "StartTime"
        case requestTypeID = "RequestTypeID"
        case requestTypeToUseID = "RequestTypeToUseID"
        case estimatedTimeInMinute = "EstimatedTimeInMinute"
        case crleg = "CRLeg"
        case modelState = "ModelState"
    }
    
}

struct ModelData:Codable{
    var error:[String]?
    
    enum CodingKeys: String, CodingKey {
        case error = "Error"
    }
}

struct CRLegData : Codable{
    var distance:String?
    var endAirport:String?
    var endAirportInfo:String?
    var endDateTime:String?
    var estimatedTimeInMinute:Int?
    var sequenceID:Int?
    var startAirport:String?
    var startAirportInfo:String?
    var startDateTime:String?
    var startTime:String?
    
    enum CodingKeys: String, CodingKey {
        case distance = "Distance"
        case endAirport = "EndAirport"
        case endAirportInfo = "EndAirportInfo"
        case endDateTime = "EndDateTime"
        case estimatedTimeInMinute = "EstimatedTimeInMinute"
        case sequenceID = "SequenceID"
        case startAirport = "StartAirport"
        case startAirportInfo = "StartAirportInfo"
        case startDateTime = "StartDateTime"
        case startTime = "StartTime"
    }
}

struct CharterUpdateStatusResponse : Codable{
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


struct GetCharterResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:CharterReqData?
    var title:String?
    
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct CharterReqData : Codable {
    var ActiveUserID:String?
    var Aircraft:String?
    var AircraftID:Int?
    var AuctionEndTime:String?
    var AuctionStartTime:String?
    var AuctionTimeInMinutes:Int?
    var BidAcceptanceDateTime:String?
    var CRleg:String?
    var CRSegments:[CRlegDetailData]?
    var CancellationFees:Int?
    var CancellationPercentage:Int?
    var ChartererRequestID:Int?
    var CreatedOn:String?
    var CurrentBidAmount:Double?
    var CurrentDateTime:String?
    var Distance:String?
    var EncodedValue:String?
    var EndAirportID:String?
    var EndDateTime:String?
    var EstimatedTimeInMinute:Int?
    var ID:Int?
    var IsCancellationOpted:Int?
    var IsInflightServiceNeeded:Int?
    var IsPaymentConfirmed:Int?
    var IsTransportNeeded:Int?
    var IsSplitPayment:Int?
    var FinalAmount:Double?
    var LowestAmount:Double?
    var LowestPreferredAircraftType:String?
    var MinBidPrice:Double?
    var MaxBidPrice:Double?
    var Note:String?
    var OwnerAircraft:String?
    var OwnerAircraftID:Int?
    var OwnerMaxPaxCount:Int?
    var OwnerID:Int?
    var OwnerMobile:String?
    var OwnerName:String?
    var PaxCount:Int?
    var PaxSegment:String?
    var PaymentConfirmedDateTime:Int?
    var PreferredAircraft:String?
    var PreferredAircraftID:Int?
    var PreferredAircraftIDCSV:String?
    var PreferredAircraftType:String?
    var PreferredAircraftTypeCSV:String?
    var PreferredAircraftTypeID:Int?
    var PreferredAircraftTypeIDCSV:String?
    var PriceExpectation:Double?
    var RequestStatus:String?
    var RequestTypeID:Int?
    var RequestTypeToUseID:Int?
    var StartAirportID:String?
    var StartDateTime:String?
    var StartTime:String?
    var Status:Int?
    var TotalPassengerSegmentFees:Double?
    var TravelTimeHHMM:String?
    var UserID:Int?
    var WinningPrice :Double?
    var endcity:String?
    var endcountry:String?
    var endstate:String?
    var startcity:String?
    var startcountry:String?
    var startstate:String?
    var AuctiontimeMilliseconds:String?
    var ChartererAcceptanceTimeMilliseconds:String?
    var ChartererAcceptanceTimeInSeconds:String?
    
    enum CodingKeys: String, CodingKey {
        case ActiveUserID
        case Aircraft
        case AircraftID
        case AuctionEndTime
        case AuctionStartTime
        case AuctionTimeInMinutes
        case BidAcceptanceDateTime
        case CRleg
        case CRSegments
        case CancellationFees
        case CancellationPercentage
        case ChartererRequestID
        case CreatedOn
        case CurrentBidAmount
        case CurrentDateTime
        case Distance
        case EncodedValue
        case EndAirportID
        case EndDateTime
        case EstimatedTimeInMinute
        case ID
        case IsCancellationOpted
        case IsInflightServiceNeeded
        case IsPaymentConfirmed
        case IsTransportNeeded
        case IsSplitPayment
        case FinalAmount
        case LowestAmount
        case LowestPreferredAircraftType
        case MinBidPrice
        case MaxBidPrice
        case Note
        case OwnerAircraft
        case OwnerAircraftID
        case OwnerMaxPaxCount
        case OwnerID
        case OwnerMobile
        case OwnerName
        case PaxCount
        case PaxSegment
        case PaymentConfirmedDateTime
        case PreferredAircraft
        case PreferredAircraftID
        case PreferredAircraftIDCSV
        case PreferredAircraftType
        case PreferredAircraftTypeCSV
        case PreferredAircraftTypeID
        case PreferredAircraftTypeIDCSV
        case PriceExpectation
        case RequestStatus
        case RequestTypeID
        case RequestTypeToUseID
        case StartAirportID
        case StartDateTime
        case StartTime
        case Status
        case TotalPassengerSegmentFees
        case TravelTimeHHMM
        case UserID
        case WinningPrice
        case endcity
        case endcountry
        case endstate
        case startcity
        case startcountry
        case startstate
        case AuctiontimeMilliseconds
        case ChartererAcceptanceTimeMilliseconds
        case ChartererAcceptanceTimeInSeconds
    }
}


struct GetOwnerAircraftResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[String]?
    var title:String?
    
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct GetPreferredBidsResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[CharterReqData]?
    var title:String?
    
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct GetMoreBidsResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[MoreBidData]?
    var title:String?
    
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct MoreBidData : Codable {
    var ActiveUserID:String?
    var Aircraft:String?
    var AircraftID:Int?
    var AuctionEndTime:String?
    var AuctionStartTime:String?
    var AuctionTimeInMinutes:Int?
    var BidAcceptanceDateTime:String?
    var CRleg:String?
    var CancellationFees:Int?
    var CancellationPercentage:Int?
    var ChartererRequestID:Int?
    var CreatedOn:String?
    var CurrentBidAmount:Int?
    var CurrentDateTime:String?
    var Distance:String?
    var EncodedValue:String?
    var EndAirportID:String?
    var EndDateTime:String?
    var EstimatedTimeInMinute:Int?
    var ID:Int?
    var IsCancellationOpted:Int?
    var IsInflightServiceNeeded:Int?
    var IsPaymentConfirmed:Int?
    var IsTransportNeeded:Int?
    var LowestAmount:Int?
    var LowestPreferredAircraftType:String?
    var Note:String?
    var OwnerAircraft:String?
    var OwnerAircraftID:Int?
    var OwnerID:Int?
    var OwnerMobile:String?
    var OwnerName:String?
    var PaxCount:Int?
    var PaxSegment:String?
    var PaymentConfirmedDateTime:Int?
    var PreferredAircraft:String?
    var PreferredAircraftID:Int?
    var PreferredAircraftIDCSV:String?
    var PreferredAircraftType:String?
    var PreferredAircraftTypeCSV:String?
    var PreferredAircraftTypeID:Int?
    var PreferredAircraftTypeIDCSV:String?
    var PriceExpectation:Double?
    var RequestStatus:String?
    var RequestTypeID:Int?
    var StartAirportID:String?
    var StartDateTime:String?
    var StartTime:String?
    var Status:Int?
    var TotalPassengerSegmentFees:Int?
    var TravelTimeHHMM:String?
    var UserID:Int?
    var WinningPrice :Int?
    var endcity:String?
    var endcountry:String?
    var endstate:String?
    var startcity:String?
    var startcountry:String?
    var startstate:String?
    
    enum CodingKeys: String, CodingKey {
        case ActiveUserID
        case Aircraft
        case AircraftID
        case AuctionEndTime
        case AuctionStartTime
        case AuctionTimeInMinutes
        case BidAcceptanceDateTime
        case CRleg
        case CancellationFees
        case CancellationPercentage
        case ChartererRequestID
        case CreatedOn
        case CurrentBidAmount
        case CurrentDateTime
        case Distance
        case EncodedValue
        case EndAirportID
        case EndDateTime
        case EstimatedTimeInMinute
        case ID
        case IsCancellationOpted
        case IsInflightServiceNeeded
        case IsPaymentConfirmed
        case IsTransportNeeded
        case LowestAmount
        case LowestPreferredAircraftType
        case Note
        case OwnerAircraft
        case OwnerAircraftID
        case OwnerID
        case OwnerMobile
        case OwnerName
        case PaxCount
        case PaxSegment
        case PaymentConfirmedDateTime
        case PreferredAircraft
        case PreferredAircraftID
        case PreferredAircraftIDCSV
        case PreferredAircraftType
        case PreferredAircraftTypeCSV
        case PreferredAircraftTypeID
        case PreferredAircraftTypeIDCSV
        case PriceExpectation
        case RequestStatus
        case RequestTypeID
        case StartAirportID
        case StartDateTime
        case StartTime
        case Status
        case TotalPassengerSegmentFees
        case TravelTimeHHMM
        case UserID
        case WinningPrice
        case endcity
        case endcountry
        case endstate
        case startcity
        case startcountry
        case startstate
    }
}


struct CRequestPendingCntResponse : Codable{
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


struct GetCRLegDetailsResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[CRlegDetailData]?
    var title:String?
    
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct CRlegDetailData : Codable{
    var ChartererRequestID:Int?
    var RequestTypeID:Int?
    var SequenceID:Int?
    var UserID:Int?
    var ChartererName:String?
    var StartAirport:String?
    var StartDisplayLine1:String?
    var StartDisplayLine2:String?
    var AirportNameFrom:String?
    var StartCityStateCountry:String?
    var EndAirport:String?
    var EndDisplayLine1:String?
    var EndDisplayLine2:String?
    var AirportNameTo:String?
    var EndCityStateCountry:String?
    var TailNumber:String?
    var MakeModel:String?
    var StartDateTime:String?
    var StartTime:String?
    var EndDateTime:String?
    var JourneyDate:String?
    var Status:Int?
    var PaxCount:Int?
    var PaxSegment:String?
    var Distance:String?
    var EstimatedTimeInMinute:Int?
    
    enum CodingKeys: String, CodingKey {
        case ChartererRequestID
        case RequestTypeID
        case SequenceID
        case UserID
        case ChartererName
        case StartAirport
        case StartDisplayLine1
        case StartDisplayLine2
        case AirportNameFrom
        case StartCityStateCountry
        case EndAirport
        case EndDisplayLine1
        case EndDisplayLine2
        case AirportNameTo
        case EndCityStateCountry
        case TailNumber
        case MakeModel
        case StartDateTime
        case StartTime
        case EndDateTime
        case JourneyDate
        case Status
        case PaxCount
        case PaxSegment
        case Distance
        case EstimatedTimeInMinute
    }
}


struct CurrentBidPriceResponse : Codable{
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

struct SearchFlightResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[SearchFlightResponseData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct SearchFlightResponseData : Codable {
    var Aircraft:String?
    var AircraftID:Int?
    var AvailableTripDateCSV:String?
    var Category:String?
    var CRleg:String?
    var Distance:String?
    var ExpectedTimeInMinutes:String?
    var EndAirportID:String?
    var EndDateTime:String?
    var FHPercentage:Double?
    var FHCharges:Double?
    var FETPercentage:Double?
    var FETCharges:Double?
    var FinalAmount:Double?
    var IntlPercentage:Double?
    var NoOfSegments:Int?
    var NoOfPassengers:Int?
    var OwnerAircraftID:Int?
    var OwnerID:Int?
    var PaxCount:Int?
    var PaxSegment:String?
    var PriceExpectation:Double?
    var PassengerSegmentFeesPerPerson:Double?
    var StartAirportID:String?
    var StartDateTime:String?
    var StartDisplayLine1:String?
    var StartDisplayLine2:String?
    var EndDisplayLine1:String?
    var EndDisplayLine2:String?
    var StartTime:String?
    var Status:Int?
    var TotalPassengerSegmentFees:Double?
    var TravelDatesCSV:String?
    var endcity:String?
    var endcountry:String?
    var endstate:String?
    var startcity:String?
    var startcountry:String?
    var startstate:String?
    
    enum CodingKeys: String, CodingKey {
        case Aircraft
        case AircraftID
        case AvailableTripDateCSV
        case Category
        case CRleg
        case Distance
        case ExpectedTimeInMinutes
        case EndAirportID
        case EndDateTime
        case FHPercentage
        case FHCharges
        case FETPercentage
        case FETCharges
        case FinalAmount
        case IntlPercentage
        case NoOfSegments
        case NoOfPassengers
        case OwnerAircraftID
        case OwnerID
        case PaxCount
        case PaxSegment
        case PriceExpectation
        case PassengerSegmentFeesPerPerson
        case StartAirportID
        case StartDateTime
        case StartTime
        case Status
        case TotalPassengerSegmentFees
        case TravelDatesCSV
        case endcity
        case endcountry
        case endstate
        case startcity
        case startcountry
        case startstate
        case StartDisplayLine1
        case StartDisplayLine2
        case EndDisplayLine1
        case EndDisplayLine2
    }
}
