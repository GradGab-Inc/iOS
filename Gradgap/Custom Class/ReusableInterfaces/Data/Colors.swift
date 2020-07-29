//
//  Colors.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

var ClearColor : UIColor = UIColor.clear //0
var WhiteColor : UIColor = UIColor.white //1
var BlackColor : UIColor = colorFromHex(hex: "000000") //2
var LightGrayColor : UIColor = colorFromHex(hex: "B8B8B8") //3
var ExtraLightGrayColor : UIColor = colorFromHex(hex: "F1F4F6") //4
var OrangeColor : UIColor = colorFromHex(hex: "FF625F") //5
var GrayColor : UIColor = colorFromHex(hex: "2B2B2B") //6
var LightBlueColor : UIColor = colorFromHex(hex: "188FF5") //7
var RedColor : UIColor = colorFromHex(hex: "FC0F46") //8

var AppColor : UIColor = colorFromHex(hex: "02194B") //9
var YellowColor : UIColor = colorFromHex(hex: "FED030") //10


enum ColorType : Int32 {
    case Clear = 0
    case White = 1
    case Black = 2
    case LightGray = 3
    case ExtraLightGray = 4
    case Orange = 5
    case Gray = 6
    case LightBlue = 7
    case Red = 8
    
    case App = 9
    case Yellow = 10
    
}

extension ColorType {
    var value: UIColor {
        get {
            switch self {
                case .Clear: //0
                    return ClearColor
                case .White: //1
                    return WhiteColor
                case .Black: //2
                    return BlackColor
                case .LightGray: //3
                    return LightGrayColor
                case .ExtraLightGray: //4
                    return ExtraLightGrayColor
                case .Orange: //5
                    return OrangeColor
                case .Gray: //6
                    return GrayColor
                case .LightBlue: //7
                    return LightBlueColor
                case .Red: //8
                    return RedColor
                case .App: //9
                    return AppColor
                case .Yellow: //10
                    return YellowColor
            }
        }
    }
}

enum GradientColorType : Int32 {
    case Clear = 0
    case Login = 1
}

extension GradientColorType {
    var layer : GradientLayer {
        get {
            let gradient = GradientLayer()
            switch self {
            case .Clear: //0
                gradient.frame = CGRect.zero
            case .Login: //1
                gradient.colors = [
                    colorFromHex(hex: "06BD8C").cgColor,
                    colorFromHex(hex: "05A191").cgColor  //089B97
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//                gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
//                gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
            }
            
            return gradient
        }
    }
}


enum GradientColorTypeForView : Int32 {
    case Clear = 0
    case App = 1
}


extension GradientColorTypeForView {
    var layer : GradientLayer {
        get {
            let gradient = GradientLayer()
            switch self {
            case .Clear: //0
                gradient.frame = CGRect.zero
            case .App: //1
                gradient.colors = [
                    colorFromHex(hex: "#00AF80").cgColor,
                    colorFromHex(hex: "#06BD8C").cgColor,
                    colorFromHex(hex: "#08969C").cgColor
                ]
                gradient.locations = [0.0, 0.5, 1.0]
                gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            }
            
            return gradient
        }
    }
}

