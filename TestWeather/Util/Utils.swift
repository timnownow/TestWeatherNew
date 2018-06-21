//
//  Utils.swift
//  TestWeather
//
//  Created by Tim on 02.06.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import Foundation
import SwiftIcons
import TimeZoneLocate
import CoreLocation

class Utils {
    
    // возвращает разницу в секундах между текущей и таймзоной города (по координатам)
    static func getSecondsTimeZone(coord:CityCoord) -> Int
    {
        let location = CLLocation(latitude: coord.lat, longitude: coord.lon)
        let timeZone = location.timeZone
        let currentTimeZone = Calendar.current.timeZone.secondsFromGMT()
        return timeZone.secondsFromGMT() - currentTimeZone
    }
    
    static func getIcon(icon:String) -> FontType
    {
        switch icon {
        case "01d":
            return  .weather(.daySunny)
        case "01n":
            return .weather(.nightClear)
        case "02d":
            return  .weather(.dayCloudy)
        case "02n":
            return  .weather(.nightCloudy)
        case "03d":
            return  .weather(.cloud)
        case "03n":
            return  .weather(.cloud)
        case "04d":
            return  .weather(.cloudy)
        case "04n":
            return  .weather(.cloudy)
        case "09d":
            return  .weather(.showers)
        case "09n":
            return  .weather(.showers)
        case "10d":
            return  .weather(.dayRain)
        case "10n":
            return  .weather(.nightRain)
        case "11d":
            return  .weather(.thunderstorm)
        case "11n":
            return  .weather(.thunderstorm)
        case "13d":
            return  .weather(.snow)
        case "13n":
            return  .weather(.snow)
        case "50d":
            return  .weather(.dust)
        case "50n":
            return  .weather(.dust)
        default:
            return .weather(.daySunny)
        }
    }

    static func getWeekday(day:Int) -> String
    {
        let weekdays = [
            "Воскресенье",
            "Понедельник",
            "Вторник",
            "Среда",
            "Четверг",
            "Пятница",
            "Суббота"
        ]
        return weekdays[day]
    }
}
