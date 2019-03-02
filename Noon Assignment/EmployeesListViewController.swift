//
//  EmployeesListViewController.swift
//  Noon Assignment
//
//  Created by Sandeep Rana on 02/03/19.
//  Copyright © 2019 Sandeep Rana. All rights reserved.
//

import UIKit
import CoreData

class EmployeesListViewController: UIViewController {

    private var arrEmployee: [Employee] = [Employee]();

    @objc func onClickEditEmployee(_ sender: UIButton) {
        let vcAdd = self.storyboard?.instantiateViewController(withIdentifier: AddEmployeeViewController.className()) as! AddEmployeeViewController;
        vcAdd.delegateResultUpdated = self;
        vcAdd.employee = self.arrEmployee[sender.tag];
        self.navigationController?.pushViewController(vcAdd, animated: true);
    }

    @IBAction func onClickAddEmployee(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: AddEmployeeViewController.className()) as! AddEmployeeViewController;
        vc.delegateResultUpdated = self;
        self.navigationController?.pushViewController(vc, animated: true);
    }

    @IBOutlet weak var tableView: UITableView!;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchEmployessListDateAndUPdateUI();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

    }

    private func fetchEmployessListDateAndUPdateUI() {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
//        let fetchRequest = Fetch
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true);
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors

        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try AppDelegate.getContext().fetch(fetchRequest)
            var employees = [Employee]();
            for data in result as! [Employee] {
                employees.append(data);
            }
            self.arrEmployee.removeAll();
            self.arrEmployee.append(contentsOf: employees);
            self.tableView.reloadData();

        } catch {

            print("Failed")
        }
    }
}

extension EmployeesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrEmployee.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellEmployeeList.className(), for: indexPath) as! CellEmployeeList;
        cell.setData(employee: self.arrEmployee[indexPath.row]);
        cell.bName.tag = indexPath.row;
        cell.bName.addTarget(self, action: #selector(self.onClickEditEmployee(_:)), for: .touchUpInside);
        return cell;
    }
}

extension EmployeesListViewController: DelegateEmployeeUpdated {
	func onCancel(vc: AddEmployeeViewController, actionType: ActionType) {
		self.navigationController?.popViewController(animated: true);
	}
	
    func onUpdateResults(vc: AddEmployeeViewController, employee: Employee, actionType: ActionType) {
        self.fetchEmployessListDateAndUPdateUI();
        self.navigationController?.popViewController(animated: true);
    }
}

