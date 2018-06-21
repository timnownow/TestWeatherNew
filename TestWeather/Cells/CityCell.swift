//
//  CityCell.swift
//  TestWeather
//
//  Created by Tim on 13.06.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCountry: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(item:Page)
    {
        self.labelName.text = String(item.city_name)
    }

    func configCellCity(item:CityFind)
    {
        self.labelName.text = String(item.city_name)
        self.labelCountry.text = String(item.country)
    }
}
