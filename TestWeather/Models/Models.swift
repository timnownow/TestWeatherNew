
import UIKit

struct Page
{
    var city_id:    Int
    var city_name:  String
}

struct CityFind
{
    var city_id:    Int
    var city_name:  String
    var country:    String
}

struct Hour
{
    var hour:   String!
    var icon:   String!
    var temp:   Int!
}

struct Day
{
    var week_day:   String!
    var icon:       String!
    var temp_day:   Int!
    var temp_night: Int!
}
