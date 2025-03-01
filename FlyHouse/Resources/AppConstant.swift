//
//  AppConstant.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 15/01/23.
//

import Foundation
import UIKit

//MARK:- StoryBoard Object
let MAIN_STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
let appDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK:- get Devices Width and Height
let SCREEN_WIDTH        = CGFloat(UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT       = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH   = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH   = min(SCREEN_WIDTH, SCREEN_HEIGHT)


//MARK:- AppDelegate Object
let APP_DELEGATE     = UIApplication.shared.delegate as! AppDelegate

let DEVICE_ID_STRING = UIDevice.current.identifierForVendor!.uuidString

let  REXP_VALID_EMAIL = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"

let PHONE_REGEX1 = "^\\d{3}-\\d{3}-\\d{4}$"
let PHONE_REGEX = "^\\d{10}$"
let VIN_VALID_NUMBER_REGEX = "[A-Z0-9]{17}"
let MOBILE_NUMBER_FORMATE = "(NNN) - NNN - NNNN"
let COUNTRY_DATA = ["US", "IND"]
let COUNTRY_PHONENO_CODE = ["+1", "+91"]
let COUNTRY_FLAGS = ["countryFlagUS", "countryFlagInd"]
let originalFormat = "yyyy-MM-dd HH:mm:ss.SSS"
let formate1 = "yyyy-MM-dd'T'HH:mm:ss"
let formate2 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
let formate3 = "yyyy-MM-dd'T'HH:mm:ss.SSS"
let formate4 = "yyyy-MM-dd'T'HH:mm:ssZ"
let formate5 = "yyyy-MM-dd hh:mm a"
let formate6 = "MMM d, yyyy"
let formate7 = "yyyy-MM-dd"
let formate8 = "MMMM d, yyyy"
let formate9 = "yyyy-MM-dd hh:mm:ss.SSS Z"
let formate10 = "MMM d"
let formate11 = "MMMM d"
let TimeFormat = "hh:mm a"

let CURRENCY_CODE = "USD"

//Font size
let TXTF_FONT_SIZE10 = CGFloat(10)
let TXTF_FONT_SIZE12 = CGFloat(12)
let TXTF_FONT_SIZE13 = CGFloat(13)
let TXTF_FONT_SIZE14 = CGFloat(14)
let TXTF_FONT_SIZE15 = CGFloat(15)
let TXTF_FONT_SIZE17 = CGFloat(17)
let TXTF_FONT_SIZE20 = CGFloat(20)
let TXTF_FONT_SIZE25 = CGFloat(25)
let TXTF_FONT_SIZE28 = CGFloat(28)
let TXTF_FONT_SIZE30 = CGFloat(30)

