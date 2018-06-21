//
//  Protocols.swift
//  TestWeather
//
//  Created by Tim on 19.06.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import Foundation

protocol DelegateToPagerFromCities {
    func selectCity(pos:Int)
}

protocol DelegateToPagerFromCityAdd {
    func addFirstCity()
}
