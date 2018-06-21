//
//  HourCell.swift
//  TestWeather
//
//  Created by Tim on 26.05.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit
import SwiftIcons

class HourCell: UICollectionViewCell {

    @IBOutlet weak var labelHour: UILabel!
    @IBOutlet weak var labelIcon: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelCelsium: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(item:Hour)
    {
        self.labelHour.text = item.hour
        self.labelTemp.text = String(item.temp)
        self.labelIcon.setIcon(icon: Utils.getIcon(icon: item.icon), iconSize: 20)
        self.labelCelsium.setIcon(icon: .weather(.degrees), iconSize: 25)
     }

}
