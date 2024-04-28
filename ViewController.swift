//
//  ViewController.swift
//  APICallDemo
//
//  Created by Wali Faisal on 22/04/24.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import CountryPickerView

class ViewController: UIViewController {

    var timezoneList = [[String:Any]]()
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.getJsonData()
    }

    
    func getJsonData() {
        let urlFile = "http://api.timezonedb.com/v2.1/list-time-zone?key=3JM5HNZ1AF4S&format=json"
        Alamofire.request(urlFile).responseJSON { response in
            switch response.result {
            case .success(_):
                if let jsondata = response.result.value as? [String:Any] {
                    if let arrTimezoneList = jsondata["zones"] as? [[String:Any]], arrTimezoneList.count > 0{
                        self.timezoneList = arrTimezoneList
                        self.myTable.reloadData()
                    }
                } else {
                    print("Error: Unable to parse JSON data")
                }
            case .failure(let error):
                print("Error Occurred: \(error.localizedDescription)")
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timezoneList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell

        // Set country code label
        cell.MyLabel_tz.text = timezoneList[indexPath.row]["countryCode"] as? String

        // Set country name label
        cell.MyLabel_country.text = timezoneList[indexPath.row]["countryName"] as? String

        return cell
    }
}
