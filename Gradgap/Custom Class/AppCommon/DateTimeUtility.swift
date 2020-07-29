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

func getFullEndDateFromDateString(_ str : String) -> String {
    if str == "" {
        return ""
    }
    let end = getDateFromDateString(strDate: str) //dict.endDate.getDate()
    let calendar = Calendar.current
    let comp = calendar.dateComponents([.day,.hour,.minute], from: Date(), to: end)
    
    if comp.hour == 0 && comp.day == 0 && comp.minute == 0 {
        return ""
    }
    else if comp.day != 0 && comp.hour != 0 {
        return "\(comp.day!) \(getTranslate("days")) \(comp.hour!) \(getTranslate("hrs"))"
    }
    else if comp.day == 0 && comp.hour != 0 && comp.minute != 0 {
        return "\(comp.hour!) \(getTranslate("hrs")) \(comp.minute!) \(getTranslate("min"))"
    }
    else if comp.day != 0 && comp.hour == 0 && comp.minute == 0 {
        return "\(comp.day!) \(getTranslate("days"))"
    }
    else if comp.day == 0 && comp.hour != 0 && comp.minute == 0 {
        return "\(comp.hour!) \(getTranslate("hrs"))"
    }
    else if comp.day == 0 && comp.hour == 0 && comp.minute != 0 {
        return "\(comp.minute!) \(getTranslate("min"))"
    }
    else {
        return ""
    }
}

func getDifferenceFromCurrentTimeInHourInDays(_ timestamp : Double) -> String
{
    let interval : Int = getDifferenceFromCurrentTime(timestamp)
    
    let second : Int = interval
    let minutes : Int = interval/60
    let hours : Int = interval/(60*60)
    let days : Int = interval/(60*60*24)
    let week : Int = interval/(60*60*24*7)
    let months : Int = interval/(60*60*24*30)
    let years : Int = interval/(60*60*24*30*12)
    
    var timeAgo : String = ""
    if  second < 60
    {
        timeAgo = (second < 3) ? "Just Now" : (String(second) + "s")
    }
    else if minutes < 60
    {
        timeAgo = String(minutes) + "m"
    }
    else if hours < 24
    {
        timeAgo = String(hours) + "h"
    }
    else if days < 30
    {
        timeAgo = String(days) + " "  + ((days > 1) ? "days" : "day")
    }
    else if week < 4
    {
        timeAgo = String(week) + " "  + ((week > 1) ? "weeks" : "week")
    }
    else if months < 12
    {
        timeAgo = String(months) + " "  + ((months > 1) ? "months" : "month")
    }
    else
    {
        timeAgo = String(years) + " "  + ((years > 1) ? "years" : "year")
    }
    
    if second > 3 {
        timeAgo = timeAgo + " ago"
    }
    return timeAgo
}
