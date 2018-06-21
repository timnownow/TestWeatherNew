
import UIKit

class CitiesVC: UIViewController {
    
    var delegate:DelegateToPagerFromCities?
    
    var pages:[Page]!
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBAction func buttonAdd(_ sender: Any) {
        self.performSegue(withIdentifier: "citiesToAdd", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pages = CoreDataManager.instance.getPages()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 64;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pages = CoreDataManager.instance.getPages()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CitiesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true, completion: {
            
            if let del = self.delegate
            {
                del.selectCity(pos: indexPath.row)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.instance.deletePage(city_id: pages[indexPath.row].city_id)
            pages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages == nil ? 0 : pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CityCell else {
            fatalError("Cell not exists in storyboard")
        }
        let page = self.pages[indexPath.row]
        cell.configCell(item:page)
        return cell
    }
}

