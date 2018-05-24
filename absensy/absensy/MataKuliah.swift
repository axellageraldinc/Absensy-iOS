//
//  MataKuliah.swift
//  absensy
//
//  Created by Axellageraldinc Adryamarthanino on 21/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit

class MataKuliah {
    var id: String
    var nama: String = ""
    var jumlahAbsen: Int
    
    init(id: String, nama: String, jumlahAbsen: Int) {
        self.id=id
        self.nama=nama
        self.jumlahAbsen=jumlahAbsen
    }
}
