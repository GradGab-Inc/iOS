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

func getDateFromDateString(strDate : String, format : String) -> Date?
{
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current //TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: strDate)
}

func getDateFromDateString(strDate : String) -> Date    // Today, 09:56 AM
{
//    let dateFormatter1 = DateFormatter()
//    dateFormatter1.locale = NSLocale.current //Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//    return dateFormatter1.date(from: strDate)!
    
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dt = dateFormatter.date(from: strDate)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date1 : String = dateFormatter.string(from: dt ?? Date())
    return dateFormatter.date(from: date1)!
}

func getDateStringFromDateString(strDate : String, formate : String) -> String    // Today, 09:56 AM
{
    let dateFormatter1 = DateFormatter()
    dateFormatter1.locale = NSLocale.current//Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date1 =  dateFormatter1.date(from: strDate)!
    dateFormatter1.dateFormat = formate //"MMMM dd"
    return dateFormatter1.string(from: date1)
}

func getMinuteFromDateString(strDate : String) -> Int
{
    let dateFormatter1 = DateFormatter()
    dateFormatter1.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date1 =  dateFormatter1.date(from: strDate)!
    dateFormatter1.dateFormat = "HH:mm"
    return dateFormatter1.string(from: date1).minuteFromString
}

func getMinuteFromDate(date : Date) -> Int
{
    let dateFormatter1 = DateFormatter()
    dateFormatter1.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter1.dateFormat = "HH:mm"
    return dateFormatter1.string(from: date).minuteFromString
}


func getMinuteFromDateString1(strDate : String) -> Int  
{
    let dateFormatter1 = DateFormatter()
    dateFormatter1.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter1.dateFormat = "HH:mm"
    let date1 =  dateFormatter1.date(from: strDate)!
    dateFormatter1.dateFormat = "HH:mm"
    return dateFormatter1.string(from: date1).minuteFromString
}


func getDateStringFromDate1(date : Date, format : String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current //TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func getDateStringFromDate(date : Date, format : String) -> String
{
    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func getDateUTCStringFromDate(date : Date, format : String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func getHourStringFromHoursString(strDate : String, formate : String) -> String
{
    let dateFormatter1 = DateFormatter()
    dateFormatter1.locale = NSLocale.current //Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter1.dateFormat = "HH:mm"
    let date1 =  dateFormatter1.date(from: strDate) ?? Date()
    dateFormatter1.dateFormat = formate //"MMMM dd"
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

func timeZoneOffsetInMinutes() -> Int {
    let seconds = TimeZone.current.secondsFromGMT()
    let minutes = (seconds / 60)
    return minutes    
}

func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
    return (minutes / 60, (minutes % 60))
}

extension String {
    var integer: Int {
        return Int(self) ?? 0
    }

    var minuteFromString : Int{
        let components: Array = self.components(separatedBy: ":")
        let hours = components[0].integer
        let minutes = components[1].integer
        return Int((hours * 60) + minutes)
    }
}

func getTimeStampFromDateString(_ strDate : String) -> Double {
    let date = getDateFromDateString(strDate: strDate)
    return getTimestampFromDate(date: date)
}

func getDifferenceFromCurrentTimeInHourInDays(_ str : String) -> Bool
{
    let timestamp : Double = getTimeStampFromDateString(str)
    let interval : Int = getDifferenceFromCurrentTime(timestamp)

    let hours : Int = interval/(60*60)
    
    var timeAgo : String = ""
    if hours < 24 && hours > 0
    {
        return true
    }
    
    return false
}

func getDifferenceFromCurrentTimeInDays(_ str : String) -> String
{
    let date = getDateFromDateString(strDate: str, format: "yyyy-MM-dd") ?? Date()
    let calendar = Calendar.current
    if calendar.isDateInToday(date) {
        return "Today"
    }
    else if calendar.isDateInYesterday(date) {
        return "Yesterday"
    }
    else {
        return getDateStringFromDate(date: date, format: "MMMM dd, yyyy")
    }
}


func getDateInUTC(_ date : Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.dateFormat = "yyyy-MM-dd"
    var strDate =  dateFormatter.string(from: date)
    strDate = strDate + " 00:00:00"
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date1 =  dateFormatter1.date(from: strDate)!
    dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter1.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    let finalDate = dateFormatter1.string(from: date1)
    return finalDate
}


func getInitialTime(currentTime: Date, interval: Int) -> Date {
    var components = Calendar.current.dateComponents([.minute, .hour], from: currentTime)
    let minute = components.minute
    let remainder = ceil(Float(minute!/interval))
    let finalMinutes = Int(remainder * Float(interval)) + interval
    components.setValue(finalMinutes, for: .minute)
    guard let finalTime = Calendar.current.date(from: components) else { return Date() }
//    getDate(date: finalTime)
    return finalTime
}

func getDate(date: Date)  {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.short
    dateFormatter.timeZone = TimeZone.current
    let time = dateFormatter.string(from: date)
}

func utcToLocal(dateStr: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    if let date = dateFormatter.date(from: dateStr) {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
    
        return dateFormatter.string(from: date)
    }
    return nil
}


func getDateFromMinute(_ min: Int) -> Date {
    let time = minutesToHoursMinutes(minutes: min)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current //TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "HH:mm"
    let timeDate = dateFormatter.date(from: "\(time.hours):\(time.leftMinutes)")!
    return timeDate
}


func getDifferenceFromCurrentTimeInMinute(_ newDate : String) -> Int
{
    let date = getDateFromDateString(strDate: newDate)
    let interval = Date().timeIntervalSince(date)
    
    let minutes : Int = Int(interval/60)

    if minutes < 5 && minutes >= 0
    {
        return 1
    }
    else {
        return 2
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



extension String {
  //MARK:- Convert UTC To Local Date by passing date formats value
    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outGoingFormat
        return dateFormatter.string(from: dt ?? Date())
    }
    
  //MARK:- Convert Local To UTC Date by passing date formats value
    func localToUTC(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = outGoingFormat
        return dateFormatter.string(from: dt ?? Date())
    }
}
