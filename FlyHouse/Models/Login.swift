//
//  Login.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import Foundation


struct LoginResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:LoginData?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct LoginData : Codable{
    var isNewUser:String?
    var otp:String?
    var mobileNum:String?
    var isMobileVerified:String?
    var isEmailVerified:String?
    var isSMSConsentAccepted:String?
    var userID:Int?
    
    enum CodingKeys: String, CodingKey {
        case isNewUser = "IsNewUser"
        case otp = "OTP"
        case mobileNum = "MobileNumber"
        case isEmailVerified = "IsEmailVerified"
        case isMobileVerified = "IsMobileVerified"
        case isSMSConsentAccepted = "IsSMSConsentAccepted"
        case userID = "UserID"
    }
}

struct VerifyMobileEmailResponse : Codable{
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


struct LoginAuthResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:LoginAuthData?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct LoginAuthData : Codable{
    var isNewUser:String?
    var mobileNum:String?
    var token:String?
    var isEmailVerified:String?
    var isMobileVerified:String?
    var isSMSConsentAccepted:String?
    var userID:Int?
    
    enum CodingKeys: String, CodingKey {
        case isNewUser = "IsNewUser"
        case mobileNum = "MobileNumber"
        case token = "token"
        case isEmailVerified = "IsEmailVerified"
        case isMobileVerified = "IsMobileVerified"
        case isSMSConsentAccepted = "IsSMSConsentAccepted"
        case userID = "UserID"
    }
}

struct RegistrationResponse:Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:RegisteredUserData?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct RegisteredUserData : Codable{
    var userID:Int?
    var userTypeID:Int?
    var userType:String?
    var mobileNum:Int64?
    var displayName:String?
    var firstName:String?
    var middleName:String?
    var lastName:String?
    var email:String?
    var phoneNumber:String?
    var profilePhotoUrl:String?
    var preferredCurrency:String?
    var componyID:Int?
    var address:String?
    var city:String?
    var state:String?
    var country:String?
    var postCode:String?
    var isNewUser:String?
    var activeUserID:Int?
    var autoBid:Bool?
    var gender:String?
    var dob:String?
    var password:String?
    var altUserEmail:String?
    var isSMSConsentAccepted:Int?
    var token:String?
    
    
    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case userTypeID = "UserTypeID"
        case userType = "UserType"
        case mobileNum = "Mobile"
        case phoneNumber = "PhoneNumber"
        case displayName = "DisplayName"
        case firstName = "FirstName"
        case middleName = "MiddleName"
        case lastName = "LastName"
        case email = "Email"
        case profilePhotoUrl = "ProfilePhotoUrl"
        case preferredCurrency = "PreferredCurrency"
        case componyID = "ComponyID"
        case address = "Address"
        case city = "City"
        case state = "State"
        case country = "Country"
        case postCode = "PostCode"
        case isNewUser = "IsNewUser"
        case activeUserID = "ActiveUserID"
        case autoBid = "AutoBid"
        case gender = "Gender"
        case dob = "DOB"
        case password = "Password"
        case altUserEmail = "AlternateEmail"
        case isSMSConsentAccepted = "IsSMSConsentAccepted"
        case token = "Token"
    }
}


struct UpdateUserResponse:Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:String?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct CheckAppVersionResponse:Codable{
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

struct GetAppAllUrlsResponse:Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:getUrlsData?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct getUrlsData : Codable {
    var version:String?
    var settingList:[SettingListData]?
    
    enum CodingKeys: String, CodingKey {
        case version
        case settingList = "SettingList"
    }
}

struct SettingListData:Codable{
    var settingid:Int?
    var name: String?
    var value: String?
    
    enum CodingKeys: String, CodingKey {
        case settingid
        case name
        case value
    }
}


struct getBaseURLResponse:Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:String?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct UserRoomKeyDataResponse:Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[UserRoomKeyData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct UserRoomKeyData:Codable{
    var RoomKeyID:Int?
    var RoomKey:String?
    var IsParent:Int?
    var UserFirstName:String?
    var UserLastName:String?
    var CreatedByName:String?
    var CreatedOn:String?
    var AssignedToName:String?
    var AssignedUnAssignedText:String?
    var DateAssigned:String?
    var CreationDate: String?
    var FlightHoursInMinutes: Int?
    var FlightDollars:Double?
    var UserID:Int?
    
    enum CodingKeys: String, CodingKey {
        case RoomKeyID
        case RoomKey
        case IsParent
        case UserFirstName
        case UserLastName
        case CreatedByName
        case CreatedOn
        case AssignedToName
        case AssignedUnAssignedText
        case DateAssigned
        case CreationDate
        case FlightHoursInMinutes
        case FlightDollars
        case UserID
    }
}

struct UserRoomKeyEarningsDataResponse:Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[UserRoomKeyEarningsData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct UserRoomKeyEarningsData:Codable{
    var AirCraftType:String?
    var AircraftTypeID: Int?
    var DollarsToHours: Int?
    var HrsEarned:Double?
    var UserID:Int?
    
    enum CodingKeys: String, CodingKey {
        case AirCraftType
        case AircraftTypeID
        case DollarsToHours
        case HrsEarned
        case UserID
    }
}
