//
//  AddMakulAlertViewDelegate.swift
//  absensy
//
//  Created by Axellageraldinc Adryamarthanino on 23/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import Foundation

protocol AddMakulAlertViewDelegate: class {
    func btnSimpanClicked(namaMakul: String, jumlahAbsen: Int, dateKuliah: Date)
}
