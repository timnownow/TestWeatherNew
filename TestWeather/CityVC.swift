
import UIKit
import Moya_ObjectMapper

class CityVC: UIViewController {
    
    @IBOutlet weak var labelCity:    UILabel!
    @IBOutlet weak var labelStatus:  UILabel!
    @IBOutlet weak var labelTemp:    UILabel!
    @IBOutlet weak var labelCelsium: UILabel!
    @IBOutlet weak var labelIcon:    UILabel!
    
    @IBOutlet weak var collectionViewHours: UICollectionView!

    @IBOutlet weak var tableViewDays: UITableView!

    @IBOutlet weak var constrTableDays: NSLayoutConstraint!
    
    var page:Page!
    
    var index:Int! = 0
    
    var days:[Day]!
    
    var hours:[Hour]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewHours.dataSource = self
        collectionViewHours.delegate = self
        
        tableViewDays.dataSource = self
        tableViewDays.delegate = self
        
        self.tableViewDays.rowHeight = 44;
        
        self.labelCelsium.setIcon(icon: .weather(.degrees), iconSize: 64)
        
        labelCity.text = page.city_name
        
        downloadMoya(page.city_id)
        downloadMoyaCity(page.city_id)
    }
    
    func downloadMoyaCity(_ id: Int) {
        
        myApi.request(.city(id)) { result in
            
            switch result {
            case let .success(response):
                do {
                    let itemCity = try response.mapObject(WeatherCity.self)
                    
                    self.labelCity.text = itemCity.name
                    self.labelStatus.text = itemCity.description
                    self.labelTemp.text = String(Int(itemCity.temp))
                    self.labelIcon.setIcon(icon: Utils.getIcon(icon: itemCity.icon), iconSize: 50)
                } catch {
                    print("error:\(error)")
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func downloadMoya(_ id: Int) {
        myApi.request(.forecast(id)) { result in
            
            switch result {
            case let .success(response):
                
                DispatchQueue.global(qos: .default).async{
                    
                    do {
                        let forecast = try response.mapObject(Forecast.self)
                        
                        self.hours = [Hour]()
                        self.days = [Day]()
                        
                        var temp_day:Int? = nil
                        var temp_night:Int? = nil
                        var icon:String = ""
                        
                        let offSetTime = Utils.getSecondsTimeZone(coord: forecast.city.coord)
                        
                        let today = Calendar.current.date(byAdding: .second, value: offSetTime, to: Date())
                        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today!)
                        
                        var lastDay:Int = 0
                        
                        let lastDate = forecast.items.last?.dt
                        
                        for item in forecast.items
                        {
                            let date = Date.init(timeIntervalSince1970: item.dt + Double(offSetTime))
                            
                            if tomorrow! > date {
                                let hour = Calendar.current.component(.hour, from: date)
                                let mhour = Hour(hour: String(hour), icon: item.icon, temp: Int(item.temp))
                                self.hours.append(mhour)
                            }
                            
                            let day = Calendar.current.component(.day, from: date)
                            if lastDay == 0
                            {
                                lastDay = day
                            }
                            
                            if lastDay == day
                            {
                                if temp_night == nil || temp_night! > Int(item.temp)
                                {
                                    temp_night = Int(item.temp)
                                }
                                if temp_day == nil || temp_day! < Int(item.temp)
                                {
                                    temp_day = Int(item.temp)
                                    icon = item.icon
                                }

                                // Это последний эллемент массива
                                if item.dt == lastDate
                                {
                                    let weekday = Calendar.current.component(.weekday, from: date)
                                    let newDay = Day(week_day: Utils.getWeekday(day: weekday-1), icon: icon, temp_day: temp_day, temp_night: temp_night)
                                    self.days.append(newDay)
                                }
                            }
                            else
                            {

                                let tempDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
                                let weekday = Calendar.current.component(.weekday, from: tempDate!)
                                
                                let newDay = Day(week_day: Utils.getWeekday(day: weekday-1), icon: icon, temp_day: temp_day, temp_night: temp_night)
                                self.days.append(newDay)
                                
                                temp_night = Int(item.temp)
                                temp_day = Int(item.temp)

                                lastDay = day
                            }
                            
                        }
                        
                        DispatchQueue.main.async() {
                            self.collectionViewHours.reloadData()
                            self.constrTableDays.constant = CGFloat(self.days.count) * self.tableViewDays.rowHeight
                            self.tableViewDays.reloadData()
                        }
                        
                    } catch {
                        print("error:\(error)")
                    }
                }
            case let .failure(error):
                print("RES_FAIL:\(error)")
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CityVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days == nil ? 0 : days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayCell else {
            fatalError("Cell not exists in storyboard")
        }
        let day = self.days[indexPath.row]
        cell.configCell(item:day)
        return cell
    }
    
    
    
}

extension CityVC:UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as? HourCell else {
            fatalError("Cell not exists in storyboard")
        }
        let hour = self.hours[indexPath.row]
        cell.configCell(item:hour)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hours == nil ? 0 : hours.count
    }
    
}


