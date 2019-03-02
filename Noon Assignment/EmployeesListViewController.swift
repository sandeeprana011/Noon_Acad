//
//  EmployeesListViewController.swift
//  Noon Assignment
//
//  Created by Sandeep Rana on 02/03/19.
//  Copyright © 2019 Sandeep Rana. All rights reserved.
//

import UIKit

class EmployeesListViewController: UIViewController {

    @IBAction func onClickAddEmployee(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: AddEmployeeViewController.className());
        self.navigationController?.pushViewController(vc!, animated: true);
    }

    @IBOutlet weak var tableView: UITableView!;

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

//extension EmployeesListViewController: UITableViewDelegate, UITableViewDataSource {
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		<#code#>
//	}
//	
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		<#code#>
//	}
//	
//
//}
