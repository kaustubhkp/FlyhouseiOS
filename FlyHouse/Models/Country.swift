//
//  Country.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 08/02/24.
//

import Foundation


//Add Edit Contacts
struct CountryResponse : Codable{
    var task:String?
    var result:String?
    var description:String?
    var data:[CountryData]?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case result
        case description
        case data
        case title
    }
}

struct CountryData:Codable{
    var countryID:Int?
    var countryName:String?
    var dialCode:String?
    var code:String?
    var flag:String?
    
    enum CodingKeys: String, CodingKey {
        case countryID = "CountryID"
        case countryName = "CountryName"
        case dialCode = "DialCode"
        case code = "Code"
        case flag = "Flag"
        
    }
}

