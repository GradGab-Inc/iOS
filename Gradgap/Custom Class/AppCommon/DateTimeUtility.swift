//
//  DateTimeUtility.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import Foundation

func getTimestampFromDate(date : Date) -> Double
{
    return date.timeIntervalSince1970
}

func getDateFromTimeStamp(_ timeStemp:Double) -> Date
{
    return Date(timeIntervalSince1970: TimeInterval(timeStemp/1000))
}

func getDateStringFromServerTimeStemp(_ timeStemp:Double) -> String {
    
    let date : Date = Date(timeIntervalSince1970: TimeInterval(timeStemp))
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "dd MMM yyyy"//DATE_FORMAT.DISPLAY_DATE_FORMAT
    return dateFormatter.string(from: date)
}

func getDateFromDateString(strDate : String) -> Date    // Today, 09:56 AM
{
    let dateFormatter1 = DateFormatter()
    dateFormatter1.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter1.date(from: strDate)!
}


func getDateStringFromDateString(strDate : String, formate : String) -> String    // Today, 09:56 AM
{
    let dateFormatter1 = DateFormatter()
    dateFormatter1.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date1 =  dateFormatter1.date(from: strDate)!
    dateFormatter1.dateFormat = formate //"MMMM dd"
    return dateFormatter1.string(from: date1)
}

func getTimeStringFromDateString1(strDate : String) -> String    // 09:56 AM
{
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date1 =  dateFormatter1.date(from: strDate)!
    dateFormatter1.dateFormat = "HH:mm a"
    return dateFormatter1.string(from: date1)
}

func getDateStringFromDate(date : Date, format : String) -> String
{
    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}


//MARK: Date difference
func getDifferenceFromCurrentTime(_ timeStemp : Double) -> Int
{
    let newDate : Date = Date(timeIntervalSince1970: TimeInterval(timeStemp))
    let currentDate : Date = getCurrentDate()
    let interval = currentDate.timeIntervalSince(newDate)
    return Int(interval)
}

func getCurrentDate() -> Date
{
    let currentDate : Date = Date()
    return currentDate
}
