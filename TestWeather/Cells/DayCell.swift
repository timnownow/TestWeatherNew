//
//  DayCell.swift
//  TestWeather
//
//  Created by Tim on 26.05.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    
    @IBOutlet weak var labelWeekDay: UILabel!
    @IBOutlet weak var labelIcon: UILabel!
    @IBOutlet weak var labelTempDay: UILabel!
    @IBOutlet weak var labelTempDayCelsium: UILabel!
    @IBOutlet weak var labelTempNight: UILabel!
    @IBOutlet weak var labelTempNightCelsium: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(item:Day)
    {
        self.labelWeekDay.text = item.week_day
        self.labelTempDay.text = String(item.temp_day)
        self.labelTempNight.text = String(item.temp_night)
        self.labelIcon.setIcon(icon: Utils.getIcon(icon: item.icon), iconSize: 25)
        self.labelTempDayCelsium.setIcon(icon: .weather(.degrees), iconSize: 25)
        self.labelTempNightCelsium.setIcon(icon: .weather(.degrees), iconSize: 25)

    }
}
