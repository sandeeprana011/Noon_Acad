//
//  AddEmployeeViewController.swift
//  Noon Assignment
//
//  Created by Sandeep Rana on 02/03/19.
//  Copyright © 2019 Sandeep Rana. All rights reserved.
//

import UIKit
import CoreData


class AddEmployeeViewController: UIViewController {

    @IBOutlet weak var tName: UITextField!;
    @IBOutlet weak var tEmail: UITextField!;
    @IBOutlet weak var bCity: UIButton!;
    @IBOutlet weak var bAnniversary: UIButton!;
    @IBOutlet weak var switchMarried: UISwitch!;
    @IBOutlet weak var viewDoneButton: UIView!;
    @IBOutlet weak var stackAnniversary: UIStackView!;

    @IBOutlet weak var datePicker: UIDatePicker!;


    var delegateResultUpdated: DelegateEmployeeUpdated?;

    var employee: Employee?;

    @IBAction func onDatePickerValueChanged(_ sender: UIDatePicker) {
        print(sender.date);

        let dateString: String = self.getFormattedDate(date: sender.date);
        self.bAnniversary.setTitle(dateString, for: .normal);
    }

    @IBAction func onClickCancel(_ sender: UIBarButtonItem) {
        self.delegateResultUpdated?.onCancel(vc: self, actionType: .CANCEL);
    }

    @IBAction func onValueChangeForSwitchMarried(_ sender: UISwitch) {
        self.stackAnniversary.isHidden = !sender.isOn;
    }


    @IBAction func onClickPickAnniversaryDate(_ sender: UIButton) {
        self.changeDatePickerVisibility(isHidden: false);
    }

    @IBAction func onClickDonePicker(_ sender: UIButton) {
        self.changeDatePickerVisibility(isHidden: true);
        self.onDatePickerValueChanged(self.datePicker);
    }

    @IBAction func onClickCity(_ sender: UIButton) {
        let vcSelectCity = self.storyboard?.instantiateViewController(withIdentifier: SelectCityViewController.className()) as! SelectCityViewController;
        vcSelectCity.delegateCitySelected = self;
        self.navigationController?.pushViewController(vcSelectCity, animated: true);
    }


    override func viewDidLoad() {
        super.viewDidLoad();
        self.changeDatePickerVisibility(isHidden: true);
        if let emp = self.employee {
            self.tName.text = emp.name;
            self.tEmail.text = emp.email ?? "";
            self.bCity.setTitle(emp.city ?? AddEmployeeViewController.labelSelectCity, for: .normal);
            if let annive = emp.anniversary {
                self.bAnniversary.setTitle(self.getDateFormatter().string(from: annive), for: .normal);
            }
            self.switchMarried.isOn = emp.married;
        }
    }

    func changeDatePickerVisibility(isHidden: Bool) {
        self.datePicker.isHidden = isHidden;
        self.viewDoneButton.isHidden = isHidden;
    }


    static let labelAniversaryDate = "Anniversary Date";
    static let labelSelectCity = "Select City";

    @IBAction func onClickAddEmployeeToCoreData(_ sender: UIButton) {
        var error: Bool = false;
        var errorMessages: [String] = [String]();

        var name = self.tName.text ?? "";
        var email = self.tEmail.text ?? "";
        var city = self.bCity.title(for: .normal) ?? AddEmployeeViewController.labelSelectCity;
        var isMarried = self.switchMarried.isOn;
        var anniversary = self.bAnniversary.title(for: .normal) ?? AddEmployeeViewController.labelAniversaryDate;


        if name.isEmpty {
            error = true;
            errorMessages.append("Name");
        }

        if email.isEmpty {
            error = true;
            errorMessages.append("Email");
        }

        if city == AddEmployeeViewController.labelSelectCity {
            error = true;
            errorMessages.append("City");
        }

        if isMarried && anniversary == AddEmployeeViewController.labelAniversaryDate {
            error = true;
            errorMessages.append(AddEmployeeViewController.labelAniversaryDate);
        }

        if error == true {
            let message = "\(errorMessages.joined(separator: ",")) must be provided!";
            self.showAlert(title: "Error", message: message);
            return;
        }


        if self.employee != nil {
            self.employee?.setValue(name, forKey: "name");
            self.employee?.setValue(email, forKey: "email");
            self.employee?.setValue(isMarried, forKey: "married");
            self.employee?.setValue(city, forKey: "city");
            let dateAnniversary = self.getDateFormatter().date(from: self.bAnniversary.title(for: .normal) ?? "");
            self.employee?.setValue(dateAnniversary, forKey: "anniversary")

            self.employee?.setValue(employee?.id, forKey: "id");
            do {
                try self.saveEmployeeDetail(employee: self.employee!)
            } catch {
                print("Error saving employeedetails");
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Employee", in: AppDelegate.getContext())
            let newEmployee = NSManagedObject(entity: entity!, insertInto: AppDelegate.getContext()) as! Employee;
            newEmployee.setValue(name, forKey: "name");
            newEmployee.setValue(email, forKey: "email");
            newEmployee.setValue(isMarried, forKey: "married");
            newEmployee.setValue(city, forKey: "city");
            let dateAnniversary = self.getDateFormatter().date(from: self.bAnniversary.title(for: .normal) ?? "");
            newEmployee.setValue(dateAnniversary, forKey: "anniversary")

            newEmployee.setValue(Int64(Date().timeIntervalSince1970), forKey: "id");
            do {
                try AppDelegate.getContext().save()
                self.delegateResultUpdated?.onUpdateResults(vc: self, employee: newEmployee, actionType: .ADD);
            } catch {
                print("Failed saving")
                self.showAlert(title: "Error", message: "Failed saving!");

            }
        }

    }

    func saveEmployeeDetail(employee: Employee) throws {
        let context = AppDelegate.getContext();

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        fetchRequest.predicate = NSPredicate(format: "id = \(employee.id)", "");

        if let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject] {
            if fetchResults.count != 0 {

                if var object = fetchResults.first {
                    object.setValue(employee.name, forKey: "name");
                    object.setValue(employee.email, forKey: "email");
                    object.setValue(employee.married, forKey: "married");
                    object.setValue(employee.city, forKey: "city");
                    let dateAnniversary = self.getDateFormatter().date(from: self.bAnniversary.title(for: .normal) ?? "");
                    object.setValue(employee.anniversary, forKey: "anniversary")
                    object.setValue(employee.id, forKey: "id");

                }

                do {
                    try context.save()
                    self.delegateResultUpdated?.onUpdateResults(vc: self, employee: employee, actionType: .EDIT);
                } catch {
                    print("Failed to update");
                    self.showAlert(title: "Error", message: "Failed to save!");
                }
            }
        }
    }


}

extension AddEmployeeViewController: DelegateCitySelected {
    func onCitySelected(vc: SelectCityViewController, selectedCity: String) {
        self.bCity.setTitle(selectedCity, for: .normal);
        self.navigationController?.popViewController(animated: true);
        // dismiss if presented
    }
}



