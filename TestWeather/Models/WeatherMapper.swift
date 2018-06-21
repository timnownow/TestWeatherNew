
import Foundation
import ObjectMapper

struct City: Mappable {
    var id:     Int!
    var name:   String!
    var coord:  CityCoord!
    var country:String!
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id      <- map["id"]
        name    <- map["name"]
        coord   <- map["coord"]
        country <- map["sys.country"]
    }
}

struct CityCoord: Mappable {
    var lon:    Double!
    var lat:    Double!
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        lon <- map["lon"]
        lat <- map["lat"]
    }
}

struct Item: Mappable {
    var dt:         Double!
    var dt_txt:     String!
    var temp:       Double!
    var icon:       String!
    var description:String!

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        dt          <- map["dt"]
        dt_txt      <- map["dt_txt"]
        temp        <- map["main.temp"]
        icon        <- map["weather.0.icon"]
        description <- map["weather.0.description"]
    }
}

struct WeatherCity:Mappable {
    var id:         Int!
    var cod:        Int!
    var dt:         Double!
    var name:       String!
    var coord:      CityCoord!
    var temp:       Double!
    var icon:       String!
    var description:String!

    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        cod         <- map["cod"]
        dt          <- map["dt"]
        name        <- map["name"]
        coord       <- map["coord"]
        temp        <- map["main.temp"]
        icon        <- map["weather.0.icon"]
        description <- map["weather.0.description"]
    }
}

struct Find:Mappable {
    var cnt:        Int!
    var items:      [City]!
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        cnt      <- map["count"]
        items    <- map["list"]
    }
}

struct Forecast: Mappable {
    var cnt:     Int!
    var city:    City!
    var items:   [Item]!
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        cnt     <- map["cnt"]
        city    <- map["city"]
        items   <- map["list"]
    }
}
