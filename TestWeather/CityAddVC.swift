//
//  CityAddVC.swift
//  TestWeather
//
//  Created by Tim on 14.06.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit
import Moya_ObjectMapper

class CityAddVC: UIViewController {
    
    var delegate:DelegateToPagerFromCityAdd?
    var isFirstCity: Bool = false

    @IBOutlet weak var tableView:UITableView!
    
    var cities = [CityFind]()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "City name"
        tableView.tableHeaderView = searchController.searchBar

        searchController.searchBar.setShowsCancelButton(!isFirstCity, animated: true)

    }

    func findCity(name:String)
    {
        if name.count < 3 {
            cities.removeAll()
            tableView.reloadData()
            return
        }
        
        myApi.request(.find(name)) { result in
            
            switch result {
            case let .success(response):
                do {
                    let itemCity = try response.mapObject(Find.self)
                    self.cities.removeAll()
                    for item in itemCity.items
                    {
                        self.cities.append(CityFind(city_id: item.id, city_name: item.name, country: item.country ))
                    }
                    self.tableView.reloadData()
                } catch {
                    print("error:\(error)")
                }
            case let .failure(error):
                print(error)
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension CityAddVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            CoreDataManager.instance.addPage(item: self.cities[indexPath.row])

            if let del = self.delegate
            {
                del.addFirstCity()
            }

        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CityCell else {
            fatalError("Cell not exists in storyboard")
        }
        let page = self.cities[indexPath.row]
        cell.configCellCity(item:page)
        return cell
    }
}

extension CityAddVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension CityAddVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            findCity(name: searchText)
        }
    }
}
