//
//  SelectCityViewController.swift
//  Noon Assignment
//
//  Created by Sandeep Rana on 02/03/19.
//  Copyright © 2019 Sandeep Rana. All rights reserved.
//

import UIKit

protocol DelegateCitySelected {
    func onCitySelected(vc: SelectCityViewController, selectedCity: String);
}

class SelectCityViewController: UIViewController {

    var arrOfCities = ["Delhi", "Bengaluru", "Hyderabad", "Mumbai", "Pune", "Kolkata"];

    @IBOutlet weak var tableView: UITableView!;

    var delegateCitySelected: DelegateCitySelected?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }

}

extension SelectCityViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfCities.count;
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellSelectCity.className(), for: indexPath) as! CellSelectCity;
        cell.lCityName.text = self.arrOfCities[indexPath.row];
        return cell;
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegateCitySelected?.onCitySelected(vc: self, selectedCity: self.arrOfCities[indexPath.row]);
    }
}
