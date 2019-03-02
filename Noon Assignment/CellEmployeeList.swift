//
// Created by Sandeep Rana on 2019-03-02.
// Copyright (c) 2019 Sandeep Rana. All rights reserved.
//

import Foundation
import UIKit

class CellEmployeeList: UITableViewCell {
    @IBOutlet weak var bName: UIButton!;
    @IBOutlet weak var lEmail: UILabel!;
    @IBOutlet weak var lCity: UILabel!;
    @IBOutlet weak var lAnniversary: UILabel!;
    @IBOutlet weak var lIsMarried: UILabel!;
    @IBOutlet weak var stackAnniversary: UIStackView!;

    func setData(employee: Employee) {
        self.bName.setTitle(employee.name ?? "n/a", for: .normal);
        self.lEmail.text = employee.email ?? "n/a";
        self.lCity.text = employee.city ?? "n/a"
		if let date = employee.anniversary {
            self.lAnniversary.text = UIViewController.getFormattedDate(date: date);
        }

		self.lIsMarried.text = (employee.married ?? false) ? "YES" : "NO";
		self.stackAnniversary.isHidden = !(employee.married ?? true)
    }
}
