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

    @IBOutlet weak var datePicker: UIDatePicker!;

    let dateFormatterGet = DateFormatter();


    @IBAction func onDatePickerValueChanged(_ sender: UIDatePicker) {
        print(sender.date);

        let dateString: String = dateFormatterGet.string(from: sender.date);
        self.bAnniversary.setTitle(dateString, for: .normal);
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
        dateFormatterGet.dateFormat = "MMM dd,yyyy";
        self.changeDatePickerVisibility(isHidden: true);
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

        let entity = NSEntityDescription.entity(forEntityName: "Employee", in: AppDelegate.getContext())
        let newEmployee = NSManagedObject(entity: entity!, insertInto: AppDelegate.getContext());
        newEmployee.setValue(name, forKey: "name");
        newEmployee.setValue(email, forKey: "email");
        newEmployee.setValue(isMarried, forKey: "married");
        newEmployee.setValue(city, forKey: "city");
        let dateAnniversary = self.dateFormatterGet.date(from: self.bAnniversary.title(for: .normal) ?? "");
        newEmployee.setValue(dateAnniversary, forKey: "anniversary")

        do {
            try AppDelegate.getContext().save()
            self.navigationController?.popViewController(animated: true);
        } catch {
            print("Failed saving")
            self.showAlert(title: "Error", message: "Failed saving!");

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
