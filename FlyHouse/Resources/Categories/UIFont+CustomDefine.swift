//
//  UIFont+CustomDefine.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit
import CoreText

enum fontType : NSInteger {
    case fReguler = 0
    case fBold = 1
    case fSemiBold = 2
    case fLight = 3
    case fMedium = 4
    case fBoldItalic = 5
    case fSemiBoldItalic = 6
    case fBoldBlack = 7
}

let fontsArry = ["Outfit-Regular", "Outfit-Bold", "Outfit-SemiBold", "Outfit-Light","Outfit-Medium","Outfit-ExtraLight","Outfit-Thin","Outfit-Black"]
/*
 Poppins-Regular
 name: Poppins-Italic
 name: Poppins-Light
 name: Poppins-Medium
 name: Poppins-SemiBold
 name: Poppins-SemiBoldItalic
 name: Poppins-Bold
 name: Poppins-BoldItalic
 */

extension UIFont
{
    
    //MARK:- Custom Font Size
    class func RegularWithSize(size: CGFloat) -> UIFont
    {
        if SCREEN_WIDTH > 414
        {
            return UIFont(name: fontsArry[0], size: size+7)!
        }
        else if SCREEN_WIDTH > 320 {
            return UIFont(name: fontsArry[0], size: size+3)!
        }
        else
        {
            return UIFont(name: fontsArry[0], size: size)!
        }
    }
    
    class func BoldWithSize(size: CGFloat) -> UIFont
    {
        if SCREEN_WIDTH > 414
        {
            return UIFont(name: fontsArry[1], size: size+7)!
        }
        else if SCREEN_WIDTH > 320 {
            return UIFont(name: fontsArry[1], size: size+3)!
        }
        else
        {
            return UIFont(name: fontsArry[1], size: size)!
        }
    }
    
    class func SemiBoldWithSize(size: CGFloat) -> UIFont
    {
        if SCREEN_WIDTH > 414
        {
            return UIFont(name: fontsArry[2], size: size+7)!
        }
        else if SCREEN_WIDTH > 320 {
            return UIFont(name: fontsArry[2], size: size+3)!
        }
        else
        {
            return UIFont(name: fontsArry[2], size: size)!
        }
    }
    
    class func LightWithSize(size: CGFloat) -> UIFont
    {
        if SCREEN_WIDTH > 414
        {
            return UIFont(name: fontsArry[3], size: size+7)!
        }
        else if SCREEN_WIDTH > 320 {
            return UIFont(name: fontsArry[3], size: size+3)!
        }
        else
        {
            return UIFont(name: fontsArry[3], size: size)!
        }
    }
    
    class func MediumWithSize(size: CGFloat) -> UIFont
    {
        if SCREEN_WIDTH > 414
        {
            return UIFont(name: fontsArry[4], size: size+7)!
        }
        else if SCREEN_WIDTH > 320 {
            return UIFont(name: fontsArry[4], size: size+3)!
        }
        else
        {
            return UIFont(name: fontsArry[4], size: size)!
        }
    }
    
    class func boldItalicWithSize(size: CGFloat) -> UIFont
    {
        if SCREEN_WIDTH > 414
        {
            return UIFont(name: fontsArry[5], size: size+7)!
        }
        else if SCREEN_WIDTH > 320 {
            return UIFont(name: fontsArry[5], size: size+3)!
        }
        else
        {
            return UIFont(name: fontsArry[5], size: size)!
        }
    }
    
    class func ThinWithSize(size: CGFloat) -> UIFont
    {
        if SCREEN_WIDTH > 414
        {
            return UIFont(name: fontsArry[6], size: size+7)!
        }
        else if SCREEN_WIDTH > 320 {
            return UIFont(name: fontsArry[6], size: size+3)!
        }
        else
        {
            return UIFont(name: fontsArry[6], size: size)!
        }
    }
    
    class func BlackBoldItalicWithSize(size: CGFloat) -> UIFont
    {
        if SCREEN_WIDTH > 414{
            return UIFont(name: fontsArry[7], size: size+7)!
        }else if SCREEN_WIDTH > 320 {
            return UIFont(name: fontsArry[7], size: size+3)!
        }else{
            return UIFont(name: fontsArry[7], size: size)!
        }
    }
    
}
