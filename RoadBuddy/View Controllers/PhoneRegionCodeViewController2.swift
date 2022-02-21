//
//  PhoneRegionCodeViewController2.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-21.
//

import UIKit

protocol PhoneRegionCodeDelegate: AnyObject
{
    func didTapRegion(regionCode : String)
}

class PhoneRegionCodeViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    
    weak var delegate: PhoneRegionCodeDelegate?
    
    let keyArray = Array(countryPrefixes.keys).sorted(by: <)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RegionCell.nib(), forCellReuseIdentifier: RegionCell.identifier)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = keyArray[indexPath.row]
        let value = "+" + countryPrefixes[key]!
        self.delegate?.didTapRegion(regionCode:value)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return countryPrefixes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: RegionCell.identifier, for: indexPath) as! RegionCell
        let key = keyArray[indexPath.row]
        let value = countryPrefixes[key]
        cell.regionText.text = key
        cell.regionNumberCodeText.text = "+" + value!
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let key = Array(countryPrefixes)[indexPath.row].key
        let value = countryPrefixes[key]
        cell.textLabel?.text = key + "                                                                         +" + value!
        print(cell.textLabel?.text)
        return cell
    }
     */
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Please choose the regional code"
    }
    


}

