//
// Created by Sandeep Rana on 2019-03-02.
// Copyright (c) 2019 Sandeep Rana. All rights reserved.
//

import Foundation

protocol DelegateEmployeeUpdated {
    func onUpdateResults(vc: AddEmployeeViewController, employee: Employee, actionType: ActionType);
    func onCancel(vc: AddEmployeeViewController, actionType: ActionType);
}


enum ActionType: String {
    case EDIT, ADD, DELETE, CANCEL
}